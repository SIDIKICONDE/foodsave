import 'package:foodsave_app/domain/entities/basket.dart';

/// Interface abstraite pour la data source distante des paniers.
/// 
/// Définit les contrats pour les opérations distantes sur les paniers
/// via l'API REST.
abstract class BasketRemoteDataSource {
  /// Récupère la liste des paniers disponibles depuis l'API.
  /// 
  /// [latitude] et [longitude] pour filtrer par localisation.
  /// [radius] en kilomètres pour limiter la recherche.
  /// [limit] nombre maximum de résultats.
  /// [offset] pour la pagination.
  Future<List<Basket>> getAvailableBaskets({
    double? latitude,
    double? longitude,
    double radius = 10.0,
    int limit = 20,
    int offset = 0,
  });

  /// Récupère un panier par son ID depuis l'API.
  /// 
  /// [basketId] identifiant du panier.
  /// Lève une exception si le panier n'existe pas.
  Future<Basket> getBasketById(String basketId);

  /// Recherche des paniers selon des critères via l'API.
  /// 
  /// [query] terme de recherche.
  /// [commerceTypes] types de commerce à filtrer.
  /// [maxPrice] prix maximum.
  /// [dietaryTags] tags alimentaires requis.
  /// [availableFrom] heure de disponibilité minimum.
  /// [availableUntil] heure de disponibilité maximum.
  /// [latitude] et [longitude] pour la recherche géographique.
  /// [radius] rayon de recherche en kilomètres.
  /// [limit] nombre maximum de résultats.
  /// [offset] pour la pagination.
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
  });

  /// Récupère les paniers favoris de l'utilisateur depuis l'API.
  /// 
  /// [userId] identifiant de l'utilisateur.
  Future<List<Basket>> getFavoriteBaskets(String userId);

  /// Ajoute un panier aux favoris via l'API.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [basketId] identifiant du panier.
  Future<void> addToFavorites(String userId, String basketId);

  /// Retire un panier des favoris via l'API.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [basketId] identifiant du panier.
  Future<void> removeFromFavorites(String userId, String basketId);

  /// Vérifie si un panier est dans les favoris via l'API.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [basketId] identifiant du panier.
  Future<bool> isFavorite(String userId, String basketId);

  /// Récupère les paniers d'un commerce spécifique depuis l'API.
  /// 
  /// [commerceId] identifiant du commerce.
  /// [includeExpired] inclure les paniers expirés.
  Future<List<Basket>> getBasketsByCommerce(
    String commerceId, {
    bool includeExpired = false,
  });

  /// Récupère les paniers "dernière chance" depuis l'API.
  /// 
  /// [hoursUntilExpiry] nombre d'heures avant expiration.
  /// [latitude] et [longitude] pour la localisation.
  /// [radius] en kilomètres.
  /// [limit] nombre maximum de résultats.
  Future<List<Basket>> getLastChanceBaskets({
    int hoursUntilExpiry = 2,
    double? latitude,
    double? longitude,
    double radius = 10.0,
    int limit = 10,
  });

  /// Met à jour le statut d'un panier via l'API.
  /// 
  /// [basketId] identifiant du panier.
  /// [status] nouveau statut.
  Future<void> updateBasketStatus(String basketId, BasketStatus status);

  /// Décrémente la quantité disponible d'un panier via l'API.
  /// 
  /// [basketId] identifiant du panier.
  /// [quantity] quantité à décrémenter.
  Future<void> decrementBasketQuantity(String basketId, int quantity);

  /// Vérifie la disponibilité d'un panier en temps réel via l'API.
  /// 
  /// [basketId] identifiant du panier.
  Future<bool> checkBasketAvailability(String basketId);
}