import '../infrastructure/wing_logger.dart';

/// Thrown when a protected local operation is attempted without a session.
class AuthenticationRequiredException implements Exception {
  const AuthenticationRequiredException();

  @override
  String toString() =>
      'AuthenticationRequiredException: an authenticated local session is required';
}

/// Service for managing the local authentication session.
///
/// This service currently establishes an in-memory local session. It does not
/// claim to verify an external identity; a future identity provider can be
/// added behind this contract without weakening the storage boundary.
class AuthService {
  AuthService._();
  static AuthService? _instance;

  /// Returns the singleton instance of [AuthService].
  static AuthService get instance => _instance ??= AuthService._();

  bool _isInitialized = false;
  bool _isAuthenticated = false;

  /// Initializes the auth service.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _isInitialized = true;
      WingLogger.info('Auth service initialized successfully', tag: 'Auth');
    } catch (e) {
      WingLogger.error('Error initializing auth service: $e', tag: 'Auth');
      rethrow;
    }
  }

  /// Opens the local session.
  ///
  /// This is intentionally a local session contract only. It is not an
  /// external identity check until a real provider is introduced.
  Future<bool> authenticate() async {
    try {
      await initialize();
      _isAuthenticated = true;
      WingLogger.info('Local authentication session opened', tag: 'Auth');
      return true;
    } catch (e) {
      WingLogger.error('Authentication failed: $e', tag: 'Auth');
      return false;
    }
  }

  /// Whether the local session is currently authenticated.
  bool get isAuthenticated => _isAuthenticated;

  /// Throws when a protected local operation lacks an active session.
  void requireAuthenticated() {
    if (!_isAuthenticated) {
      throw const AuthenticationRequiredException();
    }
  }

  /// Logs out the user and invalidates the local session.
  Future<void> logout() async {
    _isAuthenticated = false;
    WingLogger.info('Local authentication session closed', tag: 'Auth');
  }

  /// Disposes resources.
  void dispose() {
    _isAuthenticated = false;
    _isInitialized = false;
    _instance = null;
  }
}
