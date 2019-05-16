// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility that Flutter provides. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:market_my_house/main.dart';
import 'package:market_my_house/property.dart';
import 'package:market_my_house/signup1.dart';
// import 'package:market_my_house/listings.dart';

// import 'package:second/main.dart';

void main() {

  
  print('Testing Login');
  testWidgets('Testing Login', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    expect(find.text('Email'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'mannanabdul.ams@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), '123456');
    await tester.tap(find.byType(Material).at(0));
    // sleep(const Duration(seconds:5));
    expect(find.text(''), findsNothing);

  });
  print('Testing Signup');
  testWidgets('Testing Signup', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(SignUpPage1());
    expect(find.text('Email'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'hadi');
    await tester.enterText(find.byType(TextField).at(1), 'hadi@gmail.com');
    await tester.tap(find.byType(Material).at(0));
    // sleep(const Duration(seconds:5));
    expect(find.text(''), findsNothing);

  });

  print('Testing Property Page');
  testWidgets('Testing Property', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(PropertyPage("-LevxzWafhxb4EA5D8Sg", "Property", null));
    expect(find.text('Property Page'), findsNothing);
    await tester.tap(find.byType(FlatButton).at(0));
    await tester.tap(find.byType(FlatButton).at(1));
    // sleep(const Duration(seconds:5));
    expect(find.text(''), findsNothing);

  });
  print('Testing Drawer');
  testWidgets('Testing Drawer', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(PropertyPage("-LevxzWafhxb4EA5D8Sg", "Property", null));
    expect(find.text('Home'), findsNothing);
    expect(find.text('Bookmarks'), findsNothing);
    await tester.enterText(find.byType(TextField).at(0), 'mannanabdul.ams@gmail.com');
    await tester.enterText(find.byType(TextField).at(1), '123456');
    await tester.tap(find.byType(Material).at(0));
    // sleep(const Duration(seconds:5));
    expect(find.text(''), findsNothing);

  });

  
  
}
