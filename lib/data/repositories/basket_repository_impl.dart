import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/domain/repositories/basket_repository.dart';
import 'package:foodsave_app/data/datasources/remote/basket_remote_data_source.dart';

/// Implémentation concrète de [BasketRepository] s'appuyant sur
/// une [BasketRemoteDataSource].
class BasketRepositoryImpl implements BasketRepository {
  /// Crée une nouvelle instance de [BasketRepositoryImpl].
  const BasketRepositoryImpl({required BasketRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  /// Data source distante.
  final BasketRemoteDataSource _remoteDataSource;

  @override
  Future<List<Basket>> getAvailableBaskets({
    double? latitude,
    double? longitude,
    double radius = 10.0,
    int limit = 20,
    int offset = 0,
  }) {
    return _remoteDataSource.getAvailableBaskets(
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<Basket?> getBasketById(String basketId) async {
    return _remoteDataSource.getBasketById(basketId);
  }

  @override
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
  }) {
    return _remoteDataSource.searchBaskets(
      query: query,
      commerceTypes: commerceTypes,
      maxPrice: maxPrice,
      dietaryTags: dietaryTags,
      availableFrom: availableFrom,
      availableUntil: availableUntil,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<List<Basket>> getFavoriteBaskets(String userId) {
    return _remoteDataSource.getFavoriteBaskets(userId);
  }

  @override
  Future<bool> addToFavorites(String userId, String basketId) async {
    await _remoteDataSource.addToFavorites(userId, basketId);
    return true;
  }

  @override
  Future<bool> removeFromFavorites(String userId, String basketId) async {
    await _remoteDataSource.removeFromFavorites(userId, basketId);
    return true;
  }

  @override
  Future<bool> isFavorite(String userId, String basketId) async {
    return _remoteDataSource.isFavorite(userId, basketId);
  }

  @override
  Future<List<Basket>> getBasketsByCommerce(String commerceId, {bool includeExpired = false}) {
    return _remoteDataSource.getBasketsByCommerce(commerceId, includeExpired: includeExpired);
  }

  @override
  Future<List<Basket>> getLastChanceBaskets({
    int hoursUntilExpiry = 2,
    double? latitude,
    double? longitude,
    double radius = 10.0,
    int limit = 10,
  }) {
    return _remoteDataSource.getLastChanceBaskets(
      hoursUntilExpiry: hoursUntilExpiry,
      latitude: latitude,
      longitude: longitude,
      radius: radius,
      limit: limit,
    );
  }

  @override
  Future<bool> updateBasketStatus(String basketId, BasketStatus status) async {
    await _remoteDataSource.updateBasketStatus(basketId, status);
    return true;
  }

  @override
  Future<bool> decrementBasketQuantity(String basketId, int quantity) async {
    await _remoteDataSource.decrementBasketQuantity(basketId, quantity);
    return true;
  }

  @override
  Future<bool> checkBasketAvailability(String basketId) {
    return _remoteDataSource.checkBasketAvailability(basketId);
  }

  @override
  Stream<Basket?> watchBasket(String basketId) {
    // Implémentation mock: pas de temps réel côté data source mock.
    // On renvoie un Stream qui émet une valeur unique puis se termine.
    return Stream<Basket?>.fromFuture(_remoteDataSource.getBasketById(basketId));
  }

  @override
  Stream<List<Basket>> watchAvailableBaskets({
    double? latitude,
    double? longitude,
    double radius = 10.0,
  }) {
    // Implémentation mock: on émet la liste actuelle une seule fois.
    return Stream<List<Basket>>.fromFuture(
      _remoteDataSource.getAvailableBaskets(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      ),
    );
  }
}


