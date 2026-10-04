#!/bin/sh
# Disassemble a single recovered Lua chunk to a .disasm.txt listing.
#
# UnluacBatch only emits a listing when decompilation *throws*. Chunks that
# decompile with exit 0 but emit control flow unluac's own Lua parser rejects
# (a goto landing inside a block) look like successes, so this helper is how
# those get a listing to be reconstructed from.
#
# Usage: sh tools/unluac-batch/disasm-one.sh <chunk.luac> [out.disasm.txt]
set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

chunk=${1:?usage: disasm-one.sh <chunk.luac> [out.disasm.txt]}
out=${2:-${chunk%.luac}.disasm.txt}

[ -f "$chunk" ] || { echo "error: no such chunk: $chunk" >&2; exit 1; }

# The patched classes carry the is_break_jmp null guard, so normalise() from
# UnluacBatch has to run first. Rather than reimplement the header rewrite in
# shell, hand the chunk to a one-shot JVM that calls the same code path.
if [ -f "$here/classes/DisasmOne.class" ]; then
    cp_="java"
    set -- -cp "$here/classes:$here/unluac.jar" DisasmOne "$chunk" "$out"
    exec $cp_ "$@"
fi

echo "error: build tools/unluac-batch/classes first (see tools/unluac-batch/README.md)" >&2
exit 1
