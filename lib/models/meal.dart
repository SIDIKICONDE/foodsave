import 'package:freezed_annotation/freezed_annotation.dart';

part 'meal.freezed.dart';
part 'meal.g.dart';

/// Modèle de repas/invendu pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
@freezed
class Meal with _$Meal {
  /// Constructeur du modèle Meal
  const factory Meal({
    /// Identifiant unique du repas
    required String id,
    
    /// Identifiant du commerçant propriétaire
    required String merchantId,
    
    /// Nom/titre du repas
    required String title,
    
    /// Description détaillée
    required String description,
    
    /// Prix original
    required double originalPrice,
    
    /// Prix après réduction
    required double discountedPrice,
    
    /// Catégorie du repas
    required MealCategory category,
    
    /// URLs des images
    @Default([]) List<String> imageUrls,
    
    /// Quantité disponible
    required int quantity,
    
    /// Quantité restante
    @Default(0) int remainingQuantity,
    
    /// Liste des allergènes
    @Default([]) List<String> allergens,
    
    /// Liste des ingrédients
    @Default([]) List<String> ingredients,
    
    /// Informations nutritionnelles
    NutritionalInfo? nutritionalInfo,
    
    /// Date/heure de disponibilité
    required DateTime availableFrom,
    
    /// Date/heure limite de récupération
    required DateTime availableUntil,
    
    /// Statut du repas
    @Default(MealStatus.available) MealStatus status,
    
    /// Note moyenne
    @Default(0.0) double averageRating,
    
    /// Nombre de votes
    @Default(0) int ratingCount,
    
    /// Indique si c'est végétarien
    @Default(false) bool isVegetarian,
    
    /// Indique si c'est végétalien
    @Default(false) bool isVegan,
    
    /// Indique si c'est sans gluten
    @Default(false) bool isGlutenFree,
    
    /// Indique si c'est halal
    @Default(false) bool isHalal,
    
    /// Date de création
    DateTime? createdAt,
    
    /// Date de dernière mise à jour
    DateTime? updatedAt,
  }) = _Meal;

  /// Factory pour la désérialisation JSON
  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
}

/// Catégories de repas
enum MealCategory {
  /// Plat principal
  @JsonValue('main_course')
  mainCourse,
  
  /// Entrée
  @JsonValue('appetizer')
  appetizer,
  
  /// Dessert
  @JsonValue('dessert')
  dessert,
  
  /// Boisson
  @JsonValue('beverage')
  beverage,
  
  /// Snack
  @JsonValue('snack')
  snack,
  
  /// Boulangerie
  @JsonValue('bakery')
  bakery,
  
  /// Autre
  @JsonValue('other')
  other,
}

/// Statut du repas
enum MealStatus {
  /// Disponible
  @JsonValue('available')
  available,
  
  /// Épuisé
  @JsonValue('sold_out')
  soldOut,
  
  /// Expiré
  @JsonValue('expired')
  expired,
  
  /// Suspendu
  @JsonValue('suspended')
  suspended,
}

/// Informations nutritionnelles
@freezed
class NutritionalInfo with _$NutritionalInfo {
  /// Constructeur des informations nutritionnelles
  const factory NutritionalInfo({
    /// Calories (kcal)
    int? calories,
    
    /// Protéines (g)
    double? proteins,
    
    /// Glucides (g)
    double? carbohydrates,
    
    /// Lipides (g)
    double? fats,
    
    /// Fibres (g)
    double? fiber,
    
    /// Sucres (g)
    double? sugar,
    
    /// Sodium (mg)
    double? sodium,
  }) = _NutritionalInfo;

  /// Factory pour la désérialisation JSON
  factory NutritionalInfo.fromJson(Map<String, dynamic> json) =>
      _$NutritionalInfoFromJson(json);
}

/// Extensions utiles pour Meal
extension MealExtension on Meal {
  /// Pourcentage de réduction
  double get discountPercentage {
    if (originalPrice == 0) return 0.0;
    return ((originalPrice - discountedPrice) / originalPrice) * 100;
  }
  
  /// Économie réalisée
  double get savings => originalPrice - discountedPrice;
  
  /// Indique si le repas est encore disponible
  bool get isAvailable =>
      status == MealStatus.available &&
      remainingQuantity > 0 &&
      DateTime.now().isBefore(availableUntil);
  
  /// Indique si le délai de récupération est dépassé
  bool get isExpired => DateTime.now().isAfter(availableUntil);
  
  /// Temps restant avant expiration
  Duration get timeUntilExpiration =>
      availableUntil.difference(DateTime.now());
  
  /// Indique si le repas convient aux végétariens
  bool get isSuitableForVegetarians => isVegetarian || isVegan;
}