import 'package:shared_preferences/shared_preferences.dart';

/// خدمة الإعدادات - Settings Service
/// تدير تخزين واسترجاع إعدادات المستخدم بشكل دائم.
class SettingsService {
  /// Factory constructor to return the singleton instance.
  factory SettingsService() => _instance;

  SettingsService._internal();

  static final SettingsService _instance = SettingsService._internal();

  late SharedPreferences _prefs;

  // Keys
  static const String _keyPerformanceOverride = 'perf_adaptation_override';
  static const String _keyUseDynamicAdaptation = 'perf_use_dynamic';

  /// تهيئة الخدمة
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// هل نستخدم التكيف الديناميكي؟
  bool get useDynamicAdaptation =>
      _prefs.getBool(_keyUseDynamicAdaptation) ?? true;

  /// تعيين استخدام التكيف الديناميكي
  Future<void> setUseDynamicAdaptation(bool value) async {
    await _prefs.setBool(_keyUseDynamicAdaptation, value);
  }

  /// مستوى الأداء اليدوي (Override)
  /// يعود بـ null إذا لم يكن هناك تجاوز يدوي
  String? get performanceOverride => _prefs.getString(_keyPerformanceOverride);

  /// تعيين مستوى الأداء اليدوي
  Future<void> setPerformanceOverride(String? value) async {
    if (value == null) {
      await _prefs.remove(_keyPerformanceOverride);
    } else {
      await _prefs.setString(_keyPerformanceOverride, value);
    }
  }
}
