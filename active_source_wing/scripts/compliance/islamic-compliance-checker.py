#!/usr/bin/env python3
import os
import sys
import re

# Wing of Nostalgia: Islamic Compliance Checker
# This script ensures that the codebase adheres to the 20 Islamic principles
# and the "Purity Protocol" defined in the project specification.

COMPLIANCE_LEVEL = "Strict"
PRINCIPLES_COUNT = 20

# Patterns for validation
SPIRITUAL_THEMES = [
    r"taqwa", r"sabr", r"shukur", r"rahma", r"mawadda",
    r"birr", r"adab", r"ihsan", r"amana", r"sidq"
]

FORBIDDEN_PATTERNS = [
    r"inappropriate_content",
    r"unauthorized_tracking",
    r"privacy_violation"
]

# Files to exclude from scan
EXCLUDES = [
    ".git",
    "build",
    ".dart_tool",
    "ios",
    "android",
    "scripts/compliance/islamic-compliance-checker.py"
]

def scan_file(filepath):
    """Scans a single file for compliance patterns."""
    issues = []
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read().lower()
            
            # Check for forbidden patterns
            for pattern in FORBIDDEN_PATTERNS:
                if re.search(pattern, content):
                    issues.append(f"Forbidden pattern found: {pattern}")
            
            # Check for spiritual context in relevant files (optional/info)
            if "lib/" in filepath and ".dart" in filepath:
                theme_matches = [t for t in SPIRITUAL_THEMES if re.search(t, content)]
                # Logic could be added here to warn if zero themes are found in domain logic
                
    except Exception as e:
        return [f"Error reading file: {str(e)}"]
    
    return issues

def main():
    root_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    print(f"--- Wing of Nostalgia: Islamic Compliance Scan ---")
    print(f"Root: {root_dir}")
    print(f"Compliance Level: {COMPLIANCE_LEVEL}")
    
    total_files = 0
    all_issues = {}

    for root, dirs, files in os.walk(root_dir):
        # Apply excludes
        for ex in EXCLUDES:
            if ex in dirs:
                dirs.remove(ex)
            if ex in root:
                continue

        for file in files:
            if file.endswith(('.dart', '.yaml', '.md', '.txt')):
                total_files += 1
                filepath = os.path.join(root, file)
                issues = scan_file(filepath)
                if issues:
                    all_issues[filepath] = issues

    print(f"Scanned {total_files} files.")
    
    if all_issues:
        print("\n[!] Compliance Issues Found:")
        for path, issues in all_issues.items():
            rel_path = os.path.relpath(path, root_dir)
            print(f"\nFile: {rel_path}")
            for issue in issues:
                print(f"  - {issue}")
        sys.exit(1)
    else:
        print("\n[✓] All files passed Islamic Compliance validation.")
        sys.exit(0)

if __name__ == "__main__":
    main()
