---
description: Comprehensive Institutional Health Scan
---

This workflow performs a deep audit of the system's code quality, type safety, and cognitive integrity.

// turbo-all

1. Run Static Analysis

```bash
flutter analyze .
```

2. Run Integrated Test Suite

```bash
flutter test
```

3. Verify Cognitive Module Initialization

```bash
# This triggers a simulated startup check
dart run test/core/infrastructure/app_initializer_test.dart
```

4. Audit Baseer Standard Compliance

```bash
# Checks for legacy prints or raw Hive boxes
grep -r "print(" lib || true
grep -r "Box " lib | grep -v "<" || true
```
