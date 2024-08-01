import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gif_search_app/main.dart';
import 'package:gif_search_app/gify_main_page.dart';

// This basic unit test ensures that your main application is built correctly
// and that the main page is displayed as expected
void main() {
  testWidgets('MyApp builds and shows GifyMainPage',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);

    expect(find.byType(GifyMainPage), findsOneWidget);
  });
}
