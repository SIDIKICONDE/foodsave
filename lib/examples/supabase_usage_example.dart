import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:foodsave_app/config/supabase_config.dart';
import 'package:foodsave_app/models/basket.dart';
import 'package:foodsave_app/models/shop.dart';
import 'package:foodsave_app/services/supabase_service.dart';

/// Exemples d'utilisation des services Supabase dans FoodSave
/// 
/// Cette classe montre comment utiliser les différentes fonctionnalités
/// de Supabase dans l'application FoodSave.
class SupabaseUsageExample {
  
  // EXEMPLES D'AUTHENTIFICATION

  /// Exemple d'inscription d'un utilisateur
  static Future<void> exampleSignUp() async {
    const String email = 'user@example.com';
    const String password = 'motdepasse123';
    
    final Either<SupabaseError, AuthResponse> result = await SupabaseService.signUp(
      email: email,
      password: password,
      metadata: {
        'full_name': 'John Doe',
        'age': 25,
        'preferences': ['bio', 'local'],
      },
    );

    result.fold(
      (SupabaseError error) => print('Erreur inscription: ${error.message}'),
      (AuthResponse response) => print('Inscription réussie: ${response.user?.email}'),
    );
  }

  /// Exemple de connexion d'un utilisateur
  static Future<void> exampleSignIn() async {
    const String email = 'user@example.com';
    const String password = 'motdepasse123';

    final Either<SupabaseError, AuthResponse> result = await SupabaseService.signIn(
      email: email,
      password: password,
    );

    result.fold(
      (SupabaseError error) => print('Erreur connexion: ${error.message}'),
      (AuthResponse response) => print('Connexion réussie: ${response.user?.email}'),
    );
  }

  /// Exemple de vérification de l'état de connexion
  static void exampleCheckAuthStatus() {
    if (SupabaseService.isAuthenticated) {
      print('Utilisateur connecté: ${SupabaseService.currentUser?.email}');
    } else {
      print('Utilisateur non connecté');
    }
  }

  // EXEMPLES D'OPÉRATIONS SUR LES PANIERS

  /// Exemple de récupération des paniers disponibles
  static Future<void> exampleGetAvailableBaskets() async {
    final Either<SupabaseError, List<Map<String, dynamic>>> result = await SupabaseService.select(
      tableName: SupabaseConfig.tableBasketsMap,
      filters: {'is_active': true},
      orderBy: 'created_at',
      ascending: false,
      limit: 20,
    );

    result.fold(
      (SupabaseError error) => print('Erreur récupération paniers: ${error.message}'),
      (List<Map<String, dynamic>> data) {
        final List<Basket> baskets = data.map((Map<String, dynamic> json) => Basket.fromJson(json)).toList();
        print('${baskets.length} paniers trouvés');
        
        for (final Basket basket in baskets) {
          print('- ${basket.title}: ${basket.price}€ (${basket.type})');
        }
      },
    );
  }

  /// Exemple de recherche de paniers par proximité
  static Future<void> exampleSearchBasketsByLocation(double latitude, double longitude) async {
    const double radiusKm = 5.0; // Rayon de recherche en kilomètres
    
    // Note: Pour une recherche géospatiale plus avancée,
    // vous devriez utiliser les fonctions PostGIS dans Supabase
    final Either<SupabaseError, List<Map<String, dynamic>>> result = await SupabaseService.select(
      tableName: SupabaseConfig.tableBasketsMap,
      filters: {'is_active': true},
      orderBy: 'created_at',
      ascending: false,
    );

    result.fold(
      (SupabaseError error) => print('Erreur recherche: ${error.message}'),
      (List<Map<String, dynamic>> data) {
        final List<Basket> allBaskets = data.map((Map<String, dynamic> json) => Basket.fromJson(json)).toList();
        
        // Filtrer par distance (côté client)
        final List<Basket> nearbyBaskets = allBaskets
            .where((Basket basket) => basket.distanceFrom(latitude, longitude) <= radiusKm)
            .toList();

        print('${nearbyBaskets.length} paniers trouvés dans un rayon de ${radiusKm}km');
        
        for (final Basket basket in nearbyBaskets) {
          final double distance = basket.distanceFrom(latitude, longitude);
          print('- ${basket.title}: ${distance.toStringAsFixed(1)}km (${basket.price}€)');
        }
      },
    );
  }

  /// Exemple d'ajout d'un panier aux favoris
  static Future<void> exampleAddToFavorites(String basketId) async {
    final String? userId = SupabaseService.currentUser?.id;
    
    if (userId == null) {
      print('Utilisateur non connecté');
      return;
    }

    final Either<SupabaseError, List<Map<String, dynamic>>> result = await SupabaseService.insert(
      tableName: SupabaseConfig.tableFavorites,
      data: {
        'user_id': userId,
        'basket_id': basketId,
      },
    );

    result.fold(
      (SupabaseError error) => print('Erreur ajout favori: ${error.message}'),
      (List<Map<String, dynamic>> data) => print('Panier ajouté aux favoris'),
    );
  }

  // EXEMPLES D'OPÉRATIONS SUR LES MAGASINS

  /// Exemple de récupération des magasins
  static Future<void> exampleGetShops() async {
    final Either<SupabaseError, List<Map<String, dynamic>>> result = await SupabaseService.select(
      tableName: SupabaseConfig.tableShops,
      orderBy: 'rating',
      ascending: false,
    );

    result.fold(
      (SupabaseError error) => print('Erreur récupération magasins: ${error.message}'),
      (List<Map<String, dynamic>> data) {
        final List<Shop> shops = data.map((Map<String, dynamic> json) => Shop.fromJson(json)).toList();
        print('${shops.length} magasins trouvés');
        
        for (final Shop shop in shops) {
          print('- ${shop.name}: ${shop.rating}/5 (${shop.totalReviews} avis)');
          print('  ${shop.isOpenNow ? "Ouvert" : "Fermé"} maintenant');
        }
      },
    );
  }

  // EXEMPLES DE TEMPS RÉEL

  /// Exemple d'écoute des changements en temps réel sur les paniers
  static RealtimeChannel exampleRealtimeBaskets() {
    final RealtimeChannel channel = SupabaseService.subscribeToTable(
      tableName: SupabaseConfig.tableBasketsMap,
      callback: (PostgresChangePayload payload) {
        print('Changement détecté: ${payload.eventType}');
        print('Données: ${payload.newRecord}');
      },
    );

    print('Écoute des changements en temps réel sur les paniers...');

    // Retourner le channel pour permettre l'arrêt de l'écoute plus tard
    return channel;
  }

  // EXEMPLES DE GESTION DES ERREURS

  /// Exemple de gestion d'erreurs lors d'une opération
  static Future<void> exampleErrorHandling() async {
    final Either<SupabaseError, List<Map<String, dynamic>>> result = await SupabaseService.select(
      tableName: 'table_inexistante', // Table qui n'existe pas
    );

    result.fold(
      (SupabaseError error) {
        print('Type d\'erreur: ${error.runtimeType}');
        print('Message: ${error.message}');
        print('Code: ${error.code}');
        
        // Gestion spécifique selon le type d'erreur
        if (error.code == '42P01') {
          print('Action: Vérifier que la table existe dans Supabase');
        } else {
          print('Action: Vérifier la connexion et les permissions');
        }
      },
      (List<Map<String, dynamic>> data) => print('Données reçues: ${data.length} éléments'),
    );
  }

  // UTILITAIRES ET HELPERS

  /// Exemple d'utilisation des configurations centralisées
  static void exampleConfiguration() {
    print('Configuration Supabase:');
    print('- URL: ${SupabaseConfig.supabaseUrl}');
    print('- Rayon de proximité: ${SupabaseConfig.proximityRadiusKm}km');
    print('- Intervalle notifications: ${SupabaseConfig.notificationIntervalMinutes}min');
    print('- Durée cache: ${SupabaseConfig.cacheValidDuration.inHours}h');
    print('- Max résultats recherche: ${SupabaseConfig.maxSearchResults}');
  }

  /// Exemple d'utilisation complète avec plusieurs opérations
  static Future<void> exampleCompleteWorkflow() async {
    print('=== Workflow complet FoodSave ===');
    
    // 1. Vérifier l'authentification
    if (!SupabaseService.isAuthenticated) {
      print('1. Connexion nécessaire');
      await exampleSignIn();
    } else {
      print('1. Utilisateur déjà connecté');
    }

    // 2. Récupérer les paniers disponibles
    print('2. Récupération des paniers...');
    await exampleGetAvailableBaskets();

    // 3. Récupérer les magasins
    print('3. Récupération des magasins...');
    await exampleGetShops();

    // 4. Recherche par localisation (exemple avec Paris)
    print('4. Recherche par proximité...');
    await exampleSearchBasketsByLocation(48.8566, 2.3522); // Coordonnées de Paris

    print('=== Fin du workflow ===');
  }
}
