// Providers Riverpod pour l'intégration Supabase - FoodSave
// Standards NYTH - Zero Compromise

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user.dart';
import '../services/supabase_service.dart';

// =================== PROVIDERS DE SERVICES ===================

/// Provider pour le service Supabase principal
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService.instance;
});

/// Provider pour le client Supabase natif (accès direct si nécessaire)
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// =================== PROVIDERS D'AUTHENTIFICATION ===================

/// Provider pour l'état d'authentification actuel
final authStateProvider = StreamProvider<AuthState>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return supabase.auth.onAuthStateChange;
});

/// Provider pour l'utilisateur actuellement connecté
final currentUserProvider = StreamProvider<User?>((ref) async* {
  final authState = await ref.watch(authStateProvider.future);
  
  if (authState.session?.user != null) {
    final supabaseService = ref.read(supabaseServiceProvider);
    
    try {
      // Récupérer les informations complètes de l'utilisateur depuis la DB
      final userProfile = await supabaseService.getCurrentUser();
      yield userProfile;
    } catch (e) {
      // En cas d'erreur, créer un utilisateur basique à partir des données auth
      final authUser = authState.session!.user;
      yield User(
        id: authUser.id,
        email: authUser.email ?? '',
        username: authUser.userMetadata?['username'] ?? '',
        userType: UserType.values.firstWhere(
          (type) => type.name == (authUser.userMetadata?['user_type'] ?? 'student'),
          orElse: () => UserType.student,
        ),
        isVerified: authUser.emailConfirmedAt != null,
        isActive: true,
        createdAt: authUser.createdAt != null 
            ? DateTime.parse(authUser.createdAt!) 
            : DateTime.now(),
        updatedAt: authUser.updatedAt != null 
            ? DateTime.parse(authUser.updatedAt!) 
            : DateTime.now(),
      );
    }
  } else {
    yield null;
  }
});

/// Provider pour vérifier si l'utilisateur est connecté
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.session != null,
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Provider pour récupérer le token d'authentification
final authTokenProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.session?.accessToken,
    loading: () => null,
    error: (_, __) => null,
  );
});

// =================== PROVIDERS DE DONNÉES ===================

/// Provider pour les repas de l'utilisateur (si commerçant)
final userMealsProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  
  if (user == null || user.userType != UserType.merchant) {
    return [];
  }
  
  final supabaseService = ref.read(supabaseServiceProvider);
  return await supabaseService.getMerchantMeals(user.id);
});

/// Provider pour les commandes de l'utilisateur
final userOrdersProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  
  if (user == null) return [];
  
  final supabaseService = ref.read(supabaseServiceProvider);
  return await supabaseService.getUserOrders(user.id);
});

/// Provider pour les favoris de l'utilisateur
final userFavoritesProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final user = await ref.watch(currentUserProvider.future);
  
  if (user == null) return [];
  
  final supabaseService = ref.read(supabaseServiceProvider);
  return await supabaseService.getUserFavorites(user.id);
});

/// Provider pour les notifications non lues
final unreadNotificationsProvider = StreamProvider.autoDispose<List<dynamic>>((ref) async* {
  final user = await ref.watch(currentUserProvider.future);
  
  if (user == null) {
    yield [];
    return;
  }
  
  final supabaseService = ref.read(supabaseServiceProvider);
  
  // Écouter les changements de notifications en temps réel
  await for (final notifications in supabaseService.streamUserNotifications(user.id)) {
    yield notifications.where((n) => !(n['is_read'] ?? false)).toList();
  }
});

// =================== PROVIDERS D'ACTIONS ===================

/// Provider pour les actions d'authentification
final authActionsProvider = Provider<AuthActions>((ref) {
  final supabaseService = ref.read(supabaseServiceProvider);
  return AuthActions(supabaseService);
});

/// Provider pour les actions de gestion des repas
final mealActionsProvider = Provider<MealActions>((ref) {
  final supabaseService = ref.read(supabaseServiceProvider);
  return MealActions(supabaseService);
});

/// Provider pour les actions de commande
final orderActionsProvider = Provider<OrderActions>((ref) {
  final supabaseService = ref.read(supabaseServiceProvider);
  return OrderActions(supabaseService);
});

// =================== CLASSES D'ACTIONS ===================

/// Actions d'authentification
class AuthActions {
  final SupabaseService _service;
  
  AuthActions(this._service);
  
  Future<AuthResult> signIn(String email, String password) async {
    return await _service.signInWithPassword(email: email, password: password);
  }
  
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String username,
    required UserType userType,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    return await _service.signUpWithPassword(
      email: email,
      password: password,
      username: username,
      userType: userType,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );
  }
  
  Future<void> signOut() async {
    await _service.signOut();
  }
  
  Future<bool> requestPasswordReset(String email) async {
    return await _service.requestPasswordReset(email);
  }
  
  Future<AuthResult> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
    String? city,
    String? postalCode,
  }) async {
    return await _service.updateUserProfile(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      address: address,
      city: city,
      postalCode: postalCode,
    );
  }
}

/// Actions de gestion des repas
class MealActions {
  final SupabaseService _service;
  
  MealActions(this._service);
  
  Future<Map<String, dynamic>> createMeal({
    required String title,
    required String description,
    required String category,
    required double originalPrice,
    required double discountedPrice,
    required int quantity,
    required DateTime availableUntil,
    List<String>? imageUrls,
    List<String>? allergens,
    List<String>? ingredients,
    Map<String, dynamic>? nutritionalInfo,
    bool isVegetarian = false,
    bool isVegan = false,
    bool isGlutenFree = false,
    bool isHalal = false,
  }) async {
    return await _service.createMeal(
      title: title,
      description: description,
      category: category,
      originalPrice: originalPrice,
      discountedPrice: discountedPrice,
      quantity: quantity,
      availableUntil: availableUntil,
      imageUrls: imageUrls,
      allergens: allergens,
      ingredients: ingredients,
      nutritionalInfo: nutritionalInfo,
      isVegetarian: isVegetarian,
      isVegan: isVegan,
      isGlutenFree: isGlutenFree,
      isHalal: isHalal,
    );
  }
  
  Future<bool> updateMeal(String mealId, Map<String, dynamic> updates) async {
    return await _service.updateMeal(mealId, updates);
  }
  
  Future<bool> deleteMeal(String mealId) async {
    return await _service.deleteMeal(mealId);
  }
}

/// Actions de commande
class OrderActions {
  final SupabaseService _service;
  
  OrderActions(this._service);
  
  Future<Map<String, dynamic>?> createOrder({
    required String mealId,
    required int quantity,
    String? notes,
  }) async {
    return await _service.createOrder(
      mealId: mealId,
      quantity: quantity,
      notes: notes,
    );
  }
  
  Future<bool> updateOrderStatus(String orderId, String status) async {
    return await _service.updateOrderStatus(orderId, status);
  }
  
  Future<bool> cancelOrder(String orderId, String reason) async {
    return await _service.cancelOrder(orderId, reason);
  }
}

// =================== TYPES ET MODÈLES ===================

/// Résultat d'une opération d'authentification (compatible avec l'ancien AuthResult)
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? token;
  final String? error;

  const AuthResult._({
    required this.isSuccess,
    this.user,
    this.token,
    this.error,
  });

  factory AuthResult.success({
    required User user,
    required String token,
  }) => AuthResult._(
    isSuccess: true,
    user: user,
    token: token,
  );

  factory AuthResult.failure({
    required String error,
  }) => AuthResult._(
    isSuccess: false,
    error: error,
  );
}

// =================== PROVIDERS DE CONFIGURATION ===================

/// Provider pour vérifier si l'app est en mode développement
final isDevelopmentModeProvider = Provider<bool>((ref) {
  return const String.fromEnvironment('ENVIRONMENT', defaultValue: 'development') == 'development';
});

/// Provider pour les URLs de configuration
final configProvider = Provider<AppConfig>((ref) {
  final isDev = ref.watch(isDevelopmentModeProvider);
  
  return AppConfig(
    isDevelopment: isDev,
    supabaseUrl: isDev 
        ? const String.fromEnvironment('SUPABASE_URL_LOCAL', defaultValue: 'http://localhost:54321')
        : const String.fromEnvironment('SUPABASE_URL'),
    bucketMealImages: const String.fromEnvironment('BUCKET_MEAL_IMAGES', defaultValue: 'meal-images'),
    bucketUserAvatars: const String.fromEnvironment('BUCKET_USER_AVATARS', defaultValue: 'user-avatars'),
    bucketRestaurantImages: const String.fromEnvironment('BUCKET_RESTAURANT_IMAGES', defaultValue: 'restaurant-images'),
    bucketDocuments: const String.fromEnvironment('BUCKET_DOCUMENTS', defaultValue: 'documents'),
  );
});

/// Configuration de l'application
class AppConfig {
  final bool isDevelopment;
  final String supabaseUrl;
  final String bucketMealImages;
  final String bucketUserAvatars;
  final String bucketRestaurantImages;
  final String bucketDocuments;
  
  const AppConfig({
    required this.isDevelopment,
    required this.supabaseUrl,
    required this.bucketMealImages,
    required this.bucketUserAvatars,
    required this.bucketRestaurantImages,
    required this.bucketDocuments,
  });
}