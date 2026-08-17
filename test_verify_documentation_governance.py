#!/usr/bin/env python3
"""Focused regression tests for the documentation-governance checker."""

from __future__ import annotations

import importlib.util
import tempfile
import unittest
from pathlib import Path

SCRIPT_PATH = Path(__file__).with_name("verify_documentation_governance.py")
SPEC = importlib.util.spec_from_file_location("documentation_governance", SCRIPT_PATH)
assert SPEC and SPEC.loader
GOVERNANCE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(GOVERNANCE)


class DocumentationGovernanceTests(unittest.TestCase):
    def test_valid_relative_link_has_no_error(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            source = root / "docs" / "current" / "source.md"
            target = root / "docs" / "current" / "target.md"
            source.parent.mkdir(parents=True)
            source.write_text("[الهدف](target.md)\n", encoding="utf-8")
            target.write_text("# الهدف\n", encoding="utf-8")

            previous_root = GOVERNANCE.ROOT
            try:
                GOVERNANCE.ROOT = root
                self.assertEqual(GOVERNANCE.documentation_link_errors(source, source.read_text()), [])
            finally:
                GOVERNANCE.ROOT = previous_root

    def test_missing_relative_link_is_reported(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            source = root / "docs" / "current" / "source.md"
            source.parent.mkdir(parents=True)
            source.write_text("[مفقود](missing.md)\n", encoding="utf-8")

            previous_root = GOVERNANCE.ROOT
            try:
                GOVERNANCE.ROOT = root
                errors = GOVERNANCE.documentation_link_errors(source, source.read_text())
            finally:
                GOVERNANCE.ROOT = previous_root

            self.assertEqual(len(errors), 1)
            self.assertIn("local link target does not exist", errors[0])

    def test_empty_list_marker_is_reported(self) -> None:
        with tempfile.TemporaryDirectory() as temporary_directory:
            root = Path(temporary_directory)
            source = root / "docs" / "current" / "source.md"
            source.parent.mkdir(parents=True)
            source.write_text("- بند صحيح\n- \n", encoding="utf-8")

            previous_root = GOVERNANCE.ROOT
            try:
                GOVERNANCE.ROOT = root
                errors = GOVERNANCE.formatting_errors(source, source.read_text())
            finally:
                GOVERNANCE.ROOT = previous_root

            self.assertEqual(len(errors), 1)
            self.assertIn("empty Markdown list marker", errors[0])


if __name__ == "__main__":
    unittest.main()
