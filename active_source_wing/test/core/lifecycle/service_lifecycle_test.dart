import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wing_of_nostalgia/core/data/app_database.dart';
import 'package:wing_of_nostalgia/core/di/service_locator.dart';
import 'package:wing_of_nostalgia/core/services/auth_service.dart';
import 'package:wing_of_nostalgia/core/services/secure_media_cleanup_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  tearDown(() async {
    await sl.reset();
    AuthService.instance.dispose();
  });

  test('sl.reset closes its database without leaving an open Drift handle',
      () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await sl.initialize(testDb: database);

    await sl.reset();

    expect(sl.isInitialized, isFalse);
    expect(() => sl.database, throwsStateError);
    await expectLater(
      database.select(database.memories).get(),
      throwsA(anything),
    );
  });

  test('sl.initialize can create a fresh graph after a complete reset',
      () async {
    final firstDatabase = AppDatabase.forTesting(NativeDatabase.memory());
    await sl.initialize(testDb: firstDatabase);
    await sl.reset();

    final secondDatabase = AppDatabase.forTesting(NativeDatabase.memory());
    await sl.initialize(testDb: secondDatabase);

    expect(sl.isInitialized, isTrue);
    expect(identical(sl.database, secondDatabase), isTrue);
  });

  test('AuthService.dispose requires a new initialize before a new session',
      () async {
    final authService = AuthService.instance;
    await authService.initialize();
    expect(await authService.authenticate(), isTrue);

    authService.dispose();

    expect(authService.isAuthenticated, isFalse);
    expect(
      () => authService.requireAuthenticated(),
      throwsA(isA<AuthenticationRequiredException>()),
    );

    final freshAuthService = AuthService.instance;
    expect(identical(freshAuthService, authService), isFalse);
    expect(freshAuthService.isAuthenticated, isFalse);
    await freshAuthService.initialize();
    expect(await freshAuthService.authenticate(), isTrue);
  });

  test('SecureMediaCleanupService treats an empty path as a safe no-op',
      () async {
    final cleanupService = SecureMediaCleanupService(
      applicationDirectoryProvider: () async {
        throw StateError('an empty path must not access the filesystem');
      },
    );

    expect(await cleanupService.deleteMediaPath(''), isFalse);
  });
}
