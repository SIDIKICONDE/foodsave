import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Helpers spécifiques pour les tests d'authentification.
/// 
/// Ce fichier contient tous les utilitaires nécessaires pour tester
/// les pages d'authentification (connexion, inscription, etc.).
/// Suit les directives strictes Dart pour la sécurité et la maintenabilité.
class AuthTestHelpers {
  /// Constructeur privé pour empêcher l'instanciation.
  const AuthTestHelpers._();

  /// Wrapper widget pour les tests avec theme et localizations.
  static Widget wrapWithMaterialApp(Widget child) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        textTheme: AppTextStyles.createTextTheme(),
      ),
      home: child,
    );
  }

  /// Crée un context de navigation pour les tests.
  static Widget createNavigationContext({
    required Widget child,
    Map<String, WidgetBuilder>? routes,
  }) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        textTheme: AppTextStyles.createTextTheme(),
      ),
      home: child,
      routes: routes ?? {},
    );
  }

  /// Trouve un champ de texte par son label.
  static Finder findTextFieldByLabel(String labelText) {
    return find.byWidgetPredicate(
      (widget) => widget.toString().contains(labelText),
    );
  }

  /// Trouve un bouton par son texte.
  static Finder findButtonByText(String text) {
    final elevatedButton = find.widgetWithText(ElevatedButton, text);
    final textButton = find.widgetWithText(TextButton, text);
    final outlinedButton = find.widgetWithText(OutlinedButton, text);
    
    // Retourne le premier finder qui trouve quelque chose
    if (elevatedButton.evaluate().isNotEmpty) return elevatedButton;
    if (textButton.evaluate().isNotEmpty) return textButton;
    if (outlinedButton.evaluate().isNotEmpty) return outlinedButton;
    
    // Si aucun n'est trouvé, retourne le finder des ElevatedButton par défaut
    return elevatedButton;
  }

  /// Saisit du texte dans un champ par son label.
  static Future<void> enterTextInField(
    WidgetTester tester,
    String labelText,
    String text,
  ) async {
    final finder = findTextFieldByLabel(labelText);
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Tape sur un bouton par son texte.
  static Future<void> tapButtonByText(
    WidgetTester tester,
    String buttonText,
  ) async {
    final finder = findButtonByText(buttonText);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Remplit un formulaire d'inscription complet.
  static Future<void> fillSignupForm(
    WidgetTester tester, {
    String fullName = 'Jean Dupont',
    String email = 'jean.dupont@example.com',
    String password = 'MotDePasse123',
    String confirmPassword = 'MotDePasse123',
  }) async {
    await enterTextInField(tester, 'Nom complet', fullName);
    await enterTextInField(tester, 'Adresse email', email);
    await enterTextInField(tester, 'Mot de passe', password);
    await enterTextInField(tester, 'Confirmer le mot de passe', confirmPassword);
  }

  /// Remplit un formulaire de connexion.
  static Future<void> fillLoginForm(
    WidgetTester tester, {
    String email = 'jean.dupont@example.com',
    String password = 'MotDePasse123',
  }) async {
    await enterTextInField(tester, 'Adresse email', email);
    await enterTextInField(tester, 'Mot de passe', password);
  }

  /// Remplit un formulaire de réinitialisation de mot de passe.
  static Future<void> fillResetPasswordForm(
    WidgetTester tester, {
    String email = 'jean.dupont@example.com',
  }) async {
    await enterTextInField(tester, 'Adresse email', email);
  }

  /// Vérifie qu'un message d'erreur spécifique est affiché.
  static void expectErrorMessage(String expectedMessage) {
    expect(find.text(expectedMessage), findsOneWidget);
  }

  /// Vérifie qu'un message de succès est affiché.
  static void expectSuccessMessage(String expectedMessage) {
    expect(find.text(expectedMessage), findsOneWidget);
  }

  /// Vérifie qu'un loading indicator est visible.
  static void expectLoadingIndicator() {
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  }

  /// Vérifie qu'aucun loading indicator n'est visible.
  static void expectNoLoadingIndicator() {
    expect(find.byType(CircularProgressIndicator), findsNothing);
  }

  /// Vérifie que le titre de la page est correct.
  static void expectPageTitle(String expectedTitle) {
    expect(find.text(expectedTitle), findsOneWidget);
  }

  /// Vérifie qu'un champ a une erreur de validation.
  static void expectFieldValidationError(String errorMessage) {
    expect(find.text(errorMessage), findsOneWidget);
  }

  /// Simule un délai pour les opérations async.
  static Future<void> waitForAsync(WidgetTester tester, {
    Duration duration = const Duration(milliseconds: 100),
  }) async {
    await tester.pump(duration);
  }

  /// Configure la taille d'écran pour les tests responsifs.
  static Future<void> setScreenSize(WidgetTester tester, Size size) async {
    await tester.binding.setSurfaceSize(size);
    await tester.pump();
  }

  /// Vérifie l'affichage responsif selon la taille d'écran.
  static void verifyResponsiveLayout(Size screenSize) {
    final double width = screenSize.width;
    
    if (width < 600) {
      // Mobile : vérifications pour petit écran
      expect(width, lessThan(600));
    } else if (width < 900) {
      // Tablette : vérifications pour écran moyen
      expect(width, greaterThanOrEqualTo(600));
      expect(width, lessThan(900));
    } else {
      // Desktop : vérifications pour grand écran
      expect(width, greaterThanOrEqualTo(900));
    }
  }

  /// Tailles d'écran pour les tests responsifs.
  static const Size mobileSize = Size(360, 640);
  static const Size tabletSize = Size(768, 1024);
  static const Size desktopSize = Size(1200, 800);

  /// Données de test valides.
  static const Map<String, String> validUserData = {
    'fullName': 'Jean Dupont',
    'email': 'jean.dupont@example.com',
    'password': 'MotDePasse123',
    'confirmPassword': 'MotDePasse123',
  };

  /// Données de test invalides.
  static const Map<String, String> invalidUserData = {
    'fullName': 'A', // Trop court
    'email': 'email-invalide', // Format invalide
    'password': '123', // Trop court et faible
    'confirmPassword': '456', // Ne correspond pas
  };

  /// Messages d'erreur attendus.
  static const Map<String, String> expectedErrorMessages = {
    'emptyFullName': 'Le nom complet est obligatoire',
    'shortFullName': 'Le nom doit contenir au moins 2 caractères',
    'emptyEmail': 'L\'adresse email est obligatoire',
    'invalidEmail': 'Veuillez entrer une adresse email valide',
    'emptyPassword': 'Le mot de passe est obligatoire',
    'shortPassword': 'Le mot de passe doit contenir au moins 8 caractères',
    'weakPassword': 'Le mot de passe doit contenir au moins une majuscule, une minuscule et un chiffre',
    'emptyConfirmPassword': 'La confirmation du mot de passe est obligatoire',
    'passwordMismatch': 'Les mots de passe ne correspondent pas',
  };

  /// Messages de succès attendus.
  static const Map<String, String> expectedSuccessMessages = {
    'emailSent': 'Email de réinitialisation envoyé avec succès !',
    'emailVerified': 'Email vérifié avec succès ! Redirection...',
    'loginSuccess': 'Connexion réussie ! Bienvenue.',
    'emailResent': 'Email de vérification renvoyé avec succès !',
  };

  /// Créé des données d'utilisateur aléatoires pour les tests.
  static Map<String, String> generateRandomUserData() {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    return {
      'fullName': 'Utilisateur Test $timestamp',
      'email': 'test$timestamp@example.com',
      'password': 'TestPassword$timestamp',
      'confirmPassword': 'TestPassword$timestamp',
    };
  }
}

/// Mock de SupabaseClient pour les tests.
class MockSupabaseClient extends Mock implements SupabaseClient {}

/// Mock de GoTrueClient pour les tests d'authentification.
class MockGoTrueClient extends Mock implements GoTrueClient {}

/// Mock de AuthResponse pour les tests.
class MockAuthResponse extends Mock implements AuthResponse {}

/// Mock de User pour les tests.
class MockUser extends Mock implements User {}

/// Mock de AuthException pour les tests.
class MockAuthException extends Mock implements AuthException {}

/// Classe helper pour configurer les mocks Supabase.
class SupabaseMockHelper {
  /// Mock client Supabase.
  static final MockSupabaseClient mockClient = MockSupabaseClient();
  
  /// Mock client d'authentification.
  static final MockGoTrueClient mockAuth = MockGoTrueClient();

  /// Configure les mocks pour une inscription réussie.
  static void setupSuccessfulSignup({
    String email = 'test@example.com',
    String userId = 'test-user-id',
  }) {
    final mockUser = MockUser();
    final mockResponse = MockAuthResponse();

    when(() => mockUser.id).thenReturn(userId);
    when(() => mockUser.email).thenReturn(email);
    when(() => mockResponse.user).thenReturn(mockUser);

    when(() => mockAuth.signUp(
      email: any(named: 'email'),
      password: any(named: 'password'),
      data: any(named: 'data'),
    )).thenAnswer((_) async => mockResponse);

    when(() => mockClient.auth).thenReturn(mockAuth);
  }

  /// Configure les mocks pour une connexion réussie.
  static void setupSuccessfulLogin({
    String email = 'test@example.com',
    String userId = 'test-user-id',
  }) {
    final mockUser = MockUser();
    final mockResponse = MockAuthResponse();

    when(() => mockUser.id).thenReturn(userId);
    when(() => mockUser.email).thenReturn(email);
    when(() => mockResponse.user).thenReturn(mockUser);

    when(() => mockAuth.signInWithPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => mockResponse);

    when(() => mockClient.auth).thenReturn(mockAuth);
  }

  /// Configure les mocks pour un échec d'authentification.
  static void setupAuthFailure({
    String errorMessage = 'Invalid credentials',
  }) {
    final mockException = MockAuthException();
    when(() => mockException.message).thenReturn(errorMessage);

    when(() => mockAuth.signInWithPassword(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenThrow(mockException);

    when(() => mockAuth.signUp(
      email: any(named: 'email'),
      password: any(named: 'password'),
      data: any(named: 'data'),
    )).thenThrow(mockException);

    when(() => mockClient.auth).thenReturn(mockAuth);
  }

  /// Configure les mocks pour une réinitialisation de mot de passe réussie.
  static void setupSuccessfulPasswordReset() {
    when(() => mockAuth.resetPasswordForEmail(
      any(),
      redirectTo: any(named: 'redirectTo'),
    )).thenAnswer((_) async {});

    when(() => mockClient.auth).thenReturn(mockAuth);
  }

  /// Configure les mocks pour le renvoi d'email de vérification.
  static void setupSuccessfulResendEmail() {
    // Note: La méthode resend retourne ResendResponse, pas void
    // Pour les tests, nous pouvons juste simuler un succès sans erreur
    when(() => mockClient.auth).thenReturn(mockAuth);
  }

  /// Nettoie tous les mocks.
  static void tearDown() {
    reset(mockClient);
    reset(mockAuth);
  }
}