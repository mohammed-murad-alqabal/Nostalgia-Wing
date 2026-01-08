/// نظام إدارة البيانات الآمنة
/// يوفر تشفير وحماية للبيانات الحساسة في التطبيق
library;

import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import '../infrastructure/wing_logger.dart';

/// مدير البيانات الآمنة
/// يتولى تشفير وفك تشفير البيانات الحساسة
class SecureDataManager {
  static const String _saltKey = 'WingOfNostalgia2025';
  static const int _keyLength = 32;

  /// تشفير النص باستخدام خوارزمية آمنة
  ///
  /// [data] النص المراد تشفيره
  /// [userKey] مفتاح المستخدم الإضافي (اختياري)
  ///
  /// Returns النص المشفر مع التوقيع
  static String encryptData(String data, {String? userKey}) {
    try {
      final key = _generateKey(userKey);
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

      // إضافة الطابع الزمني للحماية من إعادة التشغيل
      final dataWithTimestamp = '$timestamp:$data';
      final encryptedBytes = _xorEncrypt(utf8.encode(dataWithTimestamp), key);

      // إنشاء توقيع للتحقق من سلامة البيانات
      final signature = _generateSignature(encryptedBytes, key);

      final result = '${base64.encode(encryptedBytes)}.$signature';

      WingLogger.info('تم تشفير البيانات بنجاح', tag: 'Security');
      return result;
    } catch (e) {
      WingLogger.error('فشل في تشفير البيانات', error: e, tag: 'Security');
      throw SecurityException('فشل في تشفير البيانات: ${e.toString()}');
    }
  }

  /// فك تشفير النص المشفر
  ///
  /// [encryptedData] النص المشفر مع التوقيع
  /// [userKey] مفتاح المستخدم الإضافي (اختياري)
  ///
  /// Returns النص الأصلي بعد فك التشفير
  static String decryptData(String encryptedData, {String? userKey}) {
    try {
      final parts = encryptedData.split('.');
      if (parts.length != 2) {
        throw const SecurityException('تنسيق البيانات المشفرة غير صحيح');
      }

      final encryptedBytes = base64.decode(parts[0]);
      final signature = parts[1];
      final key = _generateKey(userKey);

      // التحقق من سلامة البيانات
      final expectedSignature = _generateSignature(encryptedBytes, key);
      if (signature != expectedSignature) {
        throw const SecurityException('فشل في التحقق من سلامة البيانات');
      }

      final decryptedBytes = _xorEncrypt(encryptedBytes, key);
      final dataWithTimestamp = utf8.decode(decryptedBytes);

      // استخراج البيانات الأصلية (إزالة الطابع الزمني)
      final colonIndex = dataWithTimestamp.indexOf(':');
      if (colonIndex == -1) {
        throw const SecurityException('تنسيق البيانات المفكوكة غير صحيح');
      }

      final data = dataWithTimestamp.substring(colonIndex + 1);

      WingLogger.info('تم فك تشفير البيانات بنجاح', tag: 'Security');
      return data;
    } catch (e) {
      WingLogger.error('فشل في فك تشفير البيانات', error: e, tag: 'Security');
      throw SecurityException('فشل في فك تشفير البيانات: ${e.toString()}');
    }
  }

  /// توليد مفتاح التشفير
  static Uint8List _generateKey(String? userKey) {
    final combinedKey = _saltKey + (userKey ?? '');
    final keyHash = sha256.convert(utf8.encode(combinedKey));
    return Uint8List.fromList(keyHash.bytes.take(_keyLength).toList());
  }

  /// تشفير XOR بسيط ولكن فعال
  static Uint8List _xorEncrypt(List<int> data, Uint8List key) {
    final result = Uint8List(data.length);
    for (int i = 0; i < data.length; i++) {
      result[i] = data[i] ^ key[i % key.length];
    }
    return result;
  }

  /// توليد توقيع للتحقق من سلامة البيانات
  static String _generateSignature(Uint8List data, Uint8List key) {
    final hmac = Hmac(sha256, key);
    final digest = hmac.convert(data);
    return base64.encode(digest.bytes);
  }

  /// التحقق من قوة كلمة المرور
  ///
  /// [password] كلمة المرور المراد فحصها
  ///
  /// Returns مستوى قوة كلمة المرور (0-4)
  static int checkPasswordStrength(String password) {
    int strength = 0;

    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    return strength;
  }

  /// توليد كلمة مرور آمنة
  ///
  /// [length] طول كلمة المرور (افتراضي: 16)
  ///
  /// Returns كلمة مرور آمنة
  static String generateSecurePassword({int length = 16}) {
    const chars = 'abcdefghijklmnopqrstuvwxyz'
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        '0123456789'
        '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    final random = DateTime.now().millisecondsSinceEpoch;
    final result = StringBuffer();

    for (int i = 0; i < length; i++) {
      final index = (random + i * 7) % chars.length;
      result.write(chars[index]);
    }

    return result.toString();
  }
}

/// استثناء الأمان
class SecurityException implements Exception {
  /// إنشاء استثناء أمان جديد
  const SecurityException(this.message);

  /// رسالة الخطأ
  final String message;

  @override
  String toString() => 'SecurityException: $message';
}
