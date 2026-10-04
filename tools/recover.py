#!/usr/bin/env python3
"""Capture an authorized APK, index every Unity object, export validated assets.

Python 3.11+. No game code is executed and no network requests are made. Raw
capture, readable decoding, dependency resolution, and conversion have separate
statuses. Original source and a playable Godot port are NOT implied by any count.
"""
from __future__ import annotations

import argparse
import io
import json
from pathlib import Path
import re
import sys
import zipfile

from recovery_core import (Catalog, RecoveryError, digest, identity, json_bytes,
                           key, lossless_tree, validate_obj, walk_fragment)

UNITYPY_VERSION = "1.25.4"
UNITY_VERSION = "2019.4.41f1"
STREAM_TYPES = {"Texture2D", "Mesh", "AudioClip"}


def unity_module():
    import UnityPy
    if UnityPy.__version__ != UNITYPY_VERSION:
        raise RecoveryError(f"UnityPy {UNITYPY_VERSION} required, got {UnityPy.__version__}")
    UnityPy.config.FALLBACK_UNITY_VERSION = UNITY_VERSION
    return UnityPy


def environment(catalog: Catalog | None = None, owner: str | None = None):
    UnityPy = unity_module()
    from fsspec.implementations.memory import MemoryFileSystem

    class ScopedEnvironment(UnityPy.Environment):
        def find_file(self, name, is_dependency=True):
            # No global monkeypatch and no fallback to a whole-disk search.
            if catalog is None:
                return self.get_cab(name)
            state, member = catalog.resolve(name, owner)
            if member is None:
                raise FileNotFoundError(f"{state}: {name}")
            cached = self.get_cab(name)
            if cached is not None:
                return cached
            data = catalog.store.path(member["sha"]).read_bytes()
            return self.load_file(io.BytesIO(data), name=name, is_dependency=is_dependency)

    return ScopedEnvironment(fs=MemoryFileSystem(), path="")


def read_tree(obj):
    return obj.parse_as_dict()


def stream_refs(value, trail=""):
    """Find streamed textures/meshes and audio resource references in decoded trees."""
    if isinstance(value, dict):
        if {"path", "offset", "size"} <= value.keys():
            if value["path"] and value["size"]:
                yield trail, str(value["path"]), int(value["offset"]), int(value["size"])
        elif {"m_Source", "m_Offset", "m_Size"} <= value.keys():
            if value["m_Source"] and value["m_Size"]:
                yield trail, str(value["m_Source"]), int(value["m_Offset"]), int(value["m_Size"])
        for name, child in value.items():
            yield from stream_refs(child, trail + "/" + str(name))
    elif isinstance(value, (tuple, list)):
        for i, child in enumerate(value):
            yield from stream_refs(child, trail + "/" + str(i))


def add_dependency(cat, mid, oid, kind, label, name, offset=None, size=None):
    cat.db.execute("INSERT INTO dependencies VALUES (?,?,?,?,?,?,?,?,?,?)",
                   (identity(mid, oid, kind, label), mid, oid, kind, name, offset, size,
                    "not_resolved", None, None))


def index_loaded(cat: Catalog, unit_id: str, loaded, *, trees: bool = False):
    """Keep original decompressed member bytes; object records reference exact spans."""
    def walk(item, parts):
        serial = hasattr(item, "objects") and hasattr(item, "reader")
        children = getattr(item, "files", None)
        # SerializedFile inherits an empty .files dictionary from UnityPy File.
        # Test serialized objects BEFORE treating that dictionary as a container.
        if not serial and children is not None:
            for name, child in sorted(children.items()):
                walk(child, parts + [str(name)])
            return
        reader = item.reader if serial else item
        raw = bytes(reader.bytes)
        sha, size = cat.blob(raw)
        name = "/".join(parts) or str(getattr(item, "name", None) or
               cat.db.execute("SELECT name FROM units WHERE id=?", (unit_id,)).fetchone()[0])
        mid = identity(unit_id, parts)
        objects = item.objects if serial else {}
        cat.db.execute("INSERT INTO members VALUES (?,?,?,?,?,?,?,?,?)",
                       (mid, unit_id, name, key(name), key(name).rsplit("/", 1)[-1],
                        sha, size, "serialized" if serial else "resource", len(objects)))
        if serial:
            for i, ext in enumerate(getattr(item, "externals", ())):
                add_dependency(cat, mid, None, "external", i, str(ext.path))
        for path_id, obj in sorted(objects.items()):
            oid = identity(mid, int(path_id))
            start, length = int(obj.byte_start), int(obj.byte_size)
            if start < 0 or length < 0 or start + length > size:
                raise RecoveryError(f"object {oid} outside serialized member")
            original = obj.get_raw_data()
            if bytes(original) != raw[start:start + length]:
                raise RecoveryError(f"object {oid} raw data disagrees with member bytes")
            tname = str(obj.type.name)
            try:
                name = obj.peek_name()
            except Exception:
                name = None
            cat.db.execute("INSERT INTO objects VALUES (?,?,?,?,?,?,?,?,?,?)",
                           (oid, mid, int(path_id), tname, name, start, length,
                            digest(original), None, None))
            if trees or tname in STREAM_TYPES:
                try:
                    tree = read_tree(obj)
                    tree_sha, _ = cat.blob(json_bytes(lossless_tree(tree, cat)))
                    cat.db.execute("UPDATE objects SET tree_sha=? WHERE id=?", (tree_sha, oid))
                    for trail, resource, off, count in stream_refs(tree):
                        add_dependency(cat, mid, oid, "stream", trail, resource, off, count)
                except Exception as exc:
                    # Decoding failure does not discard raw bytes or claim absence.
                    cat.db.execute("UPDATE objects SET decode_error=? WHERE id=?", (str(exc), oid))
    walk(loaded, [])


def process_unit(cat, entry, name, data, offset, process, trees=False):
    uid = identity(entry["id"], name, offset)
    sha, size = cat.blob(data)
    cat.db.execute("INSERT INTO units VALUES (?,?,?,?,?,?,?,NULL)",
                   (uid, entry["id"], name, sha, offset, size, "pending"))
    if not process:
        cat.db.execute("UPDATE units SET status='not_indexed' WHERE id=?", (uid,))
        return
    try:
        env = environment()
        loaded = env.load_file(io.BytesIO(data), name=name)
        index_loaded(cat, uid, loaded, trees=trees)
        cat.db.execute("UPDATE units SET status='indexed' WHERE id=?", (uid,))
    except Exception as exc:
        cat.db.execute("UPDATE units SET status='error',error=? WHERE id=?", (str(exc), uid))
        cat.issue(uid, exc)
    cat.db.commit()


def capture(apk: Path, out: Path, *, max_units=0, max_bytes=16 * 1024**3, trees=False):
    if not apk.is_file():
        raise RecoveryError("APK does not exist")
    unity_module()  # Dependency guard before creating an output directory.
    cat = Catalog(out, create=True, max_bytes=max_bytes)
    try:
        cat.set_meta("tool", {"UnityPy": UNITYPY_VERSION, "unity_fallback": UNITY_VERSION})
        with apk.open("rb") as src:
            sha, _ = cat.blob_stream(src, apk.stat().st_size)
        cat.set_meta("input_sha256", sha)
        cat.db.commit()
        # Read the preserved snapshot, not a potentially changing original path.
        with zipfile.ZipFile(cat.store.path(sha)) as z:
            infos = z.infolist()
            if len(infos) > 500000:
                raise RecoveryError("APK entry-count budget exceeded")
            cat.set_meta("input_entries_expected", len(infos))
            for ordinal, info in enumerate(infos):
                if info.file_size > 1024**3:
                    raise RecoveryError("APK entry exceeds one-GiB safety limit")
                with z.open(info) as src:
                    entry_sha, size = cat.blob_stream(src, info.file_size)
                cat.db.execute("INSERT INTO entries VALUES (?,?,?,?,?,?,?,?)",
                               (identity(sha, ordinal), ordinal, info.filename, entry_sha, size,
                                info.CRC, info.compress_size, int(info.is_dir())))
            cat.db.commit()
        entries = cat.db.execute("SELECT * FROM entries ORDER BY ordinal").fetchall()
        by_name = {}
        for entry in entries:
            by_name.setdefault(entry["name"], []).append(entry)
        split_groups = {}
        for entry in entries:
            match = re.fullmatch(r"(assets/bin/Data/.*)\.split(\d+)", entry["name"])
            if match:
                split_groups.setdefault(match[1], []).append(int(match[2]))
        for name, numbers in split_groups.items():
            if sorted(numbers) != list(range(len(numbers))):
                raise RecoveryError("non-contiguous or duplicate split input: " + name)
        processed = 0
        for entry in entries:
            name = entry["name"]
            base = name.rsplit("/", 1)[-1]
            path = cat.store.path(entry["sha"])
            if re.fullmatch(r"BundleFragment\d+\.bytes", base):
                with path.open("rb") as f:
                    for off, size in walk_fragment(f, entry["size"]):
                        f.seek(off)
                        data = f.read(size)
                        process_unit(cat, entry, name + f"@{off}", data, off,
                                     not max_units or processed < max_units, trees)
                        processed += 1
                        if processed % 100 == 0:
                            print(f"indexed/scheduled {processed} Unity units", flush=True)
            elif name.startswith("assets/bin/Data/") and not entry["is_dir"]:
                split = re.fullmatch(r"(.*)\.split(\d+)", name)
                if split:
                    if int(split[2]) != 0:
                        continue
                    prefix = split[1]
                    parts = sorted((int(n.rsplit(".split", 1)[1]), rows)
                                   for n, rows in by_name.items()
                                   if re.fullmatch(re.escape(prefix) + r"\.split\d+", n))
                    if [i for i, _ in parts] != list(range(len(parts))) or any(len(rows) != 1 for _, rows in parts):
                        raise RecoveryError("ambiguous or non-contiguous split file: " + prefix)
                    if sum(rows[0]["size"] for _, rows in parts) > 1024**3:
                        raise RecoveryError("reassembled serialized file exceeds budget")
                    data = b"".join(cat.store.path(rows[0]["sha"]).read_bytes() for _, rows in parts)
                    name = prefix
                else:
                    data = path.read_bytes()
                process_unit(cat, entry, name, data, 0, not max_units or processed < max_units, trees)
                processed += 1
        cat.resolve_dependencies()
        issues = cat.db.execute("SELECT COUNT(*) FROM issues").fetchone()[0]
        pending = cat.db.execute("SELECT COUNT(*) FROM units WHERE status!='indexed'").fetchone()[0]
        cat.set_meta("state", "failed" if issues else "partial" if pending else "captured")
        cat.db.commit()
        cat.write_summary()
        return cat.summary()
    except BaseException as exc:
        cat.issue("capture", exc)
        cat.set_meta("state", "failed")
        cat.db.commit()
        cat.write_summary()
        raise
    finally:
        cat.close()


def texture_data(texture) -> bytes:
    """Inline absence alone is NOT proof of missing texture data."""
    data = texture.get_image_data()
    if not data:
        raise RecoveryError("texture has no resolved pixel bytes")
    stream = getattr(texture, "m_StreamData", None)
    if not getattr(texture, "image_data", None) and stream and stream.size:
        if len(data) != stream.size:
            raise RecoveryError("short texture resource stream")
    return data


def sprite_textures(sprite):
    """Use the same atlas/render-data selection as UnityPy, then validate streams."""
    rd = sprite.m_RD
    if sprite.m_SpriteAtlas:
        atlas = sprite.m_SpriteAtlas.deref_parse_as_object()
        rd = next(v for k, v in atlas.m_RenderDataMap if k == sprite.m_RenderDataKey)
    elif getattr(sprite, "m_AtlasTags", None):
        # Do not guess an atlas; preserving the raw sprite is still successful.
        raise RecoveryError("sprite atlas tag needs explicit atlas binding")
    yield rd.texture.deref_parse_as_object()
    alpha = getattr(rd, "alphaTexture", None)
    if alpha:
        yield alpha.deref_parse_as_object()


def convert(obj, kind: str) -> tuple[str, bytes, dict]:
    data = obj.parse_as_object()
    if kind == "Mesh":
        text = data.export()
        geometry = validate_obj(text)
        return "obj", text.encode("utf-8"), {"geometry": geometry, "rig_preserved_in_raw_only": True}
    if kind == "Texture2D":
        texture_data(data)
    elif kind == "Sprite":
        for tex in sprite_textures(data):
            texture_data(tex)
    if kind in ("Texture2D", "Sprite"):
        image = data.image
        if image is None or image.width < 1 or image.height < 1:
            raise RecoveryError("no decodable image")
        stream = io.BytesIO()
        image.save(stream, format="PNG")
        # Independent re-open forces detection of a malformed output.
        from PIL import Image
        with Image.open(io.BytesIO(stream.getvalue())) as reopened:
            reopened.verify()
        return "png", stream.getvalue(), {"width": image.width, "height": image.height}
    if kind == "TextAsset":
        raw = data.m_Script
        if isinstance(raw, str):
            raw = raw.encode("utf-8", "surrogateescape")
        return "bin", bytes(raw), {"binary_safe": True}
    raise RecoveryError("no neutral exporter for " + kind)


def export_assets(root: Path, *, kinds=None, limit=100):
    cat = Catalog(root)
    try:
        errors = cat.verify()
        if errors:
            raise RecoveryError("capture verification failed: " + "; ".join(errors[:3]))
        kinds = kinds or ["Mesh", "Texture2D", "Sprite", "TextAsset"]
        placeholders = ",".join("?" for _ in kinds)
        rows = cat.db.execute(f"SELECT * FROM objects WHERE type IN ({placeholders}) ORDER BY member_id,path_id", kinds)
        count = failed = 0
        current_mid, env, member = None, None, None
        for row in rows:
            if limit and count >= limit:
                break
            if row["member_id"] != current_mid:
                current_mid = row["member_id"]
                member = cat.db.execute("SELECT * FROM members WHERE id=?", (current_mid,)).fetchone()
                env = environment(cat, current_mid)
                # Load only the requested serialized member; dependencies load lazily
                # from the catalog, with no unbounded filesystem scan.
                try:
                    loaded = env.load_file(io.BytesIO(cat.store.path(member["sha"]).read_bytes()), name=member["name"])
                    load_error = None
                except Exception as exc:
                    loaded, load_error = None, str(exc)
            try:
                if loaded is None:
                    raise RecoveryError(load_error)
                obj = loaded.objects[row["path_id"]]
                extension, data, detail = convert(obj, row["type"])
                sha, size = cat.blob(data)
                cat.db.execute("INSERT OR REPLACE INTO exports VALUES (?,?,?,?,?,?)",
                               (row["id"], row["type"], sha, size, "exported",
                                json.dumps({"extension": extension, **detail})))
            except Exception as exc:
                failed += 1
                cat.db.execute("INSERT OR REPLACE INTO exports VALUES (?,?,?,?,?,?)",
                               (row["id"], row["type"], None, None, "failed", str(exc)))
            count += 1
        cat.db.commit()
        cat.write_summary()
        return {"attempted": count, "failed": failed, "remaining_unattempted":
                cat.db.execute(f"SELECT COUNT(*) FROM objects WHERE type IN ({placeholders}) AND id NOT IN (SELECT object_id FROM exports)", kinds).fetchone()[0]}
    finally:
        cat.close()


def materialize(root: Path, output: Path):
    """Make neutral exports usable by viewers; object IDs prevent name collisions."""
    cat = Catalog(root)
    try:
        if output.exists() and any(output.iterdir()):
            raise RecoveryError("materialized output must be empty")
        output.mkdir(parents=True, exist_ok=True)
        count = 0
        for row in cat.db.execute("SELECT e.*,o.type,o.name FROM exports e JOIN objects o ON o.id=e.object_id WHERE status='exported'"):
            detail = json.loads(row["detail"])
            ext = detail["extension"]
            if ext not in {"obj", "png", "bin"}:
                raise RecoveryError("invalid export extension")
            data = cat.store.path(row["sha"]).read_bytes()
            if digest(data) != row["sha"] or len(data) != row["size"]:
                raise RecoveryError("corrupted export blob")
            if ext == "obj":
                validate_obj(data.decode("utf-8"))
            target = output / (row["object_id"] + "." + ext)
            target.write_bytes(data)
            target.with_suffix(target.suffix + ".json").write_bytes(json_bytes(dict(row)))
            count += 1
        return count
    finally:
        cat.close()


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest="command", required=True)
    p = sub.add_parser("capture")
    p.add_argument("--apk", type=Path, required=True)
    p.add_argument("--out", type=Path, required=True)
    p.add_argument("--max-units", type=int, default=0)
    p.add_argument("--max-gib", type=float, default=16)
    p.add_argument("--trees", action="store_true", help="decode all typetrees, retaining binary fields")
    p = sub.add_parser("verify")
    p.add_argument("root", type=Path)
    p = sub.add_parser("export")
    p.add_argument("root", type=Path)
    p.add_argument("--types", nargs="+", choices=["Mesh", "Texture2D", "Sprite", "TextAsset"])
    p.add_argument("--limit", type=int, default=100, help="0 means all matching objects")
    p = sub.add_parser("materialize")
    p.add_argument("root", type=Path)
    p.add_argument("output", type=Path)
    args = parser.parse_args(argv)
    try:
        if args.command == "capture":
            if args.max_units < 0 or args.max_gib <= 0:
                raise RecoveryError("limits must be nonnegative and storage must be positive")
            result = capture(args.apk, args.out, max_units=args.max_units,
                             max_bytes=int(args.max_gib * 1024**3), trees=args.trees)
            print(json.dumps(result, indent=2))
            return 0 if result["capture_complete"] else 1
        if args.command == "verify":
            cat = Catalog(args.root)
            try:
                errors = cat.verify()
                print(json.dumps({"errors": errors, "summary": cat.summary()}, indent=2))
            finally:
                cat.close()
            return int(bool(errors))
        if args.command == "export":
            if args.limit < 0:
                raise RecoveryError("limit cannot be negative")
            result = export_assets(args.root, kinds=args.types, limit=args.limit)
            print(json.dumps(result, indent=2))
            return int(bool(result["failed"]))
        print(json.dumps({"materialized": materialize(args.root, args.output)}))
        return 0
    except Exception as exc:
        print(f"recovery failed: {type(exc).__name__}: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
