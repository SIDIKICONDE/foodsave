import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

import '../models/user.dart';
import '../models/meal.dart';
import '../models/order.dart';
import 'security_service.dart';

/// Service Supabase pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
/// Intégration complète avec authentification, base de données temps réel et storage
class SupabaseService {
  static SupabaseService? _instance;

  /// Instance singleton
  static SupabaseService get instance => _instance ??= SupabaseService._();

  /// Constructeur privé
  SupabaseService._();

  /// Client Supabase
  SupabaseClient get client => Supabase.instance.client;

  /// Service de sécurité pour le chiffrement local
  final _securityService = SecurityService.instance;

  // Tables de la base de données
  static const String _usersTable = 'users';
  static const String _restaurantsTable = 'restaurants';
  static const String _mealsTable = 'meals';
  static const String _ordersTable = 'orders';
  static const String _reviewsTable = 'reviews';

  // Buckets de stockage
  static const String _mealImagesBucket = 'meal-images';
  static const String _restaurantImagesBucket = 'restaurant-images';
  static const String _userAvatarsBucket = 'user-avatars';

  /// Initialise le service Supabase
  static Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: kDebugMode,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );

    await SecurityService.instance.initialize();
  }

  // =================== AUTHENTIFICATION ===================

  /// Inscription avec email et mot de passe
  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String username,
    required UserType userType,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    try {
      // Vérifier la force du mot de passe
      final passwordStrength =
          _securityService.validatePasswordStrength(password);
      if (!passwordStrength.isAcceptable) {
        return AuthResult.failure(
          error: 'Mot de passe trop faible: ${passwordStrength.feedback.first}',
        );
      }

      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'user_type': userType.name,
          'first_name': firstName,
          'last_name': lastName,
          'phone_number': phoneNumber,
        },
      );

      if (response.user != null) {
        // Créer l'entrée utilisateur dans la table custom
        await _createUserProfile(
          userId: response.user!.id,
          email: email,
          username: username,
          userType: userType,
          firstName: firstName,
          lastName: lastName,
          phoneNumber: phoneNumber,
        );

        // Stocker les tokens de manière sécurisée
        if (response.session != null) {
          await _storeAuthTokens(response.session!);
        }

        final user = await _getUserProfile(response.user!.id);
        return AuthResult.success(
          user: user,
          token: response.session?.accessToken ?? '',
        );
      }

      return AuthResult.failure(error: 'Erreur lors de l\'inscription');
    } on AuthException catch (e) {
      return AuthResult.failure(error: _handleAuthError(e));
    } catch (e) {
      return AuthResult.failure(error: 'Erreur inconnue: $e');
    }
  }

  /// Connexion avec email et mot de passe
  Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Vérifier les tentatives de brute force
      final isBruteForce =
          await _securityService.detectBruteForceAttempt(email);
      if (isBruteForce) {
        await _securityService.temporaryBlock(email);
        return AuthResult.failure(
          error:
              'Trop de tentatives de connexion. Compte temporairement bloqué.',
        );
      }

      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null && response.session != null) {
        // Stocker les tokens de manière sécurisée
        await _storeAuthTokens(response.session!);

        final user = await _getUserProfile(response.user!.id);
        return AuthResult.success(
          user: user,
          token: response.session!.accessToken,
        );
      }

      return AuthResult.failure(error: 'Identifiants invalides');
    } on AuthException catch (e) {
      return AuthResult.failure(error: _handleAuthError(e));
    } catch (e) {
      return AuthResult.failure(error: 'Erreur de connexion: $e');
    }
  }

  /// Connexion avec Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      final response = await client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? null : 'com.foodsave.app://login',
      );

      // La redirection sera gérée par le deep link
      return AuthResult.success(user: null, token: '');
    } on AuthException catch (e) {
      return AuthResult.failure(error: _handleAuthError(e));
    } catch (e) {
      return AuthResult.failure(error: 'Erreur connexion Google: $e');
    }
  }

  /// Déconnexion
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
      await _securityService.clearTokens();
    } catch (e) {
      debugPrint('Erreur déconnexion: $e');
    }
  }

  /// Récupère l'utilisateur actuel
  Future<User?> getCurrentUser() async {
    final supabaseUser = client.auth.currentUser;
    if (supabaseUser != null) {
      return await _getUserProfile(supabaseUser.id);
    }
    return null;
  }

  /// Écoute les changements d'état d'authentification
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // =================== GESTION DES PROFILS ===================

  /// Crée un profil utilisateur
  Future<void> _createUserProfile({
    required String userId,
    required String email,
    required String username,
    required UserType userType,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    await client.from(_usersTable).insert({
      'id': userId,
      'email': email,
      'username': username,
      'user_type': userType.name,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  /// Récupère le profil d'un utilisateur
  Future<User> _getUserProfile(String userId) async {
    final response =
        await client.from(_usersTable).select().eq('id', userId).single();

    return User.fromJson({
      'id': response['id'],
      'email': response['email'],
      'username': response['username'],
      'userType': response['user_type'],
      'firstName': response['first_name'],
      'lastName': response['last_name'],
      'phoneNumber': response['phone_number'],
      'avatarUrl': response['avatar_url'],
      'isVerified': response['is_verified'] ?? false,
      'isActive': response['is_active'] ?? true,
      'createdAt': response['created_at'],
      'updatedAt': response['updated_at'],
    });
  }

  /// Met à jour le profil utilisateur
  Future<User> updateUserProfile({
    String? username,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté');

    await client.from(_usersTable).update({
      if (username != null) 'username': username,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', userId);

    return await _getUserProfile(userId);
  }

  // =================== GESTION DES REPAS ===================

  /// Récupère les repas disponibles avec filtres
  Future<List<Meal>> getMeals({
    String? searchQuery,
    List<MealCategory>? categories,
    double? maxPrice,
    bool? isVegetarian,
    bool? isVegan,
    double? latitude,
    double? longitude,
    double? radiusKm,
  }) async {
    var query = client
        .from(_mealsTable)
        .select()
        .eq('status', 'available')
        .gte('available_until', DateTime.now().toIso8601String())
        .gt('remaining_quantity', 0);

    // Filtres optionnels seraient appliqués côté serveur avec des RPC

    final response = await query;
    return response.map((json) => Meal.fromJson(json)).toList();
  }

  /// Crée un nouveau repas (pour les commerçants)
  Future<Meal> createMeal({
    required String title,
    required String description,
    required MealCategory category,
    required double originalPrice,
    required double discountedPrice,
    required int quantity,
    required DateTime availableUntil,
    List<String>? imageUrls,
    List<String>? allergens,
    List<String>? ingredients,
    NutritionalInfo? nutritionalInfo,
    bool isVegetarian = false,
    bool isVegan = false,
    bool isGlutenFree = false,
    bool isHalal = false,
  }) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté');

    // Vérifier que l'utilisateur est un commerçant
    final user = await getCurrentUser();
    if (user?.userType != UserType.merchant) {
      throw Exception('Seuls les commerçants peuvent créer des repas');
    }

    final response = await client
        .from(_mealsTable)
        .insert({
          'merchant_id': userId,
          'title': title,
          'description': description,
          'category': category.name,
          'original_price': originalPrice,
          'discounted_price': discountedPrice,
          'quantity': quantity,
          'remaining_quantity': quantity,
          'available_from': DateTime.now().toIso8601String(),
          'available_until': availableUntil.toIso8601String(),
          'image_urls': imageUrls,
          'allergens': allergens,
          'ingredients': ingredients,
          'nutritional_info': nutritionalInfo?.toJson(),
          'is_vegetarian': isVegetarian,
          'is_vegan': isVegan,
          'is_gluten_free': isGlutenFree,
          'is_halal': isHalal,
          'status': MealStatus.available.name,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    return Meal.fromJson(response);
  }

  /// Met à jour un repas
  Future<Meal> updateMeal(String mealId, Map<String, dynamic> updates) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté');

    updates['updated_at'] = DateTime.now().toIso8601String();

    final response = await client
        .from(_mealsTable)
        .update(updates)
        .eq('id', mealId)
        .eq('merchant_id',
            userId) // Sécurité: seul le propriétaire peut modifier
        .select()
        .single();

    return Meal.fromJson(response);
  }

  /// Supprime un repas
  Future<void> deleteMeal(String mealId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté');

    await client
        .from(_mealsTable)
        .delete()
        .eq('id', mealId)
        .eq('merchant_id', userId);
  }

  // =================== GESTION DES COMMANDES ===================

  /// Crée une nouvelle commande
  Future<Order> createOrder({
    required String mealId,
    required int quantity,
    String? notes,
  }) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté');

    // Vérifier la disponibilité du repas
    final meal =
        await client.from(_mealsTable).select().eq('id', mealId).single();

    if (meal['remaining_quantity'] < quantity) {
      throw Exception('Quantité insuffisante disponible');
    }

    // Calculer le prix total
    final totalPrice = meal['discounted_price'] * quantity;

    // Créer la commande dans une transaction
    final response =
        await client.rpc('create_order_with_stock_update', params: {
      'meal_id': mealId,
      'customer_id': userId,
      'quantity': quantity,
      'total_price': totalPrice,
      'notes': notes,
    });

    return Order.fromJson(response);
  }

  /// Récupère les commandes d'un utilisateur
  Stream<List<Order>> getUserOrdersStream() {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté');

    return client
        .from(_ordersTable)
        .stream(primaryKey: ['id'])
        .eq('customer_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Order.fromJson(json)).toList());
  }

  /// Récupère les commandes d'un commerçant
  Stream<List<Order>> getMerchantOrdersStream() {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté');

    return client
        .from(_ordersTable)
        .stream(primaryKey: ['id'])
        .eq('merchant_id', userId)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Order.fromJson(json)).toList());
  }

  /// Met à jour le statut d'une commande
  Future<Order> updateOrderStatus(String orderId, OrderStatus status) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté');

    final response = await client
        .from(_ordersTable)
        .update({
          'status': status.name,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', orderId)
        .eq('merchant_id', userId) // Seul le commerçant peut changer le statut
        .select()
        .single();

    return Order.fromJson(response);
  }

  // =================== GESTION DES FICHIERS ===================

  /// Upload une image de repas
  Future<String> uploadMealImage(File imageFile, String mealId) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté');

    final fileName = '${mealId}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await client.storage
        .from(_mealImagesBucket)
        .upload('$userId/$fileName', imageFile);

    return client.storage
        .from(_mealImagesBucket)
        .getPublicUrl('$userId/$fileName');
  }

  /// Upload un avatar utilisateur
  Future<String> uploadUserAvatar(File imageFile) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) throw Exception('Utilisateur non connecté');

    final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';

    await client.storage
        .from(_userAvatarsBucket)
        .upload('$userId/$fileName', imageFile);

    final imageUrl = client.storage
        .from(_userAvatarsBucket)
        .getPublicUrl('$userId/$fileName');

    // Mettre à jour le profil avec la nouvelle image
    await updateUserProfile(avatarUrl: imageUrl);

    return imageUrl;
  }

  // =================== UTILITAIRES PRIVÉS ===================

  /// Stocke les tokens d'authentification de manière sécurisée
  Future<void> _storeAuthTokens(Session session) async {
    await _securityService.storeTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken ?? '',
      expiryTime: session.expiresAt != null
          ? DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000)
          : null,
    );
  }

  /// Gère les erreurs d'authentification
  String _handleAuthError(AuthException error) {
    switch (error.statusCode) {
      case '400':
        return 'Données d\'authentification invalides';
      case '401':
        return 'Identifiants incorrects';
      case '422':
        return 'Email déjà utilisé';
      case '429':
        return 'Trop de tentatives, veuillez réessayer plus tard';
      default:
        return error.message;
    }
  }
}

/// Résultat d'une opération d'authentification
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

  factory AuthResult.success({required User? user, required String token}) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      token: token,
    );
  }

  factory AuthResult.failure({required String error}) {
    return AuthResult._(
      isSuccess: false,
      error: error,
    );
  }
}
