import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/core/data/app_database.dart';
import 'package:wing_of_nostalgia/core/di/service_locator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    await sl.reset();
  });

  test('initialization is idempotent and keeps the first database', () async {
    final firstDatabase = AppDatabase.forTesting(NativeDatabase.memory());
    final ignoredDatabase = AppDatabase.forTesting(NativeDatabase.memory());

    await sl.initialize(testDb: firstDatabase);
    await sl.initialize(testDb: ignoredDatabase);

    expect(sl.isInitialized, isTrue);
    expect(identical(sl.database, firstDatabase), isTrue);

    await ignoredDatabase.close();
  });

  test('reset clears initialization state and permits a fresh setup', () async {
    final firstDatabase = AppDatabase.forTesting(NativeDatabase.memory());
    await sl.initialize(testDb: firstDatabase);

    await sl.reset();

    expect(sl.isInitialized, isFalse);
    expect(() => sl.database, throwsStateError);

    final secondDatabase = AppDatabase.forTesting(NativeDatabase.memory());
    await sl.initialize(testDb: secondDatabase);

    expect(sl.isInitialized, isTrue);
    expect(identical(sl.database, secondDatabase), isTrue);
  });

  test('reset is safe when called repeatedly', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    await sl.initialize(testDb: database);

    await sl.reset();
    await sl.reset();

    expect(sl.isInitialized, isFalse);
  });
}
