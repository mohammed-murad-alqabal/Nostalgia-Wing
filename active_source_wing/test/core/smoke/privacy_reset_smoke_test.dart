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
import 'package:wing_of_nostalgia/core/security/privacy_reset_audit_store.dart';
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
  late PrivacyResetAuditStore auditStore;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('privacy-reset-smoke-');
    databaseFile = File('${tempDir.path}/privacy.sqlite');
    Hive.init(tempDir.path);
    SharedPreferences.setMockInitialValues({'smoke_key': 'smoke_value'});

    binaryMessenger.setMockMethodCallHandler(pathProviderChannel, (call) async {
      if (call.method == 'getApplicationDocumentsDirectory') {
        return tempDir.path;
      }
      return null;
    });

    database = AppDatabase.forTesting(NativeDatabase(databaseFile));
    await sl.initialize(testDb: database);
    sl.keyManager = KeyManager(store: _InMemoryKeyValueStore());
    auditStore = PrivacyResetAuditStore(
      storage: _InMemoryPrivacyResetAuditStorage(),
    );

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

  test('successful reset closes Drift and leaves every store empty', () async {
    await database.into(database.memories).insert(
          MemoriesCompanion.insert(
            title: 'Smoke memory',
            encryptedContent: 'Encrypted smoke content',
            createdAt: drift.Value(DateTime.now()),
          ),
        );
    await database.into(database.sentMessages).insert(
          SentMessagesCompanion.insert(
            encryptedContent: 'Encrypted smoke message',
            type: 'smoke',
          ),
        );

    await PrivacyMaintenanceService.maintenanceReset(auditStore: auditStore);

    final audit = await auditStore.read();
    expect(audit?.status, PrivacyResetAuditStatus.succeeded);
    expect(audit?.finishedAt, isNotNull);
    expect(sl.isInitialized, isFalse);
    expect(AuthService.instance.isAuthenticated, isFalse);
    expect(Hive.isBoxOpen(PsychologicalContextManager.boxName), isFalse);
    expect(Hive.isBoxOpen(SafetyBoxService.boxName), isFalse);
    expect(
        (await SharedPreferences.getInstance()).getString('smoke_key'), isNull);
    await expectLater(
      database.select(database.memories).get(),
      throwsA(anything),
    );

    final reopenedDatabase =
        AppDatabase.forTesting(NativeDatabase(databaseFile));
    try {
      expect(
        await reopenedDatabase.select(reopenedDatabase.memories).get(),
        isEmpty,
      );
      expect(
        await reopenedDatabase.select(reopenedDatabase.sentMessages).get(),
        isEmpty,
      );
      expect(
        await reopenedDatabase.select(reopenedDatabase.reflections).get(),
        isEmpty,
      );
      expect(
        await reopenedDatabase.select(reopenedDatabase.surprises).get(),
        isEmpty,
      );
    } finally {
      await reopenedDatabase.close();
    }
  });
}

class _InMemoryKeyValueStore implements KeyValueStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    values.remove(key);
  }

  @override
  Future<Map<String, String>> readAll() async =>
      Map<String, String>.from(values);
}

class _InMemoryPrivacyResetAuditStorage implements PrivacyResetAuditStorage {
  final values = <String, String>{};

  @override
  Future<String?> read({required String key}) async => values[key];

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }
}
