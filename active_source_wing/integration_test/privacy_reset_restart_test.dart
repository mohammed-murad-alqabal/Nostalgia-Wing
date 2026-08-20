import 'dart:io';

import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:wing_of_nostalgia/core/cognitive/psychological_context_manager.dart';
import 'package:wing_of_nostalgia/core/data/app_database.dart';
import 'package:wing_of_nostalgia/core/di/service_locator.dart';
import 'package:wing_of_nostalgia/core/security/privacy_reset_audit_store.dart';
import 'package:wing_of_nostalgia/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'privacy reset clears platform stores and app restarts cleanly',
    (tester) async {
      await app.main();
      await _pumpUntil(
        tester,
        find.text('مختبر الذكاء المعرفي'),
        reason: 'The initialized application did not render the home screen.',
      );

      final mediaFile = await _seedSensitivePlatformData();
      final contextBox = Hive.box<dynamic>(
        PsychologicalContextManager.boxName,
      );
      final memoryRows = await sl.database.select(sl.database.memories).get();

      expect(memoryRows, hasLength(1));
      expect(
          contextBox.get('integration_sentinel'), 'synthetic-sensitive-data');
      expect(mediaFile.existsSync(), isTrue);

      final labEntry = find.text('مختبر الذكاء المعرفي').first;
      await tester.tap(labEntry);
      await _pumpUntil(
        tester,
        find.text('مختبر الذكاء المعرفي'),
        reason: 'The intelligence lab did not open on the device.',
      );

      final maintenanceButton =
          find.text('صيانة الخصوصية - Privacy Maintenance');
      await tester.scrollUntilVisible(
        maintenanceButton,
        500.0,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 30,
      );
      await tester.pump(const Duration(seconds: 2));
      await _pumpUntil(
        tester,
        maintenanceButton,
        reason:
            'The privacy maintenance control was not reachable on the device.',
      );

      await tester.tap(maintenanceButton);
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('تأكيد صيانة البيانات وحماية الخصوصية'), findsOneWidget);

      await tester.tap(find.text('بدء الصيانة'));
      await _pumpUntil(
        tester,
        find.text('تمت عملية صيانة الخصوصية بنجاح 🛡️'),
        reason: 'The privacy reset did not report a successful completion.',
      );

      final resetAudit = await PrivacyResetAuditStore().read();
      expect(resetAudit, isNotNull);
      expect(resetAudit!.status, PrivacyResetAuditStatus.succeeded);
      expect(resetAudit.finishedAt, isNotNull);
      expect(mediaFile.existsSync(), isFalse);
      expect(Hive.isBoxOpen(PsychologicalContextManager.boxName), isFalse);
      expect(sl.isInitialized, isFalse);

      // Calling the real entrypoint again models a fresh process initialization
      // after the reset. The audit record must survive SharedPreferences.clear.
      await app.main();
      await _pumpUntil(
        tester,
        find.byType(app.WingOfNostalgiaApp),
        reason: 'The application did not initialize after a complete reset.',
      );
      expect(find.byType(app.EmergencyApp), findsNothing);

      final restartedAudit = await PrivacyResetAuditStore().read();
      expect(restartedAudit?.status, PrivacyResetAuditStatus.succeeded);
      expect(restartedAudit?.finishedAt, isNotNull);

      final restartedMemoryRows =
          await sl.database.select(sl.database.memories).get();
      expect(restartedMemoryRows, isEmpty);

      final restartedContextBox = Hive.box<dynamic>(
        PsychologicalContextManager.boxName,
      );
      expect(restartedContextBox.isEmpty, isTrue);
    },
  );
}

Future<File> _seedSensitivePlatformData() async {
  final database = sl.database;
  await database.into(database.memories).insert(
        MemoriesCompanion.insert(
          title: 'Synthetic integration memory',
          encryptedContent: 'synthetic-encrypted-content',
          description: const drift.Value('Synthetic test data only'),
        ),
      );

  final contextBox = Hive.box<dynamic>(PsychologicalContextManager.boxName);
  await contextBox.put('integration_sentinel', 'synthetic-sensitive-data');

  final appDir = await getApplicationDocumentsDirectory();
  final secureMediaDir = Directory(p.join(appDir.path, 'secure_media'));
  await secureMediaDir.create(recursive: true);
  final mediaFile =
      File(p.join(secureMediaDir.path, 'integration-sentinel.bin'));
  await mediaFile.writeAsBytes(<int>[1, 2, 3, 4]);
  return mediaFile;
}

Future<void> _pumpUntil(
  WidgetTester tester,
  Finder finder, {
  required String reason,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (finder.evaluate().isEmpty && DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 250));
  }
  expect(finder, findsWidgets, reason: reason);
}
