import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/services/secure_media_cleanup_service.dart';

void main() {
  late Directory appDirectory;
  late Directory secureMediaDirectory;
  late SecureMediaCleanupService service;

  setUp(() async {
    appDirectory = await Directory.systemTemp.createTemp('secure-media-');
    secureMediaDirectory = Directory('${appDirectory.path}/secure_media');
    await secureMediaDirectory.create();
    service = SecureMediaCleanupService(
      applicationDirectoryProvider: () async => appDirectory,
    );
  });

  tearDown(() async {
    if (appDirectory.existsSync()) {
      appDirectory.deleteSync(recursive: true);
    }
  });

  test('deletes only an owned encrypted media path', () async {
    final ownedFile = File('${secureMediaDirectory.path}/owned.enc');
    final outsideFile = File('${appDirectory.parent.path}/outside.enc');
    ownedFile.writeAsStringSync('owned');
    outsideFile.writeAsStringSync('outside');

    expect(await service.deleteMediaPath(ownedFile.path), isTrue);
    expect(ownedFile.existsSync(), isFalse);

    expect(await service.deleteMediaPath(outsideFile.path), isFalse);
    expect(outsideFile.existsSync(), isTrue);
    outsideFile.deleteSync();
  });

  test('deletes only unreferenced direct encrypted files', () async {
    final referencedFile = File('${secureMediaDirectory.path}/referenced.enc');
    final orphanedFile = File('${secureMediaDirectory.path}/orphaned.enc');
    final unrelatedFile = File('${secureMediaDirectory.path}/keep.txt');
    final nestedDirectory = Directory('${secureMediaDirectory.path}/nested');
    referencedFile.writeAsStringSync('referenced');
    orphanedFile.writeAsStringSync('orphaned');
    unrelatedFile.writeAsStringSync('unrelated');
    await nestedDirectory.create();
    File('${nestedDirectory.path}/nested.enc').writeAsStringSync('nested');

    expect(
      await service.deleteOrphanedFiles([referencedFile.path]),
      1,
    );
    expect(referencedFile.existsSync(), isTrue);
    expect(orphanedFile.existsSync(), isFalse);
    expect(unrelatedFile.existsSync(), isTrue);
    expect(File('${nestedDirectory.path}/nested.enc').existsSync(), isTrue);
  });

  test('does not recreate a missing secure media directory', () async {
    secureMediaDirectory.deleteSync(recursive: true);

    expect(await service.deleteOrphanedFiles(const []), 0);
    expect(secureMediaDirectory.existsSync(), isFalse);
  });
}
