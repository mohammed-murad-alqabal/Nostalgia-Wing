import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

import 'decryption_observer.dart';
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
    this.onDecryptionFailure,
  });

  /// Low-level AES-GCM envelope implementation.
  final SecurityService securityService;

  /// Active and retained key management.
  final KeyManager keyManager;

  /// Receives failures that occur before the low-level decrypt call.
  final DecryptionFailureObserver? onDecryptionFailure;

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
    String? keyId;
    late final SecretKey key;
    try {
      keyId = securityService.keyIdFromBytes(bytes);
      key = await keyManager.getKey(keyId ?? KeyManager.legacyKeyId);
    } catch (error) {
      _notifyKeyResolutionFailure(
        operation: 'bytes',
        keyId: keyId,
        envelopeVersion: securityService.versionHintFromBytes(bytes),
        payloadLength: bytes.length,
        error: error,
      );
      rethrow;
    }
    return securityService.decryptBytes(bytes, key);
  }

  /// Creates a new active key while retaining the previous key for reads.
  Future<KeyRotationResult> rotateMasterKey() => keyManager.rotateMasterKey();

  /// Re-wraps one text payload under the current active key.
  Future<String> rewrap(String cipherBase64) async =>
      encrypt(await decrypt(cipherBase64));

  /// Re-wraps one binary payload under the current active key.
  Future<Uint8List> rewrapBytes(Uint8List bytes) async =>
      encryptBytes(await decryptBytes(bytes));

  Future<SecretKey> _keyForText(String cipherBase64) async {
    String? keyId;
    try {
      keyId = securityService.keyIdFromBase64(cipherBase64);
      return await keyManager.getKey(keyId ?? KeyManager.legacyKeyId);
    } catch (error) {
      _notifyKeyResolutionFailure(
        operation: 'text',
        keyId: keyId,
        envelopeVersion: securityService.versionHintFromBase64(cipherBase64),
        payloadLength: cipherBase64.length,
        error: error,
      );
      rethrow;
    }
  }

  void _notifyKeyResolutionFailure({
    required String operation,
    required String? keyId,
    required int? envelopeVersion,
    required int payloadLength,
    required Object error,
  }) {
    final kind = error is StateError
        ? DecryptionFailureKind.missingKey
        : error is DecryptionFormatException
            ? error.kind
            : error is FormatException
                ? DecryptionFailureKind.invalidEncoding
                : DecryptionFailureKind.unknown;
    try {
      onDecryptionFailure?.call(
        DecryptionFailureEvent(
          kind: kind,
          operation: operation,
          keyId: safeDecryptionKeyId(keyId),
          envelopeVersion: envelopeVersion,
          payloadLength: payloadLength,
        ),
      );
    } catch (_) {
      // Observability must never change key resolution or decryption behavior.
    }
  }
}
