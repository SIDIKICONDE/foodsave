import 'dart:math' as math;
import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/domain/entities/commerce.dart';
import 'package:foodsave_app/data/datasources/remote/basket_remote_data_source.dart';

/// Implémentation mock de la data source distante des paniers.
/// 
/// Cette implémentation simule des appels API avec des données fictives
/// pour le développement et les tests. En production, elle serait remplacée
/// par une implémentation utilisant http/dio.
class BasketRemoteDataSourceImpl implements BasketRemoteDataSource {
  /// Crée une nouvelle instance de [BasketRemoteDataSourceImpl].
  BasketRemoteDataSourceImpl();

  /// Délai de simulation pour les appels réseau.
  static const Duration _networkDelay = Duration(milliseconds: 500);

  /// Données mock des commerces.
  static final List<Commerce> _mockCommerces = [
    Commerce(
      id: 'commerce_1',
      name: 'Boulangerie Martin',
      type: CommerceType.bakery,
      address: '123 Rue de la Paix, 75001 Paris',
      latitude: 48.8566,
      longitude: 2.3522,
      phone: '+33 1 23 45 67 89',
      email: 'contact@boulangerie-martin.fr',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      isActive: true,
      averageRating: 4.8,
      totalReviews: 127,
      ecoEngagement: EcoEngagementLevel.gold,
      totalBasketsSold: 1250,
      totalKgSaved: 890.5,
      totalCo2Saved: 125.3,
    ),
    Commerce(
      id: 'commerce_2',
      name: 'Fruits & Bio',
      type: CommerceType.greengrocer,
      address: '456 Avenue des Champs, 75002 Paris',
      latitude: 48.8606,
      longitude: 2.3376,
      phone: '+33 1 34 56 78 90',
      email: 'hello@fruitsbio.fr',
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      isActive: true,
      averageRating: 4.6,
      totalReviews: 89,
      ecoEngagement: EcoEngagementLevel.champion,
      totalBasketsSold: 890,
      totalKgSaved: 567.2,
      totalCo2Saved: 89.4,
    ),
    Commerce(
      id: 'commerce_3',
      name: 'Chez Luigi',
      type: CommerceType.restaurant,
      address: '789 Boulevard Saint-Germain, 75003 Paris',
      latitude: 48.8529,
      longitude: 2.3499,
      phone: '+33 1 45 67 89 01',
      email: 'luigi@chezluigi.fr',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      isActive: true,
      averageRating: 4.9,
      totalReviews: 203,
      ecoEngagement: EcoEngagementLevel.silver,
      totalBasketsSold: 2100,
      totalKgSaved: 1456.8,
      totalCo2Saved: 234.7,
    ),
  ];

  /// Génère des paniers mock.
  List<Basket> _generateMockBaskets({
    int count = 20,
    String? commerceIdFilter,
    bool lastChance = false,
  }) {
    final List<Basket> baskets = [];
    final math.Random random = math.Random();

    for (int i = 0; i < count; i++) {
      final Commerce commerce = commerceIdFilter != null
          ? _mockCommerces.firstWhere((c) => c.id == commerceIdFilter)
          : _mockCommerces[random.nextInt(_mockCommerces.length)];

      final DateTime now = DateTime.now();
      final DateTime availableFrom = now.add(Duration(minutes: random.nextInt(60)));
      final DateTime availableUntil = lastChance
          ? now.add(Duration(hours: 1 + random.nextInt(2))) // Expire bientôt
          : now.add(Duration(hours: 4 + random.nextInt(8)));

      final double originalPrice = 15.0 + random.nextDouble() * 20.0;
      final double discountedPrice = originalPrice * (0.3 + random.nextDouble() * 0.4);

      baskets.add(Basket(
        id: 'basket_${i + 1}',
        commerceId: commerce.id,
        commerce: commerce,
        title: _getBasketTitle(commerce.type, i),
        description: _getBasketDescription(commerce.type, i),
        originalPrice: double.parse(originalPrice.toStringAsFixed(2)),
        discountedPrice: double.parse(discountedPrice.toStringAsFixed(2)),
        availableFrom: availableFrom,
        availableUntil: availableUntil,
        pickupTimeStart: availableFrom.add(const Duration(hours: 1)),
        pickupTimeEnd: availableUntil.subtract(const Duration(minutes: 30)),
        quantity: 1 + random.nextInt(5),
        createdAt: now.subtract(Duration(hours: random.nextInt(24))),
        status: BasketStatus.available,
        imageUrls: [_getImageUrl(commerce.type)],
        estimatedWeight: 0.8 + random.nextDouble() * 1.5,
        size: BasketSize.values[random.nextInt(BasketSize.values.length)],
        allergens: _getAllergens(random),
        dietaryTags: _getDietaryTags(commerce.type, random),
        ingredients: _getIngredients(commerce.type, random),
        isLastChance: lastChance,
        co2Saved: 0.5 + random.nextDouble() * 2.0,
      ));
    }

    return baskets;
  }

  String _getBasketTitle(CommerceType type, int index) {
    switch (type) {
      case CommerceType.bakery:
        return [
          'Panier Boulangerie du jour',
          'Mix Viennoiseries & Pains',
          'Sélection Pâtisseries',
        ][index % 3];
      case CommerceType.greengrocer:
        return [
          'Panier Fruits & Légumes Bio',
          'Mix Légumes de Saison',
          'Fruits de Saison',
        ][index % 3];
      case CommerceType.restaurant:
        return [
          'Panier Plats Cuisinés',
          'Mix Italien du Chef',
          'Spécialités Maison',
        ][index % 3];
      default:
        return 'Panier Surprise';
    }
  }

  String _getBasketDescription(CommerceType type, int index) {
    switch (type) {
      case CommerceType.bakery:
        return 'Assortiment de pains, viennoiseries et pâtisseries fraîches du jour';
      case CommerceType.greengrocer:
        return 'Sélection de fruits et légumes bio de saison, frais et savoureux';
      case CommerceType.restaurant:
        return 'Plats cuisinés maison prêts à emporter, recettes authentiques';
      default:
        return 'Panier surprise avec des produits de qualité';
    }
  }

  String _getImageUrl(CommerceType type) {
    switch (type) {
      case CommerceType.bakery:
        return 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400';
      case CommerceType.greengrocer:
        return 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400';
      case CommerceType.restaurant:
        return 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400';
      default:
        return 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400';
    }
  }

  List<String> _getAllergens(math.Random random) {
    final List<String> allAllergens = [
      'Gluten', 'Lactose', 'Œufs', 'Fruits à coque', 'Arachides'
    ];
    final int count = random.nextInt(3);
    return allAllergens.take(count).toList();
  }

  List<String> _getDietaryTags(CommerceType type, math.Random random) {
    final List<String> tags = [];
    if (random.nextBool()) tags.add('Bio');
    if (random.nextBool()) tags.add('Local');
    if (type == CommerceType.greengrocer) {
      tags.addAll(['Végétarien', 'Végan']);
    }
    return tags;
  }

  List<String> _getIngredients(CommerceType type, math.Random random) {
    switch (type) {
      case CommerceType.bakery:
        return ['Farine', 'Beurre', 'Levure', 'Sucre'];
      case CommerceType.greengrocer:
        return ['Pommes', 'Carottes', 'Salade', 'Tomates'];
      case CommerceType.restaurant:
        return ['Pâtes', 'Tomates', 'Basilic', 'Parmesan'];
      default:
        return ['Ingrédients variés'];
    }
  }

  @override
  Future<List<Basket>> getAvailableBaskets({
    double? latitude,
    double? longitude,
    double radius = 10.0,
    int limit = 20,
    int offset = 0,
  }) async {
    await Future.delayed(_networkDelay);

    final List<Basket> allBaskets = _generateMockBaskets(count: 50);
    
    // Simuler le filtrage géographique
    List<Basket> filteredBaskets = allBaskets;
    if (latitude != null && longitude != null) {
      filteredBaskets = allBaskets.where((basket) {
        final double distance = basket.commerce.calculateDistance(latitude, longitude);
        return distance <= radius;
      }).toList();
    }

    // Pagination
    final int start = offset;
    final int end = math.min(start + limit, filteredBaskets.length);
    
    if (start >= filteredBaskets.length) return [];
    
    return filteredBaskets.sublist(start, end);
  }

  @override
  Future<Basket> getBasketById(String basketId) async {
    await Future.delayed(_networkDelay);

    final List<Basket> baskets = _generateMockBaskets(count: 10);
    final Basket? basket = baskets.cast<Basket?>().firstWhere(
      (b) => b?.id == basketId,
      orElse: () => null,
    );

    if (basket == null) {
      throw Exception('Panier non trouvé: $basketId');
    }

    return basket;
  }

  @override
  Future<List<Basket>> searchBaskets({
    String? query,
    List<String>? commerceTypes,
    double? maxPrice,
    List<String>? dietaryTags,
    DateTime? availableFrom,
    DateTime? availableUntil,
    double? latitude,
    double? longitude,
    double radius = 10.0,
    int limit = 20,
    int offset = 0,
  }) async {
    await Future.delayed(_networkDelay);

    List<Basket> allBaskets = _generateMockBaskets(count: 100);

    // Filtrage par recherche textuelle
    if (query != null && query.isNotEmpty) {
      allBaskets = allBaskets.where((basket) {
        return basket.title.toLowerCase().contains(query.toLowerCase()) ||
               basket.description.toLowerCase().contains(query.toLowerCase()) ||
               basket.commerce.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }

    // Filtrage par prix
    if (maxPrice != null) {
      allBaskets = allBaskets.where((basket) => basket.discountedPrice <= maxPrice).toList();
    }

    // Filtrage par tags alimentaires
    if (dietaryTags != null && dietaryTags.isNotEmpty) {
      allBaskets = allBaskets.where((basket) {
        return dietaryTags.any((tag) => basket.dietaryTags.contains(tag));
      }).toList();
    }

    // Pagination
    final int start = offset;
    final int end = math.min(start + limit, allBaskets.length);
    
    if (start >= allBaskets.length) return [];
    
    return allBaskets.sublist(start, end);
  }

  @override
  Future<List<Basket>> getFavoriteBaskets(String userId) async {
    await Future.delayed(_networkDelay);
    
    // Simuler quelques favoris
    return _generateMockBaskets(count: 5);
  }

  @override
  Future<void> addToFavorites(String userId, String basketId) async {
    await Future.delayed(_networkDelay);
    // Simuler l'ajout aux favoris
  }

  @override
  Future<void> removeFromFavorites(String userId, String basketId) async {
    await Future.delayed(_networkDelay);
    // Simuler la suppression des favoris
  }

  @override
  Future<bool> isFavorite(String userId, String basketId) async {
    await Future.delayed(_networkDelay);
    // Simuler aléatoirement
    return math.Random().nextBool();
  }

  @override
  Future<List<Basket>> getBasketsByCommerce(
    String commerceId, {
    bool includeExpired = false,
  }) async {
    await Future.delayed(_networkDelay);
    
    return _generateMockBaskets(count: 8, commerceIdFilter: commerceId);
  }

  @override
  Future<List<Basket>> getLastChanceBaskets({
    int hoursUntilExpiry = 2,
    double? latitude,
    double? longitude,
    double radius = 10.0,
    int limit = 10,
  }) async {
    await Future.delayed(_networkDelay);
    
    return _generateMockBaskets(count: limit, lastChance: true);
  }

  @override
  Future<void> updateBasketStatus(String basketId, BasketStatus status) async {
    await Future.delayed(_networkDelay);
    // Simuler la mise à jour du statut
  }

  @override
  Future<void> decrementBasketQuantity(String basketId, int quantity) async {
    await Future.delayed(_networkDelay);
    // Simuler la décrémentation de quantité
  }

  @override
  Future<bool> checkBasketAvailability(String basketId) async {
    await Future.delayed(_networkDelay);
    // Simuler aléatoirement la disponibilité
    return math.Random().nextBool();
  }
}