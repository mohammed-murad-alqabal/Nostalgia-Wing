import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drift/native.dart';
import 'package:wing_of_nostalgia/core/data/app_database.dart';
import 'package:wing_of_nostalgia/core/services/auth_service.dart';
import 'package:wing_of_nostalgia/core/services/db_service.dart';
import 'package:wing_of_nostalgia/core/services/secure_media_cleanup_service.dart';
import 'package:wing_of_nostalgia/core/di/service_locator.dart';
import 'package:drift/drift.dart' as drift;

void main() {
  late DBService dbService;
  late AppDatabase db;
  late Directory tempDir;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    tempDir = await Directory.systemTemp.createTemp('db-service-media-');

    // Setup in-memory drift database for testing
    db = AppDatabase.forTesting(NativeDatabase.memory());

    // Setup service locator for testing
    await sl.initialize(testDb: db);

    dbService = DBService(
      mediaCleanup: SecureMediaCleanupService(
        applicationDirectoryProvider: () async => tempDir,
      ),
    );
    await AuthService.instance.logout();
  });

  tearDown(() async {
    await AuthService.instance.logout();
    await db.close();
    await sl.reset();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  group('DBService - Authentication Contract', () {
    test('rejects database access without an authenticated session', () async {
      await AuthService.instance.logout();

      expect(
        () => dbService.getMemories(),
        throwsA(isA<AuthenticationRequiredException>()),
      );
    });

    test('rejects database access after logout', () async {
      await AuthService.instance.authenticate();
      expect(await dbService.getMemories(), isEmpty);

      await AuthService.instance.logout();

      expect(
        () => dbService.getMemories(),
        throwsA(isA<AuthenticationRequiredException>()),
      );
    });
  });

  group('DBService - Memory Operations (Drift)', () {
    setUp(() async {
      await AuthService.instance.authenticate();
    });

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

    test('Should delete a memory and its linked encrypted media file',
        () async {
      final secureMediaDir = Directory('${tempDir.path}/secure_media');
      await secureMediaDir.create();
      final mediaFile = File('${secureMediaDir.path}/linked-memory.enc');
      mediaFile.writeAsStringSync('ciphertext');

      final memory = MemoriesCompanion.insert(
        title: 'To Delete',
        encryptedContent: 'Content',
        mediaPath: drift.Value(mediaFile.path),
        createdAt: drift.Value(DateTime.now()),
      );

      final id = await dbService.insertMemory(memory);
      await dbService.deleteMemory(id);

      final memories = await dbService.getMemories();
      expect(memories.any((m) => m.id == id), isFalse);
      expect(mediaFile.existsSync(), isFalse);
    });

    test('Should remove multiple orphaned files and preserve references',
        () async {
      final secureMediaDir = Directory('${tempDir.path}/secure_media');
      await secureMediaDir.create();
      final referencedFile = File('${secureMediaDir.path}/referenced.enc');
      final secondReferencedFile =
          File('${secureMediaDir.path}/second-referenced.enc');
      final orphanedFile = File('${secureMediaDir.path}/orphaned.enc');
      final secondOrphanedFile =
          File('${secureMediaDir.path}/second-orphaned.enc');
      final unrelatedFile = File('${secureMediaDir.path}/keep.txt');
      referencedFile.writeAsStringSync('referenced');
      secondReferencedFile.writeAsStringSync('referenced');
      orphanedFile.writeAsStringSync('orphaned');
      secondOrphanedFile.writeAsStringSync('orphaned');
      unrelatedFile.writeAsStringSync('unrelated');

      for (final entry in [
        (title: 'Referenced memory', file: referencedFile),
        (title: 'Second referenced memory', file: secondReferencedFile),
      ]) {
        await dbService.insertMemory(
          MemoriesCompanion.insert(
            title: entry.title,
            encryptedContent: 'Content',
            mediaPath: drift.Value(entry.file.path),
            createdAt: drift.Value(DateTime.now()),
          ),
        );
      }

      expect(await dbService.cleanupOrphanedMedia(), 2);
      expect(referencedFile.existsSync(), isTrue);
      expect(secondReferencedFile.existsSync(), isTrue);
      expect(orphanedFile.existsSync(), isFalse);
      expect(secondOrphanedFile.existsSync(), isFalse);
      expect(unrelatedFile.existsSync(), isTrue);

      expect(await dbService.cleanupOrphanedMedia(), 0);
      expect(referencedFile.existsSync(), isTrue);
      expect(secondReferencedFile.existsSync(), isTrue);
      expect(unrelatedFile.existsSync(), isTrue);
    });
  });
}
