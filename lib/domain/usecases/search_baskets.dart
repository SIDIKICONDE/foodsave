import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/domain/repositories/basket_repository.dart';
import 'package:foodsave_app/domain/usecases/usecase.dart';

/// Use case pour rechercher des paniers selon des critères.
/// 
/// Permet de filtrer les paniers par nom, type, prix, tags alimentaires, etc.
class SearchBaskets extends UseCase<List<Basket>, SearchBasketsParams> {
  /// Crée une nouvelle instance de [SearchBaskets].
  SearchBaskets(this._repository);

  /// Repository des paniers.
  final BasketRepository _repository;

  @override
  Future<List<Basket>> call(SearchBasketsParams params) async {
    // Validation de la requête
    if (params.query != null && params.query!.trim().isEmpty) {
      throw ArgumentError('La requête de recherche ne peut pas être vide');
    }

    if (params.maxPrice != null && params.maxPrice! < 0) {
      throw ArgumentError('Le prix maximum ne peut pas être négatif');
    }

    return await _repository.searchBaskets(
      query: params.query?.trim(),
      commerceTypes: params.commerceTypes,
      maxPrice: params.maxPrice,
      dietaryTags: params.dietaryTags,
      availableFrom: params.availableFrom,
      availableUntil: params.availableUntil,
      latitude: params.latitude,
      longitude: params.longitude,
      radius: params.radius,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

/// Paramètres pour rechercher des paniers.
class SearchBasketsParams extends UseCaseParams {
  /// Crée une nouvelle instance de [SearchBasketsParams].
  const SearchBasketsParams({
    this.query,
    this.commerceTypes,
    this.maxPrice,
    this.dietaryTags,
    this.availableFrom,
    this.availableUntil,
    this.latitude,
    this.longitude,
    this.radius = 10.0,
    this.limit = 20,
    this.offset = 0,
  });

  /// Terme de recherche.
  final String? query;

  /// Types de commerce à filtrer.
  final List<String>? commerceTypes;

  /// Prix maximum.
  final double? maxPrice;

  /// Tags alimentaires requis (végétarien, sans gluten, etc.).
  final List<String>? dietaryTags;

  /// Heure de disponibilité minimum.
  final DateTime? availableFrom;

  /// Heure de disponibilité maximum.
  final DateTime? availableUntil;

  /// Latitude pour la recherche géographique.
  final double? latitude;

  /// Longitude pour la recherche géographique.
  final double? longitude;

  /// Rayon de recherche en kilomètres.
  final double radius;

  /// Nombre maximum de résultats.
  final int limit;

  /// Offset pour la pagination.
  final int offset;

  @override
  List<Object?> get props => [
        query,
        commerceTypes,
        maxPrice,
        dietaryTags,
        availableFrom,
        availableUntil,
        latitude,
        longitude,
        radius,
        limit,
        offset,
      ];
}