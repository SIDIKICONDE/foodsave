import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Modèle représentant un marqueur sur la carte
class MapMarker {
  final String id;
  final LatLng position;
  final MarkerType type;
  final String title;
  final String description;
  final double? price;
  final String? imageUrl;
  final bool isFavorite;
  final DateTime? availableUntil;
  final int? quantity;
  final double? rating;
  final String? shopName;
  final String? address;

  const MapMarker({
    required this.id,
    required this.position,
    required this.type,
    required this.title,
    required this.description,
    this.price,
    this.imageUrl,
    this.isFavorite = false,
    this.availableUntil,
    this.quantity,
    this.rating,
    this.shopName,
    this.address,
  });

  /// Crée une copie du marqueur avec les modifications spécifiées
  MapMarker copyWith({
    String? id,
    LatLng? position,
    MarkerType? type,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavorite,
    DateTime? availableUntil,
    int? quantity,
    double? rating,
    String? shopName,
    String? address,
  }) {
    return MapMarker(
      id: id ?? this.id,
      position: position ?? this.position,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      availableUntil: availableUntil ?? this.availableUntil,
      quantity: quantity ?? this.quantity,
      rating: rating ?? this.rating,
      shopName: shopName ?? this.shopName,
      address: address ?? this.address,
    );
  }
}

/// Types de marqueurs disponibles
enum MarkerType {
  boulangerie,
  restaurant,
  supermarche,
  primeur,
  autre,
  userLocation,
}

/// Extension pour obtenir les propriétés visuelles des types de marqueurs
extension MarkerTypeExtension on MarkerType {
  String get label {
    switch (this) {
      case MarkerType.boulangerie:
        return 'Boulangerie';
      case MarkerType.restaurant:
        return 'Restaurant';
      case MarkerType.supermarche:
        return 'Supermarché';
      case MarkerType.primeur:
        return 'Primeur';
      case MarkerType.autre:
        return 'Autre';
      case MarkerType.userLocation:
        return 'Ma position';
    }
  }

  BitmapDescriptor get markerColor {
    switch (this) {
      case MarkerType.boulangerie:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      case MarkerType.restaurant:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case MarkerType.supermarche:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case MarkerType.primeur:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case MarkerType.autre:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      case MarkerType.userLocation:
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  String get iconAsset {
    switch (this) {
      case MarkerType.boulangerie:
        return '🥖';
      case MarkerType.restaurant:
        return '🍽️';
      case MarkerType.supermarche:
        return '🛒';
      case MarkerType.primeur:
        return '🥬';
      case MarkerType.autre:
        return '📦';
      case MarkerType.userLocation:
        return '📍';
    }
  }
}