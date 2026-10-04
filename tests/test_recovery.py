"""Synthetic recovery regressions. No proprietary game fixture or network required."""
import importlib.util
import io
import json
from pathlib import Path
import sqlite3
import struct
import sys
import tempfile
from types import SimpleNamespace as NS
import unittest
from unittest.mock import patch
import zipfile

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "tools"))
import recover
from recovery_core import (BlobStore, Catalog, RecoveryError, digest, identity,
                           lossless_tree, validate_obj, walk_fragment)

TRIANGLE = "# real synthetic geometry\nv 0 0 0\nv 1 0 0\nv 0 1 0\nf 1 2 3\n"


def bundle(payload=b"payload"):
    prefix = b"UnityFS\0" + struct.pack(">I", 6) + b"5.x.x\0" + b"2019.4.41f1\0"
    size = len(prefix) + 20 + len(payload)
    return prefix + struct.pack(">QIII", size, 0, 0, 0) + payload


class FakeObject:
    def __init__(self, raw=b"object", kind="Mesh", pid=1, start=0, tree=None):
        self.raw = raw
        self.type = NS(name=kind)
        self.path_id = pid
        self.byte_start = start
        self.byte_size = len(raw)
        self.tree = tree

    def get_raw_data(self):
        return self.raw

    def peek_name(self):
        return "same/name/../../not-a-destination"

    def parse_as_dict(self):
        if isinstance(self.tree, Exception):
            raise self.tree
        return self.tree or {"m_Name": "example", "buffer": b"\xff\x00"}

    def parse_as_object(self):
        return NS(export=lambda: TRIANGLE, m_Script="binary\udcff\x00")


def serial(kinds=("Mesh",), name="shared.assets", tree=None):
    objects, raw = {}, b""
    for i, kind in enumerate(kinds):
        payload = (kind + str(i)).encode()
        objects[i + 1] = FakeObject(payload, kind, i + 1, len(raw), tree)
        raw += payload
    return NS(name=name, reader=NS(bytes=raw), objects=objects, externals=[], files={})


class FakeEnvironment:
    loaded = None

    def load_file(self, *args, **kwargs):
        return self.loaded or serial()


class Fixture(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)

    def tearDown(self):
        self.temp.cleanup()

    def apk(self, entries):
        path = self.root / "input.apk"
        with zipfile.ZipFile(path, "w") as z:
            for name, data in entries:
                z.writestr(name, data)
        return path

    def capture(self, entries=None, *, loaded=None, **kw):
        entries = entries or [("assets/bin/Data/sharedassets0.assets", b"synthetic")]
        apk = self.apk(entries)
        env = FakeEnvironment()
        env.loaded = loaded
        with patch.object(recover, "unity_module", return_value=None), \
             patch.object(recover, "environment", return_value=env):
            result = recover.capture(apk, self.root / "capture", **kw)
        return result

    def cat(self):
        return Catalog(self.root / "capture")


class BlobTests(Fixture):
    def test_round_trip_and_dedup(self):
        store = BlobStore(self.root / "blobs")
        a, n = store.put(b"\x00\xff\x01")
        self.assertEqual((a, n), store.put(b"\x00\xff\x01"))
        self.assertEqual(store.used, 3)
        self.assertEqual(store.read_range(a, 1, 2), b"\xff\x01")

    def test_existing_corruption_is_not_trusted(self):
        store = BlobStore(self.root)
        sha, _ = store.put(b"good")
        store.path(sha).write_bytes(b"evil")
        with self.assertRaises(RecoveryError):
            store.put(b"good")

    def test_limits_short_reads_and_no_temporary_leak(self):
        store = BlobStore(self.root, max_bytes=3)
        with self.assertRaises(RecoveryError):
            store.put(b"large")
        with self.assertRaises(RecoveryError):
            store.put_stream(io.BytesIO(b"x"), 2)
        self.assertFalse(list(self.root.glob(".pending-*")))

    def test_safe_digest_and_stream_ranges(self):
        store = BlobStore(self.root)
        with self.assertRaises(RecoveryError):
            store.path("../../secret")
        sha, _ = store.put(b"abc")
        for off, count in [(-1, 1), (0, -1), (2, 2)]:
            with self.assertRaises(RecoveryError):
                store.read_range(sha, off, count)

    def test_symlink_rejected(self):
        store = BlobStore(self.root / "blobs")
        sha = digest(b"x")
        (store.root / sha[:2]).symlink_to(self.root, target_is_directory=True)
        with self.assertRaises(RecoveryError):
            store.put(b"x")


class FragmentTests(unittest.TestCase):
    def test_exact_walk(self):
        a, b = bundle(), bundle(b"second")
        self.assertEqual(list(walk_fragment(io.BytesIO(a + b), len(a + b))), [(0, len(a)), (len(a), len(b))])

    def test_trailing_noise_rejected(self):
        data = bundle() + b"noise"
        with self.assertRaises(RecoveryError):
            list(walk_fragment(io.BytesIO(data), len(data)))

    def test_bad_size_rejected(self):
        data = bytearray(bundle())
        p = 12 + len(b"5.x.x\0") + len(b"2019.4.41f1\0")
        for size in (0, 2**63):
            struct.pack_into(">Q", data, p, size)
            with self.assertRaises(RecoveryError):
                list(walk_fragment(io.BytesIO(data), len(data)))

    def test_invalid_header_rejected(self):
        for data in [b"UnityFS\0", b"not a bundle", b"UnityFS\0" + struct.pack(">I", 6) + b"a" * 240]:
            with self.assertRaises(RecoveryError):
                list(walk_fragment(io.BytesIO(data), len(data)))

    def test_unsupported_version_rejected(self):
        data = bytearray(bundle())
        struct.pack_into(">I", data, 8, 900)
        with self.assertRaises(RecoveryError):
            list(walk_fragment(io.BytesIO(data), len(data)))


class CaptureTests(Fixture):
    def test_every_type_preserved_not_just_old_whitelist(self):
        kinds = ("Mesh", "Material", "Transform", "GameObject", "AnimationClip", "Unknown")
        result = self.capture(loaded=serial(kinds))
        self.assertTrue(result["capture_complete"])
        self.assertEqual(result["counts"]["objects"], len(kinds))
        self.assertFalse(result["godot_android_port_complete"])
        cat = self.cat()
        try:
            self.assertEqual(cat.verify(), [])
            for row in cat.db.execute("SELECT o.*,m.sha AS member_sha FROM objects o JOIN members m ON m.id=o.member_id"):
                self.assertEqual(digest(cat.store.read_range(row["member_sha"], row["offset"], row["size"])), row["sha"])
        finally:
            cat.close()

    def test_reused_path_ids_in_different_members_do_not_collide(self):
        loaded = NS(files={"a": serial(name="a"), "b": serial(name="b")})
        result = self.capture(loaded=loaded)
        self.assertEqual(result["counts"]["objects"], 2)
        cat = self.cat()
        try:
            self.assertEqual(cat.db.execute("SELECT COUNT(DISTINCT id) FROM objects").fetchone()[0], 2)
            self.assertEqual(cat.verify(), [])
        finally:
            cat.close()

    def test_limited_run_is_partial_and_verification_fails(self):
        result = self.capture([("assets/AssetBundles/BundleFragment0.bytes", bundle() + bundle())], max_units=1)
        self.assertFalse(result["capture_complete"])
        self.assertEqual(result["state"], "partial")
        cat = self.cat()
        try:
            self.assertIn("capture is not complete", cat.verify())
        finally:
            cat.close()

    def test_unreadable_tree_does_not_lose_original(self):
        result = self.capture(loaded=serial(tree=ValueError("missing type tree")))
        self.assertTrue(result["capture_complete"])
        cat = self.cat()
        try:
            self.assertEqual(cat.db.execute("SELECT decode_error FROM objects").fetchone()[0], "missing type tree")
            self.assertEqual(cat.verify(), [])
        finally:
            cat.close()

    def test_invalid_object_span_fails_capture(self):
        bad = serial()
        bad.objects[1].byte_start = 999
        result = self.capture(loaded=bad)
        self.assertEqual(result["state"], "failed")
        cat = self.cat()
        try:
            self.assertTrue(cat.verify())
        finally:
            cat.close()

    def test_original_entry_names_cannot_escape_output(self):
        self.capture([("../../outside", b"original"), ("assets/bin/Data/x", b"x")])
        self.assertFalse((self.root / "outside").exists())
        cat = self.cat()
        try:
            self.assertEqual(cat.db.execute("SELECT name FROM entries ORDER BY ordinal LIMIT 1").fetchone()[0], "../../outside")
        finally:
            cat.close()

    def test_snapshot_is_not_overwritten(self):
        self.capture()
        with self.assertRaises(RecoveryError):
            Catalog(self.root / "capture", create=True)

    def test_split_inputs_reassembled(self):
        result = self.capture([("assets/bin/Data/a.split1", b"b"), ("assets/bin/Data/a.split0", b"a")])
        self.assertTrue(result["capture_complete"])
        cat = self.cat()
        try:
            unit = cat.db.execute("SELECT * FROM units").fetchone()
            self.assertEqual(cat.store.path(unit["sha"]).read_bytes(), b"ab")
        finally:
            cat.close()

    def test_orphan_split_rejected(self):
        with self.assertRaises(RecoveryError):
            self.capture([("assets/bin/Data/a.split1", b"b")])

    def test_stream_resolution_and_bounds(self):
        tree = {"m_StreamData": {"path": "archive:/cab/pixels.resS", "offset": 1, "size": 3}}
        loaded = NS(files={"cab": serial(("Texture2D",), tree=tree), "pixels.resS": NS(bytes=b"pixels")})
        result = self.capture(loaded=loaded)
        self.assertEqual(result["counts"]["dependencies"], {"resolved": 1})
        cat = self.cat()
        try:
            dep = cat.db.execute("SELECT * FROM dependencies").fetchone()
            target = cat.db.execute("SELECT * FROM members WHERE id=?", (dep["target_id"],)).fetchone()
            self.assertEqual(cat.store.read_range(target["sha"], dep["offset"], dep["size"]), b"ixe")
            cat.db.execute("UPDATE dependencies SET size=999")
            cat.resolve_dependencies()
            self.assertEqual(cat.db.execute("SELECT status FROM dependencies").fetchone()[0], "invalid_range")
        finally:
            cat.close()

    def test_missing_resource_is_not_labeled_remote(self):
        tree = {"m_StreamData": {"path": "absent.resS", "offset": 0, "size": 3}}
        result = self.capture(loaded=serial(("Texture2D",), tree=tree))
        self.assertEqual(result["counts"]["dependencies"], {"unresolved_in_capture": 1})
        self.assertTrue(result["capture_complete"])  # Raw preservation, not full asset export.

    def test_external_dependency_index(self):
        first = serial()
        first.externals = [NS(path="other.assets")]
        result = self.capture(loaded=NS(files={"first.assets": first, "other.assets": serial(name="other")}))
        self.assertEqual(result["counts"]["dependencies"], {"resolved": 1})

    def test_corrupted_blob_is_detected(self):
        self.capture()
        cat = self.cat()
        try:
            row = cat.db.execute("SELECT sha FROM members").fetchone()
            cat.store.path(row[0]).write_bytes(b"damaged")
            self.assertTrue(any("corrupt/missing" in e for e in cat.verify()))
        finally:
            cat.close()

    def test_missing_object_detected(self):
        self.capture(loaded=serial(("Material",)))
        cat = self.cat()
        try:
            cat.db.execute("DELETE FROM objects")
            self.assertTrue(any("object coverage" in e for e in cat.verify()))
        finally:
            cat.close()

    def test_invalid_export_is_not_accepted(self):
        self.capture(loaded=serial(("Material",)))
        cat = self.cat()
        try:
            oid = cat.db.execute("SELECT id FROM objects").fetchone()[0]
            sha, size = cat.blob(b"not a PNG")
            cat.db.execute("INSERT INTO exports VALUES (?,?,?,?,?,?)", (oid, "png", sha, size, "exported", '{"extension":"png"}'))
            self.assertTrue(any("invalid export" in e for e in cat.verify()))
        finally:
            cat.close()

    def test_missing_catalog_refuses(self):
        with self.assertRaises(RecoveryError):
            Catalog(self.root / "missing")


class ResolutionTests(Fixture):
    def test_duplicate_basenames_are_ambiguous_but_exact_paths_work(self):
        self.capture(loaded=NS(files={"a/t.resS": NS(bytes=b"a"), "b/t.resS": NS(bytes=b"b")}))
        cat = self.cat()
        try:
            self.assertEqual(cat.resolve("t.resS")[0], "ambiguous")
            state, member = cat.resolve("archive:/a/t.resS")
            self.assertEqual(state, "resolved")
            self.assertEqual(cat.store.path(member["sha"]).read_bytes(), b"a")
        finally:
            cat.close()

    def test_identical_alias_bytes_are_not_false_ambiguity(self):
        self.capture(loaded=NS(files={"a/t.resS": NS(bytes=b"same"), "b/t.resS": NS(bytes=b"same")}))
        cat = self.cat()
        try:
            self.assertEqual(cat.resolve("t.resS")[0], "resolved")
        finally:
            cat.close()


class ConversionTests(Fixture):
    def test_mesh_geometry_is_real_and_independently_parseable(self):
        ext, data, detail = recover.convert(FakeObject(), "Mesh")
        self.assertEqual(ext, "obj")
        self.assertEqual(detail["geometry"]["faces"], 1)
        import trimesh
        mesh = trimesh.load(io.BytesIO(data), file_type="obj", force="mesh")
        self.assertEqual(mesh.vertices.shape, (3, 3))
        self.assertEqual(mesh.faces.shape, (1, 3))

    def test_binary_text_surrogates_roundtrip(self):
        ext, data, _ = recover.convert(FakeObject(), "TextAsset")
        self.assertEqual(data, b"binary\xff\x00")

    def test_streamed_texture_not_rejected_for_empty_inline_data(self):
        texture = NS(image_data=b"", m_StreamData=NS(size=4), get_image_data=lambda: b"rgba")
        self.assertEqual(recover.texture_data(texture), b"rgba")

    def test_missing_and_short_texture_bytes_rejected(self):
        for raw in (b"", b"short"):
            texture = NS(image_data=b"", m_StreamData=NS(size=16), get_image_data=lambda: raw)
            with self.assertRaises(RecoveryError):
                recover.texture_data(texture)

    def test_sprite_uses_texture_field_not_text(self):
        expected = object()
        pointer = NS(deref_parse_as_object=lambda: expected)
        sprite = NS(m_RD=NS(texture=pointer, alphaTexture=None), m_SpriteAtlas=None, m_AtlasTags=[])
        self.assertEqual(list(recover.sprite_textures(sprite)), [expected])

    def test_lossless_binary_and_deep_tree(self):
        cat = Catalog(self.root / "cat", create=True)
        try:
            tree = {"raw": b"\xff\x00"}
            for _ in range(30):
                tree = {"child": tree}
            output = lossless_tree(tree, cat)
            for _ in range(30):
                output = output["child"]
            ref = output["raw"]
            self.assertEqual(cat.store.path(ref["$binary"]).read_bytes(), b"\xff\x00")
        finally:
            cat.close()

    def test_unknown_tree_value_is_not_silently_stringified(self):
        cat = Catalog(self.root / "cat", create=True)
        try:
            with self.assertRaises(RecoveryError):
                lossless_tree(object(), cat)
        finally:
            cat.close()

    def test_obj_placeholders_invalid_indices_and_nonfinite_rejected(self):
        for text in ["# placeholder\nv \n", TRIANGLE.replace("1 2 3", "1 2 9"),
                     TRIANGLE.replace("v 1 0 0", "v nan 0 0"),
                     TRIANGLE.replace("1 2 3", "0 2 3"),
                     TRIANGLE.replace("1 2 3", "1/99 2/99 3/99")]:
            with self.assertRaises((RecoveryError, ValueError)):
                validate_obj(text)

    def test_negative_obj_indices(self):
        self.assertEqual(validate_obj(TRIANGLE.replace("1 2 3", "-3 -2 -1"))["faces"], 1)

    def test_export_and_materialize_have_collision_free_ids(self):
        self.capture(loaded=serial(("Mesh", "Mesh")))
        env = FakeEnvironment()
        env.loaded = serial(("Mesh", "Mesh"))
        with patch.object(recover, "environment", return_value=env):
            report = recover.export_assets(self.root / "capture", kinds=["Mesh"], limit=0)
        self.assertEqual(report["attempted"], 2)
        self.assertEqual(report["failed"], 0)
        output = self.root / "exported"
        self.assertEqual(recover.materialize(self.root / "capture", output), 2)
        self.assertEqual(len(list(output.glob("*.obj"))), 2)
        self.assertTrue(all(len(p.stem) == 64 for p in output.glob("*.obj")))


def real_serialized_textasset():
    """A tiny Unity version-17 serialized TextAsset fixture, not mocked parser data."""
    def string(value):
        data = struct.pack("<i", len(value)) + value
        return data + b"\0" * (-len(data) % 4)
    raw = string(b"fixture") + string(b"original\xff\0bytes")
    meta = b"2019.4.41f1\0" + struct.pack("<i?i", 13, False, 1)
    meta += struct.pack("<i?h", 49, False, -1) + bytes(16)
    meta += struct.pack("<i", 1)
    meta += bytes(-(20 + len(meta)) % 4)
    meta += struct.pack("<qIIi", 1, 0, len(raw), 0)
    meta += struct.pack("<ii", 0, 0) + b"\0"
    data_offset = 20 + len(meta)
    return struct.pack(">IIII", len(meta), data_offset + len(raw), 17, data_offset) + bytes(4) + meta + raw


@unittest.skipUnless(importlib.util.find_spec("UnityPy"), "UnityPy unavailable in local offline runtime; required by CI")
class ActualUnityIntegration(Fixture):
    def test_real_serialized_file_capture_and_binary_export(self):
        apk = self.apk([("assets/bin/Data/sharedassets0.assets", real_serialized_textasset())])
        root = self.root / "actual"
        result = recover.capture(apk, root)
        self.assertTrue(result["capture_complete"])
        self.assertEqual(result["counts"]["object_types"], {"TextAsset": 1})
        report = recover.export_assets(root, kinds=["TextAsset"], limit=0)
        self.assertEqual(report["failed"], 0)
        cat = Catalog(root)
        try:
            self.assertEqual(cat.verify(), [])
            sha = cat.db.execute("SELECT sha FROM exports").fetchone()[0]
            self.assertEqual(cat.store.path(sha).read_bytes(), b"original\xff\0bytes")
        finally:
            cat.close()


if __name__ == "__main__":
    unittest.main()
