# Privacy Reset Audit and Drift Migration Contract

> **Status:** Partial
> **Owner:** فريق تطوير مشروع جناح الحنين
> **Authority:** عقد الخصوصية المحلي، `PrivacyMaintenanceService`، و`AppDatabase` عند schema version 3
> **Last verified:** 2026-08-19
> **Verified commit:** `fix/android-privacy-reset-integration-v2` branch under review; platform evidence is pending
> **Related code:** `active_source_wing/lib/core/security/privacy_maintenance_service.dart`, `active_source_wing/lib/core/security/privacy_reset_audit_store.dart`, `active_source_wing/lib/core/security/security_service.dart`, `active_source_wing/lib/core/security/key_manager.dart`, `active_source_wing/lib/core/security/versioned_encryption_service.dart`, `active_source_wing/lib/core/security/decryption_observer.dart`,
> `active_source_wing/lib/core/services/secure_media_cleanup_service.dart`, `active_source_wing/lib/core/services/db_service.dart`, `active_source_wing/lib/core/data/app_database.dart`
> **Related tests:** `active_source_wing/test/core/security/institutional_maintenance_test.dart`, `active_source_wing/test/core/security/security_service_test.dart`, `active_source_wing/test/core/security/versioned_encryption_service_test.dart`,
> `active_source_wing/test/core/services/secure_media_cleanup_service_test.dart`, `active_source_wing/test/core/services/db_service_test.dart`, `active_source_wing/test/core/data/app_database_migration_test.dart`, `active_source_wing/test/fixtures/drift_v2.sqlite`,
> `active_source_wing/test/core/lifecycle/service_lifecycle_test.dart`, `active_source_wing/test/core/smoke/privacy_reset_smoke_test.dart`, `active_source_wing/integration_test/privacy_reset_restart_test.dart`

## Purpose

This document defines the evidence contract for local privacy safeguards, including the persisted, non-sensitive outcome of the latest privacy reset, the migration test from Drift schema version 2 to version 3, and the SEC-03 encryption envelope contract. It does not introduce automatic expiry for memories, automatic re-encryption, or a new production use for `SafetyBoxService`.

## Privacy reset audit

The reset audit is lifecycle metadata, not a content log. It may record `running`, `succeeded`, or `failed`, together with UTC start and finish timestamps. A failed operation records only the first failed cleanup boundary and the runtime error type. It must never persist memory text, encrypted payloads, media paths, or a full stack trace.

The audit is stored independently from `SharedPreferences` because the reset contract clears all preferences. The independent storage is intentional: retaining the latest non-sensitive result allows a later diagnostic or UI flow to distinguish a completed reset from a reset that stopped during cleanup. The stored audit record is not user content and is not a substitute for a server-side audit trail.

The cleanup remains best-effort. Each independent boundary is attempted even after another boundary fails. The first cleanup error is rethrown after the terminal audit status is written. If audit persistence itself fails, that failure is logged and must not replace the original cleanup result.

## Secure media lifecycle

Each memory may reference one encrypted media path in `Memories.mediaPath`. `DBService.deleteMemory` reads the row before deletion, deletes the database row first, and then asks `SecureMediaCleanupService` to remove the linked file. The database deletion is authoritative; a file path is eligible for deletion only when it is a direct `.enc` file inside the application-owned `secure_media` directory. Paths outside that directory, missing files, non-encrypted files, and nested directories are ignored.

`DBService.cleanupOrphanedMedia` is an explicit authenticated maintenance operation. It compares direct encrypted files in `secure_media` with the paths referenced by the remaining memory rows and removes only unreferenced `.enc` files. It does not recreate a missing directory, delete unrelated files, or introduce automatic expiry. The complete privacy reset continues to remove the whole application-owned `secure_media` directory as an independent cleanup boundary.

## SEC-03 versioned encryption and key rotation

New AES-GCM payloads use a versioned authenticated envelope containing a fixed format marker, envelope version, UTF-8 key identifier, nonce, ciphertext, and authentication tag. The envelope header is authenticated as additional data, so changing the version or key identifier invalidates the payload. Production writes and reads go through `VersionedEncryptionService`, which selects the active key for new data and resolves the retained key named by each payload for reads.

Historical AES-GCM payloads in the previous `nonce + ciphertext + MAC` format remain readable as a compatibility boundary. They have no key identifier and therefore resolve to the retained `legacy` key. The compatibility reader does not claim that historical data has been re-enveloped.

`KeyManager.rotateMasterKey` creates and activates a new versioned key while retaining the previous key. It does not rewrite records, delete the previous key, or perform a background migration. `VersionedEncryptionService.rewrap` and `rewrapBytes` are explicit operations that decrypt, then encrypt under the active key; a future batch migration must verify each result before replacing the source payload. Scheduled rotation, automatic re-encryption, remote key management, and recovery from lost device keys remain outside this PR and must be separately reviewed.

The privacy reset clears the active-key pointer, the historical master key, and all retained versioned keys. After a reset, the next first-use initialization creates a new key; this is expected and does not restore previously deleted data.

### Decryption failure observability

`SecurityService` and `VersionedEncryptionService` may emit a `DecryptionFailureEvent` through an injected observer when decoding, envelope parsing, key resolution, authentication, or UTF-8 conversion fails. The event is intentionally classified and privacy-safe: it may include only the operation, failure kind, sanitized generated key ID, envelope version, and payload length. It must never include plaintext, ciphertext, secret-key bytes, exception messages, or stack traces.

The production observer currently forwards the safe fields to `WingLogger` at warning level. Observer failures are swallowed so diagnostics cannot replace or alter the original decryption exception. This is local observability only; remote telemetry, automatic retry, silent fallback, and automatic data repair remain `Proposed` and require separate review.

## Retention policy boundary

The application currently has no automatic time-to-live or age-based deletion for memories, reflections, sent messages, surprises, or psychological-context entries. The main records remain until explicit user deletion or a complete privacy reset. Psychological context is bounded by a maximum count of 100 entries; this is a size bound, not a time-retention policy.

Automatic expiry remains a product decision and is intentionally outside this change. It must not be added as an incidental consequence of introducing audit metadata or migration fixtures.

## SafetyBoxService isolation boundary

`SafetyBoxService` remains a compatibility reader for the historical Hive box `safety_box_vault`. Its historical XOR-and-SHA-256 payload has no nonce, authenticated MAC, or versioned envelope, so it is not an approved format for new sensitive data.

New legacy writes are disabled by default. The write path can be enabled only through an explicit `allowLegacyWrites: true` opt-in for a controlled compatibility test or a future, separately reviewed migration. Reading historical records, enumerating legacy identifiers, deleting records, and deleting the box during privacy reset remain available so existing data is not silently discarded.

Any new sensitive storage must use the authenticated encryption service rather than `SafetyBoxService`. A future migration may read the legacy payload, write a versioned authenticated envelope, verify the result, and delete the old record only after successful conversion. This PR does not claim that such migration has occurred, and it does not remove or rename the historical box.

## Drift v2 to v3 migration evidence

The migration fixture represents a populated version 2 database containing `memories` and `reflections` rows with stable identifiers, timestamps, nullable fields, and representative encrypted placeholders. Its SQLite `user_version` is 2. Opening the fixture through `AppDatabase` must execute the existing migration and create `sent_messages` and `surprises`.

The migration test must verify that the existing memory and reflection values survive unchanged, that the two version-3 tables exist, and that the new tables are empty when the v2 fixture contains no rows for them. The test must close and reopen the migrated database to ensure the result is durable and the migration is not repeated destructively.

The fixture contains synthetic values only. It is not a backup and must never contain a real user key, real memory content, or production media.

## Pre-release stability suite

The pre-release stability suite adds focused lifecycle and privacy-reset smoke evidence without changing production retention or encryption behavior. `service_lifecycle_test.dart` verifies that `sl.reset()` closes the owned Drift database, that a complete reset permits a fresh `sl.initialize()` graph, that `AuthService.dispose()` invalidates the old session until a newly initialized singleton is used, and that an empty secure-media path is a safe no-op. `privacy_reset_smoke_test.dart` inserts representative Drift data, runs the complete reset, verifies the successful independent audit record, confirms Hive and authentication shutdown, and reopens the SQLite file to verify that all sensitive tables are empty and durable after reset.

The performance suite continues to measure 100 memory writes and repeated reads for diagnostic output, but it no longer treats fixed wall-clock thresholds as correctness gates. Timing depends on the hosted runner, SQLite backend, debug/profile mode, and concurrent CI load; performance budgets remain a separate benchmark concern and must be calibrated from recorded runner evidence before becoming release gates.

## Platform integration evidence

The Android integration test launches the real application, writes synthetic records to Drift, Hive, and `secure_media`, executes privacy maintenance through the production UI, verifies the successful audit outcome and deletion boundaries, and invokes the real entrypoint again to model a fresh initialization. The restarted application must render the normal app root rather than `EmergencyApp`, retain the non-sensitive audit result, and expose empty local data stores.

The test is deliberately platform-scoped because it exercises `path_provider`, Hive, Flutter Secure Storage, the application entrypoint, and an Android emulator. It is not included in the local unit-test command and must run in the dedicated `platform-integration` GitHub Actions job. Test data is synthetic and must never include a real key, memory, media file, or production account.

Local verification is intentionally limited to Dart formatting and repository diff checks in the current sandbox. Flutter analysis, widget/integration execution, and build verification remain authoritative only through the repository's GitHub Actions gates; this suite does not claim local Flutter success.

## Verification boundary

Dart formatting, `git diff --check`, and static source review may run locally. Flutter analysis, unit/widget tests, build verification, and the Android platform integration test are authoritative only through GitHub Actions for this repository because Flutter is not installed in the current sandbox. A PR may be merged only after the documentation governance, Flutter quality gate, Android platform integration, and repository hygiene checks pass and the project owner confirms the merge.

## References

[1]: https://drift.simonbinder.eu/guides/datetime-migrations/ "Drift — DateTime Storage"

The v2 fixture uses Unix timestamps in seconds because that is Drift's default SQLite storage mode for `DateTime` values.[1]
