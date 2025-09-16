import 'dart:math' as math;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'restaurant.freezed.dart';
part 'restaurant.g.dart';

/// Modèle de restaurant/commerce pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
@freezed
class Restaurant with _$Restaurant {
  /// Constructeur du modèle Restaurant
  const factory Restaurant({
    /// Identifiant unique du restaurant
    required String id,
    
    /// Identifiant du propriétaire/commerçant
    required String ownerId,
    
    /// Nom du restaurant
    required String name,
    
    /// Description du restaurant
    required String description,
    
    /// Type de cuisine/restaurant
    required RestaurantType type,
    
    /// URL de la photo de couverture
    String? coverImageUrl,
    
    /// URL du logo
    String? logoUrl,
    
    /// Galerie d'images
    @Default([]) List<String> imageUrls,
    
    /// Adresse complète
    required String address,
    
    /// Ville
    required String city,
    
    /// Code postal
    required String postalCode,
    
    /// Coordonnées géographiques
    required LocationCoordinates coordinates,
    
    /// Numéro de téléphone
    String? phoneNumber,
    
    /// Email de contact
    String? email,
    
    /// Site web
    String? website,
    
    /// Horaires d'ouverture
    @Default({}) Map<String, OpeningHours> openingHours,
    
    /// Note moyenne
    @Default(0.0) double averageRating,
    
    /// Nombre total d'avis
    @Default(0) int totalReviews,
    
    /// Nombre total de repas vendus
    @Default(0) int totalMealsSold,
    
    /// Nombre total d'économies générées (en euros)
    @Default(0.0) double totalSavingsGenerated,
    
    /// Spécialités culinaires
    @Default([]) List<String> specialties,
    
    /// Certifications (bio, halal, etc.)
    @Default([]) List<RestaurantCertification> certifications,
    
    /// Rayon de livraison en km
    @Default(5.0) double deliveryRadius,
    
    /// Temps de préparation moyen en minutes
    @Default(15) int averagePreparationTime,
    
    /// Indique si le restaurant est ouvert
    @Default(true) bool isOpen,
    
    /// Indique si le restaurant est actif
    @Default(true) bool isActive,
    
    /// Indique si le restaurant est vérifié
    @Default(false) bool isVerified,
    
    /// Indique si le restaurant propose de la livraison
    @Default(false) bool offersDelivery,
    
    /// Date de création
    DateTime? createdAt,
    
    /// Date de dernière mise à jour
    DateTime? updatedAt,
  }) = _Restaurant;

  /// Factory pour la désérialisation JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);
}

/// Types de restaurants
enum RestaurantType {
  /// Restaurant traditionnel
  @JsonValue('restaurant')
  restaurant,
  
  /// Boulangerie
  @JsonValue('bakery')
  bakery,
  
  /// Café
  @JsonValue('cafe')
  cafe,
  
  /// Fast-food
  @JsonValue('fast_food')
  fastFood,
  
  /// Traiteur
  @JsonValue('caterer')
  caterer,
  
  /// Food truck
  @JsonValue('food_truck')
  foodTruck,
  
  /// Supermarché
  @JsonValue('supermarket')
  supermarket,
  
  /// Épicerie
  @JsonValue('grocery_store')
  groceryStore,
  
  /// Autre
  @JsonValue('other')
  other,
}

/// Certifications du restaurant
enum RestaurantCertification {
  /// Certification biologique
  @JsonValue('organic')
  organic,
  
  /// Halal
  @JsonValue('halal')
  halal,
  
  /// Casher
  @JsonValue('kosher')
  kosher,
  
  /// Commerce équitable
  @JsonValue('fair_trade')
  fairTrade,
  
  /// Développement durable
  @JsonValue('sustainable')
  sustainable,
  
  /// Local/circuit court
  @JsonValue('local')
  local,
}

/// Coordonnées géographiques
@freezed
class LocationCoordinates with _$LocationCoordinates {
  /// Constructeur des coordonnées
  const factory LocationCoordinates({
    /// Latitude
    required double latitude,
    
    /// Longitude
    required double longitude,
  }) = _LocationCoordinates;

  /// Factory pour la désérialisation JSON
  factory LocationCoordinates.fromJson(Map<String, dynamic> json) =>
      _$LocationCoordinatesFromJson(json);
}

/// Horaires d'ouverture
@freezed
class OpeningHours with _$OpeningHours {
  /// Constructeur des horaires d'ouverture
  const factory OpeningHours({
    /// Heure d'ouverture
    required String openTime,
    
    /// Heure de fermeture
    required String closeTime,
    
    /// Indique si c'est fermé ce jour
    @Default(false) bool isClosed,
    
    /// Pause déjeuner (optionnelle)
    TimeSlot? lunchBreak,
  }) = _OpeningHours;

  /// Factory pour la désérialisation JSON
  factory OpeningHours.fromJson(Map<String, dynamic> json) =>
      _$OpeningHoursFromJson(json);
}

/// Créneau horaire
@freezed
class TimeSlot with _$TimeSlot {
  /// Constructeur du créneau horaire
  const factory TimeSlot({
    /// Heure de début
    required String startTime,
    
    /// Heure de fin
    required String endTime,
  }) = _TimeSlot;

  /// Factory pour la désérialisation JSON
  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);
}

/// Extensions utiles pour Restaurant
extension RestaurantExtension on Restaurant {
  /// Indique si le restaurant est actuellement ouvert
  bool get isCurrentlyOpen {
    if (!isOpen || !isActive) return false;
    
    final now = DateTime.now();
    final today = _getDayName(now.weekday);
    final todayHours = openingHours[today];
    
    if (todayHours == null || todayHours.isClosed) return false;
    
    final currentTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    return _isTimeInRange(currentTime, todayHours.openTime, todayHours.closeTime) &&
           (todayHours.lunchBreak == null || 
            !_isTimeInRange(currentTime, todayHours.lunchBreak!.startTime, todayHours.lunchBreak!.endTime));
  }
  
  /// Distance depuis une position donnée (approximative)
  double distanceFrom(LocationCoordinates userLocation) {
    // Calcul approximatif de la distance en utilisant la formule haversine
    const double earthRadius = 6371; // Rayon de la Terre en km
    
    final lat1Rad = userLocation.latitude * (3.14159 / 180);
    final lat2Rad = coordinates.latitude * (3.14159 / 180);
    final deltaLatRad = (coordinates.latitude - userLocation.latitude) * (3.14159 / 180);
    final deltaLngRad = (coordinates.longitude - userLocation.longitude) * (3.14159 / 180);
    
    final a = math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
              math.cos(lat1Rad) * math.cos(lat2Rad) *
              math.sin(deltaLngRad / 2) * math.sin(deltaLngRad / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadius * c;
  }
  
  /// Indique si le restaurant a une bonne note
  bool get hasGoodRating => averageRating >= 4.0;
  
  /// Indique si le restaurant est populaire
  bool get isPopular => totalReviews >= 50 && averageRating >= 4.0;
  
  /// Impact environnemental (économies générées)
  String get environmentalImpact {
    if (totalSavingsGenerated < 100) return 'Débutant';
    if (totalSavingsGenerated < 500) return 'Engagé';
    if (totalSavingsGenerated < 1000) return 'Actif';
    return 'Champion';
  }
}

/// Fonctions utilitaires privées
String _getDayName(int weekday) {
  const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
  return days[weekday - 1];
}

bool _isTimeInRange(String current, String start, String end) {
  final currentParts = current.split(':').map(int.parse).toList();
  final startParts = start.split(':').map(int.parse).toList();
  final endParts = end.split(':').map(int.parse).toList();
  
  final currentMinutes = currentParts[0] * 60 + currentParts[1];
  final startMinutes = startParts[0] * 60 + startParts[1];
  final endMinutes = endParts[0] * 60 + endParts[1];
  
  return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
}