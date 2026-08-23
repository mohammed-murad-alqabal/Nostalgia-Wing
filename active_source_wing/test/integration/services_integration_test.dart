import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/native.dart';
import 'package:wing_of_nostalgia/core/data/app_database.dart';
import 'package:wing_of_nostalgia/core/services/auth_service.dart';
import 'package:wing_of_nostalgia/core/services/db_service.dart';
import 'package:wing_of_nostalgia/core/di/service_locator.dart';
import 'package:drift/drift.dart' as drift;

/// Integration tests for service interactions.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  late DBService dbService;
  late AuthService authService;
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await sl.initialize(testDb: db);

    dbService = DBService();
    authService = AuthService.instance;
    await authService.initialize();
  });

  tearDown(() async {
    await authService.logout();
    await db.close();
    await sl.reset();
  });

  group('Service Integration Tests (Drift Authoritative)', () {
    test('DB access requires an authenticated local session', () async {
      expect(
        () => dbService.getMemories(),
        throwsA(isA<AuthenticationRequiredException>()),
      );

      await authService.authenticate();
      expect(await dbService.getMemories(), isEmpty);

      await authService.logout();
      expect(
        () => dbService.getMemories(),
        throwsA(isA<AuthenticationRequiredException>()),
      );
    });

    test('All protected table reads reject access after logout', () async {
      await authService.authenticate();
      await authService.logout();

      expect(
        () => dbService.getMemories(),
        throwsA(isA<AuthenticationRequiredException>()),
      );
      expect(
        () => dbService.getSentMessages(),
        throwsA(isA<AuthenticationRequiredException>()),
      );
      expect(
        () => dbService.getSurprises(),
        throwsA(isA<AuthenticationRequiredException>()),
      );
    });

    test('Disposing the session invalidates the bound DB service', () async {
      await authService.authenticate();
      expect(await dbService.getMemories(), isEmpty);

      authService.dispose();

      expect(
        () => dbService.getMemories(),
        throwsA(isA<AuthenticationRequiredException>()),
      );

      final freshAuthService = AuthService.instance;
      final freshDbService = DBService();
      await freshAuthService.authenticate();
      expect(await freshDbService.getMemories(), isEmpty);
    });

    test('Auth and DB services should work together', () async {
      final isAuthenticated = await authService.authenticate();
      expect(isAuthenticated, isTrue);

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
      await authService.authenticate();

      final memory = MemoriesCompanion.insert(
        title: 'CRUD Test Memory',
        encryptedContent: 'Content',
        createdAt: drift.Value(DateTime.now()),
      );
      final id = await dbService.insertMemory(memory);

      final memories = await dbService.getMemories();
      final savedMemory = memories.firstWhere((m) => m.id == id);
      expect(savedMemory.title, 'CRUD Test Memory');

      await dbService.deleteMemory(id);
      final memoriesAfterDelete = await dbService.getMemories();
      expect(memoriesAfterDelete.any((m) => m.id == id), isFalse);
    });

    test('Sent Message Persistence Flow', () async {
      await authService.authenticate();

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
