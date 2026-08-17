import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() async {
      AuthService.instance.dispose();
      authService = AuthService.instance;
    });

    test('Initial state should be unauthenticated', () {
      expect(authService.isAuthenticated, isFalse);
    });

    test('Initialize should not open a local session', () async {
      await authService.initialize();

      expect(authService.isAuthenticated, isFalse);
    });

    test('Authenticate should return true and set isAuthenticated', () async {
      final result = await authService.authenticate();

      expect(result, isTrue);
      expect(authService.isAuthenticated, isTrue);
    });

    test('Repeated authenticate calls keep the same local session state',
        () async {
      expect(await authService.authenticate(), isTrue);
      expect(await authService.authenticate(), isTrue);
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

    test('Repeated logout calls remain safe and unauthenticated', () async {
      await authService.logout();
      await authService.logout();

      expect(authService.isAuthenticated, isFalse);
    });

    test('Dispose clears the session and allows a fresh local session',
        () async {
      await authService.authenticate();
      authService.dispose();

      final freshAuthService = AuthService.instance;
      expect(freshAuthService.isAuthenticated, isFalse);
      expect(await freshAuthService.authenticate(), isTrue);
    });
  });
}
