#!/usr/bin/env bash
# Recreate the unity-project symlinks that point at the recovered payloads.
#
#   bash unity-project/sync-links.sh
#
# Assets/, DataTable/ and CSharp/ are symlinks rather than copies so the ~4 GB
# of recovered content is stored once. The targets are gitignored generated
# output, so after a fresh clone these links are dangling until the pipeline has
# been run:
#
#   bash tools/decompile.sh          # produces decompiled/ and source-app/
#   bash tools/decompile-csharp.sh   # produces source-app/csharp/
#   bash unity-project/sync-links.sh # (re)creates the links
#
# Run this after the pipeline; it is idempotent and reports which targets are
# still missing rather than failing silently.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
root="$(cd "$here/.." && pwd)"

# Each entry is "link path relative to unity-project" -> "target relative to repo root"
links=(
  "Assets/Main/LuaScripts:source-app/lua/src"
  "Assets/Main/HotUpdateDll:decompiled/unity/assemblies"
  "Assets/Main/Art:source-app/game-assets/assets"
  "Assets/DataTable:source-app/data-tables-lua"
  "Assets/CSharp:source-app/csharp"
)

missing=0
for entry in "${links[@]}"; do
  link="${entry%%:*}"
  target="${entry#*:}"
  dest="$here/$link"
  src="$root/$target"

  mkdir -p "$(dirname "$dest")"
  ln -sfn "$(realpath --relative-to="$(dirname "$dest")" "$src")" "$dest"

  # Search the whole tree: several targets (e.g. source-app/csharp) contain only
  # subdirectories at depth 1, so a shallow probe would call them empty.
  if [ -d "$dest" ] && [ -n "$(find -L "$dest" -type f -print -quit 2>/dev/null)" ]; then
    printf '  ok    %-28s -> %s (%s files)\n' \
      "$link" "$target" "$(find -L "$dest" -type f | wc -l)"
  else
    printf '  EMPTY %-28s -> %s (target missing; run the pipeline first)\n' \
      "$link" "$target" >&2
    missing=$((missing + 1))
  fi
done

echo
if [ "$missing" -gt 0 ]; then
  echo "$missing link(s) point at content that has not been generated yet." >&2
  exit 1
fi
echo "all links resolve"
