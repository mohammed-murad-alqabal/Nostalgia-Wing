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
    await ownedFile.writeAsString('owned');
    await outsideFile.writeAsString('outside');

    expect(await service.deleteMediaPath(ownedFile.path), isTrue);
    expect(await ownedFile.exists(), isFalse);

    expect(await service.deleteMediaPath(outsideFile.path), isFalse);
    expect(await outsideFile.exists(), isTrue);
    await outsideFile.delete();
  });

  test('deletes only unreferenced direct encrypted files', () async {
    final referencedFile = File('${secureMediaDirectory.path}/referenced.enc');
    final orphanedFile = File('${secureMediaDirectory.path}/orphaned.enc');
    final unrelatedFile = File('${secureMediaDirectory.path}/keep.txt');
    final nestedDirectory = Directory('${secureMediaDirectory.path}/nested');
    await referencedFile.writeAsString('referenced');
    await orphanedFile.writeAsString('orphaned');
    await unrelatedFile.writeAsString('unrelated');
    await nestedDirectory.create();
    await File('${nestedDirectory.path}/nested.enc').writeAsString('nested');

    expect(
      await service.deleteOrphanedFiles([referencedFile.path]),
      1,
    );
    expect(await referencedFile.exists(), isTrue);
    expect(await orphanedFile.exists(), isFalse);
    expect(await unrelatedFile.exists(), isTrue);
    expect(await File('${nestedDirectory.path}/nested.enc').exists(), isTrue);
  });

  test('does not recreate a missing secure media directory', () async {
    secureMediaDirectory.deleteSync(recursive: true);

    expect(await service.deleteOrphanedFiles(const []), 0);
    expect(secureMediaDirectory.existsSync(), isFalse);
  });
}
