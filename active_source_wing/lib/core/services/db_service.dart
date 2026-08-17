import 'package:drift/drift.dart';
import '../data/app_database.dart';
import '../di/service_locator.dart';
import 'auth_service.dart';

/// Service for handling authenticated local database operations using Drift.
class DBService {
  DBService({AuthService? authService})
      : _authService = authService ?? AuthService.instance,
        _db = sl.database;

  final AppDatabase _db;
  final AuthService _authService;

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

  /// Deletes a memory by its ID.
  Future<void> deleteMemory(int id) async {
    _requireAuthenticated();
    await (_db.delete(_db.memories)..where((t) => t.id.equals(id))).go();
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
