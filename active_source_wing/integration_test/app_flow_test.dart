import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wing_of_nostalgia/main.dart' as app;
import 'package:fl_chart/fl_chart.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End Cognitive Flow', () {
    testWidgets('Verify Intelligence Lab and Privacy Maintenance Action', (
      tester,
    ) async {
      // 1. Start App
      debugPrint('System: Initiating Cognitive Application (API 28)...');
      await app.main();
      await tester.pump();
      final openSessionButton = find.byKey(const Key('open_session_button'));
      if (openSessionButton.evaluate().isNotEmpty) {
        await tester.tap(openSessionButton);
        await tester.pump();
      }

      // 2. Wait for UI to emerge
      debugPrint('System: Starting Deep UI Probe (30s Buffer)...');

      bool found = false;
      for (int i = 0; i < 15; i++) {
        await tester.pump(const Duration(seconds: 2));

        // Search for the actual action button rendered by EnhancedHomeScreen.
        final labAction = find.text('مختبر الذكاء');
        if (labAction.evaluate().isNotEmpty ||
            find.byIcon(Icons.science).evaluate().isNotEmpty) {
          debugPrint(
            'System: SUCCESS -> Intelligence Lab '
            'trigger detected at attempt ${i + 1}',
          );
          found = true;
          break;
        }

        // Diagnostic: What is on screen?
        final allText = find
            .byType(Text)
            .evaluate()
            .map((e) => (e.widget as Text).data)
            .toList();
        debugPrint('System: Probe ${i + 1} -> Found text items: $allText');

        if (allText.any((t) => t?.contains('Error') ?? false)) {
          debugPrint('CRITICAL: Error screen detected!');
          break;
        }
      }

      if (!found) {
        debugPrint('CRITICAL: UI Probe failed. Finalizing diagnostic check...');
        expect(
          found,
          isTrue,
          reason: 'Failed to find main UI after 30 seconds.',
        );
      }

      // 3. Find and Tap 'مختبر الذكاء'
      final labButton = find.text('مختبر الذكاء');
      final labIcon = find.byIcon(Icons.science);
      final Finder trigger =
          labButton.evaluate().isNotEmpty ? labButton : labIcon;

      debugPrint('System: Tapping Intelligence Lab trigger...');
      await tester.ensureVisible(trigger);
      await tester.pump();

      // Accessibility contract: visible critical actions must be discoverable.
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && widget.properties.label == 'مختبر الذكاء',
        ),
        findsWidgets,
      );
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics && widget.properties.label == 'الرئيسية',
        ),
        findsOneWidget,
      );

      await tester.tap(trigger);

      // Wait for screen transition and settle animations (Legacy Buffer)
      await tester.pump(const Duration(seconds: 10));

      // 4. Verify Intelligence Lab Screen
      expect(find.text('مختبر الذكاء المعرفي'), findsOneWidget);

      // 5. Scroll to find components
      debugPrint('System: Scrolling to locate Privacy Maintenance Button...');
      final maintenanceButtonFinder = find.text(
        'صيانة الخصوصية - Privacy Maintenance',
      );

      await tester.scrollUntilVisible(
        maintenanceButtonFinder,
        500.0,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 30, // Optimized for small/slow screens
      );
      await tester.pump(const Duration(seconds: 2));

      // 6. Verify Charts (Legacy Diagnostic Only)
      debugPrint('System: Probing for complex charts...');
      final hasLineChart = find.byType(LineChart).evaluate().isNotEmpty;
      final hasBarChart = find.byType(BarChart).evaluate().isNotEmpty;
      debugPrint(
        'System: Chart Detection Status -> '
        'Line: $hasLineChart, Bar: $hasBarChart',
      );

      // We don't fail here on legacy hardware if they take too long to render
      // as long as the main UI is present.

      // 7. Verify Privacy Maintenance Button
      expect(maintenanceButtonFinder, findsOneWidget);

      // 8. Test maintenance Dialog Flow
      await tester.tap(maintenanceButtonFinder);
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('تأكيد صيانة البيانات وحماية الخصوصية'), findsOneWidget);

      await tester.tap(find.text('إلغاء'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('تأكيد صيانة البيانات وحماية الخصوصية'), findsNothing);
      debugPrint('System: Privacy Maintenance verification complete. Pass.');
    });
  });

  group('Navigation Verification', () {
    testWidgets('Can navigate back from Lab', (tester) async {
      await app.main();
      await tester.pump();
      final openSessionButton = find.byKey(const Key('open_session_button'));
      if (openSessionButton.evaluate().isNotEmpty) {
        await tester.tap(openSessionButton);
        await tester.pump();
      }
      await tester.pump(const Duration(seconds: 10));

      final labButton = find.text('مختبر الذكاء');
      final labIcon = find.byIcon(Icons.science);
      final Finder trigger =
          labButton.evaluate().isNotEmpty ? labButton : labIcon;
      expect(trigger, findsWidgets);
      await tester.ensureVisible(trigger.first);
      await tester.pump();

      await tester.tap(trigger.first);
      await tester.pump(const Duration(seconds: 5));

      // Tap Back (Standard AppBar Back Icon)
      final backButton = find.byType(BackButton);
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton.first);
      } else {
        final backIcon = find.byIcon(Icons.arrow_back);
        if (backIcon.evaluate().isNotEmpty) {
          await tester.tap(backIcon.first);
        } else {
          debugPrint(
            'Cognitive System: Standard Back Button not found, Pop...',
          );
          await tester.pageBack();
        }
      }

      await tester.pump(const Duration(seconds: 5));

      expect(find.text('مختبر الذكاء'), findsWidgets);
    });
  });
}
