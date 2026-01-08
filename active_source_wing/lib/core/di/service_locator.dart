import '../data/app_database.dart';
import '../security/security_service.dart';
import '../security/key_manager.dart';
import '../analysis/spiritual_analyzer.dart';
import '../services/settings_service.dart';

/// Singleton instance of ServiceLocator.
final sl = ServiceLocator();

/// Manages dependency injection and service lifetimes.
class ServiceLocator {
  /// Security service for encryption.
  late SecurityService securityService;

  /// Key manager for master key storage.
  late KeyManager keyManager;

  /// Local database instance.
  late AppDatabase _database;

  /// Public getter for database.
  AppDatabase get database => _database;

  /// Spiritual analyzer service.
  late SpiritualAnalyzer analyzer;

  /// Settings service for user preferences.
  late SettingsService settingsService;

  /// Initializes the service locator and registers all dependencies.
  Future<void> initialize({AppDatabase? testDb}) async {
    // Services
    securityService = SecurityService();
    keyManager = KeyManager();
    _database = testDb ?? AppDatabase();
    analyzer = SpiritualAnalyzer();

    settingsService = SettingsService();
    await settingsService.init();
  }

  /// Resets the service locator for tests.
  Future<void> reset() async {
    try {
      await _database.close();
    } catch (_) {
      // Database not initialized, ignore
    }
  }
}
