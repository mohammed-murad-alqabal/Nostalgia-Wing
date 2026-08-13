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
  late Directory tempDir;
  late AppDatabase database;
  late _TrackingKeyManager keyManager;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('privacy-maintenance-');
    Hive.init(tempDir.path);
    SharedPreferences.setMockInitialValues({'test_key': 'test_value'});

    pathProviderChannel.setMockMethodCallHandler((call) async {
      if (call.method == 'getApplicationDocumentsDirectory') {
        return tempDir.path;
      }
      return null;
    });

    database = AppDatabase.forTesting(NativeDatabase.memory());
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
    await tempDir.delete(recursive: true);
    pathProviderChannel.setMockMethodCallHandler(null);
  });

  test('privacy maintenance clears every application-owned sensitive store',
      () async {
    final secureMediaDir = Directory('${tempDir.path}/secure_media');
    await secureMediaDir.create();
    await File('${secureMediaDir.path}/memory.enc').writeAsString('ciphertext');

    final memoryId = await database.into(database.memories).insert(
          MemoriesCompanion.insert(
            title: 'Encrypted title',
            encryptedContent: 'Encrypted content',
            createdAt: drift.Value(DateTime.now()),
          ),
        );
    await database.into(database.reflections).insert(
          ReflectionsCompanion.insert(memoryId: memoryId, aiInsight: 'Insight'),
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

    expect(await database.select(database.memories).get(), isEmpty);
    expect(await database.select(database.reflections).get(), isEmpty);
    expect(await database.select(database.sentMessages).get(), isEmpty);
    expect(await database.select(database.surprises).get(), isEmpty);
    expect(await secureMediaDir.exists(), isFalse);
    expect((await SharedPreferences.getInstance()).getString('test_key'), isNull);
    expect(AuthService.instance.isAuthenticated, isFalse);
    expect(Hive.isBoxOpen(PsychologicalContextManager.boxName), isFalse);
    expect(Hive.isBoxOpen(SafetyBoxService.boxName), isFalse);
    expect(keyManager.wasCleared, isTrue);
  });

  test('privacy maintenance propagates a key invalidation failure', () async {
    sl.keyManager = _FailingKeyManager();

    await expectLater(
      PrivacyMaintenanceService.maintenanceReset(),
      throwsA(isA<StateError>()),
    );

    // يفشل المسار بصورة ظاهرة للمستدعي ولا يدّعي نجاح التصفير.
    expect((await SharedPreferences.getInstance()).getString('test_key'), isNull);
    expect(AuthService.instance.isAuthenticated, isFalse);
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
