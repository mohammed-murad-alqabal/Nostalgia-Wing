// ignore_for_file: avoid_print
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/native.dart';
import 'package:wing_of_nostalgia/core/data/app_database.dart';
import 'package:wing_of_nostalgia/core/services/auth_service.dart';
import 'package:wing_of_nostalgia/core/services/db_service.dart';
import 'package:wing_of_nostalgia/core/di/service_locator.dart';
import 'package:drift/drift.dart' as drift;

/// Performance and basic security tests for Drift-based persistence.
void main() {
  late DBService dbService;
  late AppDatabase db;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await sl.initialize(testDb: db);
    dbService = DBService();
    await AuthService.instance.authenticate();
  });

  tearDown(() async {
    await AuthService.instance.logout();
    await db.close();
    await sl.reset();
  });

  group('Performance Tests (Drift)', () {
    test('Database write performance reports the measured duration', () async {
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
      expect(elapsedMs, isNotNull);
    });

    test('Database read performance reports the measured duration', () async {
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 10; i++) {
        await dbService.getMemories();
      }

      stopwatch.stop();
      final elapsedMs = stopwatch.elapsedMilliseconds;

      print('10 full memory list reads completed in ${elapsedMs}ms');
      expect(elapsedMs, isNotNull);
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
