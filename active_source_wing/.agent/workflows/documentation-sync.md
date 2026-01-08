---
description: Living Documentation Synchronization
---

Triggers the SEF Living Documentation System to generate fresh ADRs, architecture maps, and API guides.

// turbo

1. Run Documentation Sync

```bash
# Triggers the generation of current state docs
dart run test/core/infrastructure/living_documentation_test.dart
```

2. Refresh Project Structure Map

```bash
# Optionally updates the directory mapping
ls -R lib > lib_map.txt
```
