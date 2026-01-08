import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/services/auth_service.dart';
import 'package:wing_of_nostalgia/core/security/secure_data_manager.dart';

/// Error handling and resilience tests.
void main() {
  group('Error Handling - AuthService', () {
    late AuthService authService;

    setUp(() async {
      authService = AuthService.instance;
      await authService.logout();
    });

    test('Should not authenticate twice in a row issue', () async {
      final first = await authService.authenticate();
      final second = await authService.authenticate();

      expect(first, isTrue);
      expect(second, isTrue);
      expect(authService.isAuthenticated, isTrue);
    });

    test('Logout should work even if not authenticated', () async {
      expect(authService.isAuthenticated, isFalse);
      await authService.logout();
      expect(authService.isAuthenticated, isFalse);
    });

    test('Initialize should be idempotent', () async {
      await authService.initialize();
      await authService.initialize();
      await authService.initialize();
      // Should not throw and should still work
      expect(await authService.authenticate(), isTrue);
    });
  });

  group('Error Handling - SecureDataManager', () {
    test('Encryption should handle empty string', () {
      final result = SecureDataManager.encryptData('');
      expect(result, isNotEmpty);
    });

    test('Encryption and decryption should be reversible', () {
      const original = 'Sensitive data: أهلاً وسهلاً';
      final encrypted = SecureDataManager.encryptData(original);
      final decrypted = SecureDataManager.decryptData(encrypted);

      expect(decrypted, original);
    });

    test('Encryption with custom key should work', () {
      const original = 'Secret message';
      const userKey = 'my-secret-key-123';

      final encrypted = SecureDataManager.encryptData(
        original,
        userKey: userKey,
      );
      final decrypted = SecureDataManager.decryptData(
        encrypted,
        userKey: userKey,
      );

      expect(decrypted, original);
    });

    test('Wrong key should throw SecurityException', () {
      const original = 'Secret message';
      final encrypted = SecureDataManager.encryptData(
        original,
        userKey: 'correct-key',
      );

      expect(
        () => SecureDataManager.decryptData(
          encrypted,
          userKey: 'wrong-key',
        ),
        throwsA(isA<SecurityException>()),
      );
    });

    test('Password strength checker works correctly', () {
      // 'weak' = 4 chars (no length bonus), 1 lowercase = 1
      expect(SecureDataManager.checkPasswordStrength('weak'), 1);
      // 'Stronger' = 8 chars + lowercase + uppercase = 3
      expect(SecureDataManager.checkPasswordStrength('Stronger'), 3);
      // 'Str0nger' = 8 chars + lowercase + uppercase + digit = 4
      expect(SecureDataManager.checkPasswordStrength('Str0nger'), 4);
      // 'Str0ng3r!' = 8 chars + lowercase + uppercase + digit + special = 5
      expect(SecureDataManager.checkPasswordStrength('Str0ng3r!'), 5);
    });

    test('Generate secure password creates valid password', () {
      final password = SecureDataManager.generateSecurePassword(length: 20);
      expect(password.length, 20);
    });
  });
}
