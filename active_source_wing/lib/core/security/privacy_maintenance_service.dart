import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../di/service_locator.dart';
import '../infrastructure/wing_logger.dart';
import '../services/auth_service.dart';
import '../services/safety_box_service.dart';
import '../cognitive/psychological_context_manager.dart';

/// خدمة صيانة الخصوصية المعرفية
/// Privacy Security Protocols
class PrivacyMaintenanceService {
  PrivacyMaintenanceService._();

  /// صيانة الخصوصية وتصفير البيانات - مسح جميع البيانات الحساسة والسياقات
  /// Privacy Maintenance Reset: Clears sensitive data & psychological contexts.
  static Future<void> maintenanceReset() async {
    WingLogger.critical(
      'PRIVACY MAINTENANCE STARTING: Total context erasure starting...',
      tag: 'SecurityProtocol',
    );

    try {
      // 1. مسح ملفات الوسائط المشفرة، بما في ذلك الملفات اليتيمة.
      await _clearEncryptedMedia();

      // 2. مسح البيانات العلائقية قبل حذف المفتاح الذي يحميها.
      await sl.database.clearAllSensitiveData();

      // 3. مسح صناديق Hive.
      await Hive.deleteBoxFromDisk(PsychologicalContextManager.boxName);
      await Hive.deleteBoxFromDisk(SafetyBoxService.boxName);

      // 4. مسح الإعدادات المحلية.
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 5. إعادة تعيين الجلسة ثم إبطال المفتاح الرئيسي.
      await AuthService.instance.logout();
      AuthService.instance.dispose();
      await sl.keyManager.clearMasterKey();

      WingLogger.critical(
        'PRIVACY MAINTENANCE COMPLETED: Project is now in a state of purity '
        '(Professional Clarity).',
        tag: 'SecurityProtocol',
      );
    } catch (e, stackTrace) {
      WingLogger.error(
        'Critical failure during Privacy Maintenance',
        tag: 'SecurityProtocol',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
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
