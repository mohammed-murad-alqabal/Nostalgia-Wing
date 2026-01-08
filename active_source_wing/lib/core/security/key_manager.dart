import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// [KeyManager] handles the generation and secure storage of the
/// Master Secret Key (MSK) used for data encryption.
class KeyManager {
  static const String _mskKey = 'wing_of_nostalgia_msk';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Retrieves the Master Secret Key from secure storage.
  /// If it doesn't exist, it generates a new one.
  Future<SecretKey> getMasterKey() async {
    final String? encodedKey = await _storage.read(key: _mskKey);

    if (encodedKey != null) {
      final List<int> keyBytes = base64.decode(encodedKey);
      return SecretKey(keyBytes);
    } else {
      // Generate a new 256-bit key
      final SecretKey newKey = await AesGcm.with256bits().newSecretKey();
      final List<int> keyBytes = await newKey.extractBytes();

      await _storage.write(
        key: _mskKey,
        value: base64.encode(keyBytes),
      );

      return newKey;
    }
  }

  /// Clears the master key.
  /// CAUTION: This will make all existing encrypted data unreadable.
  Future<void> clearMasterKey() async {
    await _storage.delete(key: _mskKey);
  }
}
