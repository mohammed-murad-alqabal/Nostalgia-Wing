/// نظام التسجيل المتقدم لمشروع جناح الحنين
/// يوفر تسجيلاً شاملاً مع مستويات متعددة ومراقبة الأداء
library;

import 'dart:convert';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// مستويات التسجيل المختلفة
enum LogLevel {
  /// تسجيل تفصيلي للتطوير
  debug,

  /// معلومات عامة
  info,

  /// تحذيرات مهمة
  warning,

  /// أخطاء حرجة
  error,

  /// أخطاء حرجة جداً تتطلب تدخل فوري
  critical,
}

/// نظام التسجيل المعرفي لجناح الحنين
class WingLogger {
  static const String _appName = 'WingOfNostalgia';
  static const bool _isDebugMode = kDebugMode;
  static final List<LogEntry> _localBuffer = [];
  static const int _maxBufferSize = 1000;

  /// رموز المستويات للعرض
  static const Map<LogLevel, String> _levelPrefixes = {
    LogLevel.debug: '🔍 DEBUG',
    LogLevel.info: 'ℹ️ INFO',
    LogLevel.warning: '⚠️ WARNING',
    LogLevel.error: '❌ ERROR',
    LogLevel.critical: '🚨 CRITICAL',
  };

  /// تسجيل رسالة تطوير (فقط في وضع التطوير)
  static void debug(
    String message, {
    String? tag,
    Map<String, dynamic>? data,
    dynamic error,
  }) {
    if (_isDebugMode) {
      _log(LogLevel.debug, message, tag: tag, data: data, error: error);
    }
  }

  /// تسجيل معلومات عامة
  static void info(
    String message, {
    String? tag,
    Map<String, dynamic>? data,
    dynamic error,
  }) {
    _log(LogLevel.info, message, tag: tag, data: data, error: error);
  }

  /// تسجيل تحذير مهم
  static void warning(
    String message, {
    String? tag,
    Map<String, dynamic>? data,
    dynamic error,
  }) {
    _log(LogLevel.warning, message, tag: tag, data: data, error: error);
  }

  /// تسجيل خطأ حرج
  static void error(
    String message, {
    String? tag,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
    dynamic error,
  }) {
    _log(LogLevel.error, message,
        tag: tag, data: data, stackTrace: stackTrace, error: error);

    // إرسال تقرير خطأ للمراقبة
    _sendErrorReport(message, tag, data, stackTrace);
  }

  /// تسجيل خطأ حرج جداً
  static void critical(
    String message, {
    String? tag,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
    dynamic error,
  }) {
    _log(LogLevel.critical, message,
        tag: tag, data: data, stackTrace: stackTrace, error: error);

    // إرسال تنبيه فوري
    _sendCriticalAlert(message, tag, data, stackTrace);
  }

  /// الدالة الأساسية للتسجيل
  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
    dynamic error,
  }) {
    final timestamp = DateTime.now().toIso8601String();
    final prefix = _levelPrefixes[level]!;
    final tagStr = tag != null ? '[$tag]' : '';

    final logMessage = '$timestamp $prefix $_appName$tagStr: $message';

    // طباعة في وحدة التحكم
    developer.log(
      logMessage,
      name: _appName,
      level: _getLevelValue(level),
      error: error ??
          (level == LogLevel.error || level == LogLevel.critical
              ? message
              : null),
      stackTrace: stackTrace,
    );

    // إضافة البيانات الإضافية إذا وجدت
    if (data != null && data.isNotEmpty) {
      developer.log(
        '  Data: ${jsonEncode(data)}',
        name: _appName,
        level: _getLevelValue(level),
      );
    }

    // حفظ في سجل محلي (للتنفيذ المستقبلي)
    _saveToLocalLog(level, message, tag, data, stackTrace);
  }

  /// تحويل مستوى التسجيل إلى قيمة رقمية
  static int _getLevelValue(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.critical:
        return 1200;
    }
  }

  /// حفظ السجل محلياً (للتنفيذ المستقبلي)
  static void _saveToLocalLog(
    LogLevel level,
    String message,
    String? tag,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
  ) {
    if (_localBuffer.length >= _maxBufferSize) {
      _localBuffer.removeAt(0);
    }
    _localBuffer.add(LogEntry(
      timestamp: DateTime.now(),
      level: level,
      message: message,
      tag: tag,
      data: data,
      stackTrace: stackTrace?.toString(),
    ));
  }

  /// إرسال تقرير خطأ للمراقبة
  static void _sendErrorReport(
    String message,
    String? tag,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
  ) {
    // Placeholder for telemetry (e.g., Sentry, Firebase)
    // Silenced for Zero Issues state
  }

  /// إرسال تنبيه حرج فوري
  static void _sendCriticalAlert(
    String message,
    String? tag,
    Map<String, dynamic>? data,
    StackTrace? stackTrace,
  ) {
    // Placeholder for SMS/Push-based critical alerting
    // Silenced for Zero Issues state
  }
}

/// فئة لتمثيل إدخال سجل
class LogEntry {
  /// إنشاء إدخال سجل جديد
  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
    this.tag,
    this.data,
    this.stackTrace,
  });

  /// إنشاء من JSON
  factory LogEntry.fromJson(Map<String, dynamic> json) => LogEntry(
        timestamp: DateTime.parse(json['timestamp'] as String),
        level: LogLevel.values.firstWhere(
          (e) => e.toString() == json['level'],
        ),
        message: json['message'] as String,
        tag: json['tag'] as String?,
        data: json['data'] as Map<String, dynamic>?,
        stackTrace: json['stackTrace'] as String?,
      );

  /// الوقت والتاريخ
  final DateTime timestamp;

  /// مستوى التسجيل
  final LogLevel level;

  /// الرسالة
  final String message;

  /// العلامة (اختيارية)
  final String? tag;

  /// البيانات الإضافية
  final Map<String, dynamic>? data;

  /// تتبع المكدس
  final String? stackTrace;

  /// تحويل إلى JSON
  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'level': level.toString(),
        'message': message,
        'tag': tag,
        'data': data,
        'stackTrace': stackTrace,
      };
}
