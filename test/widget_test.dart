// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility that Flutter provides. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market_my_house/main.dart';
import 'package:market_my_house/login.dart';

// import 'package:second/main.dart';

void main() {
  testWidgets('Testing Login', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    expect(find.text('Email'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'mannanabdul.ams@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), '123456');
    await tester.tap(find.byType(Material).at(0));
    expect(find.byType(FloatingActionButton), findsOneWidget);
    // await tester.tap(find.byType(InkWell));
    // await tester.enterText(find.byType(TextField), 'hello');



    // // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('1'), findsOneWidget);
  });
}
