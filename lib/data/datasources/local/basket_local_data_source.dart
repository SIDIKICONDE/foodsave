import 'package:foodsave_app/domain/entities/basket.dart';

/// Interface abstraite pour la data source locale des paniers.
/// 
/// Définit les contrats pour les opérations locales sur les paniers
/// incluant la mise en cache et le stockage hors ligne.
abstract class BasketLocalDataSource {
  /// Sauvegarde une liste de paniers en cache local.
  /// 
  /// [baskets] liste des paniers à sauvegarder.
  /// [cacheKey] clé de cache pour identifier le type de données.
  Future<void> cacheBaskets(List<Basket> baskets, String cacheKey);

  /// Récupère les paniers depuis le cache local.
  /// 
  /// [cacheKey] clé de cache pour identifier le type de données.
  /// Retourne une liste vide si aucun cache n'existe.
  Future<List<Basket>> getCachedBaskets(String cacheKey);

  /// Sauvegarde un panier spécifique en cache local.
  /// 
  /// [basket] panier à sauvegarder.
  Future<void> cacheBasket(Basket basket);

  /// Récupère un panier spécifique depuis le cache local.
  /// 
  /// [basketId] identifiant du panier.
  /// Retourne null si le panier n'existe pas en cache.
  Future<Basket?> getCachedBasket(String basketId);

  /// Sauvegarde les paniers favoris d'un utilisateur.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [favoriteBasketIds] liste des IDs des paniers favoris.
  Future<void> saveFavoriteBaskets(String userId, List<String> favoriteBasketIds);

  /// Récupère les paniers favoris d'un utilisateur depuis le cache.
  /// 
  /// [userId] identifiant de l'utilisateur.
  Future<List<String>> getFavoriteBaskets(String userId);

  /// Ajoute un panier aux favoris dans le cache local.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [basketId] identifiant du panier.
  Future<void> addToFavorites(String userId, String basketId);

  /// Retire un panier des favoris dans le cache local.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [basketId] identifiant du panier.
  Future<void> removeFromFavorites(String userId, String basketId);

  /// Vérifie si un panier est dans les favoris en cache local.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [basketId] identifiant du panier.
  Future<bool> isFavorite(String userId, String basketId);

  /// Sauvegarde les critères de recherche récents.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [searchQueries] liste des recherches récentes.
  Future<void> saveRecentSearches(String userId, List<String> searchQueries);

  /// Récupère les critères de recherche récents.
  /// 
  /// [userId] identifiant de l'utilisateur.
  Future<List<String>> getRecentSearches(String userId);

  /// Sauvegarde la dernière position connue de l'utilisateur.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [latitude] latitude de la position.
  /// [longitude] longitude de la position.
  Future<void> saveLastKnownLocation(String userId, double latitude, double longitude);

  /// Récupère la dernière position connue de l'utilisateur.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// Retourne null si aucune position n'est sauvegardée.
  Future<Map<String, double>?> getLastKnownLocation(String userId);

  /// Efface tout le cache des paniers.
  Future<void> clearBasketCache();

  /// Efface le cache expiré.
  /// 
  /// [maxAge] âge maximum en heures pour considérer un cache comme valide.
  Future<void> clearExpiredCache({int maxAge = 24});

  /// Vérifie si le cache est encore valide.
  /// 
  /// [cacheKey] clé de cache à vérifier.
  /// [maxAge] âge maximum en heures.
  Future<bool> isCacheValid(String cacheKey, {int maxAge = 1});

  /// Obtient la taille du cache en bytes.
  Future<int> getCacheSize();
}