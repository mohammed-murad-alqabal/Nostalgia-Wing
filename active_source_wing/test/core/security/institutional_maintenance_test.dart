import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wing_of_nostalgia/core/security/privacy_maintenance_service.dart';
import 'package:wing_of_nostalgia/core/services/safety_box_service.dart';
import 'package:wing_of_nostalgia/core/cognitive/psychological_context_manager.dart';
import 'package:wing_of_nostalgia/core/services/auth_service.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    SharedPreferences.setMockInitialValues({});
  });

  tearDownAll(() async {
    await Hive.close();
  });

  test('Institutionalmaintenance should clear all data systems', () async {
    // 1. Prepare data
    final psychManager = PsychologicalContextManager();
    await psychManager.initialize();

    final safetyService = SafetyBoxService();
    await safetyService.initialize();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('test_key', 'test_value');

    await AuthService.instance.initialize();
    await AuthService.instance.authenticate();

    expect(AuthService.instance.isAuthenticated, isTrue);
    expect(prefs.getString('test_key'), equals('test_value'));

    // 2. Execute maintenance
    await PrivacyMaintenanceService.maintenanceReset();

    // 3. Verify
    final prefsAfter = await SharedPreferences.getInstance();
    expect(prefsAfter.getString('test_key'), isNull);
    expect(AuthService.instance.isAuthenticated, isFalse);

    // Hive checks (deleting disk boxes)
    expect(Hive.isBoxOpen(PsychologicalContextManager.boxName), isFalse);
    expect(Hive.isBoxOpen(SafetyBoxService.boxName), isFalse);
  });
}
