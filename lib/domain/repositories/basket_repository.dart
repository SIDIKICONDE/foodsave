import 'package:foodsave_app/domain/entities/basket.dart';

/// Repository abstrait pour la gestion des paniers.
/// 
/// Définit les contrats pour les opérations CRUD sur les paniers
/// et les fonctionnalités métier associées.
abstract class BasketRepository {
  /// Récupère la liste des paniers disponibles.
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

  /// Récupère un panier par son ID.
  /// 
  /// Retourne null si le panier n'existe pas.
  Future<Basket?> getBasketById(String basketId);

  /// Recherche des paniers selon des critères.
  /// 
  /// [query] terme de recherche.
  /// [commerceTypes] types de commerce à filtrer.
  /// [maxPrice] prix maximum.
  /// [dietaryTags] tags alimentaires requis.
  /// [availableFrom] heure de disponibilité minimum.
  /// [availableUntil] heure de disponibilité maximum.
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

  /// Récupère les paniers favoris de l'utilisateur.
  /// 
  /// [userId] identifiant de l'utilisateur.
  Future<List<Basket>> getFavoriteBaskets(String userId);

  /// Ajoute un panier aux favoris.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [basketId] identifiant du panier.
  Future<bool> addToFavorites(String userId, String basketId);

  /// Retire un panier des favoris.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [basketId] identifiant du panier.
  Future<bool> removeFromFavorites(String userId, String basketId);

  /// Vérifie si un panier est dans les favoris.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [basketId] identifiant du panier.
  Future<bool> isFavorite(String userId, String basketId);

  /// Récupère les paniers d'un commerce spécifique.
  /// 
  /// [commerceId] identifiant du commerce.
  /// [includeExpired] inclure les paniers expirés.
  Future<List<Basket>> getBasketsByCommerce(
    String commerceId, {
    bool includeExpired = false,
  });

  /// Récupère les paniers "dernière chance" (bientôt expirés).
  /// 
  /// [hoursUntilExpiry] nombre d'heures avant expiration.
  /// [latitude] et [longitude] pour la localisation.
  /// [radius] en kilomètres.
  Future<List<Basket>> getLastChanceBaskets({
    int hoursUntilExpiry = 2,
    double? latitude,
    double? longitude,
    double radius = 10.0,
    int limit = 10,
  });

  /// Met à jour le statut d'un panier.
  /// 
  /// [basketId] identifiant du panier.
  /// [status] nouveau statut.
  Future<bool> updateBasketStatus(String basketId, BasketStatus status);

  /// Décrémente la quantité disponible d'un panier.
  /// 
  /// [basketId] identifiant du panier.
  /// [quantity] quantité à décrémenter.
  Future<bool> decrementBasketQuantity(String basketId, int quantity);

  /// Vérifie la disponibilité d'un panier en temps réel.
  /// 
  /// [basketId] identifiant du panier.
  Future<bool> checkBasketAvailability(String basketId);

  /// Stream pour écouter les changements d'un panier.
  /// 
  /// [basketId] identifiant du panier.
  Stream<Basket?> watchBasket(String basketId);

  /// Stream pour écouter les nouveaux paniers disponibles.
  /// 
  /// [latitude] et [longitude] pour la localisation.
  /// [radius] en kilomètres.
  Stream<List<Basket>> watchAvailableBaskets({
    double? latitude,
    double? longitude,
    double radius = 10.0,
  });
}