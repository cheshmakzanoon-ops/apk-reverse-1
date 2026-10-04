#!/usr/bin/env python3
"""Integrity-checked offline APK transfer in <=200 MiB parts. Never overwrites inputs."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import tempfile
import zipfile

PART_LIMIT = 200 * 1024**2
BLOCK = 1024**2


def check_zip(path: Path) -> None:
    if not zipfile.is_zipfile(path):
        raise ValueError("input is not a ZIP/APK (possibly an HTML download error)")
    with zipfile.ZipFile(path) as archive:
        if not archive.infolist():
            raise ValueError("empty ZIP is not an APK input")


def split(apk: Path, output: Path, part_bytes: int = PART_LIMIT) -> dict:
    if type(part_bytes) is not int or not 1 <= part_bytes <= PART_LIMIT:
        raise ValueError("part size must be between 1 byte and 200 MiB")
    check_zip(apk)
    if output.exists() and (output.is_symlink() or any(output.iterdir())):
        raise ValueError("part output must be a new or empty directory")
    output.mkdir(parents=True, exist_ok=True)
    before = apk.stat()
    whole, parts, total = hashlib.sha256(), [], 0
    with apk.open("rb") as source:
        while True:
            first = source.read(min(BLOCK, part_bytes))
            if not first:
                break
            if len(parts) >= 10000:
                raise ValueError("too many parts; increase part size")
            name = f"apk.part{len(parts):05d}"
            ph, size = hashlib.sha256(), 0
            with (output / name).open("xb") as target:
                block = first
                while block:
                    target.write(block)
                    ph.update(block)
                    whole.update(block)
                    size += len(block)
                    block = source.read(min(BLOCK, part_bytes - size)) if size < part_bytes else b""
                target.flush()
                os.fsync(target.fileno())
            total += size
            parts.append({"name": name, "size": size, "sha256": ph.hexdigest()})
    after = apk.stat()
    if total != before.st_size or (before.st_size, before.st_mtime_ns) != (after.st_size, after.st_mtime_ns):
        raise ValueError("input changed during transfer; no completion manifest written")
    result = {"schema": 1, "size": total, "sha256": whole.hexdigest(), "parts": parts}
    # Written last: partial directories have no completion manifest.
    with (output / "transfer.json").open("x", encoding="utf-8") as f:
        json.dump(result, f, indent=2)
        f.write("\n")
    return result


def read_manifest(path: Path) -> dict:
    if path.is_symlink() or path.stat().st_size > 2 * 1024**2:
        raise ValueError("unsafe or oversized transfer manifest")
    data = json.loads(path.read_text(encoding="utf-8"))
    if data.get("schema") != 1 or not isinstance(data.get("parts"), list) or not 1 <= len(data["parts"]) <= 10000:
        raise ValueError("invalid transfer manifest")
    if type(data.get("size")) is not int or data["size"] <= 0:
        raise ValueError("invalid whole-file size")
    if not re.fullmatch(r"[0-9a-f]{64}", data.get("sha256", "")):
        raise ValueError("invalid whole-file digest")
    for index, part in enumerate(data["parts"]):
        if part.get("name") != f"apk.part{index:05d}":
            raise ValueError("part names/order invalid; paths are never accepted")
        if type(part.get("size")) is not int or not 1 <= part["size"] <= PART_LIMIT:
            raise ValueError("invalid part size")
        if not re.fullmatch(r"[0-9a-f]{64}", part.get("sha256", "")):
            raise ValueError("invalid part digest")
    if sum(part["size"] for part in data["parts"]) != data["size"]:
        raise ValueError("part sizes do not equal whole-file size")
    return data


def assemble(manifest: Path, output: Path) -> dict:
    data = read_manifest(manifest)
    if output.exists() or output.is_symlink():
        raise ValueError("refusing to overwrite destination")
    output.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp_name = tempfile.mkstemp(prefix=".apk-join-", dir=output.parent)
    tmp = Path(tmp_name)
    whole = hashlib.sha256()
    try:
        with os.fdopen(fd, "wb") as target:
            for part in data["parts"]:
                path = manifest.parent / part["name"]
                if path.is_symlink() or not path.is_file() or path.stat().st_size != part["size"]:
                    raise ValueError("missing/unsafe/wrong-size part: " + part["name"])
                ph, remaining = hashlib.sha256(), part["size"]
                with path.open("rb") as source:
                    while remaining:
                        block = source.read(min(BLOCK, remaining))
                        if not block:
                            raise ValueError("truncated part: " + part["name"])
                        remaining -= len(block)
                        ph.update(block)
                        whole.update(block)
                        target.write(block)
                    if source.read(1):
                        raise ValueError("part grew during assembly")
                if ph.hexdigest() != part["sha256"]:
                    raise ValueError("part hash mismatch: " + part["name"])
            target.flush()
            os.fsync(target.fileno())
        if whole.hexdigest() != data["sha256"] or tmp.stat().st_size != data["size"]:
            raise ValueError("whole-file integrity mismatch")
        check_zip(tmp)
        # Atomic create-only publication. An existing destination is never replaced.
        os.link(tmp, output)
        return {"sha256": whole.hexdigest(), "size": data["size"], "parts_verified": len(data["parts"])}
    finally:
        tmp.unlink(missing_ok=True)


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    p = commands.add_parser("split")
    p.add_argument("apk", type=Path)
    p.add_argument("output", type=Path)
    p.add_argument("--part-mib", type=int, default=200)
    p = commands.add_parser("assemble")
    p.add_argument("manifest", type=Path)
    p.add_argument("output", type=Path)
    args = parser.parse_args(argv)
    try:
        result = split(args.apk, args.output, args.part_mib * 1024**2) if args.command == "split" else assemble(args.manifest, args.output)
        print(json.dumps(result, indent=2))
        return 0
    except (OSError, ValueError, zipfile.BadZipFile) as exc:
        parser.exit(2, f"transfer failed: {exc}\n")


if __name__ == "__main__":
    raise SystemExit(main())
