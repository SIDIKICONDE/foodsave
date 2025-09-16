import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/student/feed_screen.dart';
import '../screens/student/reservations_screen.dart';
import '../screens/meal/meal_detail_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/merchant/profile_merchant_screen.dart';
import '../screens/merchant/post_meal_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../presentation/pages/splash_page.dart';

/// Configuration des routes pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
class AppRoutes {
  /// Constructeur privé pour empêcher l'instanciation
  AppRoutes._();

  /// Routes principales de l'application
  static const String splash = '/';
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String otpVerification = '/auth/otp';
  
  // Routes étudiants
  static const String studentFeed = '/student/feed';
  static const String studentMealDetail = '/student/meal/:id';
  static const String studentReservation = '/student/reservation';
  static const String studentProfile = '/student/profile';
  
  // Routes commerçants
  static const String merchantOrders = '/merchant/orders';
  static const String merchantPostMeal = '/merchant/post-meal';
  static const String merchantProfile = '/merchant/profile';
  
  // Routes communes
  static const String home = '/home';
  static const String notifications = '/notifications';

  /// Configuration du routeur GoRouter avec protection des routes
  static GoRouter createRouter(WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    return GoRouter(
      initialLocation: splash,
      debugLogDiagnostics: true,
      routes: [
        // Route splash
        GoRoute(
          path: splash,
          name: 'splash',
          builder: (context, state) => const SplashPage(),
        ),
        
        // Routes d'authentification
        GoRoute(
          path: '/auth/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/auth/signup',
          name: 'signup',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: '/auth/otp',
          name: 'otp',
          builder: (context, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            final type = state.uri.queryParameters['type'] ?? 'signup';
            return OTPVerificationScreen(email: email, type: type);
          },
        ),
        
        // Routes étudiants
        GoRoute(
          path: '/student/feed',
          name: 'student_feed',
          builder: (context, state) => const FeedScreen(),
        ),
        GoRoute(
          path: '/student/meal/:id',
          name: 'student_meal_detail',
          builder: (context, state) {
            final mealId = state.pathParameters['id']!;
            return MealDetailScreen(mealId: mealId);
          },
        ),
        GoRoute(
          path: '/student/reservation',
          name: 'student_reservation',
          builder: (context, state) => const ReservationsScreen(),
        ),
        GoRoute(
          path: '/student/profile',
          name: 'student_profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        
        // Routes commerçants
        GoRoute(
          path: '/merchant/orders',
          name: 'merchant_orders',
          builder: (context, state) => const OrdersScreen(),
        ),
        GoRoute(
          path: '/merchant/post-meal',
          name: 'merchant_post_meal',
          builder: (context, state) => const PostMealScreen(),
        ),
        GoRoute(
          path: '/merchant/profile',
          name: 'merchant_profile',
          builder: (context, state) => const ProfileMerchantScreen(),
        ),
        
        // Route home
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        
        // Route notifications
        GoRoute(
          path: notifications,
          name: 'notifications',
          builder: (context, state) => const NotificationsScreen(),
        ),
      ],
      
      // Gestion des erreurs de navigation
      errorBuilder: (context, state) => ErrorPage(error: state.error),
      
      // Redirection globale avec protection des routes
      redirect: (context, state) {
        final location = state.matchedLocation;
        final isAuth = authState.status == AuthStatus.authenticated;
        final isLoading = authState.status == AuthStatus.loading;
        
        // Si en cours de chargement, ne pas rediriger
        if (isLoading) return null;
        
        // Routes publiques (pas besoin d'authentification)
        final publicRoutes = [
          '/',
          '/auth/login',
          '/auth/signup',
          '/auth/otp',
        ];
        
        // Routes pour étudiants seulement
        final studentOnlyRoutes = [
          '/student/feed',
          '/student/reservation',
          '/student/profile',
        ];
        
        // Routes pour commerçants seulement
        final merchantOnlyRoutes = [
          '/merchant/orders',
          '/merchant/post-meal',
          '/merchant/profile',
        ];
        
        // Routes protégées (authentification requise)
        final protectedRoutes = [
          '/home',
          '/notifications',
          ...studentOnlyRoutes,
          ...merchantOnlyRoutes,
        ];
        
        // Si non authentifié et tentative d'accès à une route protégée
        if (!isAuth && protectedRoutes.any((route) => location.startsWith(route))) {
          return '/auth/login';
        }
        
        // Si authentifié et sur splash ou login/signup, rediriger vers home
        if (isAuth && (location == '/' || location == '/auth/login' || location == '/auth/signup')) {
          return '/home';
        }
        
        // Vérifier les permissions pour les routes spécifiques
        if (isAuth) {
          final userType = authState.user?.userType;
          
          // Si étudiant essaie d'accéder aux routes commerçants
          if (userType == UserType.student && 
              merchantOnlyRoutes.any((route) => location.startsWith(route))) {
            // Afficher un message et rediriger
            return '/home';
          }
          
          // Si commerçant essaie d'accéder aux routes étudiants
          if (userType == UserType.merchant && 
              studentOnlyRoutes.any((route) => location.startsWith(route))) {
            // Afficher un message et rediriger
            return '/home';
          }
        }
        
        return null; // Pas de redirection
      },
    );
  }
}

/// Écran temporaire pour les routes non encore implémentées
class PlaceholderScreen extends StatelessWidget {
  /// Titre de l'écran
  final String title;
  
  /// Constructeur de l'écran temporaire
  const PlaceholderScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: Colors.orange[400],
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Cette fonctionnalité sera bientôt disponible !',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Retour'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Écran d'erreur pour les routes non trouvées
class ErrorPage extends StatelessWidget {
  /// Erreur à afficher
  final Exception? error;
  
  /// Constructeur de l'écran d'erreur
  const ErrorPage({
    super.key,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Erreur de navigation'),
        backgroundColor: Theme.of(context).colorScheme.error,
        foregroundColor: Theme.of(context).colorScheme.onError,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 20),
              Text(
                'Page non trouvée',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.error,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'La page que vous recherchez n\'existe pas ou a été déplacée.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              if (error != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Text(
                    'Erreur: ${error.toString()}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.go(AppRoutes.splash),
                    icon: const Icon(Icons.home),
                    label: const Text('Accueil'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Retour'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}