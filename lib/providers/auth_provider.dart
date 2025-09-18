import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/user.dart';
import '../services/supabase_service.dart';

/// État de l'authentification
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Classe pour gérer l'état d'authentification
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final bool isFirstTime;

  AuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.isFirstTime = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? isFirstTime,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: errorMessage,
      isFirstTime: isFirstTime ?? this.isFirstTime,
    );
  }
}

/// Provider pour gérer l'authentification
class AuthNotifier extends StateNotifier<AuthState> {
  final SupabaseService _supabaseService;

  AuthNotifier(this._supabaseService)
      : super(AuthState(status: AuthStatus.initial)) {
    _initialize();
  }

  /// Initialise l'authentification
  Future<void> _initialize() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // Pour la démo, simuler un utilisateur non connecté au démarrage
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(status: AuthStatus.unauthenticated);
      
      // TODO: Implémenter la vraie vérification avec Supabase
      // final session = _supabaseService.currentSession;
      // if (session != null) {
      //   await _loadUserData(session.user.id);
      // } else {
      //   state = state.copyWith(status: AuthStatus.unauthenticated);
      // }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing auth: $e');
      }
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Erreur d\'initialisation',
      );
    }
  }

  /// Charge les données utilisateur
  Future<void> _loadUserData(String userId) async {
    try {
      // TODO: Récupérer les données utilisateur depuis Supabase
      // Pour la démo, on utilise des données mockées
      final mockUser = User(
        id: userId,
        firstName: 'Marie',
        lastName: 'Martin',
        email: 'marie.martin@universite.fr',
        username: 'mmartin',
        phoneNumber: '06 12 34 56 78',
        userType: UserType.student,
        avatarUrl: 'https://picsum.photos/100/100?random=user',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: mockUser,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Erreur de chargement des données',
      );
    }
  }

  /// Connexion avec email et mot de passe
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // Pour la démo, accepter n'importe quel email/password
      if (kDebugMode) {
        print('Demo mode: Login with $email');
      }

      // Simulation d'une connexion réussie
      await Future.delayed(const Duration(seconds: 1));

      // Déterminer le type d'utilisateur selon l'email (pour la démo)
      final userType = email.contains('restaurant') || email.contains('merchant')
          ? UserType.merchant
          : UserType.student;

      final mockUser = User(
        id: '1',
        firstName: email.split('@')[0].split('.')[0],
        lastName: email.split('@')[0].contains('.')
            ? email.split('@')[0].split('.')[1]
            : 'User',
        email: email,
        username: email.split('@')[0],
        phoneNumber: '06 12 34 56 78',
        userType: userType,
        avatarUrl: 'https://picsum.photos/100/100?random=user',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: mockUser,
      );

      return true;

      // TODO: Implémenter la vraie connexion avec Supabase
      // final response = await _supabaseService.signInWithEmail(
      //   email: email,
      //   password: password,
      // );
      // if (response.user != null) {
      //   await _loadUserData(response.user!.id);
      //   return true;
      // }
    } catch (e) {
      if (kDebugMode) {
        print('Error signing in: $e');
      }
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Email ou mot de passe incorrect',
      );
      return false;
    }
  }

  /// Inscription avec email et mot de passe
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required UserType userType,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // Pour la démo, accepter n'importe quelle inscription
      if (kDebugMode) {
        print('Demo mode: Signup with $email');
      }

      // Simulation d'une inscription réussie
      await Future.delayed(const Duration(seconds: 1));

      final mockUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: firstName,
        lastName: lastName,
        email: email,
        username: email.split('@')[0],
        phoneNumber: phone,
        userType: userType,
        avatarUrl: 'https://picsum.photos/100/100?random=user',
        createdAt: DateTime.now(),
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: mockUser,
        isFirstTime: true,
      );

      return true;

      // TODO: Implémenter la vraie inscription avec Supabase
      // final response = await _supabaseService.signUp(
      //   email: email,
      //   password: password,
      //   data: {
      //     'first_name': firstName,
      //     'last_name': lastName,
      //     'phone': phone,
      //     'user_type': userType.name,
      //   },
      // );
      // if (response.user != null) {
      //   await _loadUserData(response.user!.id);
      //   return true;
      // }
    } catch (e) {
      if (kDebugMode) {
        print('Error signing up: $e');
      }
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Erreur lors de l\'inscription',
      );
      return false;
    }
  }

  /// Vérification du code OTP
  Future<bool> verifyOTP({
    required String email,
    required String otp,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      // Pour la démo, accepter le code "123456"
      if (otp == '123456') {
        if (kDebugMode) {
          print('Demo mode: OTP verified for $email');
        }

        // Simulation de la vérification réussie
        await Future.delayed(const Duration(seconds: 1));

        // Créer un utilisateur de démo
        final userType = email.contains('restaurant') || email.contains('merchant')
            ? UserType.merchant
            : UserType.student;

        final mockUser = User(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          firstName: email.split('@')[0].split('.')[0],
          lastName: email.split('@')[0].contains('.')
              ? email.split('@')[0].split('.')[1]
              : 'User',
          email: email,
          username: email.split('@')[0],
          phoneNumber: '06 12 34 56 78',
          userType: userType,
          avatarUrl: 'https://picsum.photos/100/100?random=user',
          createdAt: DateTime.now(),
        );

        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: mockUser,
        );

        return true;
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: 'Code incorrect',
        );
        return false;
      }

      // TODO: Implémenter la vraie vérification OTP avec Supabase
      // final response = await _supabaseService.verifyOTP(
      //   email: email,
      //   token: otp,
      //   type: OtpType.email,
      // );
      // if (response.user != null) {
      //   await _loadUserData(response.user!.id);
      //   return true;
      // }
    } catch (e) {
      if (kDebugMode) {
        print('Error verifying OTP: $e');
      }
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: 'Erreur lors de la vérification',
      );
      return false;
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    try {
      state = state.copyWith(status: AuthStatus.loading);
      
      // TODO: Implémenter la vraie déconnexion avec Supabase
      // await _supabaseService.signOut();
      
      // Simulation de la déconnexion
      await Future.delayed(const Duration(milliseconds: 500));
      
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error signing out: $e');
      }
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Erreur lors de la déconnexion',
      );
    }
  }

  /// Réinitialiser le mot de passe
  Future<bool> resetPassword(String email) async {
    try {
      // TODO: Implémenter avec Supabase
      // await _supabaseService.resetPasswordForEmail(email);
      
      // Pour la démo
      if (kDebugMode) {
        print('Demo mode: Password reset email sent to $email');
      }
      
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error resetting password: $e');
      }
      return false;
    }
  }

  /// Mettre à jour le profil utilisateur
  Future<bool> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      final currentUser = state.user;
      if (currentUser == null) return false;

      // TODO: Implémenter la mise à jour avec Supabase
      // await _supabaseService.updateUser(...)

      // Pour la démo, mettre à jour localement
      final updatedUser = User(
        id: currentUser.id,
        firstName: firstName ?? currentUser.firstName,
        lastName: lastName ?? currentUser.lastName,
        email: currentUser.email,
        username: currentUser.username,
        phoneNumber: phoneNumber ?? currentUser.phoneNumber,
        userType: currentUser.userType,
        avatarUrl: avatarUrl ?? currentUser.avatarUrl,
        createdAt: currentUser.createdAt,
      );

      state = state.copyWith(user: updatedUser);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile: $e');
      }
      return false;
    }
  }

  /// Vérifie si l'utilisateur est connecté
  bool get isAuthenticated => state.status == AuthStatus.authenticated;

  /// Obtient l'utilisateur actuel
  User? get currentUser => state.user;

  /// Obtient le type d'utilisateur
  UserType? get userType => state.user?.userType;

  /// Vérifie si c'est un étudiant
  bool get isStudent => state.user?.userType == UserType.student;

  /// Vérifie si c'est un commerçant
  bool get isMerchant => state.user?.userType == UserType.merchant;
}

/// Provider principal pour l'authentification
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // Pour la démo, utiliser une instance simple de SupabaseService
  final supabaseService = SupabaseService.instance;
  return AuthNotifier(supabaseService);
});

/// Provider pour vérifier si l'utilisateur est authentifié
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).status == AuthStatus.authenticated;
});

/// Provider pour obtenir l'utilisateur actuel
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

/// Provider pour obtenir le type d'utilisateur
final userTypeProvider = Provider<UserType?>((ref) {
  return ref.watch(authProvider).user?.userType;
});

/// Extension pour les redirections basées sur l'authentification
extension AuthRedirect on GoRouter {
  /// Redirige vers la page appropriée selon l'état d'authentification
  String? authRedirect(AuthState authState, String location) {
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
    final studentRoutes = [
      '/student/feed',
      '/student/reservation',
      '/student/profile',
    ];
    
    // Routes pour commerçants seulement
    final merchantRoutes = [
      '/merchant/orders',
      '/merchant/post-meal',
      '/merchant/profile',
    ];
    
    // Si non authentifié et tentative d'accès à une route protégée
    if (!isAuth && !publicRoutes.contains(location)) {
      return '/auth/login';
    }
    
    // Si authentifié et sur une route publique
    if (isAuth && publicRoutes.contains(location)) {
      // Rediriger selon le type d'utilisateur
      if (authState.user?.userType == UserType.student) {
        return '/home';
      } else if (authState.user?.userType == UserType.merchant) {
        return '/home';
      }
    }
    
    // Vérifier les permissions pour les routes spécifiques
    if (isAuth) {
      final userType = authState.user?.userType;
      
      // Si étudiant essaie d'accéder aux routes commerçants
      if (userType == UserType.student && merchantRoutes.any((route) => location.startsWith(route))) {
        return '/home';
      }
      
      // Si commerçant essaie d'accéder aux routes étudiants
      if (userType == UserType.merchant && studentRoutes.any((route) => location.startsWith(route))) {
        return '/home';
      }
    }
    
    return null; // Pas de redirection
  }
}