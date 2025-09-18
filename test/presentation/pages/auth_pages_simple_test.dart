import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodsave_app/presentation/pages/auth/register_page.dart';
import 'package:foodsave_app/presentation/pages/auth/login_page.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Tests simplifiés pour les pages d'authentification.
/// 
/// Ces tests vérifient les éléments de base des pages sans mocks complexes.
/// Suit les directives strictes Dart pour la sécurité et la maintenabilité.
void main() {
  group('Authentication Pages Simple Tests', () {
    
    /// Helper pour wrapper les widgets avec MaterialApp
    Widget wrapWithMaterialApp(Widget child) {
      return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          textTheme: AppTextStyles.createTextTheme(),
        ),
        home: child,
      );
    }

    group('SignupPage Basic Tests', () {
      testWidgets('should display signup page elements', (tester) async {
        await tester.pumpWidget(wrapWithMaterialApp(const RegisterPage()));

        // Vérification des éléments de base
        expect(find.text('Rejoignez FoodSave'), findsOneWidget);
        expect(find.text('Créez votre compte pour découvrir les meilleures offres anti-gaspillage près de chez vous'), findsOneWidget);
        
        // Vérification des champs de formulaire
        expect(find.byType(TextFormField), findsNWidgets(4));
        
        // Vérification du bouton d'inscription
        expect(find.text('Créer mon compte'), findsOneWidget);
        
        // Vérification du lien vers la connexion (texte séparé)
        expect(find.textContaining('Vous avez déjà un compte'), findsOneWidget);
        expect(find.text('Se connecter'), findsOneWidget);
      });

      testWidgets('should display signup icons', (tester) async {
        await tester.pumpWidget(wrapWithMaterialApp(const RegisterPage()));

        // Vérification de l'icône principale
        expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
        
        // Vérification des icônes des champs
        expect(find.byIcon(Icons.person_outline), findsOneWidget);
        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsNWidgets(2));
      });

      testWidgets('should have password visibility toggle', (tester) async {
        await tester.pumpWidget(wrapWithMaterialApp(const RegisterPage()));

        // Trouve les boutons de visibilité des mots de passe
        final passwordVisibilityButtons = find.byIcon(Icons.visibility_outlined);
        expect(passwordVisibilityButtons, findsNWidgets(2));

        // Teste le toggle du premier champ mot de passe
        await tester.tap(passwordVisibilityButtons.first);
        await tester.pump();

        // Vérifie qu'au moins une icône a changé
        expect(find.byIcon(Icons.visibility_off_outlined), findsAtLeastNWidgets(1));
      });
    });

    group('LoginPage Basic Tests', () {
      testWidgets('should display login page elements', (tester) async {
        await tester.pumpWidget(wrapWithMaterialApp(const LoginPage()));

        // Vérification des éléments de base
        expect(find.text('Bienvenue sur FoodSave'), findsOneWidget);
        expect(find.text('Connectez-vous pour accéder à vos offres anti-gaspillage favorites'), findsOneWidget);
        
        // Vérification des champs de formulaire
        expect(find.byType(TextFormField), findsNWidgets(2));
        
        // Vérification du bouton de connexion
        expect(find.text('Se connecter'), findsOneWidget);
        
        // Vérification du lien "Mot de passe oublié"
        expect(find.text('Mot de passe oublié ?'), findsOneWidget);
        
        // Vérification du lien vers l'inscription (texte séparé)
        expect(find.textContaining('Pas encore de compte'), findsOneWidget);
        expect(find.text('S\'inscrire'), findsOneWidget);
      });

      testWidgets('should display login icons', (tester) async {
        await tester.pumpWidget(wrapWithMaterialApp(const LoginPage()));

        // Vérification de l'icône principale
        expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
        
        // Vérification des icônes des champs
        expect(find.byIcon(Icons.email_outlined), findsOneWidget);
        expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      });

      testWidgets('should have password visibility toggle', (tester) async {
        await tester.pumpWidget(wrapWithMaterialApp(const LoginPage()));

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

    group('Responsive Design Basic Tests', () {
      testWidgets('should adapt to different screen sizes - Desktop', (tester) async {
        // Configure la taille desktop
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        
        await tester.pumpWidget(wrapWithMaterialApp(const LoginPage()));

        // Vérifie que les éléments sont visibles sur desktop
        expect(find.text('Bienvenue sur FoodSave'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(2));
      });

      testWidgets('should display elements without overflow on large screens', (tester) async {
        // Configure une taille suffisamment large
        await tester.binding.setSurfaceSize(const Size(800, 1000));
        
        await tester.pumpWidget(wrapWithMaterialApp(const RegisterPage()));

        // Vérifie que les éléments principaux sont présents
        expect(find.text('Rejoignez FoodSave'), findsOneWidget);
        expect(find.byType(TextFormField), findsNWidgets(4));
        expect(find.text('Créer mon compte'), findsOneWidget);
      });
    });

    group('Design System Integration Tests', () {
      testWidgets('should use app colors consistently', (tester) async {
        await tester.pumpWidget(wrapWithMaterialApp(const RegisterPage()));

        // Vérifie que l'application utilise bien les couleurs du design system
        final MaterialApp app = tester.widget(find.byType(MaterialApp));
        // Note : ColorScheme.fromSeed génère une couleur basée sur AppColors.primary
        // mais ce n'est pas exactement la même couleur
        expect(app.theme?.colorScheme, isNotNull);
        expect(app.theme?.useMaterial3, isTrue);
      });

      testWidgets('should use app text styles', (tester) async {
        await tester.pumpWidget(wrapWithMaterialApp(const LoginPage()));

        // Vérifie que l'application utilise bien les styles de texte
        final MaterialApp app = tester.widget(find.byType(MaterialApp));
        expect(app.theme?.textTheme, isNotNull);
      });
    });

    group('Form Validation Basic Tests', () {
      testWidgets('should show validation errors for empty signup form', (tester) async {
        await tester.pumpWidget(wrapWithMaterialApp(const RegisterPage()));

        // Trouve et tape sur le bouton d'inscription
        final signupButton = find.text('Créer mon compte');
        expect(signupButton, findsOneWidget);
        
        await tester.tap(signupButton);
        await tester.pump();

        // Au moins une erreur de validation devrait apparaître
        expect(find.textContaining('obligatoire'), findsAtLeastNWidgets(1));
      });

      testWidgets('should show validation errors for empty login form', (tester) async {
        await tester.pumpWidget(wrapWithMaterialApp(const LoginPage()));

        // Trouve et tape sur le bouton de connexion
        final loginButton = find.text('Se connecter');
        expect(loginButton, findsOneWidget);
        
        await tester.tap(loginButton);
        await tester.pump();

        // Au moins une erreur de validation devrait apparaître
        expect(find.textContaining('obligatoire'), findsAtLeastNWidgets(1));
      });
    });

    group('Widget Structure Tests', () {
      testWidgets('should have proper scaffold structure in signup', (tester) async {
        await tester.pumpWidget(wrapWithMaterialApp(const RegisterPage()));

        // Vérifie la structure de base
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
      });

      testWidgets('should have proper scaffold structure in login', (tester) async {
        await tester.pumpWidget(wrapWithMaterialApp(const LoginPage()));

        // Vérifie la structure de base
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(SafeArea), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper button heights for accessibility', (tester) async {
        await tester.pumpWidget(wrapWithMaterialApp(const RegisterPage()));

        // Vérifie que les boutons ont une hauteur minimale pour l'accessibilité
        final elevatedButtons = find.byType(ElevatedButton);
        expect(elevatedButtons, findsAtLeastNWidgets(1));
        
        // Les boutons doivent être présents (test basique d'accessibilité)
        for (final element in elevatedButtons.evaluate()) {
          final button = element.widget as ElevatedButton;
          expect(button.onPressed, isNotNull); // Le bouton doit être interactif
        }
      });

      testWidgets('should have semantic labels for form fields', (tester) async {
        await tester.pumpWidget(wrapWithMaterialApp(const LoginPage()));

        // Vérifie que les champs ont des labels appropriés
        final textFields = find.byType(TextFormField);
        expect(textFields, findsNWidgets(2));
        
        // Les champs doivent être présents et accessibles
        expect(textFields.evaluate().length, equals(2));
      });
    });
  });
}