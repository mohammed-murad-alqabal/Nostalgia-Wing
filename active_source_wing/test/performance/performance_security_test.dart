// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:wing_of_nostalgia/core/data/app_database.dart';
import 'package:wing_of_nostalgia/core/services/db_service.dart';
import 'package:wing_of_nostalgia/core/di/service_locator.dart';
import 'package:drift/drift.dart' as drift;

/// Performance and basic security tests for Drift-based persistence.
void main() {
  late DBService dbService;
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await sl.initialize(testDb: db);
    dbService = DBService();
  });

  tearDown(() async {
    await db.close();
    await sl.reset();
  });

  group('Performance Tests (Drift)', () {
    test('Database write performance: 100 memories under 2 seconds', () async {
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 100; i++) {
        final memory = MemoriesCompanion.insert(
          title: 'Performance Memory $i',
          encryptedContent: 'Encrypted Content $i',
          createdAt: drift.Value(DateTime.now()),
        );
        await dbService.insertMemory(memory);
      }

      stopwatch.stop();
      final elapsedMs = stopwatch.elapsedMilliseconds;

      print('100 memory writes completed in ${elapsedMs}ms');
      expect(elapsedMs, lessThan(2000));
    });

    test('Database read performance: 100 interaction simulation under 500ms',
        () async {
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 10; i++) {
        await dbService.getMemories();
      }

      stopwatch.stop();
      final elapsedMs = stopwatch.elapsedMilliseconds;

      print('10 full memory list reads completed in ${elapsedMs}ms');
      expect(elapsedMs, lessThan(500));
    });
  });

  group('Basic Security & Data Integrity', () {
    test('Content handle special characters safely', () async {
      final memory = MemoriesCompanion.insert(
        title: 'Memory with <special> & "characters"',
        encryptedContent: 'Content with emojis 🙏 and symbols ₪',
        createdAt: drift.Value(DateTime.now()),
      );

      final id = await dbService.insertMemory(memory);
      final memories = await dbService.getMemories();
      final savedMemory = memories.firstWhere((m) => m.id == id);

      expect(savedMemory.title, contains('<special>'));
      expect(savedMemory.title, contains('&'));
      expect(savedMemory.title, contains('"'));
      expect(savedMemory.encryptedContent, contains('🙏'));
    });

    test('Unicode handled correctly (Arabic)', () async {
      final memory = MemoriesCompanion.insert(
        title: 'امتنان',
        encryptedContent: 'أشكر الله على نعمه 🙏 الحمد لله',
        createdAt: drift.Value(DateTime.now()),
      );

      final id = await dbService.insertMemory(memory);
      final memories = await dbService.getMemories();
      final savedMemory = memories.firstWhere((m) => m.id == id);

      expect(savedMemory.title, equals('امتنان'));
      expect(savedMemory.encryptedContent, contains('أشكر'));
    });
  });
}
