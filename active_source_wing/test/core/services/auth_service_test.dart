import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/services/auth_service.dart';

void main() {
  group('AuthService', () {
    late AuthService authService;

    setUp(() async {
      authService = AuthService.instance;
      // Ensure clean state if possible
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

    test('Logout should set isAuthenticated to false', () async {
      await authService.authenticate();
      expect(authService.isAuthenticated, isTrue);

      await authService.logout();
      expect(authService.isAuthenticated, isFalse);
    });
  });
}
