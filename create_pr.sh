#!/bin/bash
# Run this script to create a PR manually
# First export your GITHUB_TOKEN: export GITHUB_TOKEN="your_token_here"

curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/mohammed-murad-alqabal/Nostalgia-Wing/pulls \
  -d '{
    "title": "Merge rehabilitation and security features into main",
    "head": "feature/merged-changes-v2",
    "base": "main",
    "body": "This PR merges the following changes into main:\n\n- origin/rehabilitation/functional-recovery (3 commits)\n- origin/security/legacy-xor-contract-tests-2026-08-27 (2 commits)\n\nIncludes cleanup of deprecated files and archive documentation to active_source_wing/docs/archive/.\n\n## Commits included:\n- fc147f0 test: scroll to intelligence lab before tapping\n- a4d0131 complete functional rehabilitation and secure local lock\n- c8ce365 rehabilitate core app flows and replace fake UI actions\n- 5541886 fix: satisfy analyzer in legacy contract test\n- 83f8d3f test: preserve legacy XOR contract vectors\n\n## Files changed:\n- Added Pin Lock screen for enhanced authentication\n- Improved performance monitoring and audio service\n- Implemented legacy XOR contract tests for security\n- Updated UI screens: home, memories, messages, settings\n- Archived deprecated documentation to docs/archive/"
}'
