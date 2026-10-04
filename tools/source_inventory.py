#!/usr/bin/env python3
"""Hash tracked recovery files; optionally compile Lua 5.3 without executing game code.

Counts are client artifacts, NOT exact original source or semantic equivalence.
Only tracked regular files below source-app are inspected; symlinks are rejected.
"""
from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import json
import os
from pathlib import Path
import subprocess
import tempfile

KINDS = {".cs": "csharp", ".java": "java", ".lua": "lua", ".dll": "managed_binary",
         ".mdl": "packed_managed_binary", ".so": "native_binary", ".luac": "lua_bytecode"}


def inspect(repo: Path, output: Path, *, lua53=False) -> dict:
    head = subprocess.check_output(["git", "-C", str(repo), "rev-parse", "HEAD"], text=True).strip()
    if subprocess.run(["git", "-C", str(repo), "diff", "--quiet", "HEAD", "--", "source-app"]).returncode:
        raise ValueError("tracked source-app files differ from HEAD; commit or restore first")
    paths = subprocess.check_output(["git", "-C", str(repo), "ls-files", "-z", "--", "source-app"])
    names = sorted(os.fsdecode(p) for p in paths.split(b"\0") if p)
    if not names:
        raise ValueError("no tracked source-app payload; empty scope cannot pass")
    runtime = loader = None
    if lua53:
        from lupa.lua53 import LuaRuntime
        runtime = LuaRuntime(encoding=None, unpack_returned_tuples=True)
        if runtime.eval("_VERSION") != b"Lua 5.3":
            raise ValueError("Lua 5.3 is required")
        loader = runtime.eval("load")
    output.mkdir(parents=True, exist_ok=True)
    counts, totals, findings = Counter(), Counter(), Counter()
    lua = Counter()
    h = hashlib.sha256()
    fd, temporary = tempfile.mkstemp(prefix=".source-inventory-", dir=output)
    try:
        with os.fdopen(fd, "wb") as rows:
            for name in names:
                path = repo / name
                if path.is_symlink() or not path.is_file() or not path.resolve().is_relative_to(repo.resolve()):
                    raise ValueError("unsafe or missing tracked payload: " + name)
                raw = path.read_bytes()
                kind = KINDS.get(path.suffix.lower(), "other_asset")
                sha = hashlib.sha256(raw).hexdigest()
                record = {"path": name, "sha256": sha, "size": len(raw), "kind": kind}
                counts[kind] += 1
                totals[kind] += len(raw)
                if kind in {"lua", "csharp", "java"}:
                    record["lines"] = len(raw.splitlines())
                    flags = []
                    for marker, label in [(b"Method not decompiled:", "jadx_method_not_decompiled"),
                                          (b"ILSpy", "ilspy_text_marker"),
                                          (b"throw new NotImplementedException", "not_implemented_throw_marker")]:
                        occurrences = raw.count(marker)
                        if occurrences:
                            flags.append({"marker": label, "occurrences": occurrences})
                            findings[label] += occurrences
                    record["static_markers"] = flags
                if kind == "lua" and loader:
                    # Lua's C load() (unlike a file loader) does not remove BOM.
                    source = raw[3:] if raw.startswith(b"\xef\xbb\xbf") else raw
                    try:
                        result = loader(source, ("@" + name).encode(), b"t")
                        if isinstance(result, tuple) and result[0] is None:
                            record["syntax"] = "failed"
                            record["syntax_error"] = result[1].decode("utf-8", "replace")
                        else:
                            record["syntax"] = "passed"
                        del result
                    except Exception as exc:
                        record["syntax"] = "failed"
                        record["syntax_error"] = str(exc)
                    lua[record["syntax"]] += 1
                    if sum(lua.values()) % 500 == 0:
                        runtime.gccollect()
                line = (json.dumps(record, sort_keys=True, ensure_ascii=True) + "\n").encode()
                h.update(line)
                rows.write(line)
        os.replace(temporary, output / "source-files.jsonl")
    finally:
        Path(temporary).unlink(missing_ok=True)
    report = {"schema": 1, "commit": head, "scope": "tracked source-app files in this checkout",
              "files": len(names), "counts": dict(counts), "bytes": dict(totals),
              "inventory_sha256": h.hexdigest(), "static_markers": dict(findings),
              "lua_syntax": {"runtime": "Lua 5.3" if lua53 else "not_run", **dict(lua)},
              "original_source_equivalence_proven": False, "apk_reprocessed": False,
              "static_markers_are_not_failure_proof": True}
    (output / "source-summary.json").write_text(json.dumps(report, indent=2) + "\n")
    return report


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--repo", type=Path, default=Path("."))
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--lua53", action="store_true")
    args = parser.parse_args(argv)
    try:
        report = inspect(args.repo, args.out, lua53=args.lua53)
        print(json.dumps(report, indent=2))
        return 1 if report["lua_syntax"].get("failed", 0) else 0
    except (OSError, ValueError, ImportError, subprocess.CalledProcessError) as exc:
        parser.exit(2, f"source inventory failed: {exc}\n")


if __name__ == "__main__":
    raise SystemExit(main())
