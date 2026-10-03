# Shared environment for the APK reverse-engineering pipeline.
# Sourced by tools/decompile.sh. Safe to source repeatedly.
RE_TOOLS_DIR="${RE_TOOLS_DIR:-/opt/re-tools}"
export JAVA_HOME="${JAVA_HOME:-$RE_TOOLS_DIR/jre}"
export PATH="$JAVA_HOME/bin:$PATH"
export JADX_BIN="${JADX_BIN:-$RE_TOOLS_DIR/jadx/bin/jadx}"
export APKTOOL_JAR="${APKTOOL_JAR:-$RE_TOOLS_DIR/apktool.jar}"