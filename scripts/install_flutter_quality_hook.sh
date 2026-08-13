#!/usr/bin/env bash
# يفعّل خطافات Git المصدّرة مع المستودع للمستخدم الحالي فقط.

set -Eeuo pipefail

readonly REPOSITORY_ROOT="$(git rev-parse --show-toplevel)"
readonly HOOKS_DIRECTORY="${REPOSITORY_ROOT}/.githooks"
readonly HOOK_FILE="${HOOKS_DIRECTORY}/pre-merge-commit"

if [[ ! -f "${HOOK_FILE}" ]]; then
  printf 'ERROR: Expected hook was not found: %s\n' "${HOOK_FILE}" >&2
  exit 1
fi

chmod +x "${HOOK_FILE}" "${REPOSITORY_ROOT}/active_source_wing/tool/verify_flutter.sh"
git -C "${REPOSITORY_ROOT}" config --local core.hooksPath .githooks

printf 'SUCCESS: Local Git hooks are enabled for this repository.\n'
printf 'The Flutter quality gate will run before local merge commits.\n'
