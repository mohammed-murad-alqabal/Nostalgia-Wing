import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Owns lifecycle cleanup for encrypted files stored in `secure_media`.
///
/// The service never deletes arbitrary paths. It only handles `.enc` files
/// located directly under the application-owned secure media directory.
class SecureMediaCleanupService {
  /// Creates a cleanup service with an optional application-directory provider.
  SecureMediaCleanupService({
    Future<Directory> Function()? applicationDirectoryProvider,
  }) : _applicationDirectoryProvider =
            applicationDirectoryProvider ?? getApplicationDocumentsDirectory;

  /// The application-owned directory name for encrypted memory media.
  static const secureMediaDirectoryName = 'secure_media';

  /// The extension used by encrypted media files.
  static const encryptedMediaExtension = '.enc';

  final Future<Directory> Function() _applicationDirectoryProvider;

  /// Deletes one application-owned encrypted media file, if it exists.
  ///
  /// Returns `true` only when a file was deleted. Paths outside the owned
  /// directory, directories, non-encrypted files, and missing files are left
  /// untouched and return `false`.
  Future<bool> deleteMediaPath(String? mediaPath) async {
    if (mediaPath == null || mediaPath.isEmpty) return false;

    final secureMediaDirectory = await _secureMediaDirectory();
    final file = File(mediaPath);
    if (!_isOwnedEncryptedFile(file.path, secureMediaDirectory.path)) {
      return false;
    }

    // ignore: avoid_slow_async_io
    if (!await file.exists()) return false;
    await file.delete();
    return true;
  }

  /// Deletes encrypted files that are not referenced by any memory row.
  ///
  /// Returns the number of deleted orphan files. Only direct `.enc` files in
  /// the application-owned directory are considered; nested directories and
  /// unrelated files are preserved.
  Future<int> deleteOrphanedFiles(Iterable<String?> referencedPaths) async {
    final secureMediaDirectory = await _secureMediaDirectory();
    // ignore: avoid_slow_async_io
    if (!await secureMediaDirectory.exists()) return 0;

    final referenced = referencedPaths
        .whereType<String>()
        .where((path) => path.isNotEmpty)
        .map(_normalize)
        .toSet();

    var deletedCount = 0;
    await for (final entity in secureMediaDirectory.list(followLinks: false)) {
      if (entity is! File ||
          p.extension(entity.path) != encryptedMediaExtension ||
          referenced.contains(_normalize(entity.path))) {
        continue;
      }

      await entity.delete();
      deletedCount++;
    }
    return deletedCount;
  }

  Future<Directory> _secureMediaDirectory() async {
    final appDirectory = await _applicationDirectoryProvider();
    return Directory(
      p.join(appDirectory.path, secureMediaDirectoryName),
    );
  }

  bool _isOwnedEncryptedFile(String filePath, String directoryPath) {
    final normalizedFilePath = _normalize(filePath);
    final normalizedDirectoryPath = _normalize(directoryPath);
    final directoryPrefix = '$normalizedDirectoryPath${p.separator}';

    return normalizedFilePath.startsWith(directoryPrefix) &&
        p.extension(normalizedFilePath) == encryptedMediaExtension;
  }

  String _normalize(String path) => p.normalize(p.absolute(path));
}

/// Compatibility alias for code that prefers a shorter service name.
typedef SecureMediaCleanup = SecureMediaCleanupService;
