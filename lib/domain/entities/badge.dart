import 'package:equatable/equatable.dart';

/// Énumération des catégories de badges.
enum BadgeCategory {
  /// Badges liés aux économies réalisées.
  savings,
  /// Badges écologiques.
  environmental,
  /// Badges de fidélité.
  loyalty,
  /// Badges sociaux et communautaires.
  social,
  /// Badges de découverte.
  discovery,
  /// Badges de performance.
  performance,
  /// Badges d'événements spéciaux.
  special,
  /// Badges de collection.
  collection,
}

/// Énumération de la rareté des badges.
enum BadgeRarity {
  /// Badge commun.
  common,
  /// Badge peu commun.
  uncommon,
  /// Badge rare.
  rare,
  /// Badge épique.
  epic,
  /// Badge légendaire.
  legendary,
}

/// Entité représentant un badge dans le système de gamification.
/// 
/// Cette entité définit les caractéristiques d'un badge qui peut être
/// gagné par les utilisateurs selon leurs actions dans l'application.
class Badge extends Equatable {
  /// Crée une nouvelle instance de [Badge].
  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.rarity,
    required this.iconUrl,
    required this.pointsValue,
    required this.isActive,
    this.requirements = const {},
    this.colorHex,
    this.unlockMessage,
    this.createdAt,
    this.isHidden = false,
    this.prerequisiteBadges = const [],
    this.maxEarnings,
    this.seasonalStart,
    this.seasonalEnd,
    this.tags = const [],
  });

  /// Identifiant unique du badge.
  final String id;

  /// Nom du badge.
  final String name;

  /// Description du badge.
  final String description;

  /// Catégorie du badge.
  final BadgeCategory category;

  /// Rareté du badge.
  final BadgeRarity rarity;

  /// URL de l'icône du badge.
  final String iconUrl;

  /// Valeur en points du badge.
  final int pointsValue;

  /// Si le badge est actuellement actif.
  final bool isActive;

  /// Conditions requises pour débloquer le badge.
  final Map<String, dynamic> requirements;

  /// Couleur du badge en hexadécimal.
  final String? colorHex;

  /// Message affiché lors du déverrouillage.
  final String? unlockMessage;

  /// Date de création du badge.
  final DateTime? createdAt;

  /// Si le badge est caché jusqu'à déverrouillage.
  final bool isHidden;

  /// Badges prérequis.
  final List<String> prerequisiteBadges;

  /// Nombre maximum de fois que le badge peut être gagné.
  final int? maxEarnings;

  /// Date de début pour les badges saisonniers.
  final DateTime? seasonalStart;

  /// Date de fin pour les badges saisonniers.
  final DateTime? seasonalEnd;

  /// Tags descriptifs.
  final List<String> tags;

  /// Vérifie si le badge est saisonnier.
  bool get isSeasonal {
    return seasonalStart != null && seasonalEnd != null;
  }

  /// Vérifie si le badge est actuellement disponible (pour les badges saisonniers).
  bool get isCurrentlyAvailable {
    if (!isSeasonal) return isActive;
    
    final DateTime now = DateTime.now();
    return isActive &&
        now.isAfter(seasonalStart!) &&
        now.isBefore(seasonalEnd!);
  }

  /// Retourne la couleur selon la rareté.
  String get rarityColor {
    switch (rarity) {
      case BadgeRarity.common:
        return '#74C0FC';
      case BadgeRarity.uncommon:
        return '#51CF66';
      case BadgeRarity.rare:
        return '#FFD93D';
      case BadgeRarity.epic:
        return '#FF8787';
      case BadgeRarity.legendary:
        return '#9C88FF';
    }
  }

  /// Retourne le texte de rareté localisé.
  String get rarityText {
    switch (rarity) {
      case BadgeRarity.common:
        return 'Commun';
      case BadgeRarity.uncommon:
        return 'Peu commun';
      case BadgeRarity.rare:
        return 'Rare';
      case BadgeRarity.epic:
        return 'Épique';
      case BadgeRarity.legendary:
        return 'Légendaire';
    }
  }

  /// Retourne le texte de catégorie localisé.
  String get categoryText {
    switch (category) {
      case BadgeCategory.savings:
        return 'Économies';
      case BadgeCategory.environmental:
        return 'Écologique';
      case BadgeCategory.loyalty:
        return 'Fidélité';
      case BadgeCategory.social:
        return 'Social';
      case BadgeCategory.discovery:
        return 'Découverte';
      case BadgeCategory.performance:
        return 'Performance';
      case BadgeCategory.special:
        return 'Spécial';
      case BadgeCategory.collection:
        return 'Collection';
    }
  }

  /// Retourne l'emoji associé à la catégorie.
  String get categoryEmoji {
    switch (category) {
      case BadgeCategory.savings:
        return '💰';
      case BadgeCategory.environmental:
        return '🌱';
      case BadgeCategory.loyalty:
        return '⭐';
      case BadgeCategory.social:
        return '👥';
      case BadgeCategory.discovery:
        return '🔍';
      case BadgeCategory.performance:
        return '🚀';
      case BadgeCategory.special:
        return '🎉';
      case BadgeCategory.collection:
        return '🏆';
    }
  }

  /// Calcule le multiplicateur de points selon la rareté.
  double get pointsMultiplier {
    switch (rarity) {
      case BadgeRarity.common:
        return 1.0;
      case BadgeRarity.uncommon:
        return 1.5;
      case BadgeRarity.rare:
        return 2.0;
      case BadgeRarity.epic:
        return 3.0;
      case BadgeRarity.legendary:
        return 5.0;
    }
  }

  /// Calcule les points effectifs avec multiplicateur.
  int get effectivePoints {
    return (pointsValue * pointsMultiplier).round();
  }

  /// Crée une copie du badge avec des valeurs modifiées.
  Badge copyWith({
    String? id,
    String? name,
    String? description,
    BadgeCategory? category,
    BadgeRarity? rarity,
    String? iconUrl,
    int? pointsValue,
    bool? isActive,
    Map<String, dynamic>? requirements,
    String? colorHex,
    String? unlockMessage,
    DateTime? createdAt,
    bool? isHidden,
    List<String>? prerequisiteBadges,
    int? maxEarnings,
    DateTime? seasonalStart,
    DateTime? seasonalEnd,
    List<String>? tags,
  }) {
    return Badge(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      rarity: rarity ?? this.rarity,
      iconUrl: iconUrl ?? this.iconUrl,
      pointsValue: pointsValue ?? this.pointsValue,
      isActive: isActive ?? this.isActive,
      requirements: requirements ?? this.requirements,
      colorHex: colorHex ?? this.colorHex,
      unlockMessage: unlockMessage ?? this.unlockMessage,
      createdAt: createdAt ?? this.createdAt,
      isHidden: isHidden ?? this.isHidden,
      prerequisiteBadges: prerequisiteBadges ?? this.prerequisiteBadges,
      maxEarnings: maxEarnings ?? this.maxEarnings,
      seasonalStart: seasonalStart ?? this.seasonalStart,
      seasonalEnd: seasonalEnd ?? this.seasonalEnd,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        category,
        rarity,
        iconUrl,
        pointsValue,
        isActive,
        requirements,
        colorHex,
        unlockMessage,
        createdAt,
        isHidden,
        prerequisiteBadges,
        maxEarnings,
        seasonalStart,
        seasonalEnd,
        tags,
      ];

  @override
  String toString() {
    return 'Badge(id: $id, name: $name, rarity: $rarity, points: $effectivePoints)';
  }
}