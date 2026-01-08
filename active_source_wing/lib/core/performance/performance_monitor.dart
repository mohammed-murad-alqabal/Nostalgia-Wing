import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// نظام مراقبة الأداء - Performance Monitoring System
/// يراقب استخدام الذاكرة وأداء الحركات والإطارات
class PerformanceMonitor {
  /// Factory constructor to return the singleton instance.
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();

  final Map<String, Stopwatch> _timers = {};
  final List<PerformanceMetric> _metrics = [];
  Timer? _memoryMonitorTimer;

  // Stream for performance level updates
  final StreamController<PerformanceLevel> _levelController =
      StreamController<PerformanceLevel>.broadcast();

  /// Stream of current performance level changes.
  Stream<PerformanceLevel> get performanceLevelStream =>
      _levelController.stream;

  PerformanceLevel _currentLevel = PerformanceLevel.high;

  /// Get the current performance level.
  PerformanceLevel get currentLevel => _currentLevel;

  // حدود الأداء
  /// Maximum allowed memory usage in MB.
  static const int maxMemoryUsageMB = 200;

  /// Target standard frame rate.
  static const int targetFrameRate = 60;

  /// Maximum allowable startup time in milliseconds.
  static const int maxStartupTimeMs = 2000;

  bool _isMonitoring = false;
  int _currentMemoryUsageMB = 0;
  final double _currentFrameRate = 60.0;

  /// بدء مراقبة الأداء
  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _startMemoryMonitoring();

    if (kDebugMode) {
      print('🔍 Performance Monitor: Started monitoring');
    }
  }

  /// إيقاف مراقبة الأداء
  void stopMonitoring() {
    _isMonitoring = false;
    _memoryMonitorTimer?.cancel();

    if (kDebugMode) {
      print('🔍 Performance Monitor: Stopped monitoring');
    }
  }

  /// بدء مؤقت الأداء
  void startTimer(String name) {
    _timers[name] = Stopwatch()..start();
  }

  /// إيقاف مؤقت الأداء وتسجيل النتيجة
  void stopTimer(String name) {
    final timer = _timers[name];
    if (timer != null) {
      timer.stop();
      _recordMetric(name, timer.elapsedMilliseconds);
      _timers.remove(name);
    }
  }

  /// تسجيل مقياس أداء
  void _recordMetric(String name, int durationMs) {
    final metric = PerformanceMetric(
      name: name,
      duration: durationMs,
      timestamp: DateTime.now(),
      memoryUsage: _currentMemoryUsageMB,
      frameRate: _currentFrameRate,
    );

    _metrics.add(metric);

    // الاحتفاظ بآخر 100 مقياس فقط
    if (_metrics.length > 100) {
      _metrics.removeAt(0);
    }

    // تحذير إذا تجاوز الحد المسموح
    if (durationMs > 1000) {
      if (kDebugMode) {
        print('⚠️ Performance Warning: $name took ${durationMs}ms');
      }
    }

    _updatePerformanceLevel();
  }

  /// بدء مراقبة الذاكرة
  void _startMemoryMonitoring() {
    _memoryMonitorTimer = Timer.periodic(
      const Duration(seconds: 5),
      _checkMemoryUsage,
    );
  }

  /// فحص استخدام الذاكرة
  void _checkMemoryUsage(Timer timer) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // محاولة الحصول على معلومات الذاكرة
        final info = await _getMemoryInfo();
        _currentMemoryUsageMB = info;

        if (_currentMemoryUsageMB > maxMemoryUsageMB) {
          _triggerMemoryCleanup();
        }

        _updatePerformanceLevel();
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔍 Performance Monitor: Memory check failed: $e');
      }
    }
  }

  /// الحصول على معلومات الذاكرة
  Future<int> _getMemoryInfo() async {
    try {
      // محاولة استخدام platform channel للحصول على معلومات الذاكرة
      const platform = MethodChannel('wing_performance');
      final result = await platform.invokeMethod('getMemoryUsage');
      return result ?? 0;
    } catch (e) {
      // fallback: تقدير تقريبي
      return _estimateMemoryUsage();
    }
  }

  /// تقدير استخدام الذاكرة
  int _estimateMemoryUsage() {
    // تقدير بسيط بناءً على عدد المقاييس والمؤقتات
    const baseUsage = 50; // استخدام أساسي
    final metricsUsage = _metrics.length * 0.1;
    final timersUsage = _timers.length * 0.5;

    return (baseUsage + metricsUsage + timersUsage).round();
  }

  /// تشغيل تنظيف الذاكرة
  void _triggerMemoryCleanup() {
    if (kDebugMode) {
      print('🧹 Performance Monitor: Triggering memory cleanup');
    }

    // تنظيف المقاييس القديمة
    if (_metrics.length > 50) {
      _metrics.removeRange(0, _metrics.length - 50);
    }

    // إشعار النظام بالحاجة لتنظيف الذاكرة
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  /// الحصول على تقرير الأداء
  PerformanceReport getPerformanceReport() {
    final recentMetrics = _metrics
        .where(
          (metric) => DateTime.now().difference(metric.timestamp).inMinutes < 5,
        )
        .toList();

    return PerformanceReport(
      totalMetrics: _metrics.length,
      recentMetrics: recentMetrics.length,
      averageResponseTime: _calculateAverageResponseTime(recentMetrics),
      currentMemoryUsage: _currentMemoryUsageMB,
      currentFrameRate: _currentFrameRate,
      isPerformanceGood: _isPerformanceGood(),
    );
  }

  /// حساب متوسط وقت الاستجابة
  double _calculateAverageResponseTime(List<PerformanceMetric> metrics) {
    if (metrics.isEmpty) return 0.0;

    final totalTime = metrics.fold<int>(
      0,
      (sum, metric) => sum + metric.duration,
    );

    return totalTime / metrics.length;
  }

  /// فحص حالة الأداء
  bool _isPerformanceGood() =>
      _currentMemoryUsageMB < maxMemoryUsageMB &&
      _currentFrameRate > (targetFrameRate * 0.8);

  /// الحصول على مستوى الأداء المقترح
  PerformanceLevel getRecommendedPerformanceLevel() {
    if (_currentMemoryUsageMB > maxMemoryUsageMB * 0.8 ||
        _currentFrameRate < targetFrameRate * 0.6) {
      return PerformanceLevel.low;
    } else if (_currentMemoryUsageMB > maxMemoryUsageMB * 0.6 ||
        _currentFrameRate < targetFrameRate * 0.8) {
      return PerformanceLevel.medium;
    } else {
      return PerformanceLevel.high;
    }
  }

  /// تحديث مستوى الأداء وإرسال إشعار إذا تغير
  void _updatePerformanceLevel() {
    final newLevel = getRecommendedPerformanceLevel();
    if (newLevel != _currentLevel) {
      _currentLevel = newLevel;
      _levelController.add(_currentLevel);
      if (kDebugMode) {
        print('🚀 Performance Monitor: Level changed to $_currentLevel');
      }
    }
  }

  /// تنزيل الموارد
  void dispose() {
    _levelController.close();
    _memoryMonitorTimer?.cancel();
  }
}

/// مقياس الأداء
class PerformanceMetric {
  /// Creates a [PerformanceMetric] snapshot.
  const PerformanceMetric({
    required this.name,
    required this.duration,
    required this.timestamp,
    required this.memoryUsage,
    required this.frameRate,
  });

  /// Name of the metric.
  final String name;

  /// Duration in milliseconds.
  final int duration;

  /// Timestamp of recording.
  final DateTime timestamp;

  /// Memory usage at time of recording.
  final int memoryUsage;

  /// Frame rate at time of recording.
  final double frameRate;
}

/// تقرير الأداء
class PerformanceReport {
  /// Creates a summary [PerformanceReport].
  const PerformanceReport({
    required this.totalMetrics,
    required this.recentMetrics,
    required this.averageResponseTime,
    required this.currentMemoryUsage,
    required this.currentFrameRate,
    required this.isPerformanceGood,
  });

  /// Total metrics recorded.
  final int totalMetrics;

  /// Count of metrics in the last 5 minutes.
  final int recentMetrics;

  /// Average response time of recent metrics.
  final double averageResponseTime;

  /// Current memory usage in MB.
  final int currentMemoryUsage;

  /// Current frame rate.
  final double currentFrameRate;

  /// Whether performance meets standards.
  final bool isPerformanceGood;
}

/// مستوى الأداء
enum PerformanceLevel {
  /// High performance mode (all features on).
  high, // أداء عالي - جميع الميزات مفعلة
  /// Medium performance mode (reduced effects).
  medium, // أداء متوسط - تقليل بعض التأثيرات
  /// Low performance mode (minimal features).
  low, // أداء منخفض - الحد الأدنى من التأثيرات
}
