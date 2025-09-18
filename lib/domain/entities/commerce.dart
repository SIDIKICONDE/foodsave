import 'dart:math' as math;
import 'package:equatable/equatable.dart';

/// Énumération des types de commerce.
enum CommerceType {
  /// Boulangerie.
  bakery,
  /// Restaurant.
  restaurant,
  /// Supermarché.
  supermarket,
  /// Primeur (fruits et légumes).
  greengrocer,
  /// Boucherie.
  butcher,
  /// Poissonnerie.
  fishmonger,
  /// Épicerie.
  grocery,
  /// Café/Bar.
  cafe,
  /// Autre type de commerce.
  other,
}

/// Énumération du niveau d'engagement écologique.
enum EcoEngagementLevel {
  /// Bronze - Engagement de base.
  bronze,
  /// Silver - Engagement moyen.
  silver,
  /// Gold - Engagement élevé.
  gold,
  /// Champion - Engagement exceptionnel.
  champion,
}

/// Entité représentant un commerce partenaire de FoodSave.
/// 
/// Cette entité contient toutes les informations d'un commerce proposant
/// des paniers anti-gaspi, incluant ses détails, localisation et engagement écologique.
class Commerce extends Equatable {
  /// Crée une nouvelle instance de [Commerce].
  const Commerce({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.email,
    required this.createdAt,
    required this.isActive,
    this.description,
    this.website,
    this.imageUrl,
    this.coverImageUrl,
    this.openingHours = const {},
    this.specialDays = const [],
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.ecoEngagement = EcoEngagementLevel.bronze,
    this.certifications = const [],
    this.totalBasketsSold = 0,
    this.totalKgSaved = 0.0,
    this.totalCo2Saved = 0.0,
    this.pickupInstructions,
    this.specialOffers = const [],
    this.tags = const [],
    this.isVerified = false,
    this.joinedAt,
  });

  /// Identifiant unique du commerce.
  final String id;

  /// Nom du commerce.
  final String name;

  /// Type de commerce.
  final CommerceType type;

  /// Adresse complète du commerce.
  final String address;

  /// Latitude de la position géographique.
  final double latitude;

  /// Longitude de la position géographique.
  final double longitude;

  /// Numéro de téléphone.
  final String phone;

  /// Adresse email de contact.
  final String email;

  /// Site web (optionnel).
  final String? website;

  /// Description du commerce.
  final String? description;

  /// URL de l'image principale.
  final String? imageUrl;

  /// URL de l'image de couverture.
  final String? coverImageUrl;

  /// Date de création du profil.
  final DateTime createdAt;

  /// Date d'adhésion au programme FoodSave.
  final DateTime? joinedAt;

  /// Si le commerce est actuellement actif.
  final bool isActive;

  /// Si le commerce est vérifié par FoodSave.
  final bool isVerified;

  /// Horaires d'ouverture par jour de la semaine.
  /// Clé : jour de la semaine (1-7), Valeur : "HH:mm-HH:mm" ou null si fermé.
  final Map<int, String?> openingHours;

  /// Jours spéciaux (fermetures exceptionnelles, horaires modifiés).
  final List<String> specialDays;

  /// Note moyenne sur 5 étoiles.
  final double averageRating;

  /// Nombre total d'avis.
  final int totalReviews;

  /// Niveau d'engagement écologique.
  final EcoEngagementLevel ecoEngagement;

  /// Certifications écologiques (Bio, Label Rouge, etc.).
  final List<String> certifications;

  /// Nombre total de paniers vendus.
  final int totalBasketsSold;

  /// Total de kilogrammes de nourriture sauvés.
  final double totalKgSaved;

  /// Total de CO2 économisé (en kg).
  final double totalCo2Saved;

  /// Instructions de récupération des paniers.
  final String? pickupInstructions;

  /// Offres spéciales en cours.
  final List<String> specialOffers;

  /// Tags descriptifs (végétarien, sans gluten, etc.).
  final List<String> tags;

  /// Calcule la distance par rapport à une position donnée.
  double calculateDistance(double userLat, double userLng) {
    // Formule de haversine simplifiée pour l'exemple
    // En production, utiliser une librairie géographique appropriée
    const double earthRadius = 6371; // km
    
    final double dLat = _degreesToRadians(latitude - userLat);
    final double dLng = _degreesToRadians(longitude - userLng);
    
    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(userLat)) * math.cos(_degreesToRadians(latitude)) *
        math.sin(dLng / 2) * math.sin(dLng / 2);
    
    final double c = 2 * math.asin(math.sqrt(a));
    
    return earthRadius * c;
  }

  /// Convertit des degrés en radians.
  double _degreesToRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  /// Vérifie si le commerce est ouvert à une heure donnée.
  bool isOpenAt(DateTime dateTime) {
    final int weekday = dateTime.weekday;
    final String? hours = openingHours[weekday];
    
    if (hours == null) return false;
    
    // Parse des heures d'ouverture (format "HH:mm-HH:mm")
    final List<String> parts = hours.split('-');
    if (parts.length != 2) return false;
    
    try {
      final List<String> openParts = parts[0].split(':');
      final List<String> closeParts = parts[1].split(':');
      
      final DateTime openTime = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        int.parse(openParts[0]),
        int.parse(openParts[1]),
      );
      
      final DateTime closeTime = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        int.parse(closeParts[0]),
        int.parse(closeParts[1]),
      );
      
      return dateTime.isAfter(openTime) && dateTime.isBefore(closeTime);
    } catch (e) {
      return false;
    }
  }

  /// Crée une copie du commerce avec des valeurs modifiées.
  Commerce copyWith({
    String? id,
    String? name,
    CommerceType? type,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    String? website,
    String? description,
    String? imageUrl,
    String? coverImageUrl,
    DateTime? createdAt,
    DateTime? joinedAt,
    bool? isActive,
    bool? isVerified,
    Map<int, String?>? openingHours,
    List<String>? specialDays,
    double? averageRating,
    int? totalReviews,
    EcoEngagementLevel? ecoEngagement,
    List<String>? certifications,
    int? totalBasketsSold,
    double? totalKgSaved,
    double? totalCo2Saved,
    String? pickupInstructions,
    List<String>? specialOffers,
    List<String>? tags,
  }) {
    return Commerce(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      createdAt: createdAt ?? this.createdAt,
      joinedAt: joinedAt ?? this.joinedAt,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      openingHours: openingHours ?? this.openingHours,
      specialDays: specialDays ?? this.specialDays,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      ecoEngagement: ecoEngagement ?? this.ecoEngagement,
      certifications: certifications ?? this.certifications,
      totalBasketsSold: totalBasketsSold ?? this.totalBasketsSold,
      totalKgSaved: totalKgSaved ?? this.totalKgSaved,
      totalCo2Saved: totalCo2Saved ?? this.totalCo2Saved,
      pickupInstructions: pickupInstructions ?? this.pickupInstructions,
      specialOffers: specialOffers ?? this.specialOffers,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        address,
        latitude,
        longitude,
        phone,
        email,
        website,
        description,
        imageUrl,
        coverImageUrl,
        createdAt,
        joinedAt,
        isActive,
        isVerified,
        openingHours,
        specialDays,
        averageRating,
        totalReviews,
        ecoEngagement,
        certifications,
        totalBasketsSold,
        totalKgSaved,
        totalCo2Saved,
        pickupInstructions,
        specialOffers,
        tags,
      ];

  @override
  String toString() {
    return 'Commerce(id: $id, name: $name, type: $type, isActive: $isActive)';
  }
}