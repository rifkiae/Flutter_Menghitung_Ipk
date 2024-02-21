import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:helloword/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('Hello World'), findsOneWidget);

    // This part is added to check the counter increment.
    // Tap the screen, or you can replace it with tapping an icon or button that triggers the counter increment.
    await tester.tap(find.text('Hello World'));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('Hello World'), findsNothing);
  });
}
