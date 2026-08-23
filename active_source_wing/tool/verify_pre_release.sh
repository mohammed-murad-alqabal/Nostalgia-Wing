#!/usr/bin/env bash
set -Eeuo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

cd "${PROJECT_DIR}"

printf '\n==> Flutter quality gate\n'
bash "${SCRIPT_DIR}/verify_flutter.sh"

printf '\n==> Linux integration acceptance\n'
bash "${SCRIPT_DIR}/run_linux_integration.sh" --reporter compact

printf '\nSUCCESS: pre-release quality and Linux integration checks completed.\n'
