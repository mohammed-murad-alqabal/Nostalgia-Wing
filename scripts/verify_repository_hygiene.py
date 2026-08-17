#!/usr/bin/env python3
"""Read-only repository hygiene verification for CI and local use."""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path, PurePosixPath

ROOT = Path(__file__).resolve().parents[1]
POLICY_PATH = ROOT / "config" / "repository-policy.json"


def run_git(*args: str) -> str:
    result = subprocess.run(
        ["git", *args],
        cwd=ROOT,
        check=False,
        capture_output=True,
        text=True,
    )
    if result.returncode not in (0, 1):
        raise RuntimeError(result.stderr.strip() or "git command failed")
    return result.stdout


def tracked_files() -> list[str]:
    output = subprocess.run(
        ["git", "ls-files", "-z"],
        cwd=ROOT,
        check=True,
        capture_output=True,
    ).stdout
    return [path.decode("utf-8") for path in output.split(b"\0") if path]


def matches(path: str, pattern: str) -> bool:
    candidate = PurePosixPath(path)
    if candidate.match(pattern):
        return True
    if pattern.startswith("**/") and candidate.match(pattern[3:]):
        return True
    return False


def any_match(path: str, patterns: list[str]) -> bool:
    return any(matches(path, pattern) for pattern in patterns)


def main() -> int:
    parser = argparse.ArgumentParser(description="Verify repository hygiene policy.")
    parser.add_argument(
        "--mode",
        choices=("report", "enforce"),
        default="enforce",
        help="report always exits zero; enforce fails for new policy errors",
    )
    args = parser.parse_args()

    policy = json.loads(POLICY_PATH.read_text(encoding="utf-8"))
    files = tracked_files()
    known = set(policy.get("known_tracked_violations", []))
    forbidden = policy.get("forbidden_tracked_paths", [])
    allowed_zero_byte = policy.get("allowed_zero_byte_paths", [])

    errors: list[str] = []
    warnings: list[str] = []

    for path in files:
        if any_match(path, forbidden):
            message = f"tracked path violates policy: {path}"
            if path in known:
                warnings.append(f"baseline violation (must be cleaned separately): {path}")
            else:
                errors.append(message)

        absolute_path = ROOT / path
        if absolute_path.exists() and absolute_path.is_file() and absolute_path.stat().st_size == 0:
            if not any_match(path, allowed_zero_byte):
                warnings.append(f"zero-byte tracked file requires review: {path}")

    if policy.get("warn_on_nested_workflows", False):
        for path in files:
            normalized = path.replace("\\", "/")
            if "/.github/workflows/" in normalized:
                warnings.append(
                    "workflow file is nested and is not discovered by GitHub Actions: " + path
                )

    if policy.get("warn_on_retired_branch_references", False):
        for branch in policy.get("branch", {}).get("retired", []):
            output = run_git(
                "grep",
                "-n",
                "-I",
                "-E",
                rf"(^|[^A-Za-z0-9_-]){branch}([^A-Za-z0-9_-]|$)",
                "--",
                ".github",
            )
            for line in output.splitlines():
                warnings.append(f"retired branch reference: {line}")

    print("Repository hygiene policy version:", policy.get("version", "unknown"))
    for warning in sorted(set(warnings)):
        print("WARNING:", warning)
    for error in sorted(set(errors)):
        print("ERROR:", error)

    print(
        f"Summary: {len(errors)} error(s), {len(warnings)} warning(s), "
        f"{len(files)} tracked file(s)."
    )
    if args.mode == "enforce" and errors:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
