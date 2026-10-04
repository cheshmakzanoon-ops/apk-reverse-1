"""R2 fixtures are generated, not proprietary game data. No game code is run."""
import importlib.util
import io
import json
from pathlib import Path
import sqlite3
import struct
import subprocess
import sys
import unittest
from types import SimpleNamespace as NS
from unittest.mock import patch
import zipfile

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
import input_transfer as transfer
import recovery_graph as graph
import source_inventory
import recover
from recovery_core import Catalog, RecoveryError, digest, identity, json_bytes, lossless_tree
from test_recovery import Fixture, FakeObject, FakeEnvironment, real_serialized_textasset


def ptr(pid, fid=0):
    return {"m_FileID": fid, "m_PathID": pid}


def transform(go, parent=0, children=()):
    return {"m_GameObject": ptr(go), "m_Father": ptr(parent),
            "m_Children": [ptr(p) for p in children],
            "m_LocalPosition": dict(x=1.0, y=2.0, z=3.0),
            "m_LocalRotation": dict(x=0.0, y=0.0, z=0.0, w=1.0),
            "m_LocalScale": dict(x=1.0, y=1.0, z=1.0)}


def member(items, name="scene.assets", externals=()):
    data, objects = b"", {}
    for pid, kind, tree in items:
        raw = json_bytes(tree)
        objects[pid] = FakeObject(raw, kind, pid, len(data), tree)
        data += raw
    return NS(reader=NS(bytes=data), objects=objects, externals=[NS(path=n) for n in externals], files={}, name=name)


def model_items():
    return [(1, "GameObject", {"m_Component": [{"component": ptr(2)}, {"component": ptr(3)}]}),
            (2, "Transform", transform(1, children=(5,))),
            (3, "MeshFilter", {"m_GameObject": ptr(1), "m_Mesh": ptr(6)}),
            (4, "GameObject", {"m_Component": [{"component": ptr(5)}]}),
            (5, "Transform", transform(4, parent=2)),
            (6, "Mesh", {"m_Name": "mesh"})]


class GraphFixture(Fixture):
    def snapshot(self, items=None, externals=()):
        self.loaded = member(model_items() if items is None else items, externals=externals)
        self.capture(loaded=self.loaded, trees=True)
        return self.root / "capture"

    def build(self, root=None, **kwargs):
        with patch.object(recover, "environment", return_value=NS(load_file=lambda *a, **kw: self.loaded)):
            return graph.build(root or self.root / "capture", **kwargs)

    def oid(self, pid):
        with sqlite3.connect(self.root / "capture/catalog.sqlite") as db:
            return db.execute("SELECT id FROM objects WHERE path_id=?", (pid,)).fetchone()[0]


class PointerTests(unittest.TestCase):
    def test_json_pointer_escaping_and_array_paths(self):
        tree = {"a/b~c": [ptr(-4)], "other": ptr(0)}
        self.assertEqual([p for p, _ in graph.pointers(tree)], ["/a~1b~0c/0", "/other"])

    def test_nonintegral_and_out_of_range_fields_rejected(self):
        for pointer in (ptr(True), ptr(2**63), ptr(-(2**63)-1), ptr(2, -1), ptr(3, 2**31), ptr(3, 2.0)):
            with self.subTest(pointer=pointer), self.assertRaises(RecoveryError):
                graph.pointer_values(pointer)

    def test_signed_path_id_boundary_is_retained(self):
        self.assertEqual(graph.pointer_values(ptr(-2**63)), (0, -2**63))

    def test_container_pair_paths_preserved_not_used_as_destinations(self):
        tree = {"m_Container": [["../../same.fbx", {"asset": ptr(1)}], ["Assets/other.fbx", {"asset": ptr(2)}]]}
        self.assertEqual(list(graph.container_entries(tree)), [("../../same.fbx", "/m_Container/0/1/asset"), ("Assets/other.fbx", "/m_Container/1/1/asset")])

    def test_container_dict_form(self):
        self.assertEqual(list(graph.container_entries({"m_Container": {"A/B": {"asset": ptr(1)}}})), [("A/B", "/m_Container/A~1B/asset")])


class GraphTests(GraphFixture):
    def test_complete_graph_and_model_hierarchy(self):
        root = self.snapshot()
        result = self.build()
        self.assertTrue(result["graph_complete"])
        self.assertFalse(result["godot_port_complete"])
        cat = Catalog(root)
        try:
            self.assertEqual(graph.verify_graph(cat), [])
            result = graph.scene(cat, self.oid(1))
            self.assertTrue(result["hierarchy_complete"])
            self.assertEqual(len(result["nodes"]), 2)
            self.assertEqual(result["nodes"][0]["children"], [self.oid(5)])
            self.assertEqual(result["nodes"][0]["local_transform"]["m_LocalPosition"], [1, 2, 3])
            self.assertEqual(result["nodes"][0]["components"][1]["bindings"][1]["target_id"], self.oid(6))
        finally:
            cat.close()

    def test_decoder_failure_preserves_bytes_and_fails_completeness(self):
        root = self.snapshot([(1, "MonoBehaviour", {"example": "value"})])
        cat = Catalog(root)
        cat.db.execute("UPDATE objects SET tree_sha=NULL")
        cat.close()
        self.loaded.objects[1].tree = ValueError("unsupported script type")
        result = self.build()
        self.assertFalse(result["graph_complete"])
        cat = Catalog(root)
        try:
            self.assertEqual(cat.verify(), [])
            self.assertEqual(result["objects"], {"decode_failed": 1})
        finally:
            cat.close()

    def test_missing_object_is_not_discarded(self):
        self.snapshot([(1, "MeshFilter", {"m_Mesh": ptr(999)})])
        result = self.build()
        self.assertEqual(result["references"], {"missing_object": 1})
        self.assertFalse(result["graph_complete"])

    def test_invalid_and_null_pointers_are_distinguished(self):
        self.snapshot([(1, "MonoBehaviour", {"a": ptr(0), "b": ptr(3, -2)})])
        result = self.build()
        self.assertEqual(result["references"], {"invalid_pointer": 1, "null": 1})

    def test_external_slot_is_one_based(self):
        self.snapshot([(1, "MeshFilter", {"m_Mesh": ptr(1, 2)})], externals=("absent.assets",))
        result = self.build()
        self.assertEqual(result["references"], {"missing_external_slot": 1})

    def test_missing_external_content_is_not_labeled_cdn_only(self):
        self.snapshot([(1, "MeshFilter", {"m_Mesh": ptr(1, 1)})], externals=("absent.assets",))
        self.assertEqual(self.build()["references"], {"unresolved_in_capture": 1})

    def test_graph_limit_is_explicit_partial(self):
        self.snapshot()
        report = self.build(max_objects=2)
        self.assertEqual(report["objects"], {"decoded": 2, "not_decoded": 4})
        self.assertFalse(report["graph_complete"])

    def test_rebuild_is_idempotent(self):
        root = self.snapshot()
        first = self.build()
        second = self.build()
        self.assertEqual(first, second)
        cat = Catalog(root)
        try:
            self.assertEqual(cat.verify(), [])
            self.assertEqual(graph.verify_graph(cat), [])
        finally:
            cat.close()

    def test_changed_edge_and_missing_edge_detected(self):
        root = self.snapshot()
        self.build()
        cat = Catalog(root)
        try:
            cat.db.execute("UPDATE object_refs SET target_id=NULL WHERE status='resolved'")
            self.assertTrue(any("invalid pointer binding" in x for x in graph.verify_graph(cat)))
            cat.db.execute("DELETE FROM object_refs")
            self.assertTrue(any("pointer coverage" in x for x in graph.verify_graph(cat)))
        finally:
            cat.close()

    def test_missing_object_status_detected(self):
        root = self.snapshot()
        self.build()
        cat = Catalog(root)
        try:
            cat.db.execute("DELETE FROM graph_objects WHERE object_id=?", (self.oid(3),))
            self.assertIn("graph object coverage mismatch", graph.verify_graph(cat))
        finally:
            cat.close()

    def test_cached_tree_hash_corruption_is_rejected(self):
        root = self.snapshot()
        self.build()
        cat = Catalog(root)
        try:
            sha = cat.db.execute("SELECT tree_sha FROM objects LIMIT 1").fetchone()[0]
            cat.store.path(sha).write_bytes(b"{}")
            self.assertTrue(any("tree hash mismatch" in x for x in graph.verify_graph(cat)))
        finally:
            cat.close()

    def test_nonreciprocal_hierarchy_is_a_blocker(self):
        items = model_items()
        items[4][2]["m_Father"] = ptr(0)
        root = self.snapshot(items)
        self.build()
        cat = Catalog(root)
        try:
            result = graph.scene(cat, self.oid(1))
            self.assertFalse(result["hierarchy_complete"])
            self.assertTrue(any("nonreciprocal" in b["reason"] for b in result["blockers"]))
        finally:
            cat.close()

    def test_cycle_detected(self):
        items = model_items()
        items[4][2]["m_Children"] = [ptr(2)]
        items[1][2]["m_Father"] = ptr(5)
        root = self.snapshot(items)
        self.build()
        cat = Catalog(root)
        try:
            result = graph.scene(cat, self.oid(1))
            self.assertTrue(any("cycle" in b["reason"] for b in result["blockers"]))
        finally:
            cat.close()

    def test_nonunit_quaternion_rejected(self):
        items = model_items()
        items[1][2]["m_LocalRotation"]["w"] = 2.0
        root = self.snapshot(items)
        self.build()
        cat = Catalog(root)
        try:
            self.assertFalse(graph.scene(cat, self.oid(1))["hierarchy_complete"])
        finally:
            cat.close()

    def test_scene_node_budget_and_wrong_root_rejected(self):
        root = self.snapshot()
        self.build()
        cat = Catalog(root)
        try:
            self.assertFalse(graph.scene(cat, self.oid(1), max_nodes=1)["hierarchy_complete"])
            with self.assertRaises(RecoveryError):
                graph.scene(cat, self.oid(6))
        finally:
            cat.close()

    def test_unbuilt_graph_rejected(self):
        root = self.snapshot()
        cat = Catalog(root)
        try:
            self.assertEqual(graph.verify_graph(cat), ["graph has not been built"])
            with self.assertRaises(RecoveryError):
                graph.scene(cat, self.oid(1))
        finally:
            cat.close()

    def test_asset_paths_join_to_object_identity(self):
        items = model_items() + [(7, "AssetBundle", {"m_Container": [["Assets/MyModel.fbx", {"asset": ptr(1)}]]})]
        root = self.snapshot(items)
        self.assertEqual(self.build()["container_paths"], 1)
        cat = Catalog(root)
        try:
            row = cat.db.execute("SELECT original_path,target_id FROM container_paths p JOIN object_refs r ON p.ref_id=r.id").fetchone()
            self.assertEqual(tuple(row), ("Assets/MyModel.fbx", self.oid(1)))
        finally:
            cat.close()

    def test_bones_and_materials_retain_reference_order(self):
        items = model_items() + [(8, "SkinnedMeshRenderer", {"m_GameObject": ptr(1), "m_Mesh": ptr(6), "m_Bones": [ptr(5), ptr(2)], "m_RootBone": ptr(2), "m_Materials": [ptr(9)]}), (9, "Material", {"m_Name": "material"})]
        self.snapshot(items)
        self.build()
        cat = self.cat()
        try:
            refs = {r["pointer_path"]: r["target_id"] for r in cat.db.execute("SELECT * FROM object_refs WHERE source_id=?", (self.oid(8),))}
            self.assertEqual(refs["/m_Bones/0"], self.oid(5))
            self.assertEqual(refs["/m_Bones/1"], self.oid(2))
            self.assertEqual(refs["/m_Materials/0"], self.oid(9))
        finally:
            cat.close()


class ExternalGraphTests(Fixture):
    def test_cross_file_pointer_with_reused_signed_path_ids(self):
        source = member([(-4, "MeshFilter", {"m_Mesh": ptr(-4, 1)})], "source.assets", ("target.assets",))
        target = member([(-4, "Mesh", {"m_Name": "actual target"})], "target.assets")
        self.capture(loaded=NS(files={"source.assets": source, "target.assets": target}), trees=True)
        loader = lambda raw, name: {"source.assets": source, "target.assets": target}[name]
        with patch.object(recover, "environment", return_value=NS(load_file=loader)):
            report = graph.build(self.root / "capture")
        self.assertTrue(report["graph_complete"])
        cat = self.cat()
        try:
            edge = cat.db.execute("SELECT * FROM object_refs").fetchone()
            self.assertNotEqual(edge["source_id"], edge["target_id"])
            self.assertEqual(cat.db.execute("SELECT type FROM objects WHERE id=?", (edge["target_id"],)).fetchone()[0], "Mesh")
        finally:
            cat.close()

    def test_ambiguous_exact_path_does_not_fall_back_to_weaker_local_match(self):
        self.capture(loaded=NS(files={"a/x.resS": NS(bytes=b"one"), "b/x.resS": NS(bytes=b"two")}))
        cat = self.cat()
        try:
            rows = cat.db.execute("SELECT id FROM members ORDER BY id").fetchall()
            cat.db.execute("UPDATE members SET normalized_name='a/x.ress'")
            # A qualified name with conflicting exact matches must not be guessed.
            self.assertEqual(cat.resolve("a/x.resS", rows[0][0])[0], "ambiguous")
        finally:
            cat.close()


class TransferTests(Fixture):
    def source(self):
        return self.apk([("classes.dex", b"fake fixture dex" * 20), ("AndroidManifest.xml", b"fixture")])

    def test_split_assemble_exact_bytes(self):
        apk = self.source()
        parts = self.root / "parts"
        manifest = transfer.split(apk, parts, 73)
        output = self.root / "rejoined.apk"
        result = transfer.assemble(parts / "transfer.json", output)
        self.assertEqual(output.read_bytes(), apk.read_bytes())
        self.assertEqual(result["sha256"], manifest["sha256"])
        self.assertGreater(result["parts_verified"], 1)

    def test_corrupt_part_rejected_without_final_or_temporary_output(self):
        parts = self.root / "parts"
        transfer.split(self.source(), parts, 73)
        p = parts / "apk.part00000"
        p.write_bytes(b"x" * p.stat().st_size)
        output = self.root / "rejoined.apk"
        with self.assertRaisesRegex(ValueError, "hash mismatch"):
            transfer.assemble(parts / "transfer.json", output)
        self.assertFalse(output.exists())
        self.assertFalse(list(self.root.glob(".apk-join-*")))

    def test_missing_part(self):
        parts = self.root / "parts"
        transfer.split(self.source(), parts, 73)
        (parts / "apk.part00000").unlink()
        with self.assertRaises(ValueError):
            transfer.assemble(parts / "transfer.json", self.root / "output.apk")

    def test_overwrite_is_refused(self):
        apk = self.source()
        parts = self.root / "parts"
        transfer.split(apk, parts)
        with self.assertRaises(ValueError):
            transfer.assemble(parts / "transfer.json", apk)
        with self.assertRaises(ValueError):
            transfer.split(apk, parts)

    def test_manifest_path_injection_and_reordering_rejected(self):
        parts = self.root / "parts"
        data = transfer.split(self.source(), parts, 73)
        for name in ["../../private", "apk.part00001", "/etc/passwd"]:
            data["parts"][0]["name"] = name
            (parts / "transfer.json").write_text(json.dumps(data))
            with self.assertRaises(ValueError):
                transfer.assemble(parts / "transfer.json", self.root / "joined.apk")

    def test_size_and_whole_hash_checked(self):
        parts = self.root / "parts"
        data = transfer.split(self.source(), parts)
        data["size"] += 1
        (parts / "transfer.json").write_text(json.dumps(data))
        with self.assertRaisesRegex(ValueError, "part sizes"):
            transfer.assemble(parts / "transfer.json", self.root / "joined.apk")
        data["size"] -= 1
        data["sha256"] = "0" * 64
        (parts / "transfer.json").write_text(json.dumps(data))
        with self.assertRaisesRegex(ValueError, "whole-file"):
            transfer.assemble(parts / "transfer.json", self.root / "joined.apk")

    def test_html_and_empty_zip_are_not_apks(self):
        for content in [b"<html>denied</html>", b"PK\x05\x06" + bytes(18)]:
            path = self.root / "input.apk"
            path.write_bytes(content)
            with self.assertRaises(ValueError):
                transfer.split(path, self.root / "parts")

    def test_oversized_or_negative_part_size(self):
        apk = self.source()
        for n in (0, -1, 201 * 1024**2, True):
            with self.assertRaises(ValueError):
                transfer.split(apk, self.root / "parts", n)

    def test_symlink_part_refused(self):
        apk = self.source()
        parts = self.root / "parts"
        transfer.split(apk, parts)
        (parts / "apk.part00000").unlink()
        (parts / "apk.part00000").symlink_to(apk)
        with self.assertRaises(ValueError):
            transfer.assemble(parts / "transfer.json", self.root / "output.apk")


class SourceTests(Fixture):
    def repo(self):
        subprocess.run(["git", "init", "-q", str(self.root)], check=True)
        subprocess.run(["git", "-C", str(self.root), "-c", "user.name=Fixture", "-c", "user.email=fixture@example.invalid", "commit", "--allow-empty", "-qm", "fixture"], check=True)
        return self.root

    def tracked(self, name, data):
        path = self.root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(data)
        subprocess.run(["git", "-C", str(self.root), "add", "--", name], check=True)
        subprocess.run(["git", "-C", str(self.root), "-c", "user.name=Fixture", "-c", "user.email=fixture@example.invalid", "commit", "-qm", "fixture payload"], check=True)

    def test_hash_counts_and_static_markers_not_original_source_claim(self):
        repo = self.repo()
        self.tracked("source-app/lua/a.lua", b"return 1\n")
        self.tracked("source-app/src/a.java", b"/* Method not decompiled: example */")
        result = source_inventory.inspect(repo, self.root / "report")
        self.assertEqual(result["counts"], {"lua": 1, "java": 1})
        self.assertFalse(result["original_source_equivalence_proven"])
        self.assertEqual(result["static_markers"]["jadx_method_not_decompiled"], 1)
        rows = (self.root / "report/source-files.jsonl").read_bytes()
        self.assertEqual(digest(rows), result["inventory_sha256"])

    def test_empty_scope_rejected(self):
        with self.assertRaisesRegex(ValueError, "no tracked"):
            source_inventory.inspect(self.repo(), self.root / "out")

    def test_symlink_payload_rejected(self):
        self.repo()
        (self.root / "secret").write_bytes(b"not to be inspected")
        (self.root / "source-app").mkdir()
        (self.root / "source-app/alias.lua").symlink_to(self.root / "secret")
        subprocess.run(["git", "-C", str(self.root), "add", "source-app"], check=True)
        with self.assertRaises(ValueError):
            source_inventory.inspect(self.root, self.root / "out")

    @unittest.skipUnless(importlib.util.find_spec("lupa"), "Lua 5.3 provided by pinned CI dependency")
    def test_lua53_compile_does_not_execute_and_handles_bom(self):
        self.repo()
        self.tracked("source-app/lua/a.lua", b'error("must not execute")\n')
        self.tracked("source-app/lua/b.lua", b'\xef\xbb\xbfreturn 1\n')
        self.tracked("source-app/lua/c.lua", b'for i=1,3 do i=2 end\n')
        result = source_inventory.inspect(self.root, self.root / "out", lua53=True)
        self.assertEqual(result["lua_syntax"], {"runtime": "Lua 5.3", "passed": 3})
        self.tracked("source-app/lua/d.lua", b'local = invalid\n')
        result = source_inventory.inspect(self.root, self.root / "out", lua53=True)
        self.assertEqual(result["lua_syntax"]["failed"], 1)


def real_serialized_scene():
    """Unity 2019 player-format GameObject/Transform data with real PPtr fields."""
    def string(value):
        raw = struct.pack("<i", len(value)) + value
        return raw + bytes(-len(raw) % 4)
    def pointer(pid):
        return struct.pack("<iq", 0, pid)
    def go(name, tid):
        raw = struct.pack("<i", 1) + pointer(tid) + struct.pack("<i", 0) + string(name) + struct.pack("<H?", 0, True)
        # Padding belongs BETWEEN objects, not in GameObject byte_size.
        return raw
    def tr(goid, parent, children):
        return (pointer(goid) + struct.pack("<4f", 0, 0, 0, 1) + struct.pack("<3f", 1, 2, 3)
                + struct.pack("<3f", 1, 1, 1) + struct.pack("<i", len(children))
                + b"".join(pointer(c) for c in children) + pointer(parent))
    items = [(1, 0, go(b"Root", 2)), (2, 1, tr(1, 0, [4])),
             (3, 0, go(b"Child", 4)), (4, 1, tr(3, 2, []))]
    meta = b"2019.4.41f1\0" + struct.pack("<i?i", 13, False, 2)
    for class_id in (1, 4):
        meta += struct.pack("<i?h", class_id, False, -1) + bytes(16)
    meta += struct.pack("<i", len(items))
    meta += bytes(-(20 + len(meta)) % 4)
    raw = b""
    for pid, type_id, payload in items:
        raw += bytes(-len(raw) % 8)
        meta += struct.pack("<qIIi", pid, len(raw), len(payload), type_id)
        raw += payload
    meta += struct.pack("<ii", 0, 0) + b"\0"
    offset = (20 + len(meta) + 15) // 16 * 16
    padding = bytes(offset - 20 - len(meta))
    return struct.pack(">IIII", len(meta), offset + len(raw), 17, offset) + bytes(4) + meta + padding + raw


@unittest.skipUnless(importlib.util.find_spec("UnityPy"), "UnityPy required in CI")
class ActualGraphIntegration(Fixture):
    def test_real_unity_hierarchy_and_pointer_binding(self):
        apk = self.apk([("assets/bin/Data/scene.assets", real_serialized_scene())])
        root = self.root / "actual-scene"
        recover.capture(apk, root)
        report = graph.build(root)
        with sqlite3.connect(root / "catalog.sqlite") as db:
            diagnostics = db.execute("SELECT object_id,status,detail FROM graph_objects").fetchall()
        self.assertTrue(report["graph_complete"], (report, diagnostics))
        cat = Catalog(root)
        try:
            oid = cat.db.execute("SELECT id FROM objects WHERE path_id=1").fetchone()[0]
            result = graph.scene(cat, oid)
            self.assertTrue(result["hierarchy_complete"], result["blockers"])
            self.assertEqual([n["name"] for n in result["nodes"]], ["Root", "Child"])
            self.assertEqual(report["references"], {"null": 1, "resolved": 6})
        finally:
            cat.close()

    def test_real_unity_textasset_reparsed_and_graph_verified(self):
        apk = self.apk([("assets/bin/Data/sharedassets0.assets", real_serialized_textasset())])
        root = self.root / "actual"
        recover.capture(apk, root)
        report = graph.build(root)
        self.assertTrue(report["graph_complete"])
        self.assertEqual(report["objects"], {"decoded": 1})
        cat = Catalog(root)
        try:
            self.assertEqual(graph.verify_graph(cat), [])
            self.assertEqual(cat.verify(), [])
        finally:
            cat.close()


if __name__ == "__main__":
    unittest.main()
