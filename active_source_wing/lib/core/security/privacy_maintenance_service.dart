import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      // 1. مسح صناديق Hive
      // Clear Hive boxes
      await Hive.deleteBoxFromDisk(PsychologicalContextManager.boxName);
      await Hive.deleteBoxFromDisk(SafetyBoxService.boxName);

      // 2. مسح الإعدادات المفضلة
      // Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 3. إعادة تعيين الخدمات النشطة
      // Reset active services
      AuthService.instance.logout();
      AuthService.instance.dispose();

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
}
