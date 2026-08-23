import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/services/auth_service.dart';
import 'package:cryptography/cryptography.dart';
import 'package:wing_of_nostalgia/core/security/password_security_utils.dart';
import 'package:wing_of_nostalgia/core/security/security_service.dart';

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

  group('Error Handling - SecurityService', () {
    final service = SecurityService();
    final key = SecretKeyData(List<int>.filled(32, 7));

    test('AES-GCM encryption should handle empty string', () async {
      final result = await service.encrypt('', key);
      expect(result, isNotEmpty);
      expect(await service.decrypt(result, key), isEmpty);
    });

    test('AES-GCM encryption and decryption should be reversible', () async {
      const original = 'Sensitive data: أهلاً وسهلاً';
      final encrypted = await service.encrypt(original, key);
      final decrypted = await service.decrypt(encrypted, key);

      expect(decrypted, original);
    });

    test('AES-GCM encryption with a separate key should work', () async {
      const original = 'Secret message';
      final customKey = SecretKeyData(List<int>.generate(32, (i) => i + 1));

      final encrypted = await service.encrypt(original, customKey);
      final decrypted = await service.decrypt(encrypted, customKey);

      expect(decrypted, original);
    });

    test('Wrong key should reject authenticated ciphertext', () async {
      const original = 'Secret message';
      final encrypted = await service.encrypt(original, key);
      final wrongKey = SecretKeyData(List<int>.filled(32, 8));

      await expectLater(
        service.decrypt(encrypted, wrongKey),
        throwsA(isA<Object>()),
      );
    });

    test('Password strength checker works correctly', () {
      // 'weak' = 4 chars (no length bonus), 1 lowercase = 1
      expect(PasswordSecurityUtils.checkStrength('weak'), 1);
      // 'Stronger' = 8 chars + lowercase + uppercase = 3
      expect(PasswordSecurityUtils.checkStrength('Stronger'), 3);
      // 'Str0nger' = 8 chars + lowercase + uppercase + digit = 4
      expect(PasswordSecurityUtils.checkStrength('Str0nger'), 4);
      // 'Str0ng3r!' = 8 chars + lowercase + uppercase + digit + special = 5
      expect(PasswordSecurityUtils.checkStrength('Str0ng3r!'), 5);
    });

    test('Generate secure password creates valid password', () {
      final password = PasswordSecurityUtils.generate(length: 20);
      expect(password.length, 20);
    });
  });
}
