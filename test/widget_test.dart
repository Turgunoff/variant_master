// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:variant_master/app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // Verify that app title is displayed
    expect(find.text('Test Master'), findsWidgets);

    // Verify that our message is displayed
    expect(find.text('Loyiha tozalandi. Qayta qurish mumkin.'), findsOneWidget);

    // Verify that screen size text is displayed (partial match)
    expect(find.textContaining('Ekran o\'lchami:'), findsOneWidget);
  });
}
