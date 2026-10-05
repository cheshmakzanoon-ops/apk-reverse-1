"""Content-addressed, offline recovery primitives. No Unity dependency or execution.

Original names are metadata, NEVER filesystem destinations. SQLite object identities
include the source, serialized member, and signed 64-bit Unity path ID. Completion
of an input capture is deliberately distinct from recovery of a playable game.
"""
from __future__ import annotations

import hashlib
import io
import json
import math
import os
from pathlib import Path
import re
import sqlite3
import struct
import tempfile
from typing import BinaryIO, Iterator

SCHEMA = 1
CHUNK = 1024 * 1024


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def identity(*parts: object) -> str:
    return digest(json.dumps(parts, ensure_ascii=True, separators=(",", ":")).encode())


def json_bytes(value: object) -> bytes:
    return (json.dumps(value, ensure_ascii=True, sort_keys=True, indent=2,
                       allow_nan=False) + "\n").encode()


def key(name: str) -> str:
    """Unity archive names are logical identifiers, not paths to open on disk."""
    name = name.replace("\\", "/").lower()
    if name.startswith("archive:/"):
        name = name[len("archive:/"):]
    return name.lstrip("/")


class RecoveryError(ValueError):
    pass


class BlobStore:
    """Stream immutable blobs into hash-only paths, with a hard storage budget."""

    def __init__(self, root: Path, max_bytes: int = 16 * 1024**3):
        self.root = Path(root)
        self.root.mkdir(parents=True, exist_ok=True)
        if self.root.is_symlink():
            raise RecoveryError("blob directory must not be a symlink")
        self.max_bytes = max_bytes
        self.used = sum(p.stat().st_size for p in self.root.glob("*/*") if p.is_file())

    def path(self, sha: str) -> Path:
        if not re.fullmatch(r"[0-9a-f]{64}", sha):
            raise RecoveryError("invalid blob digest")
        result = self.root / sha[:2] / sha
        if result.parent.is_symlink() or result.is_symlink():
            raise RecoveryError("symlink inside blob store")
        return result

    def put(self, data: bytes) -> tuple[str, int]:
        return self.put_stream(io.BytesIO(data), len(data))

    def put_stream(self, source: BinaryIO, expected_size: int | None = None) -> tuple[str, int]:
        h = hashlib.sha256()
        size = 0
        fd, tmp = tempfile.mkstemp(prefix=".pending-", dir=self.root)
        try:
            with os.fdopen(fd, "wb") as out:
                while block := source.read(CHUNK):
                    size += len(block)
                    if self.used + size > self.max_bytes:
                        raise RecoveryError("blob storage budget exceeded")
                    h.update(block)
                    out.write(block)
                out.flush()
                os.fsync(out.fileno())
            if expected_size is not None and size != expected_size:
                raise RecoveryError(f"short/long input: expected {expected_size}, read {size}")
            sha = h.hexdigest()
            target = self.path(sha)
            target.parent.mkdir(exist_ok=True)
            if target.exists():
                # Existing content must be verified, never silently trusted by size.
                if file_digest(target) != sha:
                    raise RecoveryError(f"existing blob corrupted: {sha}")
            else:
                os.replace(tmp, target)
                self.used += size
            return sha, size
        finally:
            if os.path.exists(tmp):
                os.unlink(tmp)

    def read_range(self, sha: str, offset: int, size: int) -> bytes:
        path = self.path(sha)
        if offset < 0 or size < 0 or offset + size > path.stat().st_size:
            raise RecoveryError("resource range outside preserved blob")
        with path.open("rb") as f:
            f.seek(offset)
            result = f.read(size)
        if len(result) != size:
            raise RecoveryError("short resource read")
        return result


def file_digest(path: Path) -> str:
    with path.open("rb") as f:
        return hashlib.file_digest(f, "sha256").hexdigest()


def walk_fragment(stream: BinaryIO, total: int) -> Iterator[tuple[int, int]]:
    """Strict UnityFS walk; never resynchronise by scanning for a plausible magic."""
    offset = 0
    while offset < total:
        stream.seek(offset)
        header = stream.read(min(256, total - offset))
        if len(header) < 12 or header[:8] != b"UnityFS\0":
            raise RecoveryError(f"missing UnityFS header at {offset}")
        version = struct.unpack_from(">I", header, 8)[0]
        if version not in (6, 7, 8):
            raise RecoveryError(f"unsupported UnityFS format {version} at {offset}")
        p = 12
        for _ in range(2):
            end = header.find(b"\0", p)
            if end < p or end - p > 64:
                raise RecoveryError(f"invalid UnityFS version string at {offset}")
            p = end + 1
        if p + 20 > len(header):
            raise RecoveryError(f"truncated UnityFS size fields at {offset}")
        size = struct.unpack_from(">Q", header, p)[0]
        if size < p + 20 or offset + size > total:
            raise RecoveryError(f"invalid UnityFS extent at {offset}: {size}")
        yield offset, size
        offset += size
    if offset != total:
        raise RecoveryError("fragment not consumed exactly")


DDL = """
PRAGMA foreign_keys=ON;
CREATE TABLE meta(key TEXT PRIMARY KEY, value TEXT NOT NULL);
CREATE TABLE blobs(sha TEXT PRIMARY KEY, size INTEGER NOT NULL CHECK(size>=0));
CREATE TABLE entries(id TEXT PRIMARY KEY, ordinal INTEGER UNIQUE NOT NULL,
 name TEXT NOT NULL, sha TEXT NOT NULL REFERENCES blobs, size INTEGER NOT NULL,
 crc INTEGER NOT NULL, compressed_size INTEGER NOT NULL, is_dir INTEGER NOT NULL);
CREATE TABLE units(id TEXT PRIMARY KEY, entry_id TEXT NOT NULL REFERENCES entries,
 name TEXT NOT NULL, sha TEXT NOT NULL REFERENCES blobs, offset INTEGER NOT NULL,
 size INTEGER NOT NULL, status TEXT NOT NULL, error TEXT);
CREATE TABLE members(id TEXT PRIMARY KEY, unit_id TEXT NOT NULL REFERENCES units,
 name TEXT NOT NULL, normalized_name TEXT NOT NULL, basename TEXT NOT NULL,
 sha TEXT NOT NULL REFERENCES blobs, size INTEGER NOT NULL, kind TEXT NOT NULL,
 expected_objects INTEGER NOT NULL DEFAULT 0);
CREATE INDEX member_names ON members(normalized_name);
CREATE INDEX member_basenames ON members(basename);
CREATE TABLE objects(id TEXT PRIMARY KEY, member_id TEXT NOT NULL REFERENCES members,
 path_id INTEGER NOT NULL, type TEXT NOT NULL, name TEXT,
 offset INTEGER NOT NULL, size INTEGER NOT NULL, sha TEXT NOT NULL,
 tree_sha TEXT REFERENCES blobs, decode_error TEXT,
 UNIQUE(member_id,path_id));
CREATE INDEX object_types ON objects(type);
CREATE TABLE dependencies(id TEXT PRIMARY KEY, member_id TEXT NOT NULL REFERENCES members,
 object_id TEXT REFERENCES objects, kind TEXT NOT NULL, name TEXT NOT NULL,
 offset INTEGER, size INTEGER, status TEXT NOT NULL, target_id TEXT REFERENCES members,
 detail TEXT);
CREATE TABLE exports(object_id TEXT NOT NULL REFERENCES objects, format TEXT NOT NULL,
 sha TEXT REFERENCES blobs, size INTEGER, status TEXT NOT NULL, detail TEXT,
 PRIMARY KEY(object_id,format));
CREATE TABLE issues(id INTEGER PRIMARY KEY, scope TEXT NOT NULL, detail TEXT NOT NULL);
"""


class Catalog:
    def __init__(self, root: Path, *, create: bool = False, max_bytes: int = 16 * 1024**3):
        self.root = Path(root)
        db = self.root / "catalog.sqlite"
        if create:
            if self.root.exists() and any(self.root.iterdir()):
                raise RecoveryError("output must be empty; use a new snapshot directory")
            self.root.mkdir(parents=True, exist_ok=True)
        elif not db.is_file():
            raise RecoveryError("capture catalog is missing")
        if db.is_symlink():
            raise RecoveryError("catalog must not be a symlink")
        self.db = sqlite3.connect(db)
        self.db.row_factory = sqlite3.Row
        self.db.execute("PRAGMA foreign_keys=ON")
        if create:
            self.db.executescript(DDL)
        self.store = BlobStore(self.root / "blobs", max_bytes)
        if create:
            self.set_meta("schema", SCHEMA)
            self.set_meta("state", "capturing")
            self.db.commit()
        elif self.get_meta("schema") != SCHEMA:
            raise RecoveryError("unsupported catalog schema")

    def close(self):
        self.db.commit()
        self.db.close()

    def set_meta(self, name: str, value: object):
        self.db.execute("INSERT OR REPLACE INTO meta VALUES (?,?)", (name, json.dumps(value)))

    def get_meta(self, name: str, default=None):
        row = self.db.execute("SELECT value FROM meta WHERE key=?", (name,)).fetchone()
        return json.loads(row[0]) if row else default

    def blob(self, data: bytes) -> tuple[str, int]:
        sha, size = self.store.put(data)
        self.db.execute("INSERT OR IGNORE INTO blobs VALUES (?,?)", (sha, size))
        return sha, size

    def blob_stream(self, stream: BinaryIO, size: int) -> tuple[str, int]:
        sha, actual = self.store.put_stream(stream, size)
        self.db.execute("INSERT OR IGNORE INTO blobs VALUES (?,?)", (sha, actual))
        return sha, actual

    def issue(self, scope: str, error: object):
        self.db.execute("INSERT INTO issues(scope,detail) VALUES (?,?)", (scope, str(error)))

    def resolve(self, name: str, owner: str | None = None) -> tuple[str, sqlite3.Row | None]:
        """Exact name, owner-local basename, then globally unique basename.

        Never select the first of several plausible candidates. Different members
        with identical bytes are not ambiguous for resource/serialized-file reads.
        """
        norm = key(name)
        base = norm.rsplit("/", 1)[-1]
        queries = []
        # A bare name is scoped to its requesting bundle before global aliases.
        # Qualified exact names take priority. Never weaken an ambiguous match.
        if "/" in norm:
            queries.append(("normalized_name=?", (norm,)))
        if owner:
            queries.append(("unit_id=(SELECT unit_id FROM members WHERE id=?) AND basename=?",
                            (owner, base)))
        if "/" not in norm:
            queries.append(("normalized_name=?", (norm,)))
        queries.append(("basename=?", (base,)))
        for clause, args in queries:
            rows = self.db.execute("SELECT * FROM members WHERE " + clause + " ORDER BY id", args).fetchall()
            if not rows:
                continue
            if len({r["sha"] for r in rows}) != 1:
                return "ambiguous", None
            return "resolved", rows[0]
        return "unresolved_in_capture", None

    def resolve_dependencies(self):
        for dep in self.db.execute("SELECT * FROM dependencies ORDER BY id").fetchall():
            state, target = self.resolve(dep["name"], dep["member_id"])
            detail = None
            if target is not None and dep["size"] is not None:
                off, size = dep["offset"], dep["size"]
                if off is None or off < 0 or size < 0 or off + size > target["size"]:
                    state, detail = "invalid_range", "stream range exceeds preserved resource"
            self.db.execute("UPDATE dependencies SET status=?,target_id=?,detail=? WHERE id=?",
                            (state, target["id"] if target else None, detail, dep["id"]))
        self.db.commit()

    def summary(self) -> dict:
        counts = {table: self.db.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
                  for table in ("entries", "units", "members", "objects", "issues", "exports")}
        counts["object_types"] = dict(self.db.execute("SELECT type,COUNT(*) FROM objects GROUP BY type"))
        counts["dependencies"] = dict(self.db.execute("SELECT status,COUNT(*) FROM dependencies GROUP BY status"))
        counts["export_states"] = dict(self.db.execute("SELECT status,COUNT(*) FROM exports GROUP BY status"))
        return {"schema": SCHEMA, "state": self.get_meta("state"),
                "input_sha256": self.get_meta("input_sha256"),
                "input_entries_expected": self.get_meta("input_entries_expected"),
                "capture_complete": self.get_meta("state") == "captured",
                "original_source_recovered": False, "godot_android_port_complete": False,
                "counts": counts}

    def write_summary(self):
        (self.root / "summary.json").write_bytes(json_bytes(self.summary()))

    def verify(self) -> list[str]:
        errors = []
        if self.get_meta("state") != "captured":
            errors.append("capture is not complete")
        if self.db.execute("PRAGMA integrity_check").fetchone()[0] != "ok":
            errors.append("SQLite integrity check failed")
        if self.db.execute("PRAGMA foreign_key_check").fetchone():
            errors.append("catalog foreign key violation")
        if self.get_meta("input_entries_expected") != self.db.execute("SELECT COUNT(*) FROM entries").fetchone()[0]:
            errors.append("APK entry coverage mismatch")
        if not self.db.execute("SELECT COUNT(*) FROM units").fetchone()[0]:
            errors.append("no Unity units were inventoried")
        if self.db.execute("SELECT COUNT(*) FROM units WHERE status!='indexed'").fetchone()[0]:
            errors.append("one or more Unity units not indexed")
        if self.db.execute("SELECT COUNT(*) FROM issues").fetchone()[0]:
            errors.append("capture has recorded errors")
        seen = set()
        for row in self.db.execute("SELECT * FROM blobs"):
            seen.add(row["sha"])
            p = self.store.path(row["sha"])
            if not p.is_file() or p.stat().st_size != row["size"] or file_digest(p) != row["sha"]:
                errors.append("corrupt/missing blob: " + row["sha"])
        if self.get_meta("input_sha256") not in seen:
            errors.append("original APK blob is missing from the catalog")
        actual = {p.name for p in self.store.root.glob("*/*") if p.is_file()}
        if actual != seen:
            errors.append("unaccounted blob files")
        for member in self.db.execute("SELECT * FROM members"):
            objects = self.db.execute("SELECT * FROM objects WHERE member_id=?", (member["id"],)).fetchall()
            if len(objects) != member["expected_objects"]:
                errors.append("object coverage mismatch: " + member["id"])
            # One open per member; the catalog can contain a million objects.
            p = self.store.path(member["sha"])
            if not p.is_file():
                continue
            with p.open("rb") as f:
                for obj in objects:
                    if obj["offset"] < 0 or obj["size"] < 0 or obj["offset"] + obj["size"] > member["size"]:
                        errors.append("invalid object range: " + obj["id"])
                        continue
                    f.seek(obj["offset"])
                    if digest(f.read(obj["size"])) != obj["sha"]:
                        errors.append("object hash mismatch: " + obj["id"])
        # Unresolved dependencies are explicitly reported, not mislabeled CDN-only.
        # They do not invalidate preservation of bytes that WERE in this capture.
        for dep in self.db.execute("SELECT * FROM dependencies WHERE status='resolved'"):
            target = self.db.execute("SELECT * FROM members WHERE id=?", (dep["target_id"],)).fetchone()
            if target is None or (dep["size"] is not None and
                (dep["offset"] < 0 or dep["size"] < 0 or dep["offset"] + dep["size"] > target["size"])):
                errors.append("invalid resolved dependency: " + dep["id"])
        for exp in self.db.execute("SELECT * FROM exports WHERE status='exported'"):
            try:
                detail = json.loads(exp["detail"])
                data = self.store.path(exp["sha"]).read_bytes()
                if len(data) != exp["size"]:
                    raise RecoveryError("export size mismatch")
                if detail["extension"] == "obj":
                    validate_obj(data.decode("utf-8"))
                elif detail["extension"] == "png":
                    from PIL import Image
                    with Image.open(io.BytesIO(data)) as image:
                        image.verify()
                elif detail["extension"] == "wav":
                    from recovery_audio import validate_wav
                    validate_wav(data)
                elif detail["extension"] == "bin" and detail.get("storage") == "unity_float_texture_v1":
                    from recovery_numeric_texture import validate_numeric_texture
                    validate_numeric_texture(data, detail)
                elif detail["extension"] != "bin":
                    raise RecoveryError("unknown export format")
            except Exception as exc:
                errors.append("invalid export: " + exp["object_id"] + ": " + str(exc))
        return errors


def lossless_tree(value: object, catalog: Catalog) -> object:
    """Binary fields become verified blob references, never '<N bytes>' labels."""
    if isinstance(value, (bytes, bytearray, memoryview)):
        sha, size = catalog.blob(bytes(value))
        return {"$binary": sha, "size": size}
    if isinstance(value, dict):
        if not all(isinstance(k, str) for k in value):
            return {"$pairs": [[lossless_tree(k, catalog), lossless_tree(v, catalog)]
                               for k, v in value.items()]}
        return {k: lossless_tree(v, catalog) for k, v in value.items()}
    if isinstance(value, (list, tuple)):
        return [lossless_tree(v, catalog) for v in value]
    if isinstance(value, float) and not math.isfinite(value):
        return {"$float64": struct.pack(">d", value).hex()}
    if value is None or isinstance(value, (str, int, float, bool)):
        return value
    raise RecoveryError(f"unsupported typetree value: {type(value).__name__}")


def validate_obj(text: str) -> dict[str, int]:
    """Reject empty/placeholder geometry and invalid position/UV/normal indices."""
    counts = {"v": 0, "vt": 0, "vn": 0, "faces": 0}
    faces = []
    for line in text.splitlines():
        fields = line.split()
        if not fields or fields[0].startswith("#"):
            continue
        tag = fields[0]
        if tag in ("v", "vt", "vn"):
            minimum = 2 if tag == "vt" else 3
            if len(fields) < minimum + 1 or not all(math.isfinite(float(x)) for x in fields[1:]):
                raise RecoveryError("invalid OBJ coordinate")
            counts[tag] += 1
        elif tag == "f":
            if len(fields) < 4:
                raise RecoveryError("OBJ face has fewer than three corners")
            faces.append((fields[1:], dict(counts)))
    if counts["v"] < 3 or not faces:
        raise RecoveryError("OBJ contains no usable geometry")
    for corners, before in faces:
        for corner in corners:
            indices = corner.split("/")
            if len(indices) > 3 or not indices[0]:
                raise RecoveryError("invalid OBJ face token")
            for token, kind in zip(indices, ("v", "vt", "vn")):
                if not token:
                    continue
                i = int(token)
                if i == 0 or (i > 0 and i > counts[kind]) or (i < 0 and -i > before[kind]):
                    raise RecoveryError("OBJ face index out of bounds")
    counts["faces"] = len(faces)
    return counts
