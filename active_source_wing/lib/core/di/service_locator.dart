import '../analysis/spiritual_analyzer.dart';
import '../data/app_database.dart';
import '../infrastructure/wing_logger.dart';
import '../security/decryption_observer.dart';
import '../security/key_manager.dart';
import '../security/security_service.dart';
import '../security/versioned_encryption_service.dart';
import '../services/settings_service.dart';

/// Singleton instance of [ServiceLocator].
final sl = ServiceLocator();

/// Manages dependency injection and service lifetimes.
class ServiceLocator {
  /// Security service for encryption.
  late SecurityService securityService;

  /// Key manager for master key storage.
  late KeyManager keyManager;

  /// Versioned encryption facade for production reads and writes.
  late VersionedEncryptionService encryptionService;

  /// Local database instance.
  AppDatabase? _database;

  /// Spiritual analyzer service.
  late SpiritualAnalyzer analyzer;

  /// Settings service for user preferences.
  late SettingsService settingsService;

  bool _initialized = false;

  /// Whether the locator currently owns an initialized dependency graph.
  bool get isInitialized => _initialized;

  /// Public getter for the initialized database.
  ///
  /// Failing explicitly is safer than exposing a late-initialization error from
  /// an unrelated call site when a service is accessed too early.
  AppDatabase get database {
    final database = _database;
    if (!_initialized || database == null) {
      throw StateError('ServiceLocator has not been initialized');
    }
    return database;
  }

  /// Initializes and registers all dependencies.
  ///
  /// Initialization is idempotent. This is important for widget tests and
  /// recovery paths that can invoke application setup more than once.
  Future<void> initialize({AppDatabase? testDb}) async {
    if (_initialized) {
      return;
    }

    final database = testDb ?? AppDatabase();
    final nextSettingsService = SettingsService();

    try {
      await nextSettingsService.init();

      void decryptionObserver(DecryptionFailureEvent event) {
        WingLogger.warning(
          'تعذر فك بيانات محلية حساسة',
          tag: 'Decryption',
          data: event.toSafeData(),
        );
      }

      securityService = SecurityService(
        onDecryptionFailure: decryptionObserver,
      );
      keyManager = KeyManager();
      encryptionService = VersionedEncryptionService(
        securityService: securityService,
        keyManager: keyManager,
        onDecryptionFailure: decryptionObserver,
      );
      analyzer = SpiritualAnalyzer();
      settingsService = nextSettingsService;
      _database = database;
      _initialized = true;
    } catch (_) {
      await database.close();
      rethrow;
    }
  }

  /// Resets the service locator and closes the owned database.
  ///
  /// Reset is idempotent so test teardown remains safe even when a setup step
  /// fails or a test closes its database explicitly.
  Future<void> reset() async {
    final database = _database;
    _database = null;
    _initialized = false;

    if (database != null) {
      await database.close();
    }
  }
}
