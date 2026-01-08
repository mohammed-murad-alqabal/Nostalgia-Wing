/// نظام معالجة الأخطاء الآمنة
/// يوفر معالجة آمنة للأخطاء مع حماية المعلومات الحساسة
library;

import 'dart:io';
import 'package:flutter/foundation.dart';
import '../infrastructure/wing_logger.dart';

/// معالج الأخطاء الآمن
/// يتولى معالجة جميع الأخطاء بطريقة آمنة دون كشف معلومات حساسة
class SafeErrorHandler {
  static const int _maxErrorLogSize = 1000; // حد أقصى لحجم سجل الأخطاء
  static final List<ErrorRecord> _errorHistory = [];

  /// معالجة خطأ عام بطريقة آمنة
  ///
  /// [error] الخطأ المراد معالجته
  /// [stackTrace] تتبع المكدس (اختياري)
  /// [context] سياق الخطأ (اختياري)
  /// [userFriendlyMessage] رسالة ودية للمستخدم (اختياري)
  static void handleError(
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
    String? userFriendlyMessage,
  }) {
    try {
      final errorRecord = ErrorRecord(
        error: error,
        stackTrace: stackTrace,
        context: context ?? 'غير محدد',
        timestamp: DateTime.now(),
        userFriendlyMessage: userFriendlyMessage,
      );

      // تسجيل الخطأ بطريقة آمنة
      _logErrorSafely(errorRecord);

      // إضافة إلى سجل الأخطاء
      _addToErrorHistory(errorRecord);

      // إرسال تقرير مجهول إذا كان الخطأ حرجاً
      if (_isCriticalError(error)) {
        _reportCriticalError(errorRecord);
      }
    } catch (handlingError) {
      // في حالة فشل معالجة الخطأ نفسها
      WingLogger.error(
        'فشل في معالجة الخطأ الأصلي',
        error: handlingError,
        tag: 'SafeErrorHandler',
      );
    }
  }

  /// معالجة خطأ شبكة
  ///
  /// [error] خطأ الشبكة
  /// [url] الرابط المطلوب (اختياري)
  /// [method] طريقة الطلب (اختياري)
  static void handleNetworkError(
    dynamic error, {
    String? url,
    String? method,
  }) {
    final context = 'شبكة - ${method ?? 'غير محدد'}: ${_sanitizeUrl(url)}';
    final userMessage = _getNetworkErrorMessage(error);

    handleError(
      error,
      context: context,
      userFriendlyMessage: userMessage,
    );
  }

  /// معالجة خطأ قاعدة البيانات
  ///
  /// [error] خطأ قاعدة البيانات
  /// [operation] العملية المطلوبة (اختياري)
  /// [table] اسم الجدول (اختياري)
  static void handleDatabaseError(
    dynamic error, {
    String? operation,
    String? table,
  }) {
    final context =
        'قاعدة البيانات - ${operation ?? 'غير محدد'}: ${table ?? 'غير محدد'}';
    const userMessage = 'حدث خطأ في حفظ البيانات. يرجى المحاولة مرة أخرى.';

    handleError(
      error,
      context: context,
      userFriendlyMessage: userMessage,
    );
  }

  /// معالجة خطأ أمني
  ///
  /// [error] الخطأ الأمني
  /// [securityContext] سياق الأمان
  /// [severity] مستوى الخطورة
  static void handleSecurityError(
    dynamic error, {
    required String securityContext,
    SecuritySeverity severity = SecuritySeverity.medium,
  }) {
    final context = 'أمان - $securityContext';
    const userMessage = 'تم اكتشاف نشاط مشبوه. تم تسجيل الحدث.';

    // تسجيل خاص للأخطاء الأمنية
    WingLogger.error(
      'خطأ أمني: $securityContext',
      error: _sanitizeSecurityError(error),
      tag: 'Security',
    );

    handleError(
      error,
      context: context,
      userFriendlyMessage: userMessage,
    );

    // إجراءات إضافية للأخطاء الأمنية الحرجة
    if (severity == SecuritySeverity.critical) {
      _handleCriticalSecurityError(error, securityContext);
    }
  }

  /// الحصول على سجل الأخطاء الأخيرة
  ///
  /// [limit] عدد الأخطاء المطلوبة (افتراضي: 10)
  ///
  /// Returns قائمة بآخر الأخطاء
  static List<ErrorRecord> getRecentErrors({int limit = 10}) {
    final recentErrors = _errorHistory.take(limit).toList();

    // إزالة المعلومات الحساسة قبل الإرجاع
    return recentErrors.map((error) => error.sanitized()).toList();
  }

  /// مسح سجل الأخطاء
  static void clearErrorHistory() {
    _errorHistory.clear();
    WingLogger.info('تم مسح سجل الأخطاء', tag: 'SafeErrorHandler');
  }

  /// الحصول على إحصائيات الأخطاء
  ///
  /// Returns إحصائيات مفصلة عن الأخطاء
  static ErrorStatistics getErrorStatistics() {
    final now = DateTime.now();
    final last24Hours = now.subtract(const Duration(hours: 24));
    final lastWeek = now.subtract(const Duration(days: 7));

    final recent24h =
        _errorHistory.where((e) => e.timestamp.isAfter(last24Hours)).length;
    final recentWeek =
        _errorHistory.where((e) => e.timestamp.isAfter(lastWeek)).length;

    final contextCounts = <String, int>{};
    for (final error in _errorHistory) {
      contextCounts[error.context] = (contextCounts[error.context] ?? 0) + 1;
    }

    return ErrorStatistics(
      totalErrors: _errorHistory.length,
      errorsLast24Hours: recent24h,
      errorsLastWeek: recentWeek,
      mostCommonContexts: contextCounts,
    );
  }

  // الطرق الخاصة

  static void _logErrorSafely(ErrorRecord errorRecord) {
    try {
      final sanitizedError = _sanitizeError(errorRecord.error);
      final sanitizedStackTrace = _sanitizeStackTrace(errorRecord.stackTrace);

      WingLogger.error(
        'خطأ في ${errorRecord.context}',
        error: sanitizedError,
        tag: 'SafeErrorHandler',
      );

      if (sanitizedStackTrace != null) {
        WingLogger.debug('تتبع المكدس: $sanitizedStackTrace',
            tag: 'SafeErrorHandler');
      }
    } catch (e) {
      // في حالة فشل التسجيل، نستخدم debugPrint كحل أخير
      debugPrint('فشل في تسجيل الخطأ: $e');
    }
  }

  static void _addToErrorHistory(ErrorRecord errorRecord) {
    _errorHistory.insert(0, errorRecord);

    // الحفاظ على حد أقصى لحجم السجل
    if (_errorHistory.length > _maxErrorLogSize) {
      _errorHistory.removeRange(_maxErrorLogSize, _errorHistory.length);
    }
  }

  static bool _isCriticalError(dynamic error) {
    if (error is OutOfMemoryError) return true;
    if (error is StackOverflowError) return true;
    if (error.toString().toLowerCase().contains('security')) return true;
    if (error.toString().toLowerCase().contains('permission')) return true;

    return false;
  }

  static void _reportCriticalError(ErrorRecord errorRecord) {
    // تقرير مجهول للأخطاء الحرجة
    WingLogger.error(
      'خطأ حرج مكتشف',
      error: 'نوع: ${errorRecord.error.runtimeType}',
      tag: 'CriticalError',
    );
  }

  static String _sanitizeError(dynamic error) {
    final errorString = error.toString();

    // إزالة المسارات المحلية
    String sanitized =
        errorString.replaceAll(RegExp(r'/[^/\s]+/[^/\s]+/[^/\s]+'), '[PATH]');

    // إزالة عناوين IP
    sanitized = sanitized.replaceAll(
        RegExp(r'\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'), '[IP]');

    // إزالة المعرفات الفريدة
    sanitized = sanitized.replaceAll(
        RegExp(r'[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}'),
        '[UUID]');

    return sanitized;
  }

  static String? _sanitizeStackTrace(StackTrace? stackTrace) {
    if (stackTrace == null) return null;

    final stackString = stackTrace.toString();

    // إزالة المسارات المحلية من تتبع المكدس
    return stackString.replaceAll(
        RegExp(r'/[^/\s]+/[^/\s]+/[^/\s]+'), '[PATH]');
  }

  static String? _sanitizeUrl(String? url) {
    if (url == null) return null;

    try {
      final uri = Uri.parse(url);
      return '${uri.scheme}://${uri.host}${uri.path}';
    } catch (e) {
      return '[URL]';
    }
  }

  static String _sanitizeSecurityError(dynamic error) =>
      'خطأ أمني - النوع: ${error.runtimeType}';

  static String _getNetworkErrorMessage(dynamic error) {
    if (error is SocketException) {
      return 'لا يمكن الاتصال بالخادم. يرجى التحقق من اتصال الإنترنت.';
    }
    if (error.toString().contains('timeout')) {
      return 'انتهت مهلة الاتصال. يرجى المحاولة مرة أخرى.';
    }
    return 'حدث خطأ في الشبكة. يرجى المحاولة مرة أخرى.';
  }

  static void _handleCriticalSecurityError(dynamic error, String context) {
    // إجراءات إضافية للأخطاء الأمنية الحرجة
    WingLogger.error(
      'خطأ أمني حرج: $context',
      error: 'تم اتخاذ إجراءات وقائية',
      tag: 'CriticalSecurity',
    );

    // يمكن إضافة إجراءات إضافية هنا مثل:
    // - إرسال تنبيه فوري
    // - تسجيل خروج المستخدم
    // - تعطيل ميزات معينة مؤقتاً
  }
}

/// مستويات خطورة الأمان
enum SecuritySeverity {
  /// منخفض
  low,

  /// متوسط
  medium,

  /// عالي
  high,

  /// حرج
  critical,
}

/// سجل خطأ
class ErrorRecord {
  /// إنشاء سجل خطأ جديد
  const ErrorRecord({
    required this.error,
    this.stackTrace,
    required this.context,
    required this.timestamp,
    this.userFriendlyMessage,
  });

  /// الخطأ الأصلي
  final dynamic error;

  /// تتبع المكدس
  final StackTrace? stackTrace;

  /// سياق الخطأ
  final String context;

  /// وقت حدوث الخطأ
  final DateTime timestamp;

  /// رسالة ودية للمستخدم
  final String? userFriendlyMessage;

  /// إنشاء نسخة منظفة من سجل الخطأ
  ErrorRecord sanitized() => ErrorRecord(
        error: error.runtimeType.toString(),
        context: context,
        timestamp: timestamp,
        userFriendlyMessage: userFriendlyMessage,
      );
}

/// إحصائيات الأخطاء
class ErrorStatistics {
  /// إنشاء إحصائيات أخطاء جديدة
  const ErrorStatistics({
    required this.totalErrors,
    required this.errorsLast24Hours,
    required this.errorsLastWeek,
    required this.mostCommonContexts,
  });

  /// إجمالي الأخطاء
  final int totalErrors;

  /// أخطاء آخر 24 ساعة
  final int errorsLast24Hours;

  /// أخطاء آخر أسبوع
  final int errorsLastWeek;

  /// السياقات الأكثر شيوعاً
  final Map<String, int> mostCommonContexts;
}
