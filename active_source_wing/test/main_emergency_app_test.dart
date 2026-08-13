import 'package:flutter_test/flutter_test.dart';
import 'package:wing_of_nostalgia/main.dart';

void main() {
  testWidgets('emergency app shows a safe message and incident identifier',
      (tester) async {
    await tester.pumpWidget(const EmergencyApp(incidentId: 'INCIDENT-42'));

    expect(
      find.text('تعذر بدء التطبيق بأمان. يرجى إغلاقه ثم إعادة فتحه.'),
      findsOneWidget,
    );
    expect(find.text('رمز الحادثة: INCIDENT-42'), findsOneWidget);
  });
}
