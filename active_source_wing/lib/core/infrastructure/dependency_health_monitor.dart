/// نظام مراقبة صحة الاعتماديات - بروتوكول العزل والاستئصال الجراحي
/// يراقب ويدير صحة الاعتماديات لضمان الاستقرار التقني
library;

import 'dart:collection';
import 'wing_logger.dart';

/// نظام مراقبة صحة الاعتماديات
class DependencyHealthMonitor {
  /// عتبة الفشل قبل إدراج الحزمة في القائمة السوداء
  static const int _failureThreshold = 3;

  /// مدة المراقبة (24 ساعة)
  static const Duration _monitoringWindow = Duration(hours: 24);

  /// عداد الأخطاء لكل حزمة
  static final Map<String, int> _failureCount = {};

  /// الحزم المدرجة في القائمة السوداء
  static final Set<String> _blacklistedPackages = {};

  /// سجل الأخطاء مع الوقت
  static final Map<String, Queue<DateTime>> _errorHistory = {};

  /// الحزم المعتمدة رسمياً (القائمة البيضاء)
  static final Set<String> _approvedPackages = {
    'flutter',
    'cupertino_icons',
    'provider',
    'hive',
    'hive_flutter',
    'path_provider',
    'shared_preferences',
    'lottie',
    'carousel_slider',
    'smooth_page_indicator',
    'intl',
    'uuid',
    'collection',
  };

  /// فحص ما إذا كانت الحزمة صحية
  static bool isPackageHealthy(String packageName) {
    // التحقق من القائمة السوداء
    if (_blacklistedPackages.contains(packageName)) {
      WingLogger.warning(
        'Package is blacklisted',
        tag: 'DependencyHealth',
        data: {'package': packageName},
      );
      return false;
    }

    // التحقق من عدد الأخطاء
    final failureCount = _failureCount[packageName] ?? 0;
    if (failureCount >= _failureThreshold) {
      WingLogger.warning(
        'Package exceeded failure threshold',
        tag: 'DependencyHealth',
        data: {
          'package': packageName,
          'failures': failureCount,
          'threshold': _failureThreshold,
        },
      );
      return false;
    }

    return true;
  }

  /// الإبلاغ عن فشل في حزمة
  static void reportFailure(String packageName, String error,
      {StackTrace? stackTrace}) {
    WingLogger.error(
      'Package failure reported',
      tag: 'DependencyHealth',
      data: {
        'package': packageName,
        'error': error,
      },
      stackTrace: stackTrace,
    );

    // تحديث عداد الأخطاء
    _failureCount[packageName] = (_failureCount[packageName] ?? 0) + 1;

    // إضافة إلى سجل الأخطاء
    _errorHistory.putIfAbsent(packageName, () => Queue<DateTime>());
    _errorHistory[packageName]!.add(DateTime.now());

    // تنظيف السجل القديم
    _cleanupErrorHistory(packageName);

    // فحص ما إذا كان يجب إدراج الحزمة في القائمة السوداء
    if (_failureCount[packageName]! >= _failureThreshold) {
      _blacklistPackage(packageName, error);
    }
  }

  /// إدراج حزمة في القائمة السوداء
  static void _blacklistPackage(String packageName, String lastError) {
    _blacklistedPackages.add(packageName);

    WingLogger.critical(
      'Package blacklisted due to repeated failures',
      tag: 'DependencyHealth',
      data: {
        'package': packageName,
        'failure_count': _failureCount[packageName],
        'last_error': lastError,
      },
    );

    // تسجيل في سجل التهديدات المعروفة
    _logCriticalFailure(packageName, lastError);
  }

  /// تسجيل فشل حرج في سجل التهديدات
  static void _logCriticalFailure(String packageName, String error) {
    // Placeholder for persistent blacklisting
    WingLogger.critical(
      'CRITICAL THREAT: Package exceeded failure threshold',
      tag: 'ThreatRegistry',
      data: {
        'package': packageName,
        'error': error,
        'timestamp': DateTime.now().toIso8601String(),
        'action': 'BLACKLISTED',
      },
    );
  }

  /// تنظيف سجل الأخطاء القديمة
  static void _cleanupErrorHistory(String packageName) {
    final history = _errorHistory[packageName];
    if (history == null) return;

    final cutoff = DateTime.now().subtract(_monitoringWindow);

    // إزالة الأخطاء القديمة
    while (history.isNotEmpty && history.first.isBefore(cutoff)) {
      history.removeFirst();
    }

    // تحديث عداد الأخطاء بناءً على السجل المنظف
    _failureCount[packageName] = history.length;
  }

  /// التحقق من موافقة الحزمة رسمياً
  static bool isPackageApproved(String packageName) =>
      _approvedPackages.contains(packageName);

  /// إضافة حزمة إلى القائمة المعتمدة
  static void approvePackage(String packageName) {
    _approvedPackages.add(packageName);

    WingLogger.info(
      'Package approved for use',
      tag: 'DependencyHealth',
      data: {'package': packageName},
    );
  }

  /// إزالة حزمة من القائمة السوداء (إعادة تأهيل)
  static void rehabilitatePackage(String packageName) {
    _blacklistedPackages.remove(packageName);
    _failureCount.remove(packageName);
    _errorHistory.remove(packageName);

    WingLogger.info(
      'Package rehabilitated',
      tag: 'DependencyHealth',
      data: {'package': packageName},
    );
  }

  /// الحصول على تقرير صحة شامل
  static DependencyHealthReport getHealthReport() => DependencyHealthReport(
        totalPackages: _approvedPackages.length + _blacklistedPackages.length,
        healthyPackages: _approvedPackages.length - _blacklistedPackages.length,
        blacklistedPackages: List.from(_blacklistedPackages),
        packagesWithIssues: _failureCount.entries
            .where(
                (entry) => entry.value > 0 && entry.value < _failureThreshold)
            .map((entry) => PackageIssue(
                  packageName: entry.key,
                  failureCount: entry.value,
                  lastFailure: _errorHistory[entry.key]?.last,
                ))
            .toList(),
        generatedAt: DateTime.now(),
      );

  /// تنظيف شامل للبيانات
  static void cleanup() {
    final now = DateTime.now();
    // Using _monitoringWindow directly in _cleanupErrorHistory

    // تنظيف سجل الأخطاء لجميع الحزم
    for (final packageName in _errorHistory.keys.toList()) {
      _cleanupErrorHistory(packageName);

      // إزالة الحزم التي لم تعد لها أخطاء
      if (_errorHistory[packageName]!.isEmpty) {
        _errorHistory.remove(packageName);
        _failureCount.remove(packageName);
      }
    }

    WingLogger.info(
      'Dependency health cleanup completed',
      tag: 'DependencyHealth',
      data: {
        'cleanup_time': now.toIso8601String(),
        'active_packages': _errorHistory.length,
      },
    );
  }
}

/// تقرير صحة الاعتماديات
class DependencyHealthReport {
  /// إنشاء تقرير صحة جديد
  const DependencyHealthReport({
    required this.totalPackages,
    required this.healthyPackages,
    required this.blacklistedPackages,
    required this.packagesWithIssues,
    required this.generatedAt,
  });

  /// العدد الإجمالي للحزم
  final int totalPackages;

  /// عدد الحزم الصحية
  final int healthyPackages;

  /// الحزم المدرجة في القائمة السوداء
  final List<String> blacklistedPackages;

  /// الحزم التي تواجه مشاكل
  final List<PackageIssue> packagesWithIssues;

  /// وقت إنشاء التقرير
  final DateTime generatedAt;

  /// معدل الصحة (نسبة مئوية)
  double get healthRate {
    if (totalPackages == 0) return 100.0;
    return (healthyPackages / totalPackages) * 100.0;
  }

  /// هل النظام صحي؟
  bool get isSystemHealthy => healthRate >= 90.0 && blacklistedPackages.isEmpty;
}

/// مشكلة في حزمة
class PackageIssue {
  /// إنشاء مشكلة حزمة جديدة
  const PackageIssue({
    required this.packageName,
    required this.failureCount,
    this.lastFailure,
  });

  /// اسم الحزمة
  final String packageName;

  /// عدد مرات الفشل
  final int failureCount;

  /// آخر فشل
  final DateTime? lastFailure;
}
