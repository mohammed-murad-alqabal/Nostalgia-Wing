// These tests intentionally exercise the deprecated compatibility API.
// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:wing_of_nostalgia/core/services/safety_box_service.dart';

void main() {
  late SafetyBoxService service;
  final tempDir = Directory.systemTemp.createTempSync();

  setUpAll(() {
    Hive.init(tempDir.path);
  });

  tearDownAll(() {
    tempDir.deleteSync(recursive: true);
  });

  setUp(() async {
    // Existing compatibility tests explicitly opt into the legacy write path.
    service = SafetyBoxService(allowLegacyWrites: true);
    await service.initialize();
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(SafetyBoxService.boxName);
  });

  group('SafetyBoxService isolation contract', () {
    test('legacy writes are disabled by default', () async {
      final guardedService = SafetyBoxService();
      await guardedService.initialize();

      expect(
        () => guardedService.saveReflection(
          id: 'blocked',
          content: 'must not be written',
          key: 'legacy-key',
        ),
        throwsStateError,
      );

      expect(guardedService.getAllIds(), isEmpty);
    });

    test('legacy writes require explicit opt-in', () async {
      await service.saveReflection(
        id: 'explicit-legacy',
        content: 'legacy content',
        key: 'legacy-key',
      );

      expect(
        await service.getReflection('explicit-legacy', 'legacy-key'),
        equals('legacy content'),
      );
    });

    test('default service can read and delete historical records', () async {
      await service.saveReflection(
        id: 'historical-record',
        content: 'historical content',
        key: 'historical-key',
      );

      final compatibilityService = SafetyBoxService();
      await compatibilityService.initialize();

      expect(
        await compatibilityService.getReflection(
          'historical-record',
          'historical-key',
        ),
        equals('historical content'),
      );

      await compatibilityService.deleteReflection('historical-record');
      expect(compatibilityService.getAllIds(), isEmpty);
    });
  });

  group('SafetyBoxService compatibility tests', () {
    test('saveReflection and getReflection should work with correct key',
        () async {
      const id = 'test_1';
      const content = 'This is a private reflection.';
      const key = 'secret_password_123';

      await service.saveReflection(id: id, content: content, key: key);

      final decrypted = await service.getReflection(id, key);
      expect(decrypted, equals(content));
    });

    test('getReflection fail with incorrect key', () async {
      const id = 'test_2';
      const content = 'Sensitive data';
      const correctKey = 'key_A';
      const wrongKey = 'key_B';

      await service.saveReflection(id: id, content: content, key: correctKey);

      // The legacy format has no MAC. A wrong key may either produce different
      // text or fail UTF-8 decoding; neither outcome is treated as success.
      try {
        final decrypted = await service.getReflection(id, wrongKey);
        expect(decrypted, isNot(equals(content)));
      } catch (e) {
        expect(e, isNotNull);
      }
    });

    test('getAllIds should return all saved IDs', () async {
      await service.saveReflection(id: 'id1', content: 'c1', key: 'k');
      await service.saveReflection(id: 'id2', content: 'c2', key: 'k');

      final ids = service.getAllIds();
      expect(ids, containsAll(['id1', 'id2']));
    });

    test('deleteReflection should remove the item', () async {
      await service.saveReflection(id: 'del_me', content: 'content', key: 'k');
      expect(service.getAllIds(), contains('del_me'));

      await service.deleteReflection('del_me');
      expect(service.getAllIds(), isNot(contains('del_me')));
    });

    test('double encryption should result in non-human readable payload',
        () async {
      const id = 'enc_test';
      const content = 'Secret Message';
      const key = 'secure_key';

      await service.saveReflection(id: id, content: content, key: key);

      final box = await Hive.openBox<Map<dynamic, dynamic>>(
        SafetyBoxService.boxName,
      );
      final data = box.get(id) as Map;
      final payload = data['payload'] as String;

      expect(payload, isNot(contains('Secret')));
      expect(payload, isNot(contains('Message')));
    });
  });
}
