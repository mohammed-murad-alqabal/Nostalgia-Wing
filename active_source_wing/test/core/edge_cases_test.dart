import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/native.dart';
import 'package:wing_of_nostalgia/core/data/app_database.dart';
import 'package:wing_of_nostalgia/core/services/auth_service.dart';
import 'package:wing_of_nostalgia/core/services/db_service.dart';
import 'package:wing_of_nostalgia/core/di/service_locator.dart';
import 'package:drift/drift.dart' as drift;

/// Extension for Memory model.
extension MemoryExtension on Memory {
  /// Returns the age of the memory in days.
  int get ageInDays => DateTime.now().difference(createdAt).inDays;
}

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

  group('Edge Case Tests - Memory Operations (Drift)', () {
    test('Should handle empty memory list gracefully', () async {
      final result = await dbService.getMemories();
      expect(result, isEmpty);
    });

    test('Memory with very long title', () async {
      final longTitle = 'A' * 255;
      await dbService.insertMemory(MemoriesCompanion.insert(
        title: longTitle,
        encryptedContent: 'Content',
        viewCount: const drift.Value(0),
        createdAt: drift.Value(DateTime.now()),
      ));

      final memories = await dbService.getMemories();
      expect(memories.first.title.length, 255);
    });

    test('Memory ageInDays calculation', () {
      final now = DateTime.now();
      final today = Memory(
        id: 1,
        title: 'Today',
        encryptedContent: 'Content',
        viewCount: 0,
        createdAt: now,
      );

      expect(today.ageInDays, 0);

      final yesterday = Memory(
        id: 2,
        title: 'Yesterday',
        encryptedContent: 'Content',
        viewCount: 0,
        createdAt: now.subtract(const Duration(days: 1, hours: 1)),
      );

      expect(yesterday.ageInDays, 1);
    });
  });
}
