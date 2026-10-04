#!/usr/bin/env python3
"""Syntax-check the recovered Lua sources.

Every file under source-app/lua/src must be loadable by the embedded Lua
interpreter.  This is what turns "unluac returned exit 0" into "unluac
returned exit 0 *and* produced valid Lua": unluac can emit control flow it
cannot itself parse (e.g. a goto that lands inside a block), which is a
silent data-loss bug in the recovered payload -- the chunk looks recovered
right up until you try to load it.

Two verdicts, not one:

FAIL  a genuine parse error under any Lua.  Always a recovery defect.
WARN  a Lua 5.5 rule that did not exist in 5.3.  The studio compiled with
      Lua 5.3 (.version 5.3 in every .disasm.txt listing), where loop
      variables of `for` are ordinary assignable locals; Lua 5.5 made them
      read-only.  The embedded interpreter is 5.5, so these modules load fine
      in the game but not here.  Reported separately so the gate does not
      cry wolf about code that is correct for its target.

Either way this is a syntax gate, not a semantic-equivalence proof.

Usage:
    python3 tools/check-lua-syntax.py [root ...]
"""

from __future__ import annotations

import os
import sys

try:
    import lupa
except ImportError:  # pragma: no cover - dependency guard
    sys.stderr.write("lupa is not installed: pip install lupa\n")
    raise SystemExit(2)


def iter_sources(roots: list[str]):
    for root in roots:
        if os.path.isfile(root):
            yield root
            continue
        for dirpath, _dirnames, filenames in os.walk(root):
            for name in filenames:
                if name.endswith(".lua"):
                    yield os.path.join(dirpath, name)


#: Lua 5.5 made `for` loop variables read-only; 5.3 (the game's target) did not.
LUA55_ONLY = "attempt to assign to const variable"


def main(argv: list[str]) -> int:
    roots = argv[1:] or ["source-app/lua/src"]
    lua = lupa.LuaRuntime(unpack_returned_tuples=True)
    load = lua.eval("load")

    total = 0
    failures: list[tuple[str, str]] = []
    warnings: list[tuple[str, str]] = []
    for path in sorted(iter_sources(roots)):
        total += 1
        with open(path, "rb") as handle:
            chunk = handle.read()
        chunk = b"\xEF\xBB\xBF" + chunk if chunk.startswith(b"\xEF\xBB\xBF") else chunk
        try:
            # Compile only; never execute.  @<path> gives the chunk a source
            # name so error messages point at the real file.
            result = load(chunk, "@" + path)
        except Exception as exc:  # lupa.LuaError and friends
            failures.append((path, str(exc).split("\n")[0]))
            continue
        if isinstance(result, tuple) and result and result[0] is None:
            message = str(result[1]).split("\n")[0]
            (warnings if LUA55_ONLY in message else failures).append((path, message))

    for path, message in warnings:
        print(f"WARN\t{path}\t{message}")
    for path, message in failures:
        print(f"FAIL\t{path}\t{message}")
    print(
        f"checked {total} file(s): {total - len(failures) - len(warnings)} ok, "
        f"{len(warnings)} lua-5.5-only, {len(failures)} failed"
    )
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
