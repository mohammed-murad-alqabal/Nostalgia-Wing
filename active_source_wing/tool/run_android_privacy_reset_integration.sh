#!/usr/bin/env bash
set -o pipefail

TEST_TARGET="${1:-integration_test/privacy_reset_restart_test.dart}"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIAGNOSTICS_DIR="$PROJECT_DIR/android-integration-diagnostics"

cd "$PROJECT_DIR"
mkdir -p "$DIAGNOSTICS_DIR"

pub_status=0
flutter pub get 2>&1 | tee "$DIAGNOSTICS_DIR/pub-get.log" || pub_status="${PIPESTATUS[0]}"

test_status="$pub_status"
if [ "$pub_status" -eq 0 ]; then
  timeout --signal=TERM --kill-after=30s 10m \
    flutter test "$TEST_TARGET" -d emulator-5554 --verbose 2>&1 \
    | tee "$DIAGNOSTICS_DIR/flutter-test.log" || test_status="${PIPESTATUS[0]}"
fi

adb devices -l > "$DIAGNOSTICS_DIR/adb-devices.log" 2>&1 || true
adb shell dumpsys activity activities > "$DIAGNOSTICS_DIR/adb-activity.log" 2>&1 || true
adb logcat -d -t 300 > "$DIAGNOSTICS_DIR/adb-logcat.log" 2>&1 || true

exit "$test_status"
