import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wing_of_nostalgia/features/mirror/presentation/screens/intelligence_lab_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    final tempDir = Directory.systemTemp.createTempSync();
    Hive.init(tempDir.path);
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('IntelligenceLabScreen shows charts and engine cards',
      (tester) async {
    // Set larger surface size to ensure slivers are built
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: IntelligenceLabScreen()));
    // Pulse animation starts, so we use pump instead of pumpAndSettle
    await tester.pump(const Duration(seconds: 1));

    // 1. Verify AppBar and Title
    expect(find.text('مختبر الذكاء المعرفي'), findsOneWidget);

    // 2. Verify Central Brain Icon
    expect(find.byIcon(Icons.psychology), findsOneWidget);

    // 3. Verify Engine Cards presence
    expect(find.text('Governance'), findsOneWidget);

    // 4. Scroll to see charts (SliverList is lazy)
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1000));
    await tester.pump();

    // 5. Verify Charts
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.byType(BarChart), findsOneWidget);

    // 6. Verify maintenance Button
    expect(find.text('صيانة الخصوصية - Privacy Maintenance'), findsOneWidget);
  });

  testWidgets('Institutional maintenance shows confirmation dialog',
      (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const MaterialApp(home: IntelligenceLabScreen()));
    await tester.pump(const Duration(seconds: 1));

    // Scroll to maintenance Button
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1500));
    await tester.pump();

    // Tap maintenance Button
    await tester.tap(find.text('صيانة الخصوصية - Privacy Maintenance'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Dialog
    expect(find.text('تأكيد صيانة البيانات وحماية الخصوصية'), findsOneWidget);
    expect(find.text('إلغاء'), findsOneWidget);
    expect(find.text('بدء الصيانة'), findsOneWidget);

    // Tap Cancel
    await tester.tap(find.text('إلغاء'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify Dialog is gone
    expect(find.text('تأكيد صيانة البيانات وحماية الخصوصية'), findsNothing);
  });
}
