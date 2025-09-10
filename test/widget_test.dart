// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nh_timecapsule/main.dart';

void main() {
  testWidgets('NH TimeCapsule app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NHTimeCapsuleApp());

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Verify that the app loads successfully and shows the main title.
    expect(find.text('금융 타임캡슐'), findsOneWidget);

    // Also verify that the app shows the subtitle
    expect(find.text('금융과 함께하는 나만의 감정일기'), findsOneWidget);
  });
}
