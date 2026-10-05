#!/usr/bin/env python3
"""Decode and validate Unity PPtr/component graphs from a verified R1 snapshot.

No APK/game code or network is executed. Reports describe captured relationships,
not a playable scene. Unresolved pointers and unsupported trees remain blockers.
The additive graph schema keeps existing version-1 raw captures readable.
"""
from __future__ import annotations

import argparse
import io
import json
import math
from pathlib import Path
import sys
import zlib

from recovery_core import Catalog, RecoveryError, digest, identity, json_bytes, lossless_tree
import recover

DDL = """
CREATE TABLE IF NOT EXISTS graph_objects(
 object_id TEXT PRIMARY KEY REFERENCES objects, status TEXT NOT NULL, detail TEXT);
CREATE TABLE IF NOT EXISTS external_slots(
 member_id TEXT NOT NULL REFERENCES members, file_id INTEGER NOT NULL,
 name TEXT NOT NULL, PRIMARY KEY(member_id,file_id));
CREATE TABLE IF NOT EXISTS object_refs(
 id TEXT PRIMARY KEY, source_id TEXT NOT NULL REFERENCES objects, pointer_path TEXT NOT NULL,
 file_id INTEGER, path_id INTEGER, status TEXT NOT NULL,
 target_id TEXT REFERENCES objects, detail TEXT, UNIQUE(source_id,pointer_path));
CREATE INDEX IF NOT EXISTS refs_targets ON object_refs(target_id,pointer_path);
CREATE TABLE IF NOT EXISTS container_paths(
 id TEXT PRIMARY KEY, source_id TEXT NOT NULL REFERENCES objects,
 original_path TEXT NOT NULL, ref_id TEXT NOT NULL REFERENCES object_refs);
"""


def escape(text):
    return str(text).replace("~", "~0").replace("/", "~1")


def pointers(tree):
    """Yield exact JSON-pointer locations, including invalid/null serialized PPtrs."""
    stack = [("", tree)]
    while stack:
        trail, value = stack.pop()
        if isinstance(value, dict):
            if "m_FileID" in value and "m_PathID" in value:
                yield trail, value
                continue
            for key, child in reversed(list(value.items())):
                stack.append((trail + "/" + escape(key), child))
        elif isinstance(value, list):
            for index in range(len(value) - 1, -1, -1):
                stack.append((trail + "/" + str(index), value[index]))


def pointer_values(pointer):
    file_id, path_id = pointer["m_FileID"], pointer["m_PathID"]
    if type(file_id) is not int or not 0 <= file_id <= 2**31 - 1:
        raise RecoveryError("m_FileID must be a nonnegative int32")
    if type(path_id) is not int or not -(2**63) <= path_id < 2**63:
        raise RecoveryError("m_PathID must be a signed int64")
    return file_id, path_id


def resolve(cat, member_id, pointer):
    try:
        file_id, path_id = pointer_values(pointer)
    except RecoveryError as exc:
        return None, None, "invalid_pointer", None, str(exc)
    if path_id == 0:
        return file_id, path_id, "null", None, None
    target_member = member_id
    if file_id:
        slot = cat.db.execute("SELECT name FROM external_slots WHERE member_id=? AND file_id=?",
                              (member_id, file_id)).fetchone()
        if slot is None:
            return file_id, path_id, "missing_external_slot", None, str(file_id)
        status, target = cat.resolve(slot[0], member_id)
        if target is None:
            return file_id, path_id, status, None, slot[0]
        if target["kind"] != "serialized":
            return file_id, path_id, "not_serialized", None, slot[0]
        target_member = target["id"]
    obj = cat.db.execute("SELECT id FROM objects WHERE member_id=? AND path_id=?",
                         (target_member, path_id)).fetchone()
    if obj is None:
        return file_id, path_id, "missing_object", None, target_member
    return file_id, path_id, "resolved", obj[0], None


def container_entries(tree):
    """AssetBundle.m_Container is commonly a list of [path, AssetInfo] pairs."""
    value = tree.get("m_Container", []) if isinstance(tree, dict) else []
    entries = value.items() if isinstance(value, dict) else enumerate(value)
    for index, pair in entries:
        if isinstance(value, dict):
            path, info = index, pair
            trail = "/m_Container/" + escape(path) + "/asset"
        elif isinstance(pair, list) and len(pair) == 2:
            path, info = pair
            trail = "/m_Container/" + str(index) + "/1/asset"
        else:
            continue
        if isinstance(path, str) and isinstance(info, dict) and isinstance(info.get("asset"), dict):
            yield path, trail


def tree_for(cat, obj):
    if obj["tree_sha"] is None:
        if cat.get_meta("graph_scan_schema") != 1:
            raise RecoveryError("object has no decoded typetree")
        row = cat.db.execute("SELECT sha,raw_size,data FROM graph_trees WHERE object_id=?", (obj["id"],)).fetchone()
        if row is None or not 0 <= row["raw_size"] <= 128 * 1024**2:
            raise RecoveryError("missing or oversized packed typetree")
        decoder = zlib.decompressobj()
        raw = decoder.decompress(row["data"], row["raw_size"] + 1)
        if (not decoder.eof or decoder.unused_data or decoder.unconsumed_tail
                or len(raw) != row["raw_size"] or digest(raw) != row["sha"]):
            raise RecoveryError("packed typetree hash/size/framing mismatch")
        return json.loads(raw)
    raw = cat.store.path(obj["tree_sha"]).read_bytes()
    if digest(raw) != obj["tree_sha"]:
        raise RecoveryError("decoded tree hash mismatch")
    return json.loads(raw)


def populate_references(cat, obj, tree):
    for trail, pointer in pointers(tree):
        file_id, path_id, status, target, detail = resolve(cat, obj["member_id"], pointer)
        cat.db.execute("INSERT INTO object_refs VALUES (?,?,?,?,?,?,?,?)",
                       (identity(obj["id"], trail), obj["id"], trail,
                        file_id, path_id, status, target, detail))
    if obj["type"] == "AssetBundle":
        for path, trail in container_entries(tree):
            rid = identity(obj["id"], trail)
            if cat.db.execute("SELECT 1 FROM object_refs WHERE id=?", (rid,)).fetchone():
                cat.db.execute("INSERT INTO container_paths VALUES (?,?,?,?)",
                               (identity(obj["id"], path, trail), obj["id"], path, rid))


def summary(cat):
    statuses = dict(cat.db.execute("SELECT status,COUNT(*) FROM graph_objects GROUP BY status"))
    refs = dict(cat.db.execute("SELECT status,COUNT(*) FROM object_refs GROUP BY status"))
    total = cat.db.execute("SELECT COUNT(*) FROM objects").fetchone()[0]
    decoded = statuses.get("decoded", 0)
    blocked = sum(count for state, count in refs.items() if state not in ("resolved", "null"))
    return {"schema": 1, "input_sha256": cat.get_meta("input_sha256"),
            "state": cat.get_meta("graph_state", "not_built"), "objects_expected": total,
            "objects": statuses, "references": refs,
            "container_paths": cat.db.execute("SELECT COUNT(*) FROM container_paths").fetchone()[0],
            "all_objects_decoded": decoded == total and total > 0,
            "all_nonnull_references_resolved": blocked == 0,
            "graph_complete": decoded == total and total > 0 and blocked == 0,
            "apk_scope_only": True, "godot_port_complete": False}


def build(root: Path, *, max_objects=0):
    if max_objects < 0:
        raise RecoveryError("max-objects must be nonnegative")
    cat = Catalog(root)
    try:
        if cat.get_meta("graph_scan_schema"):
            raise RecoveryError("checkpointed graph exists; resume with recovery_scan.py")
        errors = cat.verify()
        if errors:
            raise RecoveryError("invalid capture: " + "; ".join(errors[:3]))
        cat.db.executescript(DDL)
        cat.set_meta("graph_schema", 1)
        cat.set_meta("graph_state", "building")
        # Invalidate first; interrupted rebuilds cannot retain an old success flag.
        for table in ("container_paths", "object_refs", "external_slots", "graph_objects"):
            cat.db.execute("DELETE FROM " + table)
        cat.db.commit()
        attempted = 0
        for member in cat.db.execute("SELECT * FROM members WHERE kind='serialized' ORDER BY id").fetchall():
            rows = cat.db.execute("SELECT * FROM objects WHERE member_id=? ORDER BY path_id", (member["id"],)).fetchall()
            if max_objects and attempted >= max_objects:
                cat.db.executemany("INSERT INTO graph_objects VALUES (?,'not_decoded',?)",
                                   [(r["id"], "object limit") for r in rows])
                continue
            try:
                env = recover.environment()
                loaded = env.load_file(io.BytesIO(cat.store.path(member["sha"]).read_bytes()), name=member["name"])
                if not hasattr(loaded, "objects") or set(loaded.objects) != {r["path_id"] for r in rows}:
                    raise RecoveryError("reparsed object identities differ from raw capture")
                for index, ext in enumerate(getattr(loaded, "externals", ())):
                    cat.db.execute("INSERT INTO external_slots VALUES (?,?,?)", (member["id"], index + 1, str(ext.path)))
            except Exception as exc:
                cat.db.executemany("INSERT INTO graph_objects VALUES (?,'decode_failed',?)",
                                   [(r["id"], str(exc)) for r in rows])
                attempted += len(rows)
                cat.db.commit()
                continue
            for obj in rows:
                if max_objects and attempted >= max_objects:
                    cat.db.execute("INSERT INTO graph_objects VALUES (?,'not_decoded','object limit')", (obj["id"],))
                    continue
                attempted += 1
                try:
                    if obj["tree_sha"]:
                        tree_for(cat, obj)  # Verify stored bytes, then reuse below.
                    else:
                        parsed = recover.read_tree(loaded.objects[obj["path_id"]])
                        sha, _ = cat.blob(json_bytes(lossless_tree(parsed, cat)))
                        cat.db.execute("UPDATE objects SET tree_sha=?,decode_error=NULL WHERE id=?", (sha, obj["id"]))
                    cat.db.execute("INSERT INTO graph_objects VALUES (?,'decoded',NULL)", (obj["id"],))
                except Exception as exc:
                    cat.db.execute("INSERT INTO graph_objects VALUES (?,'decode_failed',?)", (obj["id"], str(exc)))
            cat.db.commit()
        # File-ID slots for ALL members exist before resolving any cross-file PPtr.
        query = "SELECT o.* FROM objects o JOIN graph_objects g ON o.id=g.object_id WHERE g.status='decoded' ORDER BY o.id"
        for index, obj in enumerate(cat.db.execute(query)):
            populate_references(cat, obj, tree_for(cat, obj))
            if index % 1000 == 0:
                cat.db.commit()
        report = summary(cat)
        cat.set_meta("graph_state", "complete" if report["graph_complete"] else "incomplete")
        cat.db.commit()
        report = summary(cat)
        (root / "graph-summary.json").write_bytes(json_bytes(report))
        return report
    except BaseException:
        if cat.get_meta("graph_schema") == 1 and not cat.get_meta("graph_scan_schema"):
            cat.set_meta("graph_state", "failed")
            cat.db.commit()
        raise
    finally:
        cat.close()


def verify_graph(cat):
    """Check coverage and recompute every edge from its preserved decoded tree."""
    if cat.get_meta("graph_schema") != 1:
        return ["graph has not been built"]
    errors = []
    if cat.get_meta("graph_scan_schema") == 1:
        bad = cat.db.execute("""SELECT COUNT(*) FROM graph_trees t LEFT JOIN graph_objects g
            ON t.object_id=g.object_id WHERE g.status IS NULL OR g.status!='decoded'""").fetchone()[0]
        if bad:
            errors.append("packed typetree/status coverage mismatch")
    if cat.get_meta("graph_state") not in ("complete", "incomplete"):
        errors.append("graph build did not finish")
    if cat.db.execute("SELECT COUNT(*) FROM graph_objects").fetchone()[0] != cat.db.execute("SELECT COUNT(*) FROM objects").fetchone()[0]:
        errors.append("graph object coverage mismatch")
    for obj in cat.db.execute("SELECT o.*,g.status FROM objects o JOIN graph_objects g ON o.id=g.object_id ORDER BY o.id"):
        actual = {r["pointer_path"]: dict(r) for r in cat.db.execute("SELECT * FROM object_refs WHERE source_id=?", (obj["id"],))}
        expected = {}
        expected_paths = set()
        if obj["status"] == "decoded":
            try:
                tree = tree_for(cat, obj)
                for trail, pointer in pointers(tree):
                    expected[trail] = resolve(cat, obj["member_id"], pointer)
                if obj["type"] == "AssetBundle":
                    expected_paths = {(identity(obj["id"], path, trail), path, identity(obj["id"], trail))
                                      for path, trail in container_entries(tree) if trail in expected}
            except Exception as exc:
                errors.append(obj["id"] + ": " + str(exc))
        actual_paths = {tuple(r) for r in cat.db.execute("SELECT id,original_path,ref_id FROM container_paths WHERE source_id=?", (obj["id"],))}
        if actual_paths != expected_paths:
            errors.append("container path coverage mismatch: " + obj["id"])
        if actual.keys() != expected.keys():
            errors.append("pointer coverage mismatch: " + obj["id"])
        for trail in actual.keys() & expected.keys():
            row = actual[trail]
            values = tuple(row[k] for k in ("file_id", "path_id", "status", "target_id", "detail"))
            if values != expected[trail] or row["id"] != identity(obj["id"], trail):
                errors.append("invalid pointer binding: " + row["id"])
    report = summary(cat)
    if cat.get_meta("graph_state") == "complete" and not report["graph_complete"]:
        errors.append("graph completion flag contradicts coverage")
    return errors


def scene(cat, root_object: str, max_nodes=50000):
    """Extract hierarchy and component bindings, with strict reciprocal checks.

    This intentionally emits provenance-rich JSON, NOT guessed Godot scenes or GLB.
    Rigs/materials/animations remain original object references for conversion.
    """
    if max_nodes <= 0:
        raise RecoveryError("max-nodes must be positive")
    errors = cat.verify() + verify_graph(cat)
    if errors:
        raise RecoveryError("snapshot/graph verification failed: " + "; ".join(errors[:3]))
    def obj(oid):
        result = cat.db.execute("SELECT * FROM objects WHERE id=?", (oid,)).fetchone()
        if result is None:
            raise RecoveryError("unknown object: " + str(oid))
        return result
    def ref(oid, trail):
        return cat.db.execute("SELECT * FROM object_refs WHERE source_id=? AND pointer_path=?", (oid, trail)).fetchone()
    first = obj(root_object)
    if first["type"] == "GameObject":
        matches = cat.db.execute("SELECT r.source_id FROM object_refs r JOIN objects o ON o.id=r.source_id WHERE r.target_id=? AND r.pointer_path='/m_GameObject' AND o.type IN ('Transform','RectTransform')", (root_object,)).fetchall()
        if len(matches) != 1:
            raise RecoveryError("GameObject must have exactly one bound Transform")
        root_object = matches[0][0]
    if obj(root_object)["type"] not in ("Transform", "RectTransform"):
        raise RecoveryError("scene root must be a Transform or GameObject")
    nodes, blockers, seen, stack = [], [], set(), [root_object]
    while stack:
        oid = stack.pop()
        if oid in seen:
            blockers.append({"object": oid, "reason": "cycle or repeated child"})
            continue
        if len(seen) >= max_nodes:
            blockers.append({"reason": "node limit", "remaining": len(stack) + 1})
            break
        seen.add(oid)
        current = obj(oid)
        node = {"transform_id": oid, "name": current["name"], "children": [], "components": []}
        nodes.append(node)
        try:
            if current["type"] not in ("Transform", "RectTransform"):
                raise RecoveryError("child pointer does not target a Transform")
            tree = tree_for(cat, current)
            trs = {}
            for field, axes in (("m_LocalPosition", "xyz"), ("m_LocalRotation", "xyzw"), ("m_LocalScale", "xyz")):
                value = tree[field]
                if not isinstance(value, dict):
                    raise RecoveryError("invalid local transform")
                coords = [value[a] for a in axes]
                if any(type(x) not in (int, float) or not math.isfinite(x) for x in coords):
                    raise RecoveryError("invalid/nonfinite local transform")
                if field == "m_LocalRotation" and abs(sum(x*x for x in coords) - 1) > 0.002:
                    raise RecoveryError("non-unit local quaternion")
                trs[field] = coords
            node["local_transform"] = trs
            parent = ref(oid, "/m_Father")
            if parent is None or parent["status"] not in ("null", "resolved"):
                raise RecoveryError("unresolved/missing parent pointer")
            node["parent_transform_id"] = parent["target_id"]
            go = ref(oid, "/m_GameObject")
            if go is None or go["status"] != "resolved" or obj(go["target_id"])["type"] != "GameObject":
                raise RecoveryError("missing GameObject binding")
            go_obj = obj(go["target_id"])
            node["game_object_id"], node["name"] = go_obj["id"], go_obj["name"]
            children = tree.get("m_Children")
            if not isinstance(children, list):
                raise RecoveryError("missing child array")
            for i in range(len(children)):
                child = ref(oid, f"/m_Children/{i}")
                if child is None or child["status"] != "resolved":
                    blockers.append({"object": oid, "reason": f"unresolved child {i}"})
                    continue
                cid = child["target_id"]
                father = ref(cid, "/m_Father")
                if father is None or father["status"] != "resolved" or father["target_id"] != oid:
                    blockers.append({"object": cid, "reason": "nonreciprocal parent/child binding"})
                node["children"].append(cid)
            reverse_children = {r[0] for r in cat.db.execute("SELECT source_id FROM object_refs WHERE target_id=? AND pointer_path='/m_Father' AND status='resolved'", (oid,))}
            if reverse_children != set(node["children"]):
                blockers.append({"object": oid, "reason": "m_Father/m_Children coverage mismatch"})
            stack.extend(reversed(node["children"]))
            go_tree = tree_for(cat, go_obj)
            component_ids = []
            for trail, pointer in pointers(go_tree.get("m_Component", [])):
                r = ref(go_obj["id"], "/m_Component" + trail)
                if r is None or r["status"] != "resolved":
                    blockers.append({"object": go_obj["id"], "reason": "unresolved component"})
                    continue
                component = obj(r["target_id"])
                component_ids.append(component["id"])
                owner = ref(component["id"], "/m_GameObject")
                if owner is None or owner["status"] != "resolved" or owner["target_id"] != go_obj["id"]:
                    blockers.append({"object": component["id"], "reason": "nonreciprocal component owner"})
                bindings = [dict(r) for r in cat.db.execute("SELECT * FROM object_refs WHERE source_id=? ORDER BY pointer_path", (component["id"],))]
                bad = [r["pointer_path"] for r in bindings if r["status"] not in ("resolved", "null")]
                if bad:
                    blockers.append({"object": component["id"], "reason": "unresolved component bindings", "paths": bad})
                status = cat.db.execute("SELECT status FROM graph_objects WHERE object_id=?", (component["id"],)).fetchone()
                if status is None or status[0] != "decoded":
                    blockers.append({"object": component["id"], "reason": "component typetree unavailable"})
                node["components"].append({"object_id": component["id"], "type": component["type"], "bindings": bindings})
            if oid not in component_ids or len(component_ids) != len(set(component_ids)):
                blockers.append({"object": go_obj["id"], "reason": "missing transform or duplicate component"})
        except (RecoveryError, KeyError, TypeError) as exc:
            blockers.append({"object": oid, "reason": str(exc)})
    return {"schema": 1, "input_sha256": cat.get_meta("input_sha256"), "root": root_object,
            "coordinate_system": "unchanged Unity local coordinates; no Godot conversion applied",
            "hierarchy_complete": not blockers, "nodes": nodes, "blockers": blockers,
            "renderable_model_complete": False, "godot_port_complete": False}


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    p = sub.add_parser("build")
    p.add_argument("root", type=Path)
    p.add_argument("--max-objects", type=int, default=0)
    p = sub.add_parser("verify")
    p.add_argument("root", type=Path)
    p = sub.add_parser("scene")
    p.add_argument("root", type=Path)
    p.add_argument("--root-object", required=True)
    p.add_argument("--out", type=Path, required=True)
    p.add_argument("--max-nodes", type=int, default=50000)
    args = parser.parse_args(argv)
    cat = None
    try:
        if args.command == "build":
            result = build(args.root, max_objects=args.max_objects)
            good = result["graph_complete"]
        else:
            cat = Catalog(args.root)
            if args.command == "verify":
                errors = cat.verify() + verify_graph(cat)
                result = {"errors": errors, "summary": summary(cat) if cat.get_meta("graph_schema") == 1 else {}}
                good = not errors and result["summary"].get("graph_complete", False)
            else:
                result = scene(cat, args.root_object, args.max_nodes)
                args.out.parent.mkdir(parents=True, exist_ok=True)
                with args.out.open("xb") as target:
                    target.write(json_bytes(result))
                good = result["hierarchy_complete"]
        print(json.dumps(result, indent=2))
        return 0 if good else 1
    except (OSError, RecoveryError, ValueError) as exc:
        print(f"graph failed: {exc}", file=sys.stderr)
        return 2
    finally:
        if cat:
            cat.close()


if __name__ == "__main__":
    raise SystemExit(main())
