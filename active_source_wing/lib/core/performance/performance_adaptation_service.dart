import 'package:flutter/foundation.dart';
import 'performance_monitor.dart';
import '../di/service_locator.dart';

/// تكوين التكيف - Adaptive Configuration
/// يحتوي على الإعدادات التي يجب تغييرها بناءً على مستوى الأداء
class AdaptiveConfig {
  /// Creates an [AdaptiveConfig] snapshot.
  const AdaptiveConfig({
    required this.particleCount,
    required this.useBlur,
    required this.useShadows,
    required this.animationSpeedFactor,
    required this.performanceLevel,
  });

  /// عدد الجسيمات المسموح بها
  final int particleCount;

  /// هل يتم استخدام تأثيرات الغبش (Blur)
  final bool useBlur;

  /// هل يتم استخدام الظلال المعقدة
  final bool useShadows;

  /// معامل سرعة الحركة (لتسريع الحركات في الأداء المنخفض لتقليل الجهد)
  final double animationSpeedFactor;

  /// مستوى الأداء الحالي
  final PerformanceLevel performanceLevel;

  /// التكوين الافتراضي للأداء العالي
  static const AdaptiveConfig high = AdaptiveConfig(
    particleCount: 100,
    useBlur: true,
    useShadows: true,
    animationSpeedFactor: 1.0,
    performanceLevel: PerformanceLevel.high,
  );

  /// التكوين للأداء المتوسط
  static const AdaptiveConfig medium = AdaptiveConfig(
    particleCount: 50,
    useBlur: true,
    useShadows: false,
    animationSpeedFactor: 1.0,
    performanceLevel: PerformanceLevel.medium,
  );

  /// التكوين للأداء المنخفض
  static const AdaptiveConfig low = AdaptiveConfig(
    particleCount: 15,
    useBlur: false,
    useShadows: false,
    animationSpeedFactor: 1.5, // حركات أسرع لتقليل زمن الرسم لكل مشهد
    performanceLevel: PerformanceLevel.low,
  );
}

/// خدمة التكيف مع الأداء - Performance Adaptation Service
/// تقوم بتحويل مستويات الأداء إلى إعدادات برمجة للواجهة
class PerformanceAdaptationService extends ChangeNotifier {
  /// Factory constructor to return the singleton instance.
  factory PerformanceAdaptationService() => _instance;
  PerformanceAdaptationService._internal() {
    _monitor.performanceLevelStream.listen(_handleLevelChange);
    _loadSettings();
  }

  void _loadSettings() {
    final settings = sl.settingsService;
    _useDynamic = settings.useDynamicAdaptation;
    _overrideLevel = _parseLevel(settings.performanceOverride);
    _updateConfig();
  }

  static final PerformanceAdaptationService _instance =
      PerformanceAdaptationService._internal();
  final PerformanceMonitor _monitor = PerformanceMonitor();

  late AdaptiveConfig _config;
  bool _useDynamic = true;
  PerformanceLevel? _overrideLevel;

  /// التكوين الحالي
  AdaptiveConfig get config => _config;

  /// هل نستخدم التكيف الديناميكي؟
  bool get useDynamic => _useDynamic;

  /// مستوى التجاوز الحالي
  PerformanceLevel? get overrideLevel => _overrideLevel;

  void _handleLevelChange(PerformanceLevel level) {
    if (_useDynamic) {
      _config = _mapLevelToConfig(level);
      notifyListeners();
    }
  }

  /// تعيين التجاوز اليدوي
  Future<void> setOverride(PerformanceLevel? level) async {
    _overrideLevel = level;
    _useDynamic = (level == null);

    final settings = sl.settingsService;
    await settings.setUseDynamicAdaptation(_useDynamic);
    await settings.setPerformanceOverride(level?.name);

    _updateConfig();
    notifyListeners();
  }

  void _updateConfig() {
    if (_useDynamic) {
      _config = _mapLevelToConfig(_monitor.currentLevel);
    } else if (_overrideLevel != null) {
      _config = _mapLevelToConfig(_overrideLevel!);
    }
  }

  PerformanceLevel? _parseLevel(String? name) {
    if (name == null) return null;
    try {
      return PerformanceLevel.values.firstWhere((e) => e.name == name);
    } catch (_) {
      return null;
    }
  }

  AdaptiveConfig _mapLevelToConfig(PerformanceLevel level) {
    switch (level) {
      case PerformanceLevel.high:
        return AdaptiveConfig.high;
      case PerformanceLevel.medium:
        return AdaptiveConfig.medium;
      case PerformanceLevel.low:
        return AdaptiveConfig.low;
    }
  }
}
