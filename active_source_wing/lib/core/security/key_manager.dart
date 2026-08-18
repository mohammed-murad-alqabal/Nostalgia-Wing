import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Minimal storage contract used by [KeyManager].
///
/// The abstraction keeps key lifecycle tests independent from platform
/// channels while production uses [FlutterSecureKeyValueStore].
abstract interface class KeyValueStore {
  /// Reads a value by [key].
  Future<String?> read(String key);

  /// Writes [value] under [key].
  Future<void> write(String key, String value);

  /// Deletes [key] if present.
  Future<void> delete(String key);

  /// Reads all stored values.
  Future<Map<String, String>> readAll();
}

/// [KeyValueStore] adapter backed by Flutter Secure Storage.
class FlutterSecureKeyValueStore implements KeyValueStore {
  /// Creates a secure-storage adapter.
  FlutterSecureKeyValueStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<Map<String, String>> readAll() => _storage.readAll();
}

/// A key identifier and its material.
class EncryptionKey {
  /// Creates an encryption key descriptor.
  const EncryptionKey({required this.id, required this.secretKey});

  /// Stable identifier stored in the encrypted envelope.
  final String id;

  /// AES-256 key material.
  final SecretKey secretKey;
}

/// Result of a non-destructive master-key rotation.
class KeyRotationResult {
  /// Creates a rotation result.
  const KeyRotationResult(
      {required this.previousKeyId, required this.newKeyId});

  /// Key ID that remains available for legacy ciphertext.
  final String previousKeyId;

  /// Newly active key ID.
  final String newKeyId;
}

/// Manages versioned AES keys stored in platform secure storage.
///
/// Existing installations keep the historical master key under
/// `wing_of_nostalgia_msk`. Rotation writes a new versioned key and changes
/// only the active-key pointer. The previous key is retained so existing data
/// remains readable until an explicit re-wrap operation succeeds.
class KeyManager {
  /// Creates a manager with production storage unless [store] is supplied.
  KeyManager({KeyValueStore? store})
      : _store = store ?? FlutterSecureKeyValueStore();

  /// Identifier used for payloads created before key rotation.
  static const String legacyKeyId = 'legacy';

  static const String _mskKey = 'wing_of_nostalgia_msk';
  static const String _activeKeyIdKey = 'wing_of_nostalgia_active_key_id';
  static const String _versionedKeyPrefix = 'wing_of_nostalgia_key_';

  final KeyValueStore _store;

  /// Retrieves the currently active key, creating the legacy key on first use.
  Future<EncryptionKey> getActiveKey() async {
    final activeId = await _store.read(_activeKeyIdKey);
    if (activeId != null) {
      return EncryptionKey(
        id: activeId,
        secretKey: await _readKey(activeId),
      );
    }

    final legacyEncoded = await _store.read(_mskKey);
    if (legacyEncoded != null) {
      return EncryptionKey(
        id: legacyKeyId,
        secretKey: _decodeKey(legacyEncoded, legacyKeyId),
      );
    }

    final generated = await AesGcm.with256bits().newSecretKey();
    final keyBytes = await generated.extractBytes();
    await _store.write(_mskKey, base64.encode(keyBytes));
    return EncryptionKey(id: legacyKeyId, secretKey: SecretKey(keyBytes));
  }

  /// Backward-compatible access to the active secret key.
  Future<SecretKey> getMasterKey() async => (await getActiveKey()).secretKey;

  /// Retrieves a retained key by its envelope identifier.
  Future<SecretKey> getKey(String keyId) async {
    if (keyId == legacyKeyId) {
      final encoded = await _store.read(_mskKey);
      if (encoded == null) {
        throw StateError('Legacy encryption key is not available.');
      }
      return _decodeKey(encoded, keyId);
    }
    return _readKey(keyId);
  }

  /// Generates and activates a new key without deleting any previous key.
  Future<KeyRotationResult> rotateMasterKey() async {
    final previous = await getActiveKey();
    final newKeyId = 'v${DateTime.now().microsecondsSinceEpoch}';
    final newKey = await AesGcm.with256bits().newSecretKey();
    final keyBytes = await newKey.extractBytes();

    await _store.write(
      '$_versionedKeyPrefix$newKeyId',
      base64.encode(keyBytes),
    );
    await _store.write(_activeKeyIdKey, newKeyId);

    return KeyRotationResult(
      previousKeyId: previous.id,
      newKeyId: newKeyId,
    );
  }

  /// Removes all retained keys as part of an explicit privacy reset.
  Future<void> clearMasterKey() async {
    final allValues = await _store.readAll();
    for (final key in allValues.keys) {
      if (key.startsWith(_versionedKeyPrefix)) {
        await _store.delete(key);
      }
    }
    await _store.delete(_activeKeyIdKey);
    await _store.delete(_mskKey);
  }

  Future<SecretKey> _readKey(String keyId) async {
    if (keyId.isEmpty || keyId == legacyKeyId) {
      throw FormatException('Invalid encryption key ID: $keyId');
    }
    final encoded = await _store.read('$_versionedKeyPrefix$keyId');
    if (encoded == null) {
      throw StateError('Encryption key is not available: $keyId');
    }
    return _decodeKey(encoded, keyId);
  }

  SecretKey _decodeKey(String encoded, String keyId) {
    try {
      final bytes = base64.decode(encoded);
      if (bytes.length != 32) {
        throw FormatException('Encryption key $keyId must contain 32 bytes.');
      }
      return SecretKey(bytes);
    } on FormatException {
      rethrow;
    } catch (error) {
      throw FormatException('Invalid encryption key $keyId: $error');
    }
  }
}
