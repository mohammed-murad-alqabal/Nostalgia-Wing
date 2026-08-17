import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() async {
      authService = AuthService.instance;
      await authService.logout();
    });

    test('Initial state should be unauthenticated', () {
      expect(authService.isAuthenticated, isFalse);
    });

    test('Authenticate should return true and set isAuthenticated', () async {
      await authService.initialize();
      final result = await authService.authenticate();

      expect(result, isTrue);
      expect(authService.isAuthenticated, isTrue);
    });

    test('Protected operations require an authenticated session', () async {
      expect(
        authService.requireAuthenticated,
        throwsA(isA<AuthenticationRequiredException>()),
      );

      await authService.authenticate();
      expect(authService.requireAuthenticated, returnsNormally);

      await authService.logout();
      expect(
        authService.requireAuthenticated,
        throwsA(isA<AuthenticationRequiredException>()),
      );
    });

    test('Logout should set isAuthenticated to false', () async {
      await authService.authenticate();
      expect(authService.isAuthenticated, isTrue);

      await authService.logout();
      expect(authService.isAuthenticated, isFalse);
    });
  });
}
