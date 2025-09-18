import 'package:flutter/material.dart';
import 'package:foodsave_app/presentation/pages/auth/login_page.dart';
import 'package:foodsave_app/presentation/pages/home/main_page.dart';
import 'package:foodsave_app/presentation/pages/all_baskets/all_baskets_page.dart';
import 'package:foodsave_app/presentation/pages/baskets_map/baskets_map_page.dart';
import 'package:foodsave_app/presentation/pages/basket_detail/basket_detail_page.dart';
import 'package:foodsave_app/presentation/pages/onboarding/onboarding_page.dart';
import 'package:foodsave_app/presentation/pages/maps/enhanced_map_page.dart';
import 'package:foodsave_app/core/demo/demo_data_service.dart';

/// Configuration des routes de l'application FoodSave.
///
/// Cette classe centralise la gestion de toutes les routes de navigation
/// et les dépendances nécessaires pour chaque page.
class AppRoutes {
  /// Constructeur privé pour empêcher l'instanciation.
  const AppRoutes._();

  // === NOMS DES ROUTES ===

  /// Route de la page de connexion.
  static const String login = '/login';

  /// Route de la page d'onboarding.
  static const String onboarding = '/onboarding';

  /// Route de la page principale.
  static const String home = '/home';

  /// Route de la page de tous les paniers.
  static const String allBaskets = '/all-baskets';

  /// Route de la page de carte des paniers.
  static const String basketsMap = '/baskets-map';

  /// Route de la page de carte Google Maps.
  static const String mapPage = '/map';

  /// Route de la page de détail d'un panier.
  static const String basketDetail = '/basket-detail';

  /// Route initiale de l'application.
  static const String initial = login;

  // === GÉNÉRATEUR DE ROUTES ===

  /// Génère les routes de l'application.
  ///
  /// [settings] : Paramètres de la route demandée.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _buildRoute(
          const LoginPage(),
          settings: settings,
        );

      case onboarding:
        return _buildRoute(
          const OnboardingPage(),
          settings: settings,
        );

      case home:
        return _buildRoute(
          const MainPage(),
          settings: settings,
        );

      case allBaskets:
        return _buildRoute(
          const AllBasketsPage(), // TODO: Ajouter BlocProvider avec vraies dépendances
          settings: settings,
        );

      case basketsMap:
        return _buildRoute(
          const BasketsMapPage(), // TODO: Ajouter BlocProvider avec vraies dépendances
          settings: settings,
        );

      case mapPage:
        return _buildRoute(
          const EnhancedMapPage(),
          settings: settings,
        );

      case basketDetail:
        // Récupérer l'ID du panier depuis les arguments
        final basketId = settings.arguments as String?;
        if (basketId == null) {
          return _buildErrorRoute('ID du panier manquant');
        }

        // Récupérer le panier depuis les données de démonstration
        final demoBaskets = DemoDataService.getDemoBaskets();
        if (demoBaskets.isEmpty) {
          return _buildErrorRoute('Aucun panier disponible');
        }

        final basket = demoBaskets.firstWhere(
          (b) => b.id == basketId,
          orElse: () => demoBaskets.first, // Retourner le premier si non trouvé (temporaire)
        );

        return _buildRoute(
          BasketDetailPage(basket: basket),
          settings: settings,
        );

      default:
        return _buildErrorRoute('Route inconnue: ${settings.name}');
    }
  }

  /// Construit une route avec une transition personnalisée.
  static PageRoute<T> _buildRoute<T extends Object?>(
    Widget page, {
    required RouteSettings settings,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Animation de glissement depuis la droite
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        final slideTween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );
        final slideAnimation = slideTween.animate(curvedAnimation);

        // Animation de fondu
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(curvedAnimation);

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Construit une route d'erreur.
  static Route<dynamic> _buildErrorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Erreur'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Erreur de navigation',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(initial);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Retour à l\'accueil'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Navigue vers la page de tous les paniers.
  static Future<void> navigateToAllBaskets(BuildContext context) {
    return Navigator.of(context).pushNamed(allBaskets);
  }

  /// Navigue vers la page de carte des paniers.
  static Future<void> navigateToBasketsMap(BuildContext context) {
    return Navigator.of(context).pushNamed(basketsMap);
  }

  /// Navigue vers la page de carte Google Maps.
  static Future<void> navigateToMapPage(BuildContext context) {
    return Navigator.of(context).pushNamed(mapPage);
  }

  /// Navigue vers les détails d'un panier.
  static Future<void> navigateToBasketDetail(
    BuildContext context,
    String basketId,
  ) {
    return Navigator.of(context).pushNamed(
      basketDetail,
      arguments: basketId,
    );
  }

  /// Navigue vers la page d'accueil et supprime toutes les routes précédentes.
  static Future<void> navigateToHomeAndClear(BuildContext context) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      home,
      (route) => false,
    );
  }

  /// Navigue vers la page de connexion et supprime toutes les routes précédentes.
  static Future<void> navigateToLoginAndClear(BuildContext context) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
      login,
      (route) => false,
    );
  }
}