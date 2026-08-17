import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';

import '../infrastructure/wing_logger.dart';

/// Legacy storage service for private reflections.
///
/// This service uses a historical XOR-based format without an authenticated
/// integrity tag. New writes are disabled by default. New sensitive data must
/// use `SecurityService` instead; this class remains only for compatibility
/// with data that may already exist in [boxName].
class SafetyBoxService {
  /// Creates a legacy service.
  ///
  /// [allowLegacyWrites] is intentionally opt-in and should only be enabled
  /// by an explicit migration or compatibility test.
  SafetyBoxService({this.allowLegacyWrites = false});

  /// The Hive box name retained for historical data and reset compatibility.
  static const String boxName = 'safety_box_vault';

  /// Whether the historical XOR write path is explicitly enabled.
  final bool allowLegacyWrites;

  /// Internal reference to the box.
  late Box<Map<dynamic, dynamic>> _box;

  /// Initializes the service.
  Future<void> initialize() async {
    _box = await Hive.openBox<Map<dynamic, dynamic>>(boxName);
    WingLogger.info('SafetyBoxService initialized', tag: 'SecurityLayer');
  }

  /// Saves a legacy XOR-encrypted reflection.
  ///
  /// New writes are blocked by default because this format has no nonce,
  /// authenticated MAC, or versioned envelope. Enable [allowLegacyWrites]
  /// only for a controlled compatibility or migration scenario.
  @Deprecated('Legacy XOR storage. Use SecurityService for new data.')
  Future<void> saveReflection({
    required String id,
    required String content,
    required String key,
    Map<String, dynamic>? metadata,
  }) async {
    if (!allowLegacyWrites) {
      throw StateError(
        'Legacy SafetyBox writes are disabled. Use SecurityService.',
      );
    }

    final encryptedData = _doubleEncrypt(content, key);
    await _box.put(id, {
      'payload': encryptedData,
      'timestamp': DateTime.now().toIso8601String(),
      'metadata': metadata,
    });
  }

  /// Reads and decrypts a historical reflection for compatibility.
  ///
  /// The legacy format does not authenticate the payload, so a wrong key or
  /// tampering cannot always be distinguished from valid plaintext.
  @Deprecated('Legacy XOR storage. Use SecurityService for new data.')
  Future<String?> getReflection(String id, String key) async {
    final data = _box.get(id);
    if (data == null) return null;

    final payload = data['payload'] as String;
    return _doubleDecrypt(payload, key);
  }

  /// Lists all reflection IDs in the historical box.
  @Deprecated('Legacy storage inventory is migration-only.')
  List<String> getAllIds() => _box.keys.cast<String>().toList();

  /// Deletes a historical reflection.
  ///
  /// Deletion remains available so privacy reset and explicit cleanup can
  /// remove legacy records without enabling new writes.
  @Deprecated('Legacy storage deletion is compatibility-only.')
  Future<void> deleteReflection(String id) async {
    await _box.delete(id);
  }

  /// XOR encryption retained only to decode or migrate historical payloads.
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

  /// XOR decryption retained only for historical payload compatibility.
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
