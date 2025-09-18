import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodsave_app/presentation/pages/auth/register_page.dart';
import 'package:foodsave_app/presentation/pages/auth/email_verification_page.dart';
import 'package:foodsave_app/presentation/pages/auth/login_page.dart';
import '../../helpers/auth_test_helpers.dart';

/// Tests pour la page d'inscription (SignupPage).
/// 
/// Ces tests couvrent tous les aspects de la page d'inscription :
/// validation des formulaires, intégration Supabase, navigation, responsive design.
/// Suit les directives strictes Dart pour la sécurité et la maintenabilité.
void main() {
  group('SignupPage Widget Tests', () {
    late MockSupabaseClient mockSupabaseClient;
    late MockGoTrueClient mockAuthClient;

    setUpAll(() {
      registerFallbackValue(const RegisterPage());
      registerFallbackValue(Uri.parse('https://example.com'));
    });

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      mockAuthClient = MockGoTrueClient();
      when(() => mockSupabaseClient.auth).thenReturn(mockAuthClient);
    });

    tearDown(() {
      reset(mockSupabaseClient);
      reset(mockAuthClient);
    });

    group('UI Elements Tests', () {
      testWidgets('should display all required UI elements', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        // Vérification du titre principal
        expect(find.text('Rejoignez FoodSave'), findsOneWidget);
        
        // Vérification de la description
        expect(find.text('Créez votre compte pour découvrir les meilleures offres anti-gaspillage près de chez vous'), findsOneWidget);
        
        // Vérification des champs de formulaire
        expect(find.byType(TextFormField), findsNWidgets(4));
        expect(AuthTestHelpers.findTextFieldByLabel('Nom complet'), findsOneWidget);
        expect(AuthTestHelpers.findTextFieldByLabel('Adresse email'), findsOneWidget);
        expect(AuthTestHelpers.findTextFieldByLabel('Mot de passe'), findsOneWidget);
        expect(AuthTestHelpers.findTextFieldByLabel('Confirmer le mot de passe'), findsOneWidget);
        
        // Vérification du bouton d'inscription
        expect(AuthTestHelpers.findButtonByText('Créer mon compte'), findsOneWidget);
        
        // Vérification du lien vers la connexion
        expect(find.text('Vous avez déjà un compte ?'), findsOneWidget);
        expect(find.text('Se connecter'), findsOneWidget);
      });

      testWidgets('should display logo and icons correctly', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        // Vérification de l'icône principale
        expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
        
        // Vérification des icônes des champs
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsNWidgets(2));
      });

      testWidgets('should toggle password visibility', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        // Trouve les boutons de visibilité des mots de passe
        final passwordVisibilityButtons = find.byType(IconButton);
        expect(passwordVisibilityButtons, findsNWidgets(2));

        // Teste le toggle du premier champ mot de passe
        await tester.tap(passwordVisibilityButtons.first);
        await tester.pump();

        // Vérifie que l'icône a changé
        expect(find.byIcon(Icons.visibility_off_outlined), findsAtLeastNWidgets(1));
      });
    });

    group('Form Validation Tests', () {
      testWidgets('should show validation errors for empty fields', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        // Tente de soumettre le formulaire vide
        await AuthTestHelpers.tapButtonByText(tester, 'Créer mon compte');

        // Vérifie les messages d'erreur
        AuthTestHelpers.expectFieldValidationError(AuthTestHelpers.expectedErrorMessages['emptyFullName']!);
        AuthTestHelpers.expectFieldValidationError(AuthTestHelpers.expectedErrorMessages['emptyEmail']!);
        AuthTestHelpers.expectFieldValidationError(AuthTestHelpers.expectedErrorMessages['emptyPassword']!);
        AuthTestHelpers.expectFieldValidationError(AuthTestHelpers.expectedErrorMessages['emptyConfirmPassword']!);
      });

      testWidgets('should validate full name correctly', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        // Test nom trop court
        await AuthTestHelpers.enterTextInField(tester, 'Nom complet', 'A');
        await AuthTestHelpers.tapButtonByText(tester, 'Créer mon compte');

        AuthTestHelpers.expectFieldValidationError(AuthTestHelpers.expectedErrorMessages['shortFullName']!);
      });

      testWidgets('should validate email format', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        // Test email invalide
        await AuthTestHelpers.enterTextInField(tester, 'Adresse email', 'email-invalide');
        await AuthTestHelpers.tapButtonByText(tester, 'Créer mon compte');

        AuthTestHelpers.expectFieldValidationError(AuthTestHelpers.expectedErrorMessages['invalidEmail']!);
      });

      testWidgets('should validate password strength', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        // Test mot de passe trop court
        await AuthTestHelpers.enterTextInField(tester, 'Mot de passe', '123');
        await AuthTestHelpers.tapButtonByText(tester, 'Créer mon compte');

        AuthTestHelpers.expectFieldValidationError(AuthTestHelpers.expectedErrorMessages['shortPassword']!);
      });

      testWidgets('should validate password complexity', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        // Test mot de passe faible (sans majuscule, minuscule et chiffre)
        await AuthTestHelpers.enterTextInField(tester, 'Mot de passe', 'motdepasse');
        await AuthTestHelpers.tapButtonByText(tester, 'Créer mon compte');

        AuthTestHelpers.expectFieldValidationError(AuthTestHelpers.expectedErrorMessages['weakPassword']!);
      });

      testWidgets('should validate password confirmation', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        // Test mots de passe ne correspondent pas
        await AuthTestHelpers.enterTextInField(tester, 'Mot de passe', 'MotDePasse123');
        await AuthTestHelpers.enterTextInField(tester, 'Confirmer le mot de passe', 'AutreMotDePasse123');
        await AuthTestHelpers.tapButtonByText(tester, 'Créer mon compte');

        AuthTestHelpers.expectFieldValidationError(AuthTestHelpers.expectedErrorMessages['passwordMismatch']!);
      });

      testWidgets('should accept valid form data', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        // Remplit le formulaire avec des données valides
        await AuthTestHelpers.fillSignupForm(tester);
        
        // Aucune erreur de validation ne devrait être affichée
        expect(find.text(AuthTestHelpers.expectedErrorMessages['emptyFullName']!), findsNothing);
        expect(find.text(AuthTestHelpers.expectedErrorMessages['invalidEmail']!), findsNothing);
        expect(find.text(AuthTestHelpers.expectedErrorMessages['shortPassword']!), findsNothing);
        expect(find.text(AuthTestHelpers.expectedErrorMessages['passwordMismatch']!), findsNothing);
      });
    });

    group('Navigation Tests', () {
      testWidgets('should navigate to login page when login link is tapped', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.createNavigationContext(
            child: const RegisterPage(),
            routes: {
              '/login': (context) => const LoginPage(),
            },
          ),
        );

        // Tape sur le lien de connexion
        await tester.tap(find.text('Se connecter'));
        await tester.pumpAndSettle();

        // Vérifie que la navigation vers la page de connexion a eu lieu
        expect(find.byType(LoginPage), findsOneWidget);
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('should adapt layout for mobile screen', (tester) async {
        await AuthTestHelpers.setScreenSize(tester, AuthTestHelpers.mobileSize);
        
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        AuthTestHelpers.verifyResponsiveLayout(AuthTestHelpers.mobileSize);
        
        // Vérifie que les éléments sont visibles sur mobile
        expect(find.text('Rejoignez FoodSave'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(4));
      });

      testWidgets('should adapt layout for tablet screen', (tester) async {
        await AuthTestHelpers.setScreenSize(tester, AuthTestHelpers.tabletSize);
        
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        AuthTestHelpers.verifyResponsiveLayout(AuthTestHelpers.tabletSize);
      });

      testWidgets('should adapt layout for desktop screen', (tester) async {
        await AuthTestHelpers.setScreenSize(tester, AuthTestHelpers.desktopSize);
        
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        AuthTestHelpers.verifyResponsiveLayout(AuthTestHelpers.desktopSize);
      });
    });

    group('Loading States Tests', () {
      testWidgets('should show loading indicator during signup', (tester) async {
        // Configure un mock qui introduit un délai
        final mockUser = MockUser();
        final mockResponse = MockAuthResponse();
        when(() => mockUser.id).thenReturn('test-user');
        when(() => mockUser.email).thenReturn('test@example.com');
        when(() => mockResponse.user).thenReturn(mockUser);

        when(() => mockAuthClient.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          data: any(named: 'data'),
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return mockResponse;
        });

        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        // Remplit le formulaire
        await AuthTestHelpers.fillSignupForm(tester);
        
        // Démarre l'inscription
        await AuthTestHelpers.tapButtonByText(tester, 'Créer mon compte');
        
        // Vérifie que le loading indicator est affiché
        await tester.pump(const Duration(milliseconds: 10));
        AuthTestHelpers.expectLoadingIndicator();
      });
    });

    group('Error Handling Tests', () {
      testWidgets('should display error message on signup failure', (tester) async {
        // Configure le mock pour échouer
        final mockException = MockAuthException();
        when(() => mockException.message).thenReturn('Cette adresse email est déjà utilisée');

        when(() => mockAuthClient.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          data: any(named: 'data'),
        )).thenThrow(mockException);

        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const RegisterPage()),
        );

        // Remplit et soumet le formulaire
        await AuthTestHelpers.fillSignupForm(tester);
        await AuthTestHelpers.tapButtonByText(tester, 'Créer mon compte');
        await tester.pumpAndSettle();

        // Vérifie que le message d'erreur est affiché
        expect(find.text('Cette adresse email est déjà utilisée'), findsOneWidget);
      });
    });
  });

  group('SignupPage Integration Tests', () {
    testWidgets('should complete full signup flow successfully', (tester) async {
      // Configure les mocks pour un succès
      final mockUser = MockUser();
      final mockResponse = MockAuthResponse();
      when(() => mockUser.id).thenReturn('new-user-id');
      when(() => mockUser.email).thenReturn('nouveau@example.com');
      when(() => mockResponse.user).thenReturn(mockUser);

      final mockAuthClient = MockGoTrueClient();
      when(() => mockAuthClient.signUp(
        email: any(named: 'email'),
        password: any(named: 'password'),
        data: any(named: 'data'),
      )).thenAnswer((_) async => mockResponse);

      await tester.pumpWidget(
        AuthTestHelpers.createNavigationContext(
          child: const RegisterPage(),
          routes: {
            '/email-verification': (context) => const EmailVerificationPage(
              email: 'nouveau@example.com',
            ),
          },
        ),
      );

      // Remplit le formulaire complet
      await AuthTestHelpers.fillSignupForm(
        tester,
        fullName: 'Nouvel Utilisateur',
        email: 'nouveau@example.com',
        password: 'MotDePasse123',
        confirmPassword: 'MotDePasse123',
      );

      // Soumet le formulaire
      await AuthTestHelpers.tapButtonByText(tester, 'Créer mon compte');
      await tester.pumpAndSettle();

      // Vérifie la navigation vers la page de vérification d'email
      expect(find.byType(EmailVerificationPage), findsOneWidget);
    });
  });
}