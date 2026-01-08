---
description: Institutional System Optimization
---

Performs deep cleaning, redundancy removal, and structural optimization.

// turbo-all

1. Clean Flutter Build Artifacts

```bash
flutter clean
```

2. Rebuild Cognitive Adapters (Hive)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Optimize Asset Index

```bash
# Finds unused assets or missing references
dart run test/features/code_quality_test.dart
```

4. Deep Formatting & Fixing

```bash
dart fix --apply && dart format .
```
