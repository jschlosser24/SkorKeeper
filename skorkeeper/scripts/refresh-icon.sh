#!/usr/bin/env bash
# Regenerates the app launcher icon from assets/icons/SkorKeeper Logo.png and force-installs
# a fresh release build on a connected Android device, bypassing the launcher's icon cache.
#
# Usage (from the skorkeeper/ folder):
#   ./scripts/refresh-icon.sh
#
# Run this any time you replace assets/icons/SkorKeeper Logo.png and the device still shows
# the old icon after a normal `flutter run`/reinstall.

set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

step() {
    echo -e "${CYAN}==> $1${NC}"
}

# Resolve flutter/dart/adb even if they aren't on PATH, checking common install locations.
resolve_tool() {
    local name="$1"; shift
    if command -v "$name" >/dev/null 2>&1; then
        command -v "$name"
        return 0
    fi
    for candidate in "$@"; do
        if [ -x "$candidate" ]; then
            echo "$candidate"
            return 0
        fi
    done
    echo "ERROR: $name not found. Update the candidate paths in this script." >&2
    exit 1
}

FLUTTER_BIN=$(resolve_tool flutter \
    "$HOME/flutter/bin/flutter" \
    "/usr/local/flutter/bin/flutter" \
    "/opt/flutter/bin/flutter")
# Use the Dart SDK bundled with the resolved Flutter install, not a possibly different
# `dart` elsewhere on PATH (which can point at an incompatible/global Dart SDK).
FLUTTER_DIR=$(dirname "$FLUTTER_BIN")
DART_BIN="$FLUTTER_DIR/dart"

ADB_BIN=$(resolve_tool adb \
    "$HOME/Library/Android/sdk/platform-tools/adb" \
    "$HOME/Android/Sdk/platform-tools/adb" \
    "${ANDROID_HOME:-}/platform-tools/adb" \
    "${ANDROID_SDK_ROOT:-}/platform-tools/adb")

# Repo root = parent of this script's folder (scripts/ -> skorkeeper/)
APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$APP_DIR"

step "Fetching packages"
"$FLUTTER_BIN" pub get

step "Regenerating launcher icons from assets/icons/SkorKeeper Logo.png"
"$DART_BIN" run flutter_launcher_icons

step "Uninstalling existing app from device (clears icon cache, ok if not installed yet)"
"$ADB_BIN" uninstall com.schlosserstudio.skorkeeper || true

step "Cleaning build artifacts"
"$FLUTTER_BIN" clean

step "Re-fetching packages"
"$FLUTTER_BIN" pub get

step "Building release APK"
"$FLUTTER_BIN" build apk --release

step "Installing fresh APK on device"
"$ADB_BIN" install "$APP_DIR/build/app/outputs/flutter-apk/app-release.apk"

echo -e "${GREEN}Done. Check your device's home screen / app drawer.${NC}"
