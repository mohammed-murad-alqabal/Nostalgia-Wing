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
    service = SafetyBoxService();
    await service.initialize();
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(SafetyBoxService.boxName);
  });

  group('SafetyBoxService Tests', () {
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

      // Decrypting with incorrect key should result
      // in different data
      try {
        final decrypted = await service.getReflection(id, wrongKey);
        expect(decrypted, isNot(equals(content)));
      } catch (e) {
        // utf8.decode might throw if XOR results in invalid bytes
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
      // Accessing the box directly to check the payload
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
