import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cognitive/psychological_context_manager.dart';
import '../di/service_locator.dart';
import '../infrastructure/wing_logger.dart';
import '../services/auth_service.dart';
import '../services/safety_box_service.dart';
import 'privacy_reset_audit_store.dart';

/// خدمة صيانة الخصوصية المعرفية
/// Privacy Security Protocols
class PrivacyMaintenanceService {
  PrivacyMaintenanceService._();

  /// صيانة الخصوصية وتصفير البيانات - مسح جميع البيانات الحساسة والسياقات
  /// Privacy Maintenance Reset: Clears sensitive data & psychological contexts.
  static Future<void> maintenanceReset({
    PrivacyResetAuditStore? auditStore,
  }) async {
    final resetAudit = auditStore ?? PrivacyResetAuditStore();
    final startedAt = DateTime.now().toUtc();
    String? firstFailedStep;

    try {
      await resetAudit.markStarted(startedAt);
    } catch (error, stackTrace) {
      // Audit persistence must never prevent the actual cleanup contract.
      WingLogger.error(
        'Privacy reset audit could not record start',
        tag: 'SecurityProtocol',
        error: error,
        stackTrace: stackTrace,
      );
    }

    WingLogger.critical(
      'PRIVACY MAINTENANCE STARTING: Total context erasure starting...',
      tag: 'SecurityProtocol',
    );

    Object? firstError;
    StackTrace? firstStackTrace;

    Future<void> attempt(String step, Future<void> Function() action) async {
      try {
        await action();
      } catch (error, stackTrace) {
        firstError ??= error;
        firstStackTrace ??= stackTrace;
        firstFailedStep ??= step;
        WingLogger.error(
          'Privacy maintenance step failed: $step',
          tag: 'SecurityProtocol',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }

    final keyManager = sl.isInitialized ? sl.keyManager : null;

    // Continue through every cleanup boundary. Deletion is irreversible, so a
    // later failure must not prevent earlier-independent stores from being
    // cleaned up.
    await attempt('encrypted media', _clearEncryptedMedia);

    await attempt('relational database', () async {
      if (sl.isInitialized) {
        await sl.database.clearAllSensitiveData();
      }
    });

    await attempt(
      'psychological context Hive box',
      () => _deleteHiveBox(PsychologicalContextManager.boxName),
    );
    await attempt(
      'safety box Hive box',
      () => _deleteHiveBox(SafetyBoxService.boxName),
    );

    await attempt('local preferences', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    });

    await attempt('authentication session', () async {
      await AuthService.instance.logout();
      AuthService.instance.dispose();
    });

    await attempt('master key invalidation', () async {
      await keyManager?.clearMasterKey();
    });

    // Always close Drift, even when key invalidation or an earlier cleanup step
    // failed. The app must not remain initialized with an invalid encryption
    // key or a partially reset data graph.
    await attempt('service locator shutdown', sl.reset);

    final finishedAt = DateTime.now().toUtc();
    try {
      if (firstError == null) {
        await resetAudit.markSucceeded(
          startedAt: startedAt,
          finishedAt: finishedAt,
        );
      } else {
        await resetAudit.markFailed(
          startedAt: startedAt,
          finishedAt: finishedAt,
          failedStep: firstFailedStep,
          error: firstError!,
        );
      }
    } catch (error, stackTrace) {
      // Do not replace the cleanup result with an audit-storage failure.
      WingLogger.error(
        'Privacy reset audit could not record terminal outcome',
        tag: 'SecurityProtocol',
        error: error,
        stackTrace: stackTrace,
      );
    }

    if (firstError != null) {
      WingLogger.critical(
        'PRIVACY MAINTENANCE FAILED: Cleanup completed with errors.',
        tag: 'SecurityProtocol',
        error: firstError,
        stackTrace: firstStackTrace,
      );
      Error.throwWithStackTrace(
        firstError!,
        firstStackTrace ?? StackTrace.current,
      );
    }

    WingLogger.critical(
      'PRIVACY MAINTENANCE COMPLETED: Project is now in a state of purity '
      '(Professional Clarity).',
      tag: 'SecurityProtocol',
    );
  }

  /// Removes the Hive box file and closes the box as part of the operation.
  /// Hive 2.2.3 documents that deleteBoxFromDisk performs both actions.
  static Future<void> _deleteHiveBox(String boxName) async {
    await Hive.deleteBoxFromDisk(boxName);
  }

  /// Removes the application-owned directory containing encrypted memory media.
  ///
  /// The directory is deleted as a whole so unreferenced encrypted files cannot
  /// survive a successful privacy reset.
  static Future<void> _clearEncryptedMedia() async {
    final appDir = await getApplicationDocumentsDirectory();
    final secureMediaDir = Directory(p.join(appDir.path, 'secure_media'));

    if (secureMediaDir.existsSync()) {
      secureMediaDir.deleteSync(recursive: true);
    }
  }
}
