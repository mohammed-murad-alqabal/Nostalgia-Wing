#!/usr/bin/env python3
"""Validate the canonical documentation contract for Wing of Nostalgia.

The checker verifies documentation metadata, required canonical paths, safe local
Markdown links, and malformed empty list markers in governed documents. It does
not infer implementation state from prose.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / "docs"
REQUIRED_FIELDS = (
    "Status",
    "Owner",
    "Authority",
    "Last verified",
    "Verified commit",
    "Related code",
    "Related tests",
)
CANONICAL_DIRS = ("current", "proposed", "decisions", "guides")
STATUS_VALUES = {"Current", "Proposed", "Partial", "Deprecated", "Archived"}
LOCAL_LINK = re.compile(r"(?<!!)\[[^\]]*\]\(([^)]+)\)")
EMPTY_LIST_MARKER = re.compile(r"^(?:[-*]|\d+\.)\s*$", re.MULTILINE)


# This compact set contains the documents that direct developers to sources of
# truth or describe high-risk implementation claims.
GOVERNED_PATHS = (
    DOCS / "README.md",
    DOCS / "templates" / "document-metadata.md",
    DOCS / "strategic" / "04_technical_architecture_and_design" / "technical-architecture.md",
    DOCS / "strategic" / "04_technical_architecture_and_design" / "ai-service-design.md",
    DOCS / "strategic" / "04_technical_architecture_and_design" / "api-contract.md",
    DOCS / "strategic" / "04_technical_architecture_and_design" / "data-schema.md",
)


def read_markdown_files(directory: Path) -> list[Path]:
    if not directory.exists():
        return []
    return sorted(path for path in directory.rglob("*.md") if path.is_file())


def metadata_errors(path: Path, text: str) -> list[str]:
    errors: list[str] = []
    for field in REQUIRED_FIELDS:
        if not re.search(rf"^> \*\*{re.escape(field)}:\*\*\s*.+$", text, re.MULTILINE):
            errors.append(f"{path.relative_to(ROOT)}: missing metadata field '{field}'")

    status_match = re.search(r"^> \*\*Status:\*\*\s*([^\n]+)", text, re.MULTILINE)
    if status_match:
        status = status_match.group(1).strip().split("/")[0].strip()
        if status not in STATUS_VALUES:
            errors.append(f"{path.relative_to(ROOT)}: unsupported status '{status}'")
    return errors


def documentation_link_errors(path: Path, text: str) -> list[str]:
    errors: list[str] = []
    for raw_target in LOCAL_LINK.findall(text):
        target = raw_target.strip().strip("<>")
        if not target or target.startswith("#"):
            continue
        if re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*:", target):
            continue

        relative_target = target.split("#", 1)[0].split("?", 1)[0]
        if not relative_target:
            continue
        destination = (path.parent / relative_target).resolve()
        try:
            destination.relative_to(ROOT.resolve())
        except ValueError:
            errors.append(
                f"{path.relative_to(ROOT)}: local link escapes repository root: {raw_target}"
            )
            continue
        if not destination.exists():
            errors.append(
                f"{path.relative_to(ROOT)}: local link target does not exist: {raw_target}"
            )
    return errors


def formatting_errors(path: Path, text: str) -> list[str]:
    if EMPTY_LIST_MARKER.search(text):
        return [f"{path.relative_to(ROOT)}: contains an empty Markdown list marker"]
    return []


def main() -> int:
    errors: list[str] = []
    canonical_paths: list[Path] = []
    for directory_name in CANONICAL_DIRS:
        canonical_paths.extend(read_markdown_files(DOCS / directory_name))

    governed_paths = sorted(
        {path for path in [*canonical_paths, *GOVERNED_PATHS] if path.exists()},
        key=lambda path: str(path),
    )
    for path in canonical_paths:
        text = path.read_text(encoding="utf-8")
        errors.extend(metadata_errors(path, text))

    for path in governed_paths:
        text = path.read_text(encoding="utf-8")
        errors.extend(documentation_link_errors(path, text))
        errors.extend(formatting_errors(path, text))

    for path in read_markdown_files(DOCS / "archive"):
        text = path.read_text(encoding="utf-8")
        if re.search(r"^> \*\*Status:\*\*\s*(?:Current|Active)\b", text, re.MULTILINE | re.IGNORECASE):
            errors.append(f"{path.relative_to(ROOT)}: archived document cannot claim Current/Active")

    required_paths = (
        DOCS / "README.md",
        DOCS / "current" / "system-status.md",
        DOCS / "current" / "architecture.md",
        DOCS / "proposed" / "README.md",
        DOCS / "templates" / "document-metadata.md",
    )
    for path in required_paths:
        if not path.exists():
            errors.append(f"missing canonical documentation path: {path.relative_to(ROOT)}")

    if errors:
        print("Documentation governance check: FAILED")
        for error in errors:
            print(f"- {error}")
        return 1

    print(
        "Documentation governance check: PASSED "
        f"({len(canonical_paths)} canonical, {len(governed_paths)} governed documents checked)"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
