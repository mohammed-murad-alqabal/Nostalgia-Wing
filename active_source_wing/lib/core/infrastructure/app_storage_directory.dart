import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Resolves the application-owned documents directory.
///
/// Production platforms must provide a real application directory. The
/// temporary fallback is enabled only with the explicit
/// `NOSTALGIA_TEST_STORAGE_FALLBACK=true` dart-define, which keeps desktop
/// integration tests deterministic without silently changing production data
/// storage.
Future<Directory> resolveAppDocumentsDirectory() async {
  try {
    return await getApplicationDocumentsDirectory();
  } on MissingPlatformDirectoryException {
    const allowTestFallback = bool.fromEnvironment(
      'NOSTALGIA_TEST_STORAGE_FALLBACK',
    );
    if (!allowTestFallback) rethrow;

    final directory = Directory(
      path.join(Directory.systemTemp.path, 'wing_of_nostalgia_test_storage'),
    );
    await directory.create(recursive: true);
    return directory;
  }
}
