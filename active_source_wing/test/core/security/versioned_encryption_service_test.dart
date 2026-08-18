import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/security/key_manager.dart';
import 'package:wing_of_nostalgia/core/security/security_service.dart';
import 'package:wing_of_nostalgia/core/security/versioned_encryption_service.dart';

void main() {
  test('rotation retains old reads and activates a new key for writes',
      () async {
    final store = _MemoryKeyValueStore();
    final keyManager = KeyManager(store: store);
    final service = VersionedEncryptionService(
      securityService: SecurityService(),
      keyManager: keyManager,
    );

    final beforeRotation = await service.encrypt('قبل الدوران');
    final rotation = await service.rotateMasterKey();
    final afterRotation = await service.encrypt('بعد الدوران');

    expect(rotation.previousKeyId, KeyManager.legacyKeyId);
    expect(rotation.newKeyId, isNot(KeyManager.legacyKeyId));
    expect(
      service.securityService.keyIdFromBase64(beforeRotation),
      KeyManager.legacyKeyId,
    );
    expect(
      service.securityService.keyIdFromBase64(afterRotation),
      rotation.newKeyId,
    );
    expect(await service.decrypt(beforeRotation), 'قبل الدوران');
    expect(await service.decrypt(afterRotation), 'بعد الدوران');
  });

  test('rewrap moves a readable legacy payload to the active key', () async {
    final store = _MemoryKeyValueStore();
    final keyManager = KeyManager(store: store);
    final service = VersionedEncryptionService(
      securityService: SecurityService(),
      keyManager: keyManager,
    );

    final original = await service.encrypt('إعادة تغليف آمنة');
    final rotation = await service.rotateMasterKey();
    final rewrapped = await service.rewrap(original);

    expect(
      service.securityService.keyIdFromBase64(rewrapped),
      rotation.newKeyId,
    );
    expect(await service.decrypt(rewrapped), 'إعادة تغليف آمنة');
    expect(await service.decrypt(original), 'إعادة تغليف آمنة');
  });

  test('clearMasterKey removes the active and retained key material', () async {
    final store = _MemoryKeyValueStore();
    final keyManager = KeyManager(store: store);
    final service = VersionedEncryptionService(
      securityService: SecurityService(),
      keyManager: keyManager,
    );

    await service.encrypt('بيانات مؤقتة');
    await service.rotateMasterKey();
    await keyManager.clearMasterKey();

    expect(store.values, isEmpty);
    final regenerated = await keyManager.getActiveKey();
    expect(regenerated.id, KeyManager.legacyKeyId);
    expect(store.values, isNotEmpty);
  });
}

class _MemoryKeyValueStore implements KeyValueStore {
  final Map<String, String> values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }

  @override
  Future<Map<String, String>> readAll() async =>
      Map<String, String>.from(values);
}
