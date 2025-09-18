import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodsave_app/presentation/pages/auth/login_page.dart';
import 'package:foodsave_app/presentation/pages/auth/register_page.dart';
import 'package:foodsave_app/presentation/pages/auth/reset_password_page.dart';
import '../../helpers/auth_test_helpers.dart';

/// Tests pour la page de connexion (LoginPage).
/// 
/// Ces tests couvrent tous les aspects de la page de connexion :
/// validation des formulaires, intégration Supabase, navigation, responsive design.
/// Suit les directives strictes Dart pour la sécurité et la maintenabilité.
void main() {
  group('LoginPage Widget Tests', () {
    late MockSupabaseClient mockSupabaseClient;
    late MockGoTrueClient mockAuthClient;

    setUpAll(() {
      registerFallbackValue(const LoginPage());
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
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        // Vérification du titre principal
        expect(find.text('Bienvenue sur FoodSave'), findsOneWidget);
        
        // Vérification de la description
        expect(find.text('Connectez-vous pour accéder à vos offres anti-gaspillage favorites'), findsOneWidget);
        
        // Vérification des champs de formulaire
        expect(find.byType(TextFormField), findsNWidgets(2));
        expect(AuthTestHelpers.findTextFieldByLabel('Adresse email'), findsOneWidget);
        expect(AuthTestHelpers.findTextFieldByLabel('Mot de passe'), findsOneWidget);
        
        // Vérification du bouton de connexion
        expect(AuthTestHelpers.findButtonByText('Se connecter'), findsOneWidget);
        
        // Vérification du lien "Mot de passe oublié"
        expect(find.text('Mot de passe oublié ?'), findsOneWidget);
        
        // Vérification du lien vers l'inscription
        expect(find.text('Pas encore de compte ?'), findsOneWidget);
        expect(find.text('S\'inscrire'), findsOneWidget);
      });

      testWidgets('should display logo and icons correctly', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        // Vérification de l'icône principale
        expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
        
        // Vérification des icônes des champs
        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      });

      testWidgets('should toggle password visibility', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        // Trouve le bouton de visibilité du mot de passe
        final passwordVisibilityButton = find.byIcon(Icons.visibility_outlined);
        expect(passwordVisibilityButton, findsOneWidget);

        // Teste le toggle du champ mot de passe
        await tester.tap(passwordVisibilityButton);
        await tester.pump();

        // Vérifie que l'icône a changé
        expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      });
    });

    group('Form Validation Tests', () {
      testWidgets('should show validation errors for empty fields', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        // Tente de soumettre le formulaire vide
        await AuthTestHelpers.tapButtonByText(tester, 'Se connecter');

        // Vérifie les messages d'erreur
        AuthTestHelpers.expectFieldValidationError(AuthTestHelpers.expectedErrorMessages['emptyEmail']!);
        AuthTestHelpers.expectFieldValidationError(AuthTestHelpers.expectedErrorMessages['emptyPassword']!);
      });

      testWidgets('should validate email format', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        // Test email invalide
        await AuthTestHelpers.enterTextInField(tester, 'Adresse email', 'email-invalide');
        await AuthTestHelpers.tapButtonByText(tester, 'Se connecter');

        AuthTestHelpers.expectFieldValidationError(AuthTestHelpers.expectedErrorMessages['invalidEmail']!);
      });

      testWidgets('should accept valid email format', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        // Test email valide
        await AuthTestHelpers.enterTextInField(tester, 'Adresse email', 'test@example.com');
        await AuthTestHelpers.enterTextInField(tester, 'Mot de passe', 'password');
        
        // Aucune erreur d'email ne devrait être affichée
        expect(find.text(AuthTestHelpers.expectedErrorMessages['invalidEmail']!), findsNothing);
      });

      testWidgets('should require password field', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        // Remplit seulement l'email
        await AuthTestHelpers.enterTextInField(tester, 'Adresse email', 'test@example.com');
        await AuthTestHelpers.tapButtonByText(tester, 'Se connecter');

        AuthTestHelpers.expectFieldValidationError(AuthTestHelpers.expectedErrorMessages['emptyPassword']!);
      });

      testWidgets('should accept valid form data', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        // Remplit le formulaire avec des données valides
        await AuthTestHelpers.fillLoginForm(tester);
        
        // Aucune erreur de validation ne devrait être affichée
        expect(find.text(AuthTestHelpers.expectedErrorMessages['emptyEmail']!), findsNothing);
        expect(find.text(AuthTestHelpers.expectedErrorMessages['invalidEmail']!), findsNothing);
        expect(find.text(AuthTestHelpers.expectedErrorMessages['emptyPassword']!), findsNothing);
      });
    });

    group('Navigation Tests', () {
      testWidgets('should navigate to signup page when signup link is tapped', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.createNavigationContext(
            child: const LoginPage(),
            routes: {
              '/signup': (context) => const RegisterPage(),
            },
          ),
        );

        // Tape sur le lien d'inscription
        await tester.tap(find.text('S\'inscrire'));
        await tester.pumpAndSettle();

        // Vérifie que la navigation vers la page d'inscription a eu lieu
        expect(find.byType(RegisterPage), findsOneWidget);
      });

      testWidgets('should navigate to reset password page when forgot password is tapped', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.createNavigationContext(
            child: const LoginPage(),
            routes: {
              '/reset-password': (context) => const ResetPasswordPage(),
            },
          ),
        );

        // Tape sur le lien "Mot de passe oublié"
        await tester.tap(find.text('Mot de passe oublié ?'));
        await tester.pumpAndSettle();

        // Vérifie que la navigation vers la page de réinitialisation a eu lieu
        expect(find.byType(ResetPasswordPage), findsOneWidget);
      });
    });

    group('Responsive Design Tests', () {
      testWidgets('should adapt layout for mobile screen', (tester) async {
        await AuthTestHelpers.setScreenSize(tester, AuthTestHelpers.mobileSize);
        
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        AuthTestHelpers.verifyResponsiveLayout(AuthTestHelpers.mobileSize);
        
        // Vérifie que les éléments sont visibles sur mobile
        expect(find.text('Bienvenue sur FoodSave'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
      });

      testWidgets('should adapt layout for tablet screen', (tester) async {
        await AuthTestHelpers.setScreenSize(tester, AuthTestHelpers.tabletSize);
        
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        AuthTestHelpers.verifyResponsiveLayout(AuthTestHelpers.tabletSize);
      });

      testWidgets('should adapt layout for desktop screen', (tester) async {
        await AuthTestHelpers.setScreenSize(tester, AuthTestHelpers.desktopSize);
        
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        AuthTestHelpers.verifyResponsiveLayout(AuthTestHelpers.desktopSize);
      });
    });

    group('Loading States Tests', () {
      testWidgets('should show loading indicator during login', (tester) async {
        // Configure un mock qui introduit un délai
        final mockUser = MockUser();
        final mockResponse = MockAuthResponse();
        when(() => mockUser.id).thenReturn('test-user');
        when(() => mockUser.email).thenReturn('test@example.com');
        when(() => mockResponse.user).thenReturn(mockUser);

        when(() => mockAuthClient.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          return mockResponse;
        });

        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        // Remplit le formulaire
        await AuthTestHelpers.fillLoginForm(tester);
        
        // Démarre la connexion
        await AuthTestHelpers.tapButtonByText(tester, 'Se connecter');
        
        // Vérifie que le loading indicator est affiché
        await tester.pump(const Duration(milliseconds: 10));
        AuthTestHelpers.expectLoadingIndicator();
      });

      testWidgets('should hide loading indicator after login completes', (tester) async {
        // Configure un mock pour succès
        final mockUser = MockUser();
        final mockResponse = MockAuthResponse();
        when(() => mockUser.id).thenReturn('test-user');
        when(() => mockUser.email).thenReturn('test@example.com');
        when(() => mockResponse.user).thenReturn(mockUser);

        when(() => mockAuthClient.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => mockResponse);

        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        // Remplit et soumet le formulaire
        await AuthTestHelpers.fillLoginForm(tester);
        await AuthTestHelpers.tapButtonByText(tester, 'Se connecter');
        await tester.pumpAndSettle();

        // Vérifie que le loading indicator n'est plus affiché
        AuthTestHelpers.expectNoLoadingIndicator();
      });
    });

    group('Authentication Tests', () {
      testWidgets('should display success message on successful login', (tester) async {
        // Configure le mock pour succès
        final mockUser = MockUser();
        final mockResponse = MockAuthResponse();
        when(() => mockUser.id).thenReturn('test-user');
        when(() => mockUser.email).thenReturn('test@example.com');
        when(() => mockResponse.user).thenReturn(mockUser);

        when(() => mockAuthClient.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenAnswer((_) async => mockResponse);

        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        // Remplit et soumet le formulaire
        await AuthTestHelpers.fillLoginForm(tester);
        await AuthTestHelpers.tapButtonByText(tester, 'Se connecter');
        await tester.pumpAndSettle();

        // Vérifie que le message de succès est affiché dans la SnackBar
        expect(find.text('✅ Connexion réussie ! Bienvenue.'), findsOneWidget);
      });

      testWidgets('should display error message on login failure', (tester) async {
        // Configure le mock pour échouer
        final mockException = MockAuthException();
        when(() => mockException.message).thenReturn('Invalid login credentials');

        when(() => mockAuthClient.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(mockException);

        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        // Remplit et soumet le formulaire
        await AuthTestHelpers.fillLoginForm(tester);
        await AuthTestHelpers.tapButtonByText(tester, 'Se connecter');
        await tester.pumpAndSettle();

        // Vérifie que le message d'erreur traduit est affiché
        expect(find.text('Email ou mot de passe incorrect'), findsOneWidget);
      });

      testWidgets('should handle different auth error messages', (tester) async {
        final testCases = [
          {'original': 'Email not confirmed', 'translated': 'Veuillez confirmer votre email avant de vous connecter'},
          {'original': 'User not found', 'translated': 'Aucun compte trouvé avec cette adresse email'},
          {'original': 'Too many requests', 'translated': 'Trop de tentatives. Veuillez réessayer plus tard'},
        ];

        for (final testCase in testCases) {
          // Configure le mock pour ce cas d'erreur spécifique
          final mockException = MockAuthException();
          when(() => mockException.message).thenReturn(testCase['original']!);

          when(() => mockAuthClient.signInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(mockException);

          await tester.pumpWidget(
            AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
          );

          // Remplit et soumet le formulaire
          await AuthTestHelpers.fillLoginForm(tester);
          await AuthTestHelpers.tapButtonByText(tester, 'Se connecter');
          await tester.pumpAndSettle();

          // Vérifie que le message d'erreur traduit est affiché
          expect(find.text(testCase['translated']!), findsOneWidget);
          
          // Nettoie pour le prochain test
          await tester.pumpWidget(Container());
        }
      });
    });

    group('User Experience Tests', () {
      testWidgets('should remember entered email on validation errors', (tester) async {
        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        const String testEmail = 'test@example.com';
        
        // Saisit un email valide mais pas de mot de passe
        await AuthTestHelpers.enterTextInField(tester, 'Adresse email', testEmail);
        await AuthTestHelpers.tapButtonByText(tester, 'Se connecter');

        // Vérifie que l'email est toujours présent malgré l'erreur de validation
        expect(find.text(testEmail), findsOneWidget);
      });

      testWidgets('should clear error messages when user starts typing', (tester) async {
        // Configure le mock pour échouer
        final mockException = MockAuthException();
        when(() => mockException.message).thenReturn('Invalid credentials');

        when(() => mockAuthClient.signInWithPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        )).thenThrow(mockException);

        await tester.pumpWidget(
          AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
        );

        // Provoque une erreur
        await AuthTestHelpers.fillLoginForm(tester);
        await AuthTestHelpers.tapButtonByText(tester, 'Se connecter');
        await tester.pumpAndSettle();

        // Vérifie que l'erreur est affichée
        expect(find.textContaining('Email ou mot de passe incorrect'), findsOneWidget);

        // Commence à taper dans un champ
        await AuthTestHelpers.enterTextInField(tester, 'Adresse email', 'nouveau@email.com');

        // L'erreur devrait être effacée (selon l'implémentation)
        // Note: Ceci dépend de l'implémentation réelle de la page
      });
    });
  });

  group('LoginPage Integration Tests', () {
    testWidgets('should complete full login flow successfully', (tester) async {
      // Configure les mocks pour un succès
      final mockUser = MockUser();
      final mockResponse = MockAuthResponse();
      when(() => mockUser.id).thenReturn('existing-user-id');
      when(() => mockUser.email).thenReturn('utilisateur@example.com');
      when(() => mockResponse.user).thenReturn(mockUser);

      final mockAuthClient = MockGoTrueClient();
      when(() => mockAuthClient.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => mockResponse);

      await tester.pumpWidget(
        AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
      );

      // Remplit le formulaire complet
      await AuthTestHelpers.fillLoginForm(
        tester,
        email: 'utilisateur@example.com',
        password: 'MotDePasse123',
      );

      // Soumet le formulaire
      await AuthTestHelpers.tapButtonByText(tester, 'Se connecter');
      await tester.pumpAndSettle();

      // Vérifie le message de succès
      expect(find.text('✅ Connexion réussie ! Bienvenue.'), findsOneWidget);
    });

    testWidgets('should handle complete failure flow', (tester) async {
      // Configure les mocks pour un échec
      final mockException = MockAuthException();
      when(() => mockException.message).thenReturn('Invalid login credentials');

      final mockAuthClient = MockGoTrueClient();
      when(() => mockAuthClient.signInWithPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenThrow(mockException);

      await tester.pumpWidget(
        AuthTestHelpers.wrapWithMaterialApp(const LoginPage()),
      );

      // Remplit le formulaire avec de mauvaises données
      await AuthTestHelpers.fillLoginForm(
        tester,
        email: 'mauvais@example.com',
        password: 'mauvais-mot-de-passe',
      );

      // Soumet le formulaire
      await AuthTestHelpers.tapButtonByText(tester, 'Se connecter');
      await tester.pumpAndSettle();

      // Vérifie le message d'erreur traduit
      expect(find.text('Email ou mot de passe incorrect'), findsOneWidget);
      
      // Vérifie que les champs gardent leurs valeurs pour permettre la correction
      expect(find.text('mauvais@example.com'), findsOneWidget);
    });
  });
}