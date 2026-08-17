import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The persisted outcome of the most recent privacy reset operation.
enum PrivacyResetAuditStatus {
  /// The reset started but has not recorded a terminal outcome yet.
  running,

  /// Every cleanup boundary completed without an error.
  succeeded,

  /// At least one cleanup boundary failed.
  failed,
}

/// A non-sensitive record describing the most recent privacy reset.
///
/// This record deliberately stores lifecycle metadata only. It must never
/// contain user content, encrypted payloads, or a stack trace.
class PrivacyResetAuditRecord {
  /// Creates a reset audit record.
  const PrivacyResetAuditRecord({
    required this.status,
    required this.startedAt,
    this.finishedAt,
    this.failedStep,
    this.errorType,
  });

  /// The terminal or in-progress state of the reset.
  final PrivacyResetAuditStatus status;

  /// The UTC time at which the reset started.
  final DateTime startedAt;

  /// The UTC time at which a terminal state was recorded.
  final DateTime? finishedAt;

  /// The first cleanup boundary that failed, if any.
  final String? failedStep;

  /// The runtime type of the first error, if any.
  final String? errorType;
}

/// Minimal persistence contract used by [PrivacyResetAuditStore].
///
/// Keeping this contract small makes the audit store deterministic in tests
/// without requiring a platform secure-storage plugin there.
abstract interface class PrivacyResetAuditStorage {
  /// Reads a value by key.
  Future<String?> read({required String key});

  /// Writes a value by key.
  Future<void> write({required String key, required String value});
}

/// [PrivacyResetAuditStorage] adapter backed by platform secure storage.
class FlutterSecurePrivacyResetAuditStorage
    implements PrivacyResetAuditStorage {
  /// Creates a secure-storage adapter.
  FlutterSecurePrivacyResetAuditStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);
}

/// Persists non-sensitive lifecycle metadata for the latest privacy reset.
class PrivacyResetAuditStore {
  /// Creates an audit store.
  PrivacyResetAuditStore({PrivacyResetAuditStorage? storage})
      : _storage = storage ?? FlutterSecurePrivacyResetAuditStorage();

  static const _statusKey = 'privacy_reset_audit_status';
  static const _startedAtKey = 'privacy_reset_audit_started_at';
  static const _finishedAtKey = 'privacy_reset_audit_finished_at';
  static const _failedStepKey = 'privacy_reset_audit_failed_step';
  static const _errorTypeKey = 'privacy_reset_audit_error_type';

  final PrivacyResetAuditStorage _storage;

  /// Records that a reset has started.
  Future<void> markStarted(DateTime startedAt) async {
    await _writeRecord(
      PrivacyResetAuditRecord(
        status: PrivacyResetAuditStatus.running,
        startedAt: startedAt.toUtc(),
      ),
    );
  }

  /// Records a successful reset.
  Future<void> markSucceeded({
    required DateTime startedAt,
    required DateTime finishedAt,
  }) async {
    await _writeRecord(
      PrivacyResetAuditRecord(
        status: PrivacyResetAuditStatus.succeeded,
        startedAt: startedAt.toUtc(),
        finishedAt: finishedAt.toUtc(),
      ),
    );
  }

  /// Records a failed reset without persisting sensitive error details.
  Future<void> markFailed({
    required DateTime startedAt,
    required DateTime finishedAt,
    required String? failedStep,
    required Object error,
  }) async {
    await _writeRecord(
      PrivacyResetAuditRecord(
        status: PrivacyResetAuditStatus.failed,
        startedAt: startedAt.toUtc(),
        finishedAt: finishedAt.toUtc(),
        failedStep: failedStep,
        errorType: error.runtimeType.toString(),
      ),
    );
  }

  /// Reads the latest audit record, or null if none has been persisted.
  Future<PrivacyResetAuditRecord?> read() async {
    final statusValue = await _storage.read(key: _statusKey);
    final startedAtValue = await _storage.read(key: _startedAtKey);
    if (statusValue == null || startedAtValue == null) return null;

    final status = PrivacyResetAuditStatus.values.firstWhere(
      (value) => value.name == statusValue,
      orElse: () => throw const FormatException(
        'Unknown privacy reset audit status.',
      ),
    );
    final startedAt = DateTime.parse(startedAtValue).toUtc();
    final finishedAtValue = await _readOptional(_finishedAtKey);
    final failedStep = await _readOptional(_failedStepKey);
    final errorType = await _readOptional(_errorTypeKey);

    return PrivacyResetAuditRecord(
      status: status,
      startedAt: startedAt,
      finishedAt: finishedAtValue == null
          ? null
          : DateTime.parse(finishedAtValue).toUtc(),
      failedStep: failedStep,
      errorType: errorType,
    );
  }

  Future<void> _writeRecord(PrivacyResetAuditRecord record) async {
    await _storage.write(
      key: _statusKey,
      value: record.status.name,
    );
    await _storage.write(
      key: _startedAtKey,
      value: record.startedAt.toUtc().toIso8601String(),
    );
    await _writeOptional(_finishedAtKey, record.finishedAt);
    await _writeOptionalString(_failedStepKey, record.failedStep);
    await _writeOptionalString(_errorTypeKey, record.errorType);
  }

  Future<String?> _readOptional(String key) async {
    final value = await _storage.read(key: key);
    return value == null || value.isEmpty ? null : value;
  }

  Future<void> _writeOptional(String key, DateTime? value) =>
      _writeOptionalString(key, value?.toUtc().toIso8601String());

  Future<void> _writeOptionalString(String key, String? value) async {
    if (value == null) {
      // A null value is represented by an empty string so the storage contract
      // remains write-only and does not need a delete operation.
      await _storage.write(key: key, value: '');
    } else {
      await _storage.write(key: key, value: value);
    }
  }
}
