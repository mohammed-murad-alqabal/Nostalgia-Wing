import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/security/decryption_observer.dart';
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

  test('reports a missing retained key without logging key material', () async {
    final store = _MemoryKeyValueStore();
    final events = <DecryptionFailureEvent>[];
    final keyManager = KeyManager(store: store);
    final service = VersionedEncryptionService(
      securityService: SecurityService(),
      keyManager: keyManager,
      onDecryptionFailure: events.add,
    );

    final encrypted = await service.encrypt('مفتاح سيُفقد');
    await keyManager.clearMasterKey();

    await expectLater(
      service.decrypt(encrypted),
      throwsA(isA<StateError>()),
    );

    expect(events, hasLength(1));
    expect(events.single.kind, DecryptionFailureKind.missingKey);
    expect(events.single.keyId, KeyManager.legacyKeyId);
    expect(events.single.toSafeData().keys, isNot(contains('key')));
    expect(events.single.toSafeData().keys, isNot(contains('secret')));
  });

  test('reports malformed Base64 before key lookup', () async {
    final store = _MemoryKeyValueStore();
    final events = <DecryptionFailureEvent>[];
    final service = VersionedEncryptionService(
      securityService: SecurityService(),
      keyManager: KeyManager(store: store),
      onDecryptionFailure: events.add,
    );

    await expectLater(
      service.decrypt('%%%'),
      throwsA(isA<FormatException>()),
    );

    expect(events, hasLength(1));
    expect(events.single.kind, DecryptionFailureKind.invalidEncoding);
    expect(events.single.operation, 'text');
  });

  test('reports unsupported envelope versions through the facade', () async {
    final store = _MemoryKeyValueStore();
    final events = <DecryptionFailureEvent>[];
    final securityService = SecurityService();
    final service = VersionedEncryptionService(
      securityService: securityService,
      keyManager: KeyManager(store: store),
      onDecryptionFailure: events.add,
    );

    final encrypted = await service.encrypt('إصدار غير مدعوم');
    final bytes = base64.decode(encrypted);
    bytes[4] = SecurityService.currentEnvelopeVersion + 1;

    await expectLater(
      service.decryptBytes(Uint8List.fromList(bytes)),
      throwsA(isA<DecryptionFormatException>()),
    );

    expect(events, hasLength(1));
    expect(events.single.kind, DecryptionFailureKind.unsupportedVersion);
    expect(events.single.envelopeVersion,
        SecurityService.currentEnvelopeVersion + 1);
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
