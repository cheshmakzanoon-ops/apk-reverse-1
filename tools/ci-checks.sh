#!/usr/bin/env bash
# Validation checks for the reverse-engineering pipeline.
#
#   bash tools/ci-checks.sh
#
# Run by CI (.github/workflows/ci.yml) and usable locally. Everything here is
# fast and needs no APK, so it is safe to run on every push.
#
# The generated payloads (input/, decompiled/, source-app/) are gitignored, so
# these checks deliberately cover the committed pipeline itself: does it parse,
# does it compile, do its argument guards fire, and do the docs point at files
# that actually exist.
#
# Exit status is 0 only if every check passes; `set -euo pipefail` is kept so no
# failure is masked by a pipeline filter.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

pass=0
fail=0

ok()   { pass=$((pass + 1)); printf '  ok    %s\n' "$1"; }
bad()  { fail=$((fail + 1)); printf '  FAIL  %s\n' "$1" >&2; }

echo "== shell syntax"
for s in tools/*.sh; do
  if bash -n "$s"; then ok "$s"; else bad "$s (bash -n)"; fi
done

echo "== python syntax"
for p in tools/*.py; do
  if python3 -m py_compile "$p"; then ok "$p"; else bad "$p (py_compile)"; fi
done
rm -rf tools/__pycache__ 2>/dev/null || true

echo "== lua decompiler driver compiles"
if javac -cp tools/unluac-batch/unluac.jar \
     -d "$(mktemp -d)" tools/unluac-batch/UnluacBatch.java 2>/dev/null; then
  ok "UnluacBatch.java"
else
  bad "UnluacBatch.java (javac)"
fi

# The argument guards run before any real work, so they are safe to exercise in
# a scratch copy that has neither the APK nor the extracted output. Copying
# rather than running in place keeps this check from ever kicking off a full
# multi-gigabyte decompile on a developer machine.
echo "== argument guards (in a scratch copy)"

scratch="$(mktemp -d)"
trap 'rm -rf "$scratch"' EXIT
mkdir -p "$scratch/tools"
cp tools/*.sh "$scratch/tools/"
cp tools/re-env.sh "$scratch/tools/"

expect_exit() {
  # expect_exit <want> <label> <cmd...>
  local want="$1" label="$2"; shift 2
  local got=0
  set +e
  ( cd "$scratch" && "$@" ) >"$scratch/out.txt" 2>&1
  got=$?
  set -e
  if [ "$got" -eq "$want" ]; then
    ok "$label (exit $got)"
  else
    bad "$label (exit $got, wanted $want)"
    sed 's/^/        /' "$scratch/out.txt" | head -5 >&2
  fi
}

expect_exit 2 "decompile.sh without an APK refuses" \
  bash tools/decompile.sh
expect_exit 2 "decompile-csharp.sh without extracted output refuses" \
  bash tools/decompile-csharp.sh

echo "== docs reference real files"

# Only tools/ paths are checked: everything else the READMEs mention is
# generated output that is gitignored and absent from a fresh checkout.
docs="$(grep -oh 'tools/[A-Za-z0-9_./-]*' README.md unity-project/README.md \
        | sed 's/[.,:)`]*$//' | sort -u || true)"
if [ -z "$docs" ]; then
  bad "no tools/ paths found in the docs (grep is broken?)"
else
  for p in $docs; do
    case "$p" in *'*'*) continue ;; esac
    if [ -e "$p" ]; then ok "$p"; else bad "$p named in docs but missing"; fi
  done
fi

echo
printf 'checks: %d passed, %d failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ] || exit 1
