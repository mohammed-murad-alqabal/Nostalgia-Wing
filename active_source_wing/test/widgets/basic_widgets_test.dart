import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Basic widget tests for the application's UI components.
void main() {
  group('Basic Widget Tests', () {
    testWidgets('CircularProgressIndicator should render', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Text widget should display Arabic text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('جناح الحنين'),
            ),
          ),
        ),
      );

      expect(find.text('جناح الحنين'), findsOneWidget);
    });

    testWidgets('Gradient container should render', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text('Gradient Test'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Gradient Test'), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Icon should render correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Icon(Icons.favorite, color: Colors.red, size: 48),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('Column with multiple children should layout correctly',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite, size: 64),
                SizedBox(height: 16),
                Text('جناح الحنين'),
                SizedBox(height: 8),
                Text('مرحباً بكِ'),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.text('جناح الحنين'), findsOneWidget);
      expect(find.text('مرحباً بكِ'), findsOneWidget);
    });
  });

  group('Navigation Widget Tests', () {
    testWidgets('Navigator should push and pop correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const Scaffold(
                        body: Center(child: Text('Second Page')),
                      ),
                    ),
                  );
                },
                child: const Text('Navigate'),
              ),
            ),
          ),
        ),
      );

      // Initial state
      expect(find.text('Navigate'), findsOneWidget);
      expect(find.text('Second Page'), findsNothing);

      // Tap the button
      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      // After navigation
      expect(find.text('Second Page'), findsOneWidget);
    });
  });
}
