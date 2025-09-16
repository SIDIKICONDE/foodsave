// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:food_save/main.dart';

void main() {
  testWidgets('FoodSave app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: FoodSaveApp()));

    // Verify that the splash screen is displayed
    expect(find.text('FoodSave'), findsOneWidget);
    expect(find.text('Gestion intelligente des aliments'), findsOneWidget);
    
    // Wait for the timer to complete and dispose properly
    await tester.pumpAndSettle();
  });
}
