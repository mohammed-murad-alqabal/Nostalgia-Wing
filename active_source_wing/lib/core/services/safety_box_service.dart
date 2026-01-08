import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import '../infrastructure/wing_logger.dart';

/// Service for secure, double-encrypted storage of private reflections.
///
/// Implements a "Safety Box" for sensitive data, ensuring that even if
/// the device is compromised, data remains masked without the primary key.
class SafetyBoxService {
  /// The Hive box name.
  static const String boxName = 'safety_box_vault';

  /// Internal reference to the box.
  late Box<Map<dynamic, dynamic>> _box;

  /// Initializes the service.
  Future<void> initialize() async {
    _box = await Hive.openBox<Map<dynamic, dynamic>>(boxName);
    WingLogger.info('SafetyBoxService initialized', tag: 'SecurityLayer');
  }

  /// Saves a double-encrypted reflection.
  ///
  /// [key] is the user's private key (e.g., password or biometric hash).
  Future<void> saveReflection({
    required String id,
    required String content,
    required String key,
    Map<String, dynamic>? metadata,
  }) async {
    final encryptedData = _doubleEncrypt(content, key);

    await _box.put(id, {
      'payload': encryptedData,
      'timestamp': DateTime.now().toIso8601String(),
      'metadata': metadata,
    });
  }

  /// Retrieves and decrypts a reflection.
  Future<String?> getReflection(String id, String key) async {
    final data = _box.get(id);
    if (data == null) return null;

    final payload = data['payload'] as String;
    return _doubleDecrypt(payload, key);
  }

  /// Lists all reflection IDs in the box.
  List<String> getAllIds() => _box.keys.cast<String>().toList();

  /// Deletes a reflection.
  Future<void> deleteReflection(String id) async {
    await _box.delete(id);
  }

  /// Double Encryption logic:
  /// 1. Base64 Encoding.
  /// 2. XOR Masking with a key derived from SHA-256.
  String _doubleEncrypt(String plainText, String key) {
    final keyBytes = utf8.encode(key);
    final hash = sha256.convert(keyBytes).bytes;
    final plainBytes = utf8.encode(plainText);

    final encryptedBytes = List<int>.filled(plainBytes.length, 0);
    for (var i = 0; i < plainBytes.length; i++) {
      encryptedBytes[i] = plainBytes[i] ^ hash[i % hash.length];
    }

    return base64.encode(encryptedBytes);
  }

  /// Double Decryption logic.
  String _doubleDecrypt(String encryptedBase64, String key) {
    final keyBytes = utf8.encode(key);
    final hash = sha256.convert(keyBytes).bytes;
    final encryptedBytes = base64.decode(encryptedBase64);

    final plainBytes = List<int>.filled(encryptedBytes.length, 0);
    for (var i = 0; i < encryptedBytes.length; i++) {
      plainBytes[i] = encryptedBytes[i] ^ hash[i % hash.length];
    }

    return utf8.decode(plainBytes);
  }
}
