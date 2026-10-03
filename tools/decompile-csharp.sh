#!/usr/bin/env bash
# Recover the Unity managed assemblies from the obfuscated assets/Assemblies/*.mdl
# files and decompile the game C# into source-app/csharp.
#
#   bash tools/decompile-csharp.sh
#
# Re-runnable; skips work that is already done.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"
# shellcheck source=/dev/null
. ./tools/re-env.sh
export DOTNET_ROOT="${DOTNET_ROOT:-/opt/re-tools/dotnet}"
export PATH="$DOTNET_ROOT:$HOME/.dotnet/tools:$PATH"

MDL_DIR="decompiled/unity/assets/Assemblies"
DLL_DIR="decompiled/unity/assemblies"
CS_DIR="source-app/csharp"

if [ ! -d "$MDL_DIR" ]; then
  echo "error: $MDL_DIR missing; run 'STEPS=unity bash tools/decompile.sh' first" >&2
  exit 2
fi
mkdir -p "$DLL_DIR" "$CS_DIR"

# The packer XORs a short prefix of each assembly's DOS header with a key that
# differs per file. The key is recoverable from the "MZ" signature and the
# prefix length is found by validating the resulting PE, so nothing about the
# layout is hardcoded.
if [ -z "$(ls -A "$DLL_DIR" 2>/dev/null || true)" ]; then
  echo "== de-obfuscating .mdl -> .dll (per-file XOR key + prefix length)"
  python3 - "$MDL_DIR" "$DLL_DIR" <<'PY'
import pathlib, struct, sys

src, out = pathlib.Path(sys.argv[1]), pathlib.Path(sys.argv[2])
out.mkdir(parents=True, exist_ok=True)


def rva_to_offset(data, rva):
    pe = struct.unpack_from("<I", data, 0x3C)[0]
    if data[pe:pe + 4] != b"PE\x00\x00":
        return None
    section_count = struct.unpack_from("<H", data, pe + 6)[0]
    optional_size = struct.unpack_from("<H", data, pe + 20)[0]
    optional = pe + 24
    magic = struct.unpack_from("<H", data, optional)[0]
    directories = optional + (96 if magic == 0x10B else 112)
    table = optional + optional_size
    for index in range(section_count):
        section = table + index * 40
        virtual_size, virtual_address, raw_size, raw_offset = struct.unpack_from("<IIII", data, section + 8)
        if virtual_address <= rva < virtual_address + max(virtual_size, raw_size):
            return rva - virtual_address + raw_offset
    return None


def looks_like_clr_assembly(data):
    """A real Unity/Mono PE: PE header at e_lfanew, sane sections, CLI header, BSJB metadata."""
    if len(data) < 0x200 or data[:2] != b"MZ":
        return False
    pe_offset = struct.unpack_from("<I", data, 0x3C)[0]
    if not (0x40 <= pe_offset < 0x400) or pe_offset + 24 > len(data):
        return False
    if data[pe_offset:pe_offset + 4] != b"PE\x00\x00":
        return False
    section_count = struct.unpack_from("<H", data, pe_offset + 6)[0]
    optional_size = struct.unpack_from("<H", data, pe_offset + 20)[0]
    optional = pe_offset + 24
    if optional + optional_size > len(data):
        return False
    magic = struct.unpack_from("<H", data, optional)[0]
    if magic not in (0x10B, 0x20B):
        return False
    directory_count = struct.unpack_from("<I", data, optional + (92 if magic == 0x10B else 108))[0]
    if directory_count < 15:
        return False
    cli_rva = struct.unpack_from("<I", data, optional + (96 if magic == 0x10B else 112) + 14 * 8)[0]
    if not cli_rva:
        return False
    cli_offset = rva_to_offset(data, cli_rva)
    if cli_offset is None or cli_offset + 16 > len(data):
        return False
    metadata_rva = struct.unpack_from("<I", data, cli_offset + 8)[0]
    metadata_size = struct.unpack_from("<I", data, cli_offset + 12)[0]
    if not metadata_rva or not metadata_size:
        return False
    metadata_offset = rva_to_offset(data, metadata_rva)
    if metadata_offset is None or metadata_offset + 20 > len(data):
        return False
    return data[metadata_offset:metadata_offset + 4] == b"BSJB"


recovered = failed = 0
for path in sorted(src.glob("*.mdl")):
    raw = path.read_bytes()
    # The scrambled prefix still starts with an XOR'd "MZ", so byte 0 gives the key.
    key = raw[0] ^ 0x4D
    candidate = None
    for length in range(1, 0x21):
        trial = bytes(b ^ key for b in raw[:length]) + raw[length:]
        if looks_like_clr_assembly(trial):
            candidate = trial
            break
    if candidate is None:
        failed += 1
        print(f"   could not recover {path.name}")
        continue
    (out / (path.stem + ".dll")).write_bytes(candidate)
    recovered += 1

print(f"recovered {recovered} assemblies ({failed} failed)")
PY
else
  echo "== assemblies already recovered"
fi

echo "== ilspycmd: decompiling managed assemblies to C#"
# The game's own logic lives in Assembly-CSharp; the rest is engine/SDK code.
# -p is required for one source file per type; without it ilspycmd emits a
# single bundled .decompiled.cs instead of the type tree.
for dll in "$DLL_DIR"/Assembly-CSharp.dll "$DLL_DIR"/Assembly-CSharp-firstpass.dll; do
  [ -f "$dll" ] || continue
  name="$(basename "${dll%.dll}")"
  echo "-- $name.dll"
  rm -rf "${CS_DIR:?}/$name"
  log="$(mktemp)"
  if ilspycmd -p \
    -o "$CS_DIR/$name" \
    --nested-directories \
    -r "$DLL_DIR" \
    --disable-updatecheck \
    "$dll" >"$log" 2>&1; then
    tail -3 "$log" || true
  else
    status=$?
    echo "error: ilspycmd failed on $name.dll (exit $status)" >&2
    tail -20 "$log" >&2
    rm -f "$log"
    exit "$status"
  fi
  rm -f "$log"
  files="$(find "$CS_DIR/$name" -name '*.cs' | wc -l)"
  echo "   $files .cs files"
  if [ "$files" -eq 0 ]; then
    echo "error: ilspycmd produced no C# for $name.dll" >&2
    exit 1
  fi
done

echo "== done: C# in $CS_DIR"