import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:wing_of_nostalgia/core/data/app_database.dart';
import 'package:wing_of_nostalgia/core/services/db_service.dart';
import 'package:wing_of_nostalgia/core/services/auth_service.dart';
import 'package:wing_of_nostalgia/core/di/service_locator.dart';
import 'package:drift/drift.dart' as drift;

/// Integration tests for service interactions.
void main() {
  late DBService dbService;
  late AuthService authService;
  late AppDatabase db;

  setUp(() async {
    // Setup in-memory drift database for testing
    db = AppDatabase.forTesting(NativeDatabase.memory());

    // Setup service locator for testing
    await sl.initialize(testDb: db);

    dbService = DBService();
    authService = AuthService.instance;
    await authService.initialize();
  });

  tearDown(() async {
    await db.close();
    await sl.reset();
  });

  group('Service Integration Tests (Drift Authoritative)', () {
    test('Auth and DB services should work together', () async {
      // Authenticate user
      final isAuthenticated = await authService.authenticate();
      expect(isAuthenticated, isTrue);

      // After authentication, user can save memories
      final memory = MemoriesCompanion.insert(
        title: 'Authenticated Memory',
        encryptedContent: 'Encrypted Content',
        createdAt: drift.Value(DateTime.now()),
      );

      final id = await dbService.insertMemory(memory);
      final memories = await dbService.getMemories();

      expect(memories.any((m) => m.id == id), isTrue);
    });

    test('Data flow: Create, Read, Delete memory', () async {
      // CREATE
      final memory = MemoriesCompanion.insert(
        title: 'CRUD Test Memory',
        encryptedContent: 'Content',
        createdAt: drift.Value(DateTime.now()),
      );
      final id = await dbService.insertMemory(memory);

      // READ
      final memories = await dbService.getMemories();
      final savedMemory = memories.firstWhere((m) => m.id == id);
      expect(savedMemory.title, 'CRUD Test Memory');

      // DELETE
      await dbService.deleteMemory(id);
      final memoriesAfterDelete = await dbService.getMemories();
      expect(memoriesAfterDelete.any((m) => m.id == id), isFalse);
    });

    test('Sent Message Persistence Flow', () async {
      // Create a sent message entry
      final message = SentMessagesCompanion.insert(
        encryptedContent: 'Encrypted Love Letter',
        type: 'morning',
        sentAt: drift.Value(DateTime.now()),
      );

      final id = await dbService.insertSentMessage(message);
      final history = await dbService.getSentMessages();

      expect(history.any((m) => m.id == id), isTrue);
      expect(history.firstWhere((m) => m.id == id).type, 'morning');
    });
  });
}
