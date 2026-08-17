#!/usr/bin/env python3
"""Focused regression tests for the documentation-governance checker."""

from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path

SCRIPT_PATH = Path(__file__).resolve().parent / "scripts" / "verify_documentation_governance.py"
SPEC = importlib.util.spec_from_file_location("documentation_governance", SCRIPT_PATH)
assert SPEC and SPEC.loader
GOVERNANCE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(GOVERNANCE)


VALID_METADATA = """> **Status:** Current
> **Owner:** Engineering
> **Authority:** Repository maintainers
> **Last verified:** 2026-08-17
> **Verified commit:** test-fixture
> **Related code:** scripts/verify_documentation_governance.py
> **Related tests:** test_verify_documentation_governance.py

# Fixture
"""


class DocumentationGovernanceTests(unittest.TestCase):
    def test_valid_metadata_has_no_error(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            source = root / "docs" / "current" / "source.md"
            source.parent.mkdir(parents=True)
            source.write_text(VALID_METADATA, encoding="utf-8")

            previous_root = GOVERNANCE.ROOT
            try:
                GOVERNANCE.ROOT = root
                self.assertEqual(GOVERNANCE.metadata_errors(source), [])
            finally:
                GOVERNANCE.ROOT = previous_root

    def test_missing_metadata_field_is_reported(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            source = root / "docs" / "current" / "source.md"
            source.parent.mkdir(parents=True)
            source.write_text(VALID_METADATA.replace("> **Status:** Current\n", ""), encoding="utf-8")

            previous_root = GOVERNANCE.ROOT
            try:
                GOVERNANCE.ROOT = root
                errors = GOVERNANCE.metadata_errors(source)
            finally:
                GOVERNANCE.ROOT = previous_root

            self.assertEqual(len(errors), 1)
            self.assertIn("missing metadata field 'Status'", errors[0])

    def test_main_passes_when_canonical_paths_and_metadata_exist(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            docs = root / "docs"
            current = docs / "current"
            current.mkdir(parents=True)
            (docs / "README.md").write_text("# Documentation\n", encoding="utf-8")
            (current / "system-status.md").write_text(VALID_METADATA, encoding="utf-8")
            (current / "architecture.md").write_text(VALID_METADATA, encoding="utf-8")

            previous_root = GOVERNANCE.ROOT
            previous_docs = GOVERNANCE.DOCS
            try:
                GOVERNANCE.ROOT = root
                GOVERNANCE.DOCS = docs
                self.assertEqual(GOVERNANCE.main(), 0)
            finally:
                GOVERNANCE.ROOT = previous_root
                GOVERNANCE.DOCS = previous_docs


if __name__ == "__main__":
    unittest.main()
