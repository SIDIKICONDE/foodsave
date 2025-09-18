import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodsave_app/main.dart';

void main() {
  group('FoodSave App Integration Tests', () {
    testWidgets('Test bouton "Continuer sans compte" navigation', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const FoodSaveApp());

      // Wait for the BLoC to initialize
      await tester.pumpAndSettle();

      // Verify we start on login page
      expect(find.text('FoodSave'), findsOneWidget);
      expect(find.text('Connectez-vous à votre compte FoodSave'), findsOneWidget);
      expect(find.text('Continuer sans compte'), findsOneWidget);

      // Tap the "Continuer sans compte" button
      await tester.tap(find.text('Continuer sans compte'));
      await tester.pumpAndSettle();

      // Should navigate to main page (discovery tab)
      expect(find.text('Découverte'), findsWidgets);
      expect(find.text('Bonjour !'), findsOneWidget);
    });

    testWidgets('Test validation champs email/mot de passe', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const FoodSaveApp());
      await tester.pumpAndSettle();

      // Try to login with empty fields
      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Veuillez entrer votre email'), findsOneWidget);
      expect(find.text('Veuillez entrer votre mot de passe'), findsOneWidget);

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'invalid-email');
      await tester.enterText(find.byType(TextFormField).last, '123');
      await tester.tap(find.text('Se connecter'));
      await tester.pumpAndSettle();

      // Should show validation errors
      expect(find.text('Adresse email invalide'), findsOneWidget);
      expect(find.text('Le mot de passe doit contenir au moins 6 caractères'), findsOneWidget);
    });

    testWidgets('Test connexion réussie avec des identifiants valides', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const FoodSaveApp());
      await tester.pumpAndSettle();

      // Enter valid credentials
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      
      // Tap login button
      await tester.tap(find.text('Se connecter'));
      await tester.pump(); // Start the async operation
      
      // Wait for loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Wait for the async operation to complete
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should show success message and navigate to main page
      expect(find.text('Bienvenue Utilisateur Test !'), findsOneWidget);
      
      // Wait a bit more for navigation
      await tester.pumpAndSettle();
      
      // Should be on the main page now
      expect(find.text('Découverte'), findsWidgets);
    });
  });
}