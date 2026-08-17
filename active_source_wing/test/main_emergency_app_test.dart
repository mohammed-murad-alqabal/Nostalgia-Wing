import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/main.dart';

void main() {
  testWidgets('emergency app shows a safe message and incident identifier',
      (tester) async {
    await tester.pumpWidget(const EmergencyApp(incidentId: 'INCIDENT-42'));

    expect(
      find.text('تعذر بدء التطبيق بأمان. يمكنك إعادة المحاولة الآن.'),
      findsOneWidget,
    );
    expect(find.text('رمز الحادثة: INCIDENT-42'), findsOneWidget);
    expect(find.text('إعادة المحاولة'), findsNothing);
  });

  testWidgets('emergency app invokes retry callback once', (tester) async {
    var retryCount = 0;
    final retryCompleted = Completer<void>();

    await tester.pumpWidget(
      EmergencyApp(
        incidentId: 'INCIDENT-43',
        onRetry: () async {
          retryCount++;
          await retryCompleted.future;
        },
      ),
    );

    final retryButton = find.byType(OutlinedButton);
    expect(find.text('إعادة المحاولة'), findsOneWidget);

    await tester.tap(retryButton);
    await tester.pump();
    expect(retryCount, 1);

    // The retry is still running, so a second tap must not invoke it again.
    await tester.tap(retryButton);
    await tester.pump();
    expect(retryCount, 1);

    retryCompleted.complete();
    await tester.pump();
  });
}
