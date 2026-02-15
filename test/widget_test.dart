import 'package:e_commerc_app/views/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MainButton renders text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MainButton(text: 'Checkout', onTap: () {}),
        ),
      ),
    );

    expect(find.text('Checkout'), findsOneWidget);
  });

  testWidgets('MainButton shows loading indicator', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: MainButton(isLoading: true))),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
