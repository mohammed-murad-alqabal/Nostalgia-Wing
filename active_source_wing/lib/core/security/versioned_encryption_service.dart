import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'key_manager.dart';
import 'security_service.dart';

/// Coordinates versioned envelopes with the retained key ring.
///
/// Reads resolve the key named by the envelope. Writes use the active key.
/// Rotation does not rewrite user data implicitly; callers must explicitly
/// re-wrap records after validating each decrypted result.
class VersionedEncryptionService {
  /// Creates a versioned encryption service.
  const VersionedEncryptionService({
    required this.securityService,
    required this.keyManager,
  });

  /// Low-level AES-GCM envelope implementation.
  final SecurityService securityService;

  /// Active and retained key management.
  final KeyManager keyManager;

  /// Encrypts text using the currently active key.
  Future<String> encrypt(String plainText) async {
    final activeKey = await keyManager.getActiveKey();
    return securityService.encrypt(
      plainText,
      activeKey.secretKey,
      keyId: activeKey.id,
    );
  }

  /// Decrypts text using the key named by its envelope, or the legacy key.
  Future<String> decrypt(String cipherBase64) async {
    final key = await _keyForText(cipherBase64);
    return securityService.decrypt(cipherBase64, key);
  }

  /// Encrypts bytes using the currently active key.
  Future<Uint8List> encryptBytes(Uint8List bytes) async {
    final activeKey = await keyManager.getActiveKey();
    return securityService.encryptBytes(
      bytes,
      activeKey.secretKey,
      keyId: activeKey.id,
    );
  }

  /// Decrypts bytes using the key named by their envelope.
  Future<Uint8List> decryptBytes(Uint8List bytes) async {
    final keyId = securityService.keyIdFromBytes(bytes);
    final key = await keyManager.getKey(keyId ?? KeyManager.legacyKeyId);
    return securityService.decryptBytes(bytes, key);
  }

  /// Creates a new active key while retaining the previous key for reads.
  Future<KeyRotationResult> rotateMasterKey() => keyManager.rotateMasterKey();

  /// Re-wraps one text payload under the current active key.
  Future<String> rewrap(String cipherBase64) async {
    return encrypt(await decrypt(cipherBase64));
  }

  /// Re-wraps one binary payload under the current active key.
  Future<Uint8List> rewrapBytes(Uint8List bytes) async {
    return encryptBytes(await decryptBytes(bytes));
  }

  Future<SecretKey> _keyForText(String cipherBase64) async {
    final keyId = securityService.keyIdFromBase64(cipherBase64);
    return keyManager.getKey(keyId ?? KeyManager.legacyKeyId);
  }
}
