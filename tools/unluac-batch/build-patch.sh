#!/bin/sh
# Compile the vendored unluac patch into tools/unluac-batch/classes.
#
# The patched classes are compiled against the original unluac.jar, so they
# override only the classes they replace; everything else still resolves from
# the jar. Put `classes` first on the classpath and the fix is active.
#
# See patch/unluac/decompile/ControlFlowHandler.java for what the fix is and
# why. Run this once per checkout, or after touching anything in patch/.
set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
src="$here/patch"
out="$here/classes"

[ -f "$here/unluac.jar" ] || { echo "error: missing $here/unluac.jar" >&2; exit 1; }

mkdir -p "$out"
# Compile only the patched files. javac pulls the rest of unluac off the jar
# via -cp, so the patch tree stays a diff-sized delta rather than a fork.
javac -nowarn -cp "$here/unluac.jar" -d "$out" \
    "$src/unluac/decompile/ControlFlowHandler.java" \
    "$src/unluac/parse/LFloatNumber.java"

echo "patch classes -> $out"
