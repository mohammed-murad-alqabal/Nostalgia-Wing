#!/usr/bin/env bash
# بوابة الجودة المحلية لتطبيق Flutter. تُستخدم قبل الدمج ومن سير عمل CI.

set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

log() {
  printf '\n==> %s\n' "$1"
}

fail() {
  printf '\nERROR: %s\n' "$1" >&2
  exit 1
}

command -v flutter >/dev/null 2>&1 || fail \
  "Flutter SDK غير متاح. ثبّت Flutter stable ثم أعد تشغيل السكربت."

cd "${PROJECT_DIR}"

log "Flutter SDK"
flutter --version

log "Fetching dependencies"
flutter pub get

log "Dart formatting"
dart format --output=none --set-exit-if-changed lib test integration_test

log "Static analysis"
flutter analyze

log "Unit and widget tests"
flutter test

printf '\nSUCCESS: dart format, flutter analyze, and flutter test completed successfully.\n'
