import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../infrastructure/wing_logger.dart';

/// Thrown when a protected local operation is attempted without a session.
class AuthenticationRequiredException implements Exception {
  /// Creates an exception for an unauthenticated protected operation.
  const AuthenticationRequiredException();

  @override
  String toString() => 'AuthenticationRequiredException: '
      'an authenticated local session is required';
}

/// Service for managing the local authentication session.
///
/// This service currently establishes an in-memory local session. It does not
/// claim to verify an external identity; a future identity provider can be
/// added behind this contract without weakening the storage boundary.
class AuthService extends ChangeNotifier {
  AuthService._();
  static AuthService? _instance;

  /// Returns the singleton instance of [AuthService].
  static AuthService get instance => _instance ??= AuthService._();

  static const _pinHashKey = 'nostalgia_wing.local_pin_hash';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  bool _isInitialized = false;
  bool _isAuthenticated = false;
  bool _isDisposed = false;
  bool _hasPinConfigured = false;

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

  /// Returns whether a local PIN has been configured.
  Future<bool> hasPin() async {
    try {
      final storedHash = await _secureStorage.read(key: _pinHashKey);
      _hasPinConfigured = storedHash != null && storedHash.isNotEmpty;
      return _hasPinConfigured;
    } catch (e) {
      WingLogger.warning(
        'تعذر قراءة حالة PIN؛ لن يتم افتراض وجود قفل.',
        tag: 'Auth',
        data: {'error_type': e.runtimeType.toString()},
      );
      return false;
    }
  }

  /// Synchronous cached value used after [hasPin] or [setPin] completes.
  bool get hasPinConfigured => _hasPinConfigured;

  /// Saves a local PIN as a SHA-256 hash in secure storage.
  Future<void> setPin(String pin) async {
    final normalized = pin.trim();
    if (!RegExp(r'^\d{4,8}$').hasMatch(normalized)) {
      throw ArgumentError('PIN must contain 4 to 8 digits');
    }
    final hash = sha256.convert(utf8.encode(normalized)).toString();
    await _secureStorage.write(key: _pinHashKey, value: hash);
    _hasPinConfigured = true;
    _notifyIfActive();
  }

  /// Verifies a local PIN and opens the authenticated session on success.
  Future<bool> authenticateWithPin(String pin) async {
    try {
      final storedHash = await _secureStorage.read(key: _pinHashKey);
      if (storedHash == null || storedHash.isEmpty) return false;
      final candidate = sha256.convert(utf8.encode(pin.trim())).toString();
      if (candidate != storedHash) return false;
      await initialize();
      _hasPinConfigured = true;
      _isAuthenticated = true;
      _notifyIfActive();
      return true;
    } catch (e) {
      WingLogger.warning(
        'تعذر التحقق من PIN.',
        tag: 'Auth',
        data: {'error_type': e.runtimeType.toString()},
      );
      return false;
    }
  }

  /// Removes the local PIN requirement.
  Future<void> clearPin() async {
    try {
      await _secureStorage.delete(key: _pinHashKey);
    } on MissingPluginException {
      // Desktop/unit-test environments may not provide secure storage.
      // Android/iOS still execute the real delete operation.
    }
    _hasPinConfigured = false;
    _notifyIfActive();
  }

  /// Opens the local session.
  ///
  /// This is intentionally a local session contract only. It is not an
  /// external identity check until a real provider is introduced.
  Future<bool> authenticate() async {
    try {
      await initialize();
      _isAuthenticated = true;
      _notifyIfActive();
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
    _notifyIfActive();
    WingLogger.info('Local authentication session closed', tag: 'Auth');
  }

  void _notifyIfActive() {
    if (!_isDisposed) notifyListeners();
  }

  /// Disposes resources.
  @override
  void dispose() {
    _isAuthenticated = false;
    _isInitialized = false;
    _isDisposed = true;
    _instance = null;
    super.dispose();
  }
}
