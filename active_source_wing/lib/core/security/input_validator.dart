/// نظام التحقق من المدخلات
/// يوفر فحص وتنظيف شامل لجميع المدخلات لحماية التطبيق
library;

import '../infrastructure/wing_logger.dart';

/// مدقق المدخلات
/// يتولى فحص وتنظيف جميع المدخلات الواردة للتطبيق
class InputValidator {
  // أنماط التحقق المختلفة
  static final RegExp _emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _phonePattern = RegExp(
    r'^[\+]?[1-9][\d]{0,15}$',
  );

  static final RegExp _arabicTextPattern = RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF'
    r'\uFB50-\uFDFF\uFE70-\uFEFF\s\d.,!?()\-]+$',
  );

  static final RegExp _dangerousCharsPattern = RegExp(
    r'[<>";/\x00-\x1f\x7f-\x9f]',
  );

  /// التحقق من صحة البريد الإلكتروني
  ///
  /// [email] البريد الإلكتروني المراد فحصه
  ///
  /// Returns true إذا كان البريد الإلكتروني صحيحاً
  static bool isValidEmail(String email) {
    if (email.isEmpty || email.length > 254) {
      return false;
    }

    final isValid = _emailPattern.hasMatch(email.trim().toLowerCase());

    if (!isValid) {
      WingLogger.warning('بريد إلكتروني غير صحيح: $email',
          tag: 'InputValidator');
    }

    return isValid;
  }

  /// التحقق من صحة رقم الهاتف
  ///
  /// [phone] رقم الهاتف المراد فحصه
  ///
  /// Returns true إذا كان رقم الهاتف صحيحاً
  static bool isValidPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (cleanPhone.isEmpty || cleanPhone.length < 7 || cleanPhone.length > 15) {
      return false;
    }

    final isValid = _phonePattern.hasMatch(cleanPhone);

    if (!isValid) {
      WingLogger.warning('رقم هاتف غير صحيح: $phone', tag: 'InputValidator');
    }

    return isValid;
  }

  /// التحقق من صحة النص العربي
  ///
  /// [text] النص المراد فحصه
  /// [allowEmpty] السماح بالنص الفارغ (افتراضي: false)
  ///
  /// Returns true إذا كان النص صحيحاً
  static bool isValidArabicText(String text, {bool allowEmpty = false}) {
    if (text.isEmpty) {
      return allowEmpty;
    }

    if (text.length > 1000) {
      WingLogger.warning('نص طويل جداً: ${text.length} حرف',
          tag: 'InputValidator');
      return false;
    }

    final isValid = _arabicTextPattern.hasMatch(text);

    if (!isValid) {
      WingLogger.warning('نص يحتوي على أحرف غير مسموحة', tag: 'InputValidator');
    }

    return isValid;
  }

  /// تنظيف المدخلات من الأحرف الخطيرة
  ///
  /// [input] النص المراد تنظيفه
  /// [preserveNewlines] الحفاظ على أسطر جديدة (افتراضي: true)
  ///
  /// Returns النص المنظف
  static String sanitizeInput(String input, {bool preserveNewlines = true}) {
    if (input.isEmpty) {
      return input;
    }

    String sanitized = input;

    // إزالة الأحرف الخطيرة
    sanitized = sanitized.replaceAll(_dangerousCharsPattern, '');

    // إزالة المسافات الزائدة
    sanitized = sanitized.trim();

    // تنظيف الأسطر الجديدة إذا لم يكن مطلوباً الحفاظ عليها
    if (!preserveNewlines) {
      sanitized = sanitized.replaceAll(RegExp(r'\s+'), ' ');
    }

    // تحديد الطول الأقصى
    if (sanitized.length > 5000) {
      sanitized = sanitized.substring(0, 5000);
      WingLogger.warning('تم قطع النص لتجاوز الحد الأقصى',
          tag: 'InputValidator');
    }

    return sanitized;
  }

  /// التحقق من قوة كلمة المرور
  ///
  /// [password] كلمة المرور المراد فحصها
  ///
  /// Returns نتيجة التحقق مع التفاصيل
  static PasswordValidationResult validatePassword(String password) {
    final result = PasswordValidationResult();

    if (password.isEmpty) {
      result.isValid = false;
      result.errors.add('كلمة المرور مطلوبة');
      return result;
    }

    // فحص الطول
    if (password.length < 8) {
      result.errors.add('كلمة المرور يجب أن تكون 8 أحرف على الأقل');
    } else {
      result.strength++;
    }

    // فحص الأحرف الصغيرة
    if (password.contains(RegExp(r'[a-z]'))) {
      result.strength++;
    } else {
      result.errors.add('كلمة المرور يجب أن تحتوي على حرف صغير واحد على الأقل');
    }

    // فحص الأحرف الكبيرة
    if (password.contains(RegExp(r'[A-Z]'))) {
      result.strength++;
    } else {
      result.errors.add('كلمة المرور يجب أن تحتوي على حرف كبير واحد على الأقل');
    }

    // فحص الأرقام
    if (password.contains(RegExp(r'[0-9]'))) {
      result.strength++;
    } else {
      result.errors.add('كلمة المرور يجب أن تحتوي على رقم واحد على الأقل');
    }

    // فحص الرموز الخاصة
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>_]'))) {
      result.strength++;
    } else {
      result.errors.add('كلمة المرور يجب أن تحتوي على رمز خاص واحد على الأقل');
    }

    // تحديد صحة كلمة المرور
    result.isValid = result.errors.isEmpty;

    // تحديد مستوى القوة
    if (result.strength >= 4) {
      result.strengthLevel = PasswordStrength.strong;
    } else if (result.strength >= 3) {
      result.strengthLevel = PasswordStrength.medium;
    } else if (result.strength >= 2) {
      result.strengthLevel = PasswordStrength.weak;
    } else {
      result.strengthLevel = PasswordStrength.veryWeak;
    }

    return result;
  }

  /// التحقق من صحة URL
  ///
  /// [url] الرابط المراد فحصه
  ///
  /// Returns true إذا كان الرابط صحيحاً
  static bool isValidUrl(String url) {
    if (url.isEmpty) {
      return false;
    }

    try {
      final uri = Uri.parse(url);
      final isValid = uri.hasScheme &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.hasAuthority;

      if (!isValid) {
        WingLogger.warning('رابط غير صحيح: $url', tag: 'InputValidator');
      }

      return isValid;
    } catch (e) {
      WingLogger.warning('خطأ في تحليل الرابط: $url',
          error: e, tag: 'InputValidator');
      return false;
    }
  }

  /// فحص المدخلات للكشف عن محاولات الحقن
  ///
  /// [input] المدخل المراد فحصه
  ///
  /// Returns true إذا كان المدخل آمناً
  static bool checkForInjectionAttempts(String input) {
    final dangerousPatterns = [
      RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'on\w+\s*=', caseSensitive: false),
      RegExp(r'(union|select|insert|update|delete|drop|create|alter)\s+',
          caseSensitive: false),
      RegExp(r'(--|#|/\*|\*/)', caseSensitive: false),
    ];

    for (final pattern in dangerousPatterns) {
      if (pattern.hasMatch(input)) {
        WingLogger.error('محاولة حقن مكتشفة في المدخل', tag: 'Security');
        return false;
      }
    }

    return true;
  }
}

/// مستويات قوة كلمة المرور
enum PasswordStrength {
  /// ضعيف جداً
  veryWeak,

  /// ضعيف
  weak,

  /// متوسط
  medium,

  /// قوي
  strong,
}

/// نتيجة التحقق من كلمة المرور
class PasswordValidationResult {
  /// هل كلمة المرور صحيحة
  bool isValid = false;

  /// مستوى القوة (0-5)
  int strength = 0;

  /// مستوى قوة كلمة المرور
  PasswordStrength strengthLevel = PasswordStrength.veryWeak;

  /// قائمة الأخطاء
  List<String> errors = [];

  /// الحصول على وصف مستوى القوة
  String get strengthDescription {
    switch (strengthLevel) {
      case PasswordStrength.veryWeak:
        return 'ضعيف جداً';
      case PasswordStrength.weak:
        return 'ضعيف';
      case PasswordStrength.medium:
        return 'متوسط';
      case PasswordStrength.strong:
        return 'قوي';
    }
  }
}
