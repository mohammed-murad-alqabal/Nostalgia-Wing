import 'dart:io';

import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wing_of_nostalgia/core/cognitive/psychological_context_manager.dart';
import 'package:wing_of_nostalgia/core/data/app_database.dart';
import 'package:wing_of_nostalgia/core/di/service_locator.dart';
import 'package:wing_of_nostalgia/core/security/key_manager.dart';
import 'package:wing_of_nostalgia/core/security/privacy_maintenance_service.dart';
import 'package:wing_of_nostalgia/core/services/auth_service.dart';
import 'package:wing_of_nostalgia/core/services/safety_box_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  final binaryMessenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late Directory tempDir;
  late File databaseFile;
  late AppDatabase database;
  late _TrackingKeyManager keyManager;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('privacy-maintenance-');
    databaseFile = File('${tempDir.path}/privacy.sqlite');
    Hive.init(tempDir.path);
    SharedPreferences.setMockInitialValues({'test_key': 'test_value'});

    binaryMessenger.setMockMethodCallHandler(pathProviderChannel, (call) async {
      if (call.method == 'getApplicationDocumentsDirectory') {
        return tempDir.path;
      }
      return null;
    });

    database = AppDatabase.forTesting(NativeDatabase(databaseFile));
    await sl.initialize(testDb: database);
    keyManager = _TrackingKeyManager();
    sl.keyManager = keyManager;

    await AuthService.instance.initialize();
    await AuthService.instance.authenticate();

    await Hive.openBox<dynamic>(PsychologicalContextManager.boxName);
    await Hive.openBox<dynamic>(SafetyBoxService.boxName);
  });

  tearDown(() async {
    await sl.reset();
    await Hive.close();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
    binaryMessenger.setMockMethodCallHandler(pathProviderChannel, null);
  });

  test(
    'privacy maintenance clears every application-owned sensitive store',
    () async {
      final secureMediaDir = Directory('${tempDir.path}/secure_media');
      await secureMediaDir.create();
      await File('${secureMediaDir.path}/memory.enc')
          .writeAsString('ciphertext');

      final memoryId = await database.into(database.memories).insert(
            MemoriesCompanion.insert(
              title: 'Encrypted title',
              encryptedContent: 'Encrypted content',
              createdAt: drift.Value(DateTime.now()),
            ),
          );
      await database.into(database.reflections).insert(
            ReflectionsCompanion.insert(
              memoryId: memoryId,
              aiInsight: 'Insight',
            ),
          );
      await database.into(database.sentMessages).insert(
            SentMessagesCompanion.insert(
              encryptedContent: 'Encrypted message',
              type: 'morning',
            ),
          );
      await database.into(database.surprises).insert(
            SurprisesCompanion.insert(
              encryptedContent: 'Encrypted surprise',
              type: 'growth',
            ),
          );

      await PrivacyMaintenanceService.maintenanceReset();

      expect(sl.isInitialized, isFalse);
      expect(secureMediaDir.existsSync(), isFalse);
      expect(
        (await SharedPreferences.getInstance()).getString('test_key'),
        isNull,
      );
      expect(AuthService.instance.isAuthenticated, isFalse);
      expect(Hive.isBoxOpen(PsychologicalContextManager.boxName), isFalse);
      expect(Hive.isBoxOpen(SafetyBoxService.boxName), isFalse);
      expect(keyManager.wasCleared, isTrue);

      final reopenedDatabase =
          AppDatabase.forTesting(NativeDatabase(databaseFile));
      try {
        expect(
          await reopenedDatabase.select(reopenedDatabase.memories).get(),
          isEmpty,
        );
        expect(
          await reopenedDatabase.select(reopenedDatabase.reflections).get(),
          isEmpty,
        );
        expect(
          await reopenedDatabase.select(reopenedDatabase.sentMessages).get(),
          isEmpty,
        );
        expect(
          await reopenedDatabase.select(reopenedDatabase.surprises).get(),
          isEmpty,
        );
      } finally {
        await reopenedDatabase.close();
      }
    },
  );

  test('privacy maintenance propagates a key invalidation failure', () async {
    sl.keyManager = _FailingKeyManager();

    await expectLater(
      PrivacyMaintenanceService.maintenanceReset(),
      throwsA(isA<StateError>()),
    );

    // يفشل المسار بصورة ظاهرة للمستدعي ولا يدّعي نجاح التصفير، مع إغلاق
    // الموارد حتى لا يبقى التطبيق مهيأً بمفتاح غير صالح.
    expect(sl.isInitialized, isFalse);
    expect(
      (await SharedPreferences.getInstance()).getString('test_key'),
      isNull,
    );
    expect(AuthService.instance.isAuthenticated, isFalse);
    expect(Hive.isBoxOpen(PsychologicalContextManager.boxName), isFalse);
    expect(Hive.isBoxOpen(SafetyBoxService.boxName), isFalse);
  });
}

class _TrackingKeyManager extends KeyManager {
  bool wasCleared = false;

  @override
  Future<void> clearMasterKey() async {
    wasCleared = true;
  }
}

class _FailingKeyManager extends KeyManager {
  @override
  Future<void> clearMasterKey() {
    throw StateError('simulated key invalidation failure');
  }
}
