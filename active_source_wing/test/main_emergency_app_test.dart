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

    await tester.pumpWidget(
      EmergencyApp(
        incidentId: 'INCIDENT-43',
        onRetry: () async {
          retryCount++;
        },
      ),
    );

    expect(find.text('إعادة المحاولة'), findsOneWidget);

    await tester.tap(find.text('إعادة المحاولة'));
    await tester.pumpAndSettle();

    expect(retryCount, 1);
  });
}
