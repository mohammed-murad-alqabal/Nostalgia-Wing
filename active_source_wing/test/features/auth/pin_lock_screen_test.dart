import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wing_of_nostalgia/features/auth/screens/pin_lock_screen.dart';

void main() {
  testWidgets('PIN lock screen exposes an accessible unlock flow',
      (tester) async {
    var unlocked = false;

    await tester.pumpWidget(
      MaterialApp(
        home: PinLockScreen(onUnlocked: () => unlocked = true),
      ),
    );

    expect(find.text('الجلسة مقفلة'), findsOneWidget);
    expect(
        find.text('أدخل رمز PIN المحلي للوصول إلى ذكرياتك.'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('فتح التطبيق'), findsOneWidget);
    expect(unlocked, isFalse);
  });
}
