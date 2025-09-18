import 'package:equatable/equatable.dart';
import 'package:foodsave_app/domain/entities/commerce.dart';

/// Énumération du statut d'un panier.
enum BasketStatus {
  /// Disponible à la réservation.
  available,
  /// Réservé par un utilisateur.
  reserved,
  /// Récupéré par l'utilisateur.
  collected,
  /// Expiré (non récupéré à temps).
  expired,
  /// Annulé par le commerce ou l'utilisateur.
  cancelled,
}

/// Énumération de la taille du panier.
enum BasketSize {
  /// Petit panier (1-2 personnes).
  small,
  /// Panier moyen (3-4 personnes).
  medium,
  /// Grand panier (5+ personnes).
  large,
}

/// Entité représentant un panier anti-gaspi.
/// 
/// Cette entité contient toutes les informations d'un panier proposé
/// par un commerce, incluant son contenu, prix et disponibilité.
class Basket extends Equatable {
  /// Crée une nouvelle instance de [Basket].
  const Basket({
    required this.id,
    required this.commerceId,
    required this.commerce,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.availableFrom,
    required this.availableUntil,
    required this.pickupTimeStart,
    required this.pickupTimeEnd,
    required this.quantity,
    required this.createdAt,
    required this.status,
    this.imageUrls = const [],
    this.estimatedWeight,
    this.size = BasketSize.medium,
    this.allergens = const [],
    this.dietaryTags = const [],
    this.ingredients = const [],
    this.specialInstructions,
    this.isLastChance = false,
    this.reservedBy,
    this.reservedAt,
    this.collectedAt,
    this.rating,
    this.review,
    this.co2Saved,
    this.actualWeight,
    this.promoCode,
    this.isRecurring = false,
    this.recurringDays = const [],
  });

  /// Identifiant unique du panier.
  final String id;

  /// Identifiant du commerce propriétaire.
  final String commerceId;

  /// Commerce propriétaire du panier.
  final Commerce commerce;

  /// Titre du panier.
  final String title;

  /// Description détaillée du contenu.
  final String description;

  /// Prix original avant réduction.
  final double originalPrice;

  /// Prix après réduction FoodSave.
  final double discountedPrice;

  /// Date/heure à partir de laquelle le panier est disponible.
  final DateTime availableFrom;

  /// Date/heure jusqu'à laquelle le panier est disponible.
  final DateTime availableUntil;

  /// Heure de début de récupération.
  final DateTime pickupTimeStart;

  /// Heure de fin de récupération.
  final DateTime pickupTimeEnd;

  /// Quantité de paniers disponibles.
  final int quantity;

  /// Date de création du panier.
  final DateTime createdAt;

  /// Statut actuel du panier.
  final BasketStatus status;

  /// URLs des images du panier.
  final List<String> imageUrls;

  /// Poids estimé du panier (en kg).
  final double? estimatedWeight;

  /// Poids réel du panier après récupération (en kg).
  final double? actualWeight;

  /// Taille du panier.
  final BasketSize size;

  /// Liste des allergènes présents.
  final List<String> allergens;

  /// Tags alimentaires (végétarien, végan, bio, etc.).
  final List<String> dietaryTags;

  /// Liste des ingrédients principaux.
  final List<String> ingredients;

  /// Instructions spéciales pour la récupération.
  final String? specialInstructions;

  /// Si c'est un panier "dernière chance".
  final bool isLastChance;

  /// Identifiant de l'utilisateur qui a réservé (si applicable).
  final String? reservedBy;

  /// Date/heure de réservation.
  final DateTime? reservedAt;

  /// Date/heure de récupération.
  final DateTime? collectedAt;

  /// Note donnée par l'utilisateur (sur 5).
  final double? rating;

  /// Avis laissé par l'utilisateur.
  final String? review;

  /// CO2 économisé par ce panier (en kg).
  final double? co2Saved;

  /// Code promo appliqué.
  final String? promoCode;

  /// Si c'est une commande récurrente.
  final bool isRecurring;

  /// Jours de la semaine pour les commandes récurrentes (1-7).
  final List<int> recurringDays;

  /// Calcule le pourcentage de réduction.
  double get discountPercentage {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - discountedPrice) / originalPrice) * 100;
  }

  /// Calcule l'économie réalisée.
  double get savings {
    return originalPrice - discountedPrice;
  }

  /// Vérifie si le panier est encore disponible à la réservation.
  bool get isAvailable {
    final DateTime now = DateTime.now();
    return status == BasketStatus.available &&
        quantity > 0 &&
        now.isAfter(availableFrom) &&
        now.isBefore(availableUntil);
  }

  /// Vérifie si le panier peut être récupéré maintenant.
  bool get canBePickedUp {
    final DateTime now = DateTime.now();
    return status == BasketStatus.reserved &&
        now.isAfter(pickupTimeStart) &&
        now.isBefore(pickupTimeEnd);
  }

  /// Vérifie si la période de récupération est bientôt expirée.
  bool get isPickupSoon {
    final DateTime now = DateTime.now();
    final Duration timeUntilPickup = pickupTimeEnd.difference(now);
    return timeUntilPickup.inHours <= 2 && timeUntilPickup.inMinutes > 0;
  }

  /// Retourne la couleur de statut appropriée.
  String get statusColor {
    switch (status) {
      case BasketStatus.available:
        return isLastChance ? '#FF6B6B' : '#51CF66';
      case BasketStatus.reserved:
        return canBePickedUp ? '#FFD93D' : '#74C0FC';
      case BasketStatus.collected:
        return '#51CF66';
      case BasketStatus.expired:
        return '#ADB5BD';
      case BasketStatus.cancelled:
        return '#FF8787';
    }
  }

  /// Retourne le texte de statut localisé.
  String get statusText {
    switch (status) {
      case BasketStatus.available:
        return isLastChance ? 'Dernière chance' : 'Disponible';
      case BasketStatus.reserved:
        return canBePickedUp ? 'À récupérer' : 'Réservé';
      case BasketStatus.collected:
        return 'Récupéré';
      case BasketStatus.expired:
        return 'Expiré';
      case BasketStatus.cancelled:
        return 'Annulé';
    }
  }

  /// Crée une copie du panier avec des valeurs modifiées.
  Basket copyWith({
    String? id,
    String? commerceId,
    Commerce? commerce,
    String? title,
    String? description,
    double? originalPrice,
    double? discountedPrice,
    DateTime? availableFrom,
    DateTime? availableUntil,
    DateTime? pickupTimeStart,
    DateTime? pickupTimeEnd,
    int? quantity,
    DateTime? createdAt,
    BasketStatus? status,
    List<String>? imageUrls,
    double? estimatedWeight,
    double? actualWeight,
    BasketSize? size,
    List<String>? allergens,
    List<String>? dietaryTags,
    List<String>? ingredients,
    String? specialInstructions,
    bool? isLastChance,
    String? reservedBy,
    DateTime? reservedAt,
    DateTime? collectedAt,
    double? rating,
    String? review,
    double? co2Saved,
    String? promoCode,
    bool? isRecurring,
    List<int>? recurringDays,
  }) {
    return Basket(
      id: id ?? this.id,
      commerceId: commerceId ?? this.commerceId,
      commerce: commerce ?? this.commerce,
      title: title ?? this.title,
      description: description ?? this.description,
      originalPrice: originalPrice ?? this.originalPrice,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      availableFrom: availableFrom ?? this.availableFrom,
      availableUntil: availableUntil ?? this.availableUntil,
      pickupTimeStart: pickupTimeStart ?? this.pickupTimeStart,
      pickupTimeEnd: pickupTimeEnd ?? this.pickupTimeEnd,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      imageUrls: imageUrls ?? this.imageUrls,
      estimatedWeight: estimatedWeight ?? this.estimatedWeight,
      actualWeight: actualWeight ?? this.actualWeight,
      size: size ?? this.size,
      allergens: allergens ?? this.allergens,
      dietaryTags: dietaryTags ?? this.dietaryTags,
      ingredients: ingredients ?? this.ingredients,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      isLastChance: isLastChance ?? this.isLastChance,
      reservedBy: reservedBy ?? this.reservedBy,
      reservedAt: reservedAt ?? this.reservedAt,
      collectedAt: collectedAt ?? this.collectedAt,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      co2Saved: co2Saved ?? this.co2Saved,
      promoCode: promoCode ?? this.promoCode,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringDays: recurringDays ?? this.recurringDays,
    );
  }

  @override
  List<Object?> get props => [
        id,
        commerceId,
        commerce,
        title,
        description,
        originalPrice,
        discountedPrice,
        availableFrom,
        availableUntil,
        pickupTimeStart,
        pickupTimeEnd,
        quantity,
        createdAt,
        status,
        imageUrls,
        estimatedWeight,
        actualWeight,
        size,
        allergens,
        dietaryTags,
        ingredients,
        specialInstructions,
        isLastChance,
        reservedBy,
        reservedAt,
        collectedAt,
        rating,
        review,
        co2Saved,
        promoCode,
        isRecurring,
        recurringDays,
      ];

  @override
  String toString() {
    return 'Basket(id: $id, title: $title, status: $status, price: $discountedPrice€)';
  }
}