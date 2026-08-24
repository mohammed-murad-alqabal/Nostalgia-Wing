#!/usr/bin/env python3

"""Validate the canonical documentation contract for Wing of Nostalgia.



This checker intentionally focuses on canonical documentation directories. It

is not a prose linter and does not infer implementation from document text.

"""

from __future__ import annotations



import re

import subprocess

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
VERIFIED_COMMIT_PATTERN = re.compile(r"^`?[0-9a-f]{7,40}`?$")





def read_markdown_files(directory: Path):
  
    if not directory.exists():
      
        return []
      
    return sorted(p for p in directory.rglob("*.md") if p.is_file())
  




def metadata_errors(path: Path) -> list[str]:
  
    text = path.read_text(encoding="utf-8")
  
    errors: list[str] = []
  
    for field in REQUIRED_FIELDS:
      
        if not re.search(rf"^> \*\*{re.escape(field)}:\*\*\s*.+$", text, re.MULTILINE):
          
            errors.append(f"{path.relative_to(ROOT)}: missing metadata field '{field}'")
          
    status_match = re.search(r"^> \*\*Status:\*\*\s*([^\n]+)", text, re.MULTILINE)
    verified_match = re.search(r"^> \*\*Verified commit:\*\*\s*([^\n]+)", text, re.MULTILINE)

    if verified_match and not VERIFIED_COMMIT_PATTERN.fullmatch(verified_match.group(1).strip()):
        errors.append(
            f"{path.relative_to(ROOT)}: Verified commit must be a concrete Git SHA"
        )
  
    if status_match:
      
        status = status_match.group(1).strip().split("/")[0].strip()
      
        if status not in STATUS_VALUES:
          
            errors.append(f"{path.relative_to(ROOT)}: unsupported status '{status}'")
          
    return errors
  




def main() -> int:
  
    errors: list[str] = []
  
    checked = 0
  


    for dirname in CANONICAL_DIRS:
      
        for path in read_markdown_files(DOCS / dirname):
          
            checked += 1
            errors.extend(metadata_errors(path))

            text = path.read_text(encoding="utf-8")
            verified_match = re.search(
                r"^> \*\*Verified commit:\*\*\s*`?([0-9a-f]{7,40})`?\s*$",
                text,
                re.MULTILINE,
            )
            if verified_match and (ROOT / ".git").exists():
                sha = verified_match.group(1)
                exists = subprocess.run(
                    ["git", "cat-file", "-e", f"{sha}^{{commit}}"],
                    cwd=ROOT,
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                ).returncode == 0
                if not exists:
                    errors.append(
                        f"{path.relative_to(ROOT)}: Verified commit does not exist"
                    )
                else:
                    ancestor = subprocess.run(
                        ["git", "merge-base", "--is-ancestor", sha, "HEAD"],
                        cwd=ROOT,
                        stdout=subprocess.DEVNULL,
                        stderr=subprocess.DEVNULL,
                    ).returncode == 0
                    if not ancestor:
                        errors.append(
                            f"{path.relative_to(ROOT)}: Verified commit is not an ancestor of HEAD"
                        )
          


    archive = DOCS / "archive"
  
    for path in read_markdown_files(archive):
      
        text = path.read_text(encoding="utf-8")
      
        if re.search(r"^> \*\*Status:\*\*\s*(?:Current|Active)\b", text, re.MULTILINE | re.IGNORECASE):
          
            errors.append(f"{path.relative_to(ROOT)}: archived document cannot claim Current/Active")
          


    required_paths = (
      
        DOCS / "README.md",
      
        DOCS / "current" / "system-status.md",
      
        DOCS / "current" / "architecture.md",
      
    )
  
    for path in required_paths:
      
        if not path.exists():
          
            errors.append(f"missing canonical documentation path: {path.relative_to(ROOT)}")
          


    if errors:
      
        print("Documentation governance check: FAILED")
      
        for error in errors:
          
            print(f"- {error}")
          
        return 1
      


    print(f"Documentation governance check: PASSED ({checked} canonical documents checked)")
  
    return 0
  




if __name__ == "__main__":
  
    sys.exit(main())
  





















































