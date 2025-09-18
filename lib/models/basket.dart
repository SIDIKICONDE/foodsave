import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'basket.g.dart';

/// Modèle représentant un panier anti-gaspi
/// 
/// Correspond à la table `baskets_map` dans Supabase.
@JsonSerializable()
class Basket extends Equatable {
  /// Identifiant unique du panier
  final String id;

  /// Identifiant du magasin associé
  @JsonKey(name: 'shop_id')
  final String? shopId;

  /// Titre du panier
  final String title;

  /// Description détaillée du panier
  final String? description;

  /// Prix actuel du panier
  final double price;

  /// Prix original avant réduction
  @JsonKey(name: 'original_price')
  final double? originalPrice;

  /// Latitude de l'emplacement
  final double latitude;

  /// Longitude de l'emplacement
  final double longitude;

  /// Type de panier (ex: boulangerie, restaurant, etc.)
  final String type;

  /// Quantité disponible
  final int quantity;

  /// Date/heure de début de disponibilité
  @JsonKey(name: 'available_from')
  final DateTime? availableFrom;

  /// Date/heure de fin de disponibilité
  @JsonKey(name: 'available_until')
  final DateTime availableUntil;

  /// URL de l'image du panier
  @JsonKey(name: 'image_url')
  final String? imageUrl;

  /// Indique si le panier est actif
  @JsonKey(name: 'is_active')
  final bool isActive;

  /// Date de création
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  /// Date de dernière mise à jour
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  /// Crée une nouvelle instance de [Basket]
  const Basket({
    required this.id,
    this.shopId,
    required this.title,
    this.description,
    required this.price,
    this.originalPrice,
    required this.latitude,
    required this.longitude,
    required this.type,
    this.quantity = 1,
    this.availableFrom,
    required this.availableUntil,
    this.imageUrl,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Crée une instance de [Basket] à partir d'un JSON
  factory Basket.fromJson(Map<String, dynamic> json) => _$BasketFromJson(json);

  /// Convertit l'instance en JSON
  Map<String, dynamic> toJson() => _$BasketToJson(this);

  /// Calcule la réduction en pourcentage
  double? get discountPercentage {
    if (originalPrice == null || originalPrice! <= 0) return null;
    return ((originalPrice! - price) / originalPrice!) * 100;
  }

  /// Vérifie si le panier est disponible maintenant
  bool get isAvailable {
    if (!isActive) return false;
    
    final DateTime now = DateTime.now();
    
    // Vérifier la date de début si spécifiée
    if (availableFrom != null && now.isBefore(availableFrom!)) {
      return false;
    }
    
    // Vérifier la date de fin
    return now.isBefore(availableUntil);
  }

  /// Calcule la distance depuis une position donnée
  /// 
  /// Utilise la formule de Haversine pour calculer la distance
  /// entre deux points géographiques.
  double distanceFrom(double fromLatitude, double fromLongitude) {
    // Implémentation simplifiée - dans un vrai projet, 
    // utiliser le package geolocator pour plus de précision
    const double earthRadius = 6371; // Rayon de la Terre en kilomètres
    
    final double latDiff = _toRadians(latitude - fromLatitude);
    final double lonDiff = _toRadians(longitude - fromLongitude);
    
    final double a = math.sin(latDiff / 2) * math.sin(latDiff / 2) +
        math.cos(_toRadians(fromLatitude)) * math.cos(_toRadians(latitude)) *
        math.sin(lonDiff / 2) * math.sin(lonDiff / 2);
    
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return earthRadius * c;
  }

  /// Convertit les degrés en radians
  double _toRadians(double degrees) => degrees * (math.pi / 180);

  /// Crée une copie de l'instance avec les propriétés modifiées
  Basket copyWith({
    String? id,
    String? shopId,
    String? title,
    String? description,
    double? price,
    double? originalPrice,
    double? latitude,
    double? longitude,
    String? type,
    int? quantity,
    DateTime? availableFrom,
    DateTime? availableUntil,
    String? imageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Basket(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      availableFrom: availableFrom ?? this.availableFrom,
      availableUntil: availableUntil ?? this.availableUntil,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        shopId,
        title,
        description,
        price,
        originalPrice,
        latitude,
        longitude,
        type,
        quantity,
        availableFrom,
        availableUntil,
        imageUrl,
        isActive,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Basket(id: $id, title: $title, price: $price, type: $type, isActive: $isActive)';
  }
}
