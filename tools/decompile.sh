#!/usr/bin/env bash
# Decompile an Android APK into readable sources plus extracted assets.
#
#   bash tools/decompile.sh [path-to-apk] [output-dir]
#
# Must run under bash (not sh): the script uses `pipefail`.
# Defaults to the single APK found in ./input and writes into ./decompiled.
# Tuned for a small memory box, so steps are independent and re-runnable.
#
# Steps:
#   jadx      DEX -> Java source
#   apktool   manifest + resources
#   raw       raw dex + native libs
#   unity     managed assemblies + the whole Unity asset payload
#   lua       assets/lwScripts/LWScripts.data -> per-file Lua bytecode -> source
#   tables    assets/table/*.data -> per-table Lua bytecode -> source
#   unitydata assets/bin/Data Unity files -> textures/scenes/shaders/typetrees
#   bundles   AssetBundles fragment -> game art, audio and text
#   smali     opt-in, loss-free DEX view
#
# Environment:
#   STEPS="jadx raw"   run a subset of steps
#                      (default: jadx apktool raw unity lua tables unitydata)
#   DEXES="classes.dex classes4.dex"
#                      restrict the jadx step to specific DEX files, so a long
#                      run can be done in bounded chunks
#   LUA_MEM=2300m      heap for the Lua bytecode decompiler; the largest game
#                      data table needs ~3g
#   BUNDLE_BUDGET=150  seconds of AssetBundle extraction per invocation; the
#                      step is resumable, so rerun to continue where it stopped
#
# The lua step also verifies its own output: unluac can exit 0 on a chunk whose
# decompiled form is not valid Lua, so the step repairs the known cases and then
# compiles every module to prove the tree loads.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"
# shellcheck source=/dev/null
. ./tools/re-env.sh

APK="${1:-}"
OUT="${2:-$root/decompiled}"

if [ -z "$APK" ]; then
  APK="$(find "$root/input" -maxdepth 1 -iname '*.apk' 2>/dev/null | head -1 || true)"
fi
if [ -z "$APK" ] || [ ! -f "$APK" ]; then
  echo "error: no APK given and none found in ./input" >&2
  echo "usage: bash tools/decompile.sh [path-to-apk] [output-dir]" >&2
  exit 2
fi
APK="$(cd "$(dirname "$APK")" && pwd)/$(basename "$APK")"

slug="$(printf '%s' "$(basename "${APK%.apk}")" | tr -c 'A-Za-z0-9._-' '_')"
SRC_DIR="$root/source-$slug"
mkdir -p "$SRC_DIR" "$OUT"

# Compiles the batch driver plus the patched unluac classes into one output dir.
# The patch is vendored source rather than a rebuilt upstream: compiling it
# against the shipped unluac.jar keeps this hermetic (a JDK is all it needs)
# and keeps only the delta, not a fork of the whole decompiler.
unluac_build_classes() {
  local out="$root/tools/unluac-batch/classes"
  mkdir -p "$out"
  sh "$root/tools/unluac-batch/build-patch.sh" >/dev/null
  javac -nowarn -cp "$root/tools/unluac-batch/unluac.jar" -d "$out" \
    "$root/tools/unluac-batch/UnluacBatch.java" \
    "$root/tools/unluac-batch/DisasmOne.java"
}

step_jadx() {
  echo "== jadx: decompiling DEX to Java (one DEX per pass, low-memory safe)"
  mkdir -p "$OUT/raw" "$SRC_DIR/src"
  unzip -q -o -j -d "$OUT/raw" "$APK" 'classes*.dex' >/dev/null
  local dex status log before after
  # DEXES allows resuming a long run in bounded chunks, e.g. DEXES="classes4.dex".
  local wanted="${DEXES:-}"
  # shellcheck disable=SC2012
  for dex in $(ls -1 "$OUT/raw"/classes*.dex 2>/dev/null | sort -V); do
    if [ -n "$wanted" ]; then
      case " $wanted " in
        *" $(basename "$dex") "*) ;;
        *) continue ;;
      esac
    fi
    echo "-- jadx $(basename "$dex")"
    log="$(mktemp)"
    before="$(find "$SRC_DIR/src" -name '*.java' | wc -l)"
    # jadx exits 3 when it finished but some methods did not decompile cleanly.
    # That is expected for obfuscated third-party SDK code, so it must not abort
    # the run; any other non-zero status is a real failure.
    set +e
    "$JADX_BIN" --no-res --deobf -j 2 \
      --comments-level none \
      -d "$SRC_DIR/src" "$dex" >"$log" 2>&1
    status=$?
    set -e
    grep -vE '^INFO  - progress' "$log" | tail -3 || true
    after="$(find "$SRC_DIR/src" -name '*.java' | wc -l)"
    rm -f "$log"
    if [ "$status" -ne 0 ] && [ "$status" -ne 3 ]; then
      echo "error: jadx failed on $(basename "$dex") (exit $status)" >&2
      exit "$status"
    fi
    echo "   exit=$status new_java_files=$((after - before)) total=$after"
  done
  local total
  total="$(find "$SRC_DIR/src" -name '*.java' | wc -l)"
  echo "   total .java files: $total"
  if [ "$total" -eq 0 ]; then
    echo "error: jadx produced no Java sources" >&2
    exit 1
  fi
}

step_apktool() {
  echo "== apktool: decoding manifest + resources"
  java -Xmx2g -jar "$APKTOOL_JAR" d -f --no-src -o "$OUT/apktool" "$APK" >/dev/null
  if [ ! -f "$OUT/apktool/AndroidManifest.xml" ]; then
    echo "error: apktool produced no AndroidManifest.xml" >&2
    exit 1
  fi
}

step_raw() {
  echo "== unzip: dex + native libs (skipping res/ and assets/ payloads)"
  mkdir -p "$OUT/raw"
  unzip -q -o -j -d "$OUT/raw" "$APK" 'classes*.dex' >/dev/null
  unzip -q -o -d "$OUT/raw" "$APK" 'lib/*' >/dev/null || true
}

step_smali() {
  echo "== apktool: decoding smali (loss-free DEX view)"
  java -Xmx2g -jar "$APKTOOL_JAR" d -f -s -o "$OUT/smali" "$APK" >/dev/null
}

step_unity() {
  echo "== unity: extracting the full Unity payload (assemblies + assets)"
  mkdir -p "$OUT/unity"
  # global-metadata.dat and ScriptingAssemblies.json only exist for IL2CPP
  # builds. This APK is Mono, so their absence is expected and must not fail
  # the step; unzip reports unmatched patterns as notes, not errors.
  # Extract the whole assets/ tree, not just bin/Data/Managed: the Lua payload,
  # the 130 shipped bundles, the data tables and the AssetBundles fragment are
  # all here and all needed by the later steps.
  unzip -q -o -d "$OUT/unity" "$APK" 'assets/*' >/dev/null || true
  if [ ! -d "$OUT/unity/assets/Assemblies" ]; then
    echo "error: no assets/Assemblies extracted; cannot recover managed code" >&2
    exit 1
  fi
  echo "   $(find "$OUT/unity/assets/Assemblies" -name '*.mdl' | wc -l) .mdl files"
  echo "   $(find "$OUT/unity/assets/bin/Data" -maxdepth 1 -type f | wc -l) files in bin/Data"
  echo "   $(du -sh "$OUT/unity/assets" | cut -f1) total assets payload"
}

step_lua() {
  echo "== lua: unpacking the XLua script bundle and decompiling to source"
  local data="$OUT/unity/assets/lwScripts/LWScripts.data"
  if [ ! -f "$data" ]; then
    echo "error: $data missing; run the unity step first" >&2
    exit 1
  fi
  python3 "$root/tools/extract-lua.py" "$data" "$SRC_DIR/lua/luac"
  unluac_build_classes
  # classes FIRST: it holds the patched ControlFlowHandler, and a classpath
  # entry earlier in the list wins. Reversed, the patch is silently ignored.
  java "-Xmx${LUA_MEM:-1500m}" -Dunluac.failures="$root/unluac-failures.tsv" \
    -cp "$root/tools/unluac-batch/classes:$root/tools/unluac-batch/unluac.jar" \
    UnluacBatch "$SRC_DIR/lua/luac" "$SRC_DIR/lua/src"
  # unluac exits 0 on chunks whose output is not valid Lua (a goto that lands
  # inside a block). Repair those, then prove the whole tree loads.
  sh "$root/tools/unluac-batch/apply-recovered.sh"
  if [ -d "$SRC_DIR/lua/src" ]; then
    python3 "$root/tools/check-lua-syntax.py" "$SRC_DIR/lua/src"
  fi
}

step_tables() {
  echo "== tables: unpacking the data-table archive and decompiling to source"
  local tdir="$OUT/unity/assets/table"
  if [ ! -d "$tdir" ]; then
    echo "error: $tdir missing; run the unity step first" >&2
    exit 1
  fi
  mkdir -p "$root/tools/unluac-batch/classes"
  unluac_build_classes
  # the archive is a plain zip of studio Lua bytecode, one module per table
  rm -rf "$SRC_DIR/data-tables"
  mkdir -p "$SRC_DIR/data-tables"
  unzip -q -o -d "$SRC_DIR/data-tables" "$tdir"/*.data >/dev/null
  local n
  n="$(find "$SRC_DIR/data-tables" -type f | wc -l)"
  if [ "$n" -eq 0 ]; then
    echo "error: data-table archive extracted no entries" >&2
    exit 1
  fi
  echo "   $n table modules"
  # -Xmx must be generous: the monster tables are the largest chunks in the
  # game and need ~3g to decompile.
  java "-Xmx${LUA_MEM:-3000m}" -Dunluac.failures="$root/unluac-failures-tables.tsv" \
    -cp "$root/tools/unluac-batch/classes:$root/tools/unluac-batch/unluac.jar" \
    UnluacBatch "$SRC_DIR/data-tables" "$SRC_DIR/data-tables-lua"
}

step_unitydata() {
  echo "== unitydata: extracting built-in assets, shaders and the boot scene"
  python3 "$root/tools/extract-unity-assets.py" \
    "$OUT/unity/assets/bin/Data" "$SRC_DIR/unity-assets"
}

step_bundles() {
  echo "== bundles: extracting game art/audio from the packed AssetBundle fragment"
  local bdir="$OUT/unity/assets/AssetBundles"
  if [ ! -f "$bdir/BundleFragment0.bytes" ]; then
    echo "error: $bdir/BundleFragment0.bytes missing; run the unity step first" >&2
    exit 1
  fi
  # Resumable: each invocation records finished bundles, so rerun to continue.
  # Set BUNDLE_BUDGET=0 to process every bundle in one (long) run.
  python3 "$root/tools/extract-game-assets.py" "$bdir" "$SRC_DIR/game-assets" \
    --budget "${BUNDLE_BUDGET:-150}"
}

steps="${STEPS:-jadx apktool raw unity lua tables unitydata}"
for step in $steps; do
  "step_$step"
done
echo "== done: source in $SRC_DIR/src, artifacts in $OUT"