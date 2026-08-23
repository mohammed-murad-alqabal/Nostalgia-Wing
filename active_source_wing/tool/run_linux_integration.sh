#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

# Linux CI/test hosts may not expose an XDG Documents directory. The fallback
# is test-only and never enabled by production builds.
TEST_DEFINE="NOSTALGIA_TEST_STORAGE_FALLBACK=true"

if [[ -d /usr/lib/x86_64-linux-gnu ]]; then
  export LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH:-}"
fi

if command -v xvfb-run >/dev/null 2>&1; then
  exec xvfb-run -a flutter test integration_test \
    --dart-define="$TEST_DEFINE" "$@"
fi

exec flutter test integration_test \
  --dart-define="$TEST_DEFINE" "$@"
