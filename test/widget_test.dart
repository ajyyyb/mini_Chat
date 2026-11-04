import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:chat_jasoo/components/my_button.dart';

void main() {
  testWidgets('MyButton shows its own text and reports taps', (tester) async {
    var taps = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: MyButton(text: 'Register', onTap: () => taps++)),
    ));

    expect(find.text('Register'), findsOneWidget);
    expect(find.text('Login'), findsNothing);

    await tester.tap(find.text('Register'));
    expect(taps, 1);
  });
}
