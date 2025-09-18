import 'package:foodsave_app/domain/entities/commerce.dart';

/// Repository abstrait pour la gestion des commerces.
/// 
/// Définit les contrats pour les opérations sur les commerces partenaires,
/// leur découverte et leur gestion.
abstract class CommerceRepository {
  /// Récupère la liste des commerces disponibles.
  /// 
  /// [latitude] et [longitude] pour filtrer par localisation.
  /// [radius] en kilomètres pour limiter la recherche.
  /// [limit] nombre maximum de résultats.
  /// [offset] pour la pagination.
  Future<List<Commerce>> getAvailableCommerces({
    double? latitude,
    double? longitude,
    double radius = 10.0,
    int limit = 20,
    int offset = 0,
  });

  /// Récupère un commerce par son ID.
  /// 
  /// [commerceId] identifiant du commerce.
  Future<Commerce?> getCommerceById(String commerceId);

  /// Recherche des commerces selon des critères.
  /// 
  /// [query] terme de recherche.
  /// [type] type de commerce à filtrer.
  /// [tags] tags requis (végétarien, bio, etc.).
  /// [isVerified] seulement les commerces vérifiés.
  /// [minRating] note minimum.
  /// [ecoEngagement] niveau d'engagement écologique minimum.
  Future<List<Commerce>> searchCommerces({
    String? query,
    CommerceType? type,
    List<String>? tags,
    bool? isVerified,
    double? minRating,
    EcoEngagementLevel? ecoEngagement,
    double? latitude,
    double? longitude,
    double radius = 10.0,
    int limit = 20,
    int offset = 0,
  });

  /// Récupère les commerces favoris de l'utilisateur.
  /// 
  /// [userId] identifiant de l'utilisateur.
  Future<List<Commerce>> getFavoriteCommerces(String userId);

  /// Ajoute un commerce aux favoris.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [commerceId] identifiant du commerce.
  Future<bool> addToFavorites(String userId, String commerceId);

  /// Retire un commerce des favoris.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [commerceId] identifiant du commerce.
  Future<bool> removeFromFavorites(String userId, String commerceId);

  /// Vérifie si un commerce est dans les favoris.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [commerceId] identifiant du commerce.
  Future<bool> isFavorite(String userId, String commerceId);

  /// Récupère les commerces par type.
  /// 
  /// [type] type de commerce.
  /// [latitude] et [longitude] pour la localisation.
  /// [radius] en kilomètres.
  Future<List<Commerce>> getCommercesByType(
    CommerceType type, {
    double? latitude,
    double? longitude,
    double radius = 10.0,
    int limit = 20,
  });

  /// Récupère les commerces les mieux notés.
  /// 
  /// [minRating] note minimum.
  /// [latitude] et [longitude] pour la localisation.
  /// [radius] en kilomètres.
  /// [limit] nombre maximum de résultats.
  Future<List<Commerce>> getTopRatedCommerces({
    double minRating = 4.0,
    double? latitude,
    double? longitude,
    double radius = 10.0,
    int limit = 10,
  });

  /// Récupère les commerces les plus engagés écologiquement.
  /// 
  /// [minLevel] niveau d'engagement minimum.
  /// [latitude] et [longitude] pour la localisation.
  /// [radius] en kilomètres.
  /// [limit] nombre maximum de résultats.
  Future<List<Commerce>> getEcoFriendlyCommerces({
    EcoEngagementLevel minLevel = EcoEngagementLevel.silver,
    double? latitude,
    double? longitude,
    double radius = 10.0,
    int limit = 10,
  });

  /// Récupère les commerces récemment ajoutés.
  /// 
  /// [daysSince] nombre de jours depuis l'ajout.
  /// [latitude] et [longitude] pour la localisation.
  /// [radius] en kilomètres.
  /// [limit] nombre maximum de résultats.
  Future<List<Commerce>> getRecentCommerces({
    int daysSince = 30,
    double? latitude,
    double? longitude,
    double radius = 10.0,
    int limit = 10,
  });

  /// Vérifie si un commerce est ouvert maintenant.
  /// 
  /// [commerceId] identifiant du commerce.
  /// [dateTime] date/heure à vérifier (par défaut maintenant).
  Future<bool> isCommerceOpen(String commerceId, {DateTime? dateTime});

  /// Récupère les horaires d'un commerce.
  /// 
  /// [commerceId] identifiant du commerce.
  Future<Map<int, String?>> getCommerceOpeningHours(String commerceId);

  /// Calcule la distance jusqu'à un commerce.
  /// 
  /// [commerceId] identifiant du commerce.
  /// [userLatitude] latitude de l'utilisateur.
  /// [userLongitude] longitude de l'utilisateur.
  Future<double> calculateDistanceToCommerce(
    String commerceId,
    double userLatitude,
    double userLongitude,
  );

  /// Met à jour les statistiques d'un commerce.
  /// 
  /// [commerceId] identifiant du commerce.
  /// [basketsSold] nombre de paniers vendus à ajouter.
  /// [kgSaved] poids sauvé à ajouter.
  /// [co2Saved] CO2 économisé à ajouter.
  Future<bool> updateCommerceStats(
    String commerceId, {
    int? basketsSold,
    double? kgSaved,
    double? co2Saved,
  });

  /// Ajoute un avis sur un commerce.
  /// 
  /// [commerceId] identifiant du commerce.
  /// [userId] identifiant de l'utilisateur.
  /// [rating] note de 1 à 5.
  /// [comment] commentaire (optionnel).
  Future<bool> addCommerceReview(
    String commerceId,
    String userId, {
    required double rating,
    String? comment,
  });

  /// Stream pour écouter les changements d'un commerce.
  /// 
  /// [commerceId] identifiant du commerce.
  Stream<Commerce?> watchCommerce(String commerceId);

  /// Stream pour écouter les commerces disponibles.
  /// 
  /// [latitude] et [longitude] pour la localisation.
  /// [radius] en kilomètres.
  Stream<List<Commerce>> watchAvailableCommerces({
    double? latitude,
    double? longitude,
    double radius = 10.0,
  });
}