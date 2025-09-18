import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/domain/entities/commerce.dart';

/// Service de démonstration fournissant des données simulées.
///
/// Utilisé pour le développement et les tests de l'interface utilisateur.
class DemoDataService {
  /// Constructeur privé pour empêcher l'instanciation.
  const DemoDataService._();

  /// Génère des commerces de démonstration.
  static List<Commerce> getDemoCommerces() {
    return [
      Commerce(
        id: 'commerce_1',
        name: 'Boulangerie du Coin',
        address: '15 rue de la République, 75001 Paris',
        phone: '01 42 33 44 55',
        email: 'contact@boulangerie-ducoin.fr',
        type: CommerceType.bakery,
        latitude: 48.8566,
        longitude: 2.3522,
        averageRating: 4.8,
        imageUrl: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop&auto=format',
        openingHours: {},
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        isActive: true,
      ),
      Commerce(
        id: 'commerce_2',
        name: 'Fruits & Légumes Bio',
        address: '22 avenue des Champs-Élysées, 75008 Paris',
        phone: '01 45 67 89 10',
        email: 'info@fruitslegumes-bio.fr',
        type: CommerceType.grocery,
        latitude: 48.8738,
        longitude: 2.2950,
        averageRating: 4.6,
        imageUrl: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop&auto=format',
        openingHours: {},
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        isActive: true,
      ),
      Commerce(
        id: 'commerce_3',
        name: 'Restaurant Chez Marie',
        address: '8 rue Saint-Honoré, 75001 Paris',
        phone: '01 40 20 30 40',
        email: 'reservation@chezmarie.fr',
        type: CommerceType.restaurant,
        latitude: 48.8616,
        longitude: 2.3376,
        averageRating: 4.5,
        imageUrl: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop&auto=format',
        openingHours: {},
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        isActive: true,
      ),
      Commerce(
        id: 'commerce_4',
        name: 'Pâtisserie Délice',
        address: '35 boulevard Saint-Germain, 75005 Paris',
        phone: '01 43 54 65 76',
        email: 'contact@patisserie-delice.fr',
        type: CommerceType.bakery,
        latitude: 48.8520,
        longitude: 2.3492,
        averageRating: 4.9,
        imageUrl: 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop&auto=format',
        openingHours: {},
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        isActive: true,
      ),
    ];
  }

  /// Génère des paniers de démonstration.
  static List<Basket> getDemoBaskets() {
    final commerces = getDemoCommerces();
    final now = DateTime.now();

    return [
      Basket(
        id: 'basket_1',
        commerceId: commerces[0].id,
        commerce: commerces[0],
        title: 'Panier Viennoiseries du Matin',
        description: 'Assortiment de viennoiseries fraîches : croissants, pains au chocolat, chaussons aux pommes et brioches.',
        originalPrice: 18.00,
        discountedPrice: 4.99,
        availableFrom: now.add(const Duration(hours: 1)),
        availableUntil: now.add(const Duration(hours: 8)),
        pickupTimeStart: now.add(const Duration(hours: 2)),
        pickupTimeEnd: now.add(const Duration(hours: 6)),
        quantity: 3,
        createdAt: now.subtract(const Duration(hours: 2)),
        status: BasketStatus.available,
        imageUrls: ['https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=300&fit=crop&auto=format'],
        estimatedWeight: 1.2,
        size: BasketSize.medium,
        allergens: ['Gluten', 'Lait', 'Œufs'],
        dietaryTags: [],
        ingredients: ['Farine', 'Beurre', 'Œufs', 'Levure'],
        isLastChance: true,
        co2Saved: 2.1,
      ),
      Basket(
        id: 'basket_2',
        commerceId: commerces[1].id,
        commerce: commerces[1],
        title: 'Panier Fruits & Légumes de Saison',
        description: 'Sélection de fruits et légumes bio de saison : pommes, poires, carottes, courgettes, épinards.',
        originalPrice: 22.00,
        discountedPrice: 7.50,
        availableFrom: now,
        availableUntil: now.add(const Duration(hours: 12)),
        pickupTimeStart: now.add(const Duration(hours: 1)),
        pickupTimeEnd: now.add(const Duration(hours: 10)),
        quantity: 5,
        createdAt: now.subtract(const Duration(hours: 1)),
        status: BasketStatus.available,
        imageUrls: ['https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop&auto=format'],
        estimatedWeight: 2.5,
        size: BasketSize.large,
        allergens: [],
        dietaryTags: ['Bio', 'Végétarien', 'Végan'],
        ingredients: ['Pommes', 'Poires', 'Carottes', 'Courgettes', 'Épinards'],
        isLastChance: false,
        co2Saved: 3.8,
      ),
      Basket(
        id: 'basket_3',
        commerceId: commerces[2].id,
        commerce: commerces[2],
        title: 'Panier Plats Cuisinés Maison',
        description: 'Plats préparés avec amour : ratatouille provençale, gratin dauphinois et tarte aux légumes.',
        originalPrice: 25.00,
        discountedPrice: 6.00,
        availableFrom: now.add(const Duration(hours: 3)),
        availableUntil: now.add(const Duration(hours: 6)),
        pickupTimeStart: now.add(const Duration(hours: 4)),
        pickupTimeEnd: now.add(const Duration(hours: 5)),
        quantity: 2,
        createdAt: now.subtract(const Duration(minutes: 30)),
        status: BasketStatus.available,
        imageUrls: ['https://images.unsplash.com/photo-1551782450-17144efb5723?w=400&h=300&fit=crop&auto=format'],
        estimatedWeight: 1.8,
        size: BasketSize.medium,
        allergens: ['Lait'],
        dietaryTags: ['Végétarien'],
        ingredients: ['Légumes', 'Fromage', 'Herbes de Provence'],
        isLastChance: true,
        co2Saved: 4.2,
      ),
      Basket(
        id: 'basket_4',
        commerceId: commerces[3].id,
        commerce: commerces[3],
        title: 'Panier Pâtisseries Gourmandes',
        description: 'Délicieuses pâtisseries artisanales : éclairs, millefeuilles, tartes aux fruits et macarons.',
        originalPrice: 28.00,
        discountedPrice: 9.99,
        availableFrom: now,
        availableUntil: now.add(const Duration(hours: 4)),
        pickupTimeStart: now.add(const Duration(minutes: 30)),
        pickupTimeEnd: now.add(const Duration(hours: 3)),
        quantity: 4,
        createdAt: now.subtract(const Duration(hours: 3)),
        status: BasketStatus.available,
        imageUrls: ['https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop&auto=format'],
        estimatedWeight: 1.5,
        size: BasketSize.medium,
        allergens: ['Gluten', 'Lait', 'Œufs', 'Fruits à coque'],
        dietaryTags: [],
        ingredients: ['Farine', 'Beurre', 'Sucre', 'Crème', 'Fruits'],
        isLastChance: false,
        co2Saved: 3.1,
      ),
      Basket(
        id: 'basket_5',
        commerceId: commerces[0].id,
        commerce: commerces[0],
        title: 'Panier Pain Artisanal',
        description: 'Pains artisanaux variés : baguette tradition, pain complet, pain aux noix et focaccia.',
        originalPrice: 15.50,
        discountedPrice: 3.90,
        availableFrom: now.subtract(const Duration(hours: 1)),
        availableUntil: now.add(const Duration(hours: 2)),
        pickupTimeStart: now,
        pickupTimeEnd: now.add(const Duration(hours: 1)),
        quantity: 1,
        createdAt: now.subtract(const Duration(hours: 4)),
        status: BasketStatus.available,
        imageUrls: ['https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&h=300&fit=crop&auto=format'],
        estimatedWeight: 2.0,
        size: BasketSize.large,
        allergens: ['Gluten', 'Fruits à coque'],
        dietaryTags: ['Bio'],
        ingredients: ['Farine bio', 'Levain', 'Noix', 'Herbes'],
        isLastChance: true,
        co2Saved: 2.8,
      ),
    ];
  }

  /// Filtre les paniers selon des critères.
  static List<Basket> filterBaskets(
    List<Basket> baskets, {
    String? query,
    List<String>? commerceTypes,
    double? maxPrice,
    List<String>? dietaryTags,
    bool? lastChanceOnly,
    bool? availableNow,
  }) {
    var filteredBaskets = baskets.toList();

    // Filtre par recherche textuelle
    if (query != null && query.isNotEmpty) {
      final queryLower = query.toLowerCase();
      filteredBaskets = filteredBaskets.where((basket) {
        return basket.title.toLowerCase().contains(queryLower) ||
            basket.description.toLowerCase().contains(queryLower) ||
            basket.commerce.name.toLowerCase().contains(queryLower);
      }).toList();
    }

    // Filtre par prix maximum
    if (maxPrice != null) {
      filteredBaskets = filteredBaskets.where((basket) {
        return basket.discountedPrice <= maxPrice;
      }).toList();
    }

    // Filtre par tags diététiques
    if (dietaryTags != null && dietaryTags.isNotEmpty) {
      filteredBaskets = filteredBaskets.where((basket) {
        return dietaryTags.any((tag) => basket.dietaryTags.contains(tag));
      }).toList();
    }

    // Filtre dernière chance uniquement
    if (lastChanceOnly == true) {
      filteredBaskets = filteredBaskets.where((basket) {
        return basket.isLastChance;
      }).toList();
    }

    // Filtre disponible maintenant
    if (availableNow == true) {
      final now = DateTime.now();
      filteredBaskets = filteredBaskets.where((basket) {
        return basket.isAvailable && now.isAfter(basket.pickupTimeStart);
      }).toList();
    }

    return filteredBaskets;
  }

  /// Trie les paniers selon un critère.
  static List<Basket> sortBaskets(List<Basket> baskets, String sortBy) {
    final sortedBaskets = baskets.toList();

    switch (sortBy) {
      case 'price':
        sortedBaskets.sort((a, b) => a.discountedPrice.compareTo(b.discountedPrice));
        break;
      case 'discount':
        sortedBaskets.sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
        break;
      case 'newest':
        sortedBaskets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'expiry':
        sortedBaskets.sort((a, b) => a.availableUntil.compareTo(b.availableUntil));
        break;
      case 'proximity':
      default:
        // Tri par proximité simulé (garder l'ordre actuel)
        break;
    }

    return sortedBaskets;
  }
}