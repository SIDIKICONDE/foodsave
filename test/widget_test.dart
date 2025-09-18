// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:foodsave_app/main.dart';

void main() {
  testWidgets('FoodSave app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FoodSaveApp());

    // Verify that our FoodSave app loads
    // Wait a moment for the BLoC to initialize
    await tester.pumpAndSettle();
    
    // Verify we can find login page elements (après l'initialisation)
    expect(find.text('FoodSave'), findsOneWidget);
    expect(find.text('Connectez-vous à votre compte FoodSave'), findsOneWidget);
    expect(find.text('Continuer sans compte'), findsOneWidget);
  });
}
