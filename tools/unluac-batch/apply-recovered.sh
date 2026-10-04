#!/bin/sh
# Apply the hand-recovered Lua patches on top of unluac's output.
#
# unluac can exit 0 and still emit Lua its own parser rejects (a goto whose
# label sits inside a block). Those modules are repaired here, from patches
# reconstructed against the bytecode -- see recovered/README.md.
#
# Idempotent: an already-applied patch is skipped, so this is safe to run after
# every Lua stage and safe to run twice. A patch that applies in neither
# direction is a hard error: it means unluac's output changed and the
# reconstruction needs rechecking, which must not pass unnoticed.
#
# Usage: sh tools/unluac-batch/apply-recovered.sh
set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
dir="$here/recovered"

root=$(CDPATH= cd -- "$here/../.." && pwd)
cd "$root"

[ -d "$dir" ] || { echo "error: missing $dir" >&2; exit 1; }

applied=0
skipped=0
for patch in "$dir"/*.patch; do
    [ -e "$patch" ] || continue
    name=$(basename "$patch")

    if git apply --check "$patch" 2>/dev/null; then
        git apply "$patch"
        printf 'applied %s\n' "$name"
        applied=$((applied + 1))
    elif git apply --reverse --check "$patch" 2>/dev/null; then
        skipped=$((skipped + 1))
    else
        echo "error: $name does not apply and is not already applied." >&2
        echo "       unluac's output has drifted; recheck the reconstruction" >&2
        exit 1
    fi
done

printf 'recovered: %d applied, %d already present\n' "$applied" "$skipped"
