import 'package:drift/drift.dart';
import '../data/app_database.dart';
import '../di/service_locator.dart';
import 'auth_service.dart';
import 'secure_media_cleanup_service.dart';

/// Service for handling authenticated local database operations using Drift.
class DBService {
  /// Creates a database service bound to the current local auth session.
  DBService({
    AuthService? authService,
    SecureMediaCleanupService? mediaCleanup,
  })  : _authService = authService ?? AuthService.instance,
        _mediaCleanup = mediaCleanup ?? SecureMediaCleanupService(),
        _db = sl.database;

  final AppDatabase _db;
  final AuthService _authService;
  final SecureMediaCleanupService _mediaCleanup;

  /// Initializes the database service.
  Future<void> init() async {
    // Already handled by sl.initialize().
  }

  void _requireAuthenticated() {
    _authService.requireAuthenticated();
  }

  // Memory operations

  /// Retrieves all stored memories for the active local session.
  Future<List<Memory>> getMemories() async {
    _requireAuthenticated();
    return _db.select(_db.memories).get();
  }

  /// Saves or updates a memory entry for the active local session.
  Future<void> saveMemory(Memory memory) async {
    _requireAuthenticated();
    await _db.into(_db.memories).insertOnConflictUpdate(memory);
  }

  /// Inserts a new memory and returns its ID.
  Future<int> insertMemory(MemoriesCompanion memory) async {
    _requireAuthenticated();
    return _db.into(_db.memories).insert(memory);
  }

  /// Deletes a memory and its application-owned encrypted media file.
  ///
  /// Database deletion remains authoritative: the media file is removed only
  /// after the row deletion succeeds. Files outside the owned `secure_media`
  /// directory are intentionally ignored by [SecureMediaCleanupService].
  Future<void> deleteMemory(int id) async {
    _requireAuthenticated();
    final memory = await (_db.select(_db.memories)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();

    await (_db.delete(_db.memories)..where((t) => t.id.equals(id))).go();
    await _mediaCleanup.deleteMediaPath(memory?.mediaPath);
  }

  /// Deletes encrypted media files that are no longer referenced by memories.
  ///
  /// This is an explicit maintenance operation; it does not implement
  /// automatic retention or expiry for memories.
  Future<int> cleanupOrphanedMedia() async {
    _requireAuthenticated();
    final memories = await _db.select(_db.memories).get();
    return _mediaCleanup.deleteOrphanedFiles(
      memories.map((memory) => memory.mediaPath),
    );
  }

  // SentMessage operations

  /// Retrieves all sent messages for the active local session.
  Future<List<SentMessage>> getSentMessages() async {
    _requireAuthenticated();
    return _db.select(_db.sentMessages).get();
  }

  /// Inserts a new sent message.
  Future<int> insertSentMessage(SentMessagesCompanion entry) async {
    _requireAuthenticated();
    return _db.into(_db.sentMessages).insert(entry);
  }

  /// Deletes a sent message.
  Future<void> deleteSentMessage(int id) async {
    _requireAuthenticated();
    await (_db.delete(_db.sentMessages)..where((t) => t.id.equals(id))).go();
  }

  // Surprise operations

  /// Retrieves all surprises for the active local session.
  Future<List<Surprise>> getSurprises() async {
    _requireAuthenticated();
    return _db.select(_db.surprises).get();
  }

  /// Retrieves pending surprises for the active local session.
  Future<List<Surprise>> getPendingSurprises() async {
    _requireAuthenticated();
    return (_db.select(_db.surprises)..where((t) => t.status.equals('pending')))
        .get();
  }

  /// Inserts a new surprise.
  Future<int> insertSurprise(SurprisesCompanion entry) async {
    _requireAuthenticated();
    return _db.into(_db.surprises).insert(entry);
  }

  /// Updates a surprise status.
  Future<void> updateSurpriseStatus(int id, String status) async {
    _requireAuthenticated();
    await (_db.update(_db.surprises)..where((t) => t.id.equals(id)))
        .write(SurprisesCompanion(status: Value(status)));
  }

  /// Deletes a surprise.
  Future<void> deleteSurprise(int id) async {
    _requireAuthenticated();
    await (_db.delete(_db.surprises)..where((t) => t.id.equals(id))).go();
  }
}
