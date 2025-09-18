import 'package:equatable/equatable.dart';

/// Événements du BLoC pour la gestion des paniers.
abstract class BasketEvent extends Equatable {
  const BasketEvent();

  @override
  List<Object?> get props => [];
}

/// Événement pour charger les paniers disponibles.
class LoadAvailableBaskets extends BasketEvent {
  /// Crée une nouvelle instance de [LoadAvailableBaskets].
  const LoadAvailableBaskets({
    this.latitude,
    this.longitude,
    this.radius = 10.0,
    this.refresh = false,
  });

  /// Latitude de l'utilisateur.
  final double? latitude;

  /// Longitude de l'utilisateur.
  final double? longitude;

  /// Rayon de recherche en kilomètres.
  final double radius;

  /// Si c'est un rafraîchissement des données.
  final bool refresh;

  @override
  List<Object?> get props => [latitude, longitude, radius, refresh];
}

/// Événement pour rechercher des paniers.
class SearchBasketsEvent extends BasketEvent {
  /// Crée une nouvelle instance de [SearchBasketsEvent].
  const SearchBasketsEvent({
    this.query,
    this.commerceTypes,
    this.maxPrice,
    this.dietaryTags,
    this.latitude,
    this.longitude,
    this.radius = 10.0,
  });

  /// Terme de recherche.
  final String? query;

  /// Types de commerce à filtrer.
  final List<String>? commerceTypes;

  /// Prix maximum.
  final double? maxPrice;

  /// Tags alimentaires requis.
  final List<String>? dietaryTags;

  /// Latitude pour la recherche géographique.
  final double? latitude;

  /// Longitude pour la recherche géographique.
  final double? longitude;

  /// Rayon de recherche en kilomètres.
  final double radius;

  @override
  List<Object?> get props => [
        query,
        commerceTypes,
        maxPrice,
        dietaryTags,
        latitude,
        longitude,
        radius,
      ];
}

/// Événement pour charger plus de paniers (pagination).
class LoadMoreBaskets extends BasketEvent {
  /// Crée une nouvelle instance de [LoadMoreBaskets].
  const LoadMoreBaskets();
}

/// Événement pour ajouter un panier aux favoris.
class AddBasketToFavorites extends BasketEvent {
  /// Crée une nouvelle instance de [AddBasketToFavorites].
  const AddBasketToFavorites({
    required this.userId,
    required this.basketId,
  });

  /// Identifiant de l'utilisateur.
  final String userId;

  /// Identifiant du panier.
  final String basketId;

  @override
  List<Object> get props => [userId, basketId];
}

/// Événement pour retirer un panier des favoris.
class RemoveBasketFromFavorites extends BasketEvent {
  /// Crée une nouvelle instance de [RemoveBasketFromFavorites].
  const RemoveBasketFromFavorites({
    required this.userId,
    required this.basketId,
  });

  /// Identifiant de l'utilisateur.
  final String userId;

  /// Identifiant du panier.
  final String basketId;

  @override
  List<Object> get props => [userId, basketId];
}

/// Événement pour charger les paniers favoris.
class LoadFavoriteBaskets extends BasketEvent {
  /// Crée une nouvelle instance de [LoadFavoriteBaskets].
  const LoadFavoriteBaskets({required this.userId});

  /// Identifiant de l'utilisateur.
  final String userId;

  @override
  List<Object> get props => [userId];
}

/// Événement pour charger les paniers "dernière chance".
class LoadLastChanceBaskets extends BasketEvent {
  /// Crée une nouvelle instance de [LoadLastChanceBaskets].
  const LoadLastChanceBaskets({
    this.latitude,
    this.longitude,
    this.radius = 10.0,
    this.hoursUntilExpiry = 2,
  });

  /// Latitude de l'utilisateur.
  final double? latitude;

  /// Longitude de l'utilisateur.
  final double? longitude;

  /// Rayon de recherche en kilomètres.
  final double radius;

  /// Nombre d'heures avant expiration.
  final int hoursUntilExpiry;

  @override
  List<Object?> get props => [latitude, longitude, radius, hoursUntilExpiry];
}

/// Événement pour réinitialiser la recherche.
class ResetBasketSearch extends BasketEvent {
  /// Crée une nouvelle instance de [ResetBasketSearch].
  const ResetBasketSearch();
}