import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:wing_of_nostalgia/core/data/app_database.dart';
import 'package:wing_of_nostalgia/core/services/db_service.dart';
import 'package:wing_of_nostalgia/core/di/service_locator.dart';
import 'package:drift/drift.dart' as drift;

void main() {
  late DBService dbService;
  late AppDatabase db;

  setUp(() async {
    // Setup in-memory drift database for testing
    db = AppDatabase.forTesting(NativeDatabase.memory());

    // Setup service locator for testing
    await sl.initialize(testDb: db);

    dbService = DBService();
  });

  tearDown(() async {
    await db.close();
    await sl.reset();
  });

  group('DBService - Memory Operations (Drift)', () {
    test('Should insert and retrieve a memory', () async {
      final memory = MemoriesCompanion.insert(
        title: 'Encrypted Title',
        encryptedContent: 'Encrypted Content',
        createdAt: drift.Value(DateTime.now()),
      );

      final id = await dbService.insertMemory(memory);
      final memories = await dbService.getMemories();

      expect(memories, isNotEmpty);
      expect(memories.any((m) => m.id == id), isTrue);
      expect(memories.firstWhere((m) => m.id == id).title,
          equals('Encrypted Title'));
    });

    test('Should delete a memory', () async {
      final memory = MemoriesCompanion.insert(
        title: 'To Delete',
        encryptedContent: 'Content',
        createdAt: drift.Value(DateTime.now()),
      );

      final id = await dbService.insertMemory(memory);
      await dbService.deleteMemory(id);

      final memories = await dbService.getMemories();
      expect(memories.any((m) => m.id == id), isFalse);
    });
  });
}
