import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/data/app_database.dart';

void main() {
  test('migrates a populated Drift v2 database to v3', () async {
    final tempDir = await Directory.systemTemp.createTemp('drift-migration-');
    final databaseFile = File('${tempDir.path}/wing_of_nostalgia.sqlite');
    final fixture = File('test/fixtures/drift_v2.sqlite');

    try {
      await databaseFile.writeAsBytes(await fixture.readAsBytes());

      final database = AppDatabase.forTesting(NativeDatabase(databaseFile));
      try {
        final memory = await (database.select(database.memories).getSingle());
        final reflection =
            await (database.select(database.reflections).getSingle());

        expect(memory.id, 7);
        expect(memory.title, 'ذكرى fixture v2');
        expect(memory.description, 'بيانات ترقية اختبارية');
        expect(memory.encryptedContent, 'ciphertext-v2-memory-7');
        expect(memory.createdAt, DateTime.utc(2024, 1, 1));
        expect(memory.mediaPath, isNull);
        expect(memory.emotionalScore, 87);
        expect(memory.viewCount, 3);
        expect(memory.color, '#D4A373');

        expect(reflection.id, 11);
        expect(reflection.memoryId, 7);
        expect(reflection.ayahReference, '2:286');
        expect(reflection.hadithReference, 'fixture-hadith-v2');
        expect(reflection.aiInsight, 'insight-v2-preserved');
        expect(reflection.reflectedAt, DateTime.utc(2024, 1, 2));

        final sentMessages = await database
            .customSelect(
              "SELECT name FROM sqlite_master "
              "WHERE type = 'table' AND name = 'sent_messages'",
            )
            .get();
        final surprises = await database
            .customSelect(
              "SELECT name FROM sqlite_master "
              "WHERE type = 'table' AND name = 'surprises'",
            )
            .get();

        expect(sentMessages, hasLength(1));
        expect(surprises, hasLength(1));
        expect(await database.select(database.sentMessages).get(), isEmpty);
        expect(await database.select(database.surprises).get(), isEmpty);
      } finally {
        await database.close();
      }

      final reopened = AppDatabase.forTesting(NativeDatabase(databaseFile));
      try {
        expect(await reopened.select(reopened.memories).getSingle(), isNotNull);
        expect(
          await reopened.select(reopened.reflections).getSingle(),
          isNotNull,
        );
        expect(await reopened.select(reopened.sentMessages).get(), isEmpty);
        expect(await reopened.select(reopened.surprises).get(), isEmpty);
      } finally {
        await reopened.close();
      }
    } finally {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    }
  });
}
