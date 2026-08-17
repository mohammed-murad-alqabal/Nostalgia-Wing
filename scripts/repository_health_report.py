#!/usr/bin/env python3
"""Create a read-only Markdown health report for the repository."""

from __future__ import annotations

import argparse
import subprocess
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def git_output(*args: str) -> str:
    result = subprocess.run(
        ["git", *args],
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode not in (0, 1):
        raise RuntimeError(result.stderr.strip() or "git command failed")
    return result.stdout.strip()


def main() -> int:
    parser = argparse.ArgumentParser(description="Create repository health report.")
    parser.add_argument("--output", required=True, help="Markdown output path relative to repository root")
    args = parser.parse_args()

    output_path = (ROOT / args.output).resolve()
    if ROOT not in output_path.parents:
        raise ValueError("output must stay inside the repository")
    output_path.parent.mkdir(parents=True, exist_ok=True)

    branches = git_output(
        "for-each-ref",
        "--sort=-committerdate",
        "--format=%(refname:short)|%(objectname:short)|%(committerdate:iso-strict)|%(subject)",
        "refs/remotes/origin",
    )
    fsck = subprocess.run(
        ["git", "fsck", "--full", "--no-dangling"],
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=False,
    )
    nested_workflows = [
        path
        for path in git_output("ls-files").splitlines()
        if "/.github/workflows/" in path.replace("\\", "/")
    ]
    retired_references = git_output(
        "grep", "-n", "-I", "-E", r"(^|[^A-Za-z0-9_-])develop([^A-Za-z0-9_-]|$)", "HEAD", "--", ".github"
    )

    lines = [
        "# Repository health report",
        "",
        f"Generated: {datetime.now(timezone.utc).isoformat()}",
        "",
        "## Remote branches",
        "",
        "| Reference | SHA | Last commit date | Subject |",
        "|---|---|---|---|",
    ]
    for line in branches.splitlines():
        if not line:
            continue
        values = line.split("|", 3)
        if len(values) == 4:
            lines.append("| " + " | ".join(value.replace("|", "\\|") for value in values) + " |")

    lines.extend(["", "## Checks", ""])
    lines.append(f"- Git object integrity: {'PASS' if fsck.returncode == 0 else 'FAIL'}")
    lines.append(f"- Nested workflow files: {len(nested_workflows)}")
    lines.append(f"- Active workflow references to retired branch `develop`: {len(retired_references.splitlines()) if retired_references else 0}")

    if nested_workflows:
        lines.extend(["", "## Nested workflow review", ""])
        lines.extend(f"- `{path}`" for path in nested_workflows)

    if retired_references:
        lines.extend(["", "## Retired branch references", "", "```text", retired_references, "```"])

    lines.extend(["", "## Policy", "", "This report is read-only. It does not delete branches, modify files, merge pull requests, or rewrite history.", ""])
    output_path.write_text("\n".join(lines), encoding="utf-8")
    print(output_path.relative_to(ROOT))
    return 0 if fsck.returncode == 0 else 1


if __name__ == "__main__":
    raise SystemExit(main())
