# Privacy Reset Audit and Drift Migration Contract

> **Status:** Partial
> **Owner:** فريق تطوير مشروع جناح الحنين
> **Authority:** عقد الخصوصية المحلي، `PrivacyMaintenanceService`، و`AppDatabase` عند schema version 3
> **Last verified:** 2026-08-18
> **Verified commit:** `f5dd5c9`; platform evidence is pending PR #15 CI
> **Related code:** `active_source_wing/lib/core/security/privacy_maintenance_service.dart`, `active_source_wing/lib/core/security/privacy_reset_audit_store.dart`, `active_source_wing/lib/core/data/app_database.dart`
> **Related tests:** `active_source_wing/test/core/security/institutional_maintenance_test.dart`, `active_source_wing/test/core/data/app_database_migration_test.dart`, `active_source_wing/test/fixtures/drift_v2.sqlite`, `active_source_wing/integration_test/privacy_reset_restart_test.dart`

## Purpose

This document defines the evidence contract for two local-data safeguards: the persisted, non-sensitive outcome of the latest privacy reset and the migration test from Drift schema version 2 to version 3. It does not introduce automatic expiry for memories, key rotation, or a new production use for `SafetyBoxService`.

## Privacy reset audit

The reset audit is lifecycle metadata, not a content log. It may record `running`, `succeeded`, or `failed`, together with UTC start and finish timestamps. A failed operation records only the first failed cleanup boundary and the runtime error type. It must never persist memory text, encrypted payloads, media paths, or a full stack trace.

The audit is stored independently from `SharedPreferences` because the reset contract clears all preferences. The independent storage is intentional: retaining the latest non-sensitive result allows a later diagnostic or UI flow to distinguish a completed reset from a reset that stopped during cleanup. The stored audit record is not user content and is not a substitute for a server-side audit trail.

The cleanup remains best-effort. Each independent boundary is attempted even after another boundary fails. The first cleanup error is rethrown after the terminal audit status is written. If audit persistence itself fails, that failure is logged and must not replace the original cleanup result.

## Retention policy boundary

The application currently has no automatic time-to-live or age-based deletion for memories, reflections, sent messages, surprises, or psychological-context entries. The main records remain until explicit user deletion or a complete privacy reset. Psychological context is bounded by a maximum count of 100 entries; this is a size bound, not a time-retention policy.

Automatic expiry remains a product decision and is intentionally outside this change. It must not be added as an incidental consequence of introducing audit metadata or migration fixtures.

## Drift v2 to v3 migration evidence

The migration fixture represents a populated version 2 database containing `memories` and `reflections` rows with stable identifiers, timestamps, nullable fields, and representative encrypted placeholders. Its SQLite `user_version` is 2. Opening the fixture through `AppDatabase` must execute the existing migration and create `sent_messages` and `surprises`.

The migration test must verify that the existing memory and reflection values survive unchanged, that the two version-3 tables exist, and that the new tables are empty when the v2 fixture contains no rows for them. The test must close and reopen the migrated database to ensure the result is durable and the migration is not repeated destructively.

The fixture contains synthetic values only. It is not a backup and must never contain a real user key, real memory content, or production media.

## Platform integration evidence

PR #15 adds an Android integration test that launches the real application, writes synthetic records to Drift, Hive, and `secure_media`, executes privacy maintenance through the production UI, verifies the successful audit outcome and deletion boundaries, and invokes the real entrypoint again to model a fresh initialization. The restarted application must render the normal app root rather than `EmergencyApp`, retain the non-sensitive audit result, and expose empty local data stores.

The test is deliberately platform-scoped because it exercises `path_provider`, Hive, Flutter Secure Storage, the application entrypoint, and an Android emulator. It is not included in the local unit-test command and must run in the dedicated `platform-integration` GitHub Actions job. Test data is synthetic and must never include a real key, memory, media file, or production account.

## Verification boundary

Dart formatting, `git diff --check`, and static source review may run locally. Flutter analysis, unit/widget tests, build verification, and the Android platform integration test are authoritative only through GitHub Actions for this repository because Flutter is not installed in the current sandbox. A PR may be merged only after the documentation governance, Flutter quality gate, Android platform integration, and repository hygiene checks pass and the project owner confirms the merge.

## References

[1]: https://drift.simonbinder.eu/guides/datetime-migrations/ "Drift — DateTime Storage"

The v2 fixture uses Unix timestamps in seconds because that is Drift's default SQLite storage mode for `DateTime` values.[1]
