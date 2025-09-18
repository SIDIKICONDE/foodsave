import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/domain/usecases/get_available_baskets.dart';
import 'package:foodsave_app/domain/usecases/search_baskets.dart' as usecases;
import 'package:foodsave_app/domain/repositories/basket_repository.dart';
import 'package:foodsave_app/presentation/blocs/basket/basket_event.dart';
import 'package:foodsave_app/presentation/blocs/basket/basket_state.dart';

/// BLoC pour la gestion des paniers.
/// 
/// Gère le chargement, la recherche, les favoris et la pagination des paniers.
class BasketBloc extends Bloc<BasketEvent, BasketState> {
  /// Crée une nouvelle instance de [BasketBloc].
  BasketBloc({
    required GetAvailableBaskets getAvailableBaskets,
    required usecases.SearchBaskets searchBaskets,
    required BasketRepository basketRepository,
  })  : _getAvailableBaskets = getAvailableBaskets,
        _searchBaskets = searchBaskets,
        _basketRepository = basketRepository,
        super(const BasketInitial()) {
    on<LoadAvailableBaskets>(_onLoadAvailableBaskets);
    on<SearchBasketsEvent>(_onSearchBaskets);
    on<LoadMoreBaskets>(_onLoadMoreBaskets);
    on<AddBasketToFavorites>(_onAddBasketToFavorites);
    on<RemoveBasketFromFavorites>(_onRemoveBasketFromFavorites);
    on<LoadFavoriteBaskets>(_onLoadFavoriteBaskets);
    on<LoadLastChanceBaskets>(_onLoadLastChanceBaskets);
    on<ResetBasketSearch>(_onResetBasketSearch);
  }

  /// Use case pour récupérer les paniers disponibles.
  final GetAvailableBaskets _getAvailableBaskets;

  /// Use case pour rechercher des paniers.
  final usecases.SearchBaskets _searchBaskets;

  /// Repository des paniers.
  final BasketRepository _basketRepository;

  /// Paramètres de la dernière requête pour la pagination.
  GetAvailableBasketsParams? _lastParams;

  /// Paramètres de la dernière recherche pour la pagination.
  usecases.SearchBasketsParams? _lastSearchParams;

  /// Offset actuel pour la pagination.
  int _currentOffset = 0;

  /// Nombre d'éléments par page.
  static const int _pageSize = 20;

  /// Gère le chargement des paniers disponibles.
  Future<void> _onLoadAvailableBaskets(
    LoadAvailableBaskets event,
    Emitter<BasketState> emit,
  ) async {
    try {
      // Si c'est un rafraîchissement, on remet l'offset à zéro
      if (event.refresh) {
        _currentOffset = 0;
      }

      // Seulement afficher le loading si on n'a pas déjà de données
      if (state is! BasketLoaded || event.refresh) {
        emit(const BasketLoading());
      }

      final params = GetAvailableBasketsParams(
        latitude: event.latitude,
        longitude: event.longitude,
        radius: event.radius,
        limit: _pageSize,
        offset: _currentOffset,
      );

      _lastParams = params;
      final baskets = await _getAvailableBaskets(params);

      if (baskets.isEmpty && _currentOffset == 0) {
        emit(const BasketEmpty());
        return;
      }

      // Récupérer les favoris de l'utilisateur (simulation pour l'exemple)
      final favoriteBasketIds = <String>[];
      
      emit(BasketLoaded(
        baskets: baskets,
        hasMoreData: baskets.length == _pageSize,
        favoriteBasketIds: favoriteBasketIds,
      ));

      _currentOffset += baskets.length;
    } catch (e) {
      emit(BasketError(
        message: 'Erreur lors du chargement des paniers: ${e.toString()}',
        previousBaskets: state is BasketLoaded ? (state as BasketLoaded).baskets : null,
      ));
    }
  }

  /// Gère la recherche de paniers.
  Future<void> _onSearchBaskets(
    SearchBasketsEvent event,
    Emitter<BasketState> emit,
  ) async {
    try {
      emit(const BasketLoading());

      final params = usecases.SearchBasketsParams(
        query: event.query,
        commerceTypes: event.commerceTypes,
        maxPrice: event.maxPrice,
        dietaryTags: event.dietaryTags,
        latitude: event.latitude,
        longitude: event.longitude,
        radius: event.radius,
        limit: _pageSize,
        offset: 0,
      );

      _lastSearchParams = params;
      _currentOffset = 0;

      final baskets = await _searchBaskets(params);

      if (baskets.isEmpty) {
        emit(BasketEmpty(
          message: 'Aucun résultat pour "${event.query}"',
          isSearchResult: true,
        ));
        return;
      }

      // Récupérer les favoris de l'utilisateur
      final favoriteBasketIds = <String>[];

      emit(BasketLoaded(
        baskets: baskets,
        hasMoreData: baskets.length == _pageSize,
        isSearchResult: true,
        searchQuery: event.query,
        favoriteBasketIds: favoriteBasketIds,
      ));

      _currentOffset += baskets.length;
    } catch (e) {
      emit(BasketError(
        message: 'Erreur lors de la recherche: ${e.toString()}',
      ));
    }
  }

  /// Gère le chargement de plus de paniers (pagination).
  Future<void> _onLoadMoreBaskets(
    LoadMoreBaskets event,
    Emitter<BasketState> emit,
  ) async {
    final currentState = state;
    if (currentState is! BasketLoaded || !currentState.hasMoreData) {
      return;
    }

    try {
      emit(BasketLoadingMore(currentBaskets: currentState.baskets));

      List<Basket> newBaskets;

      if (currentState.isSearchResult && _lastSearchParams != null) {
        // Pagination pour une recherche
        final params = _lastSearchParams!.copyWith(
          offset: _currentOffset,
        );
        newBaskets = await _searchBaskets(params);
      } else if (_lastParams != null) {
        // Pagination pour les paniers disponibles
        final params = GetAvailableBasketsParams(
          latitude: _lastParams!.latitude,
          longitude: _lastParams!.longitude,
          radius: _lastParams!.radius,
          limit: _pageSize,
          offset: _currentOffset,
        );
        newBaskets = await _getAvailableBaskets(params);
      } else {
        return;
      }

      final allBaskets = [...currentState.baskets, ...newBaskets];

      emit(currentState.copyWith(
        baskets: allBaskets,
        hasMoreData: newBaskets.length == _pageSize,
      ));

      _currentOffset += newBaskets.length;
    } catch (e) {
      emit(BasketError(
        message: 'Erreur lors du chargement: ${e.toString()}',
        previousBaskets: currentState.baskets,
      ));
    }
  }

  /// Gère l'ajout d'un panier aux favoris.
  Future<void> _onAddBasketToFavorites(
    AddBasketToFavorites event,
    Emitter<BasketState> emit,
  ) async {
    try {
      final success = await _basketRepository.addToFavorites(
        event.userId,
        event.basketId,
      );

      if (success) {
        emit(BasketFavoriteUpdated(
          basketId: event.basketId,
          isFavorite: true,
          message: 'Panier ajouté aux favoris',
        ));
      } else {
        emit(const BasketError(message: 'Impossible d\'ajouter aux favoris'));
      }
    } catch (e) {
      emit(BasketError(message: 'Erreur: ${e.toString()}'));
    }
  }

  /// Gère la suppression d'un panier des favoris.
  Future<void> _onRemoveBasketFromFavorites(
    RemoveBasketFromFavorites event,
    Emitter<BasketState> emit,
  ) async {
    try {
      final success = await _basketRepository.removeFromFavorites(
        event.userId,
        event.basketId,
      );

      if (success) {
        emit(BasketFavoriteUpdated(
          basketId: event.basketId,
          isFavorite: false,
          message: 'Panier retiré des favoris',
        ));
      } else {
        emit(const BasketError(message: 'Impossible de retirer des favoris'));
      }
    } catch (e) {
      emit(BasketError(message: 'Erreur: ${e.toString()}'));
    }
  }

  /// Gère le chargement des paniers favoris.
  Future<void> _onLoadFavoriteBaskets(
    LoadFavoriteBaskets event,
    Emitter<BasketState> emit,
  ) async {
    try {
      emit(const BasketLoading());

      final favoriteBaskets = await _basketRepository.getFavoriteBaskets(
        event.userId,
      );

      if (favoriteBaskets.isEmpty) {
        emit(const BasketEmpty(message: 'Aucun panier favori'));
        return;
      }

      emit(FavoriteBasketsLoaded(favoriteBaskets: favoriteBaskets));
    } catch (e) {
      emit(BasketError(message: 'Erreur: ${e.toString()}'));
    }
  }

  /// Gère le chargement des paniers "dernière chance".
  Future<void> _onLoadLastChanceBaskets(
    LoadLastChanceBaskets event,
    Emitter<BasketState> emit,
  ) async {
    try {
      emit(const BasketLoading());

      final lastChanceBaskets = await _basketRepository.getLastChanceBaskets(
        hoursUntilExpiry: event.hoursUntilExpiry,
        latitude: event.latitude,
        longitude: event.longitude,
        radius: event.radius,
      );

      if (lastChanceBaskets.isEmpty) {
        emit(const BasketEmpty(message: 'Aucun panier dernière chance'));
        return;
      }

      emit(LastChanceBasketsLoaded(lastChanceBaskets: lastChanceBaskets));
    } catch (e) {
      emit(BasketError(message: 'Erreur: ${e.toString()}'));
    }
  }

  /// Gère la réinitialisation de la recherche.
  Future<void> _onResetBasketSearch(
    ResetBasketSearch event,
    Emitter<BasketState> emit,
  ) async {
    _currentOffset = 0;
    _lastSearchParams = null;
    emit(const BasketInitial());
  }
}

/// Extension pour ajouter des méthodes utilitaires aux paramètres de recherche.
extension SearchBasketsParamsExtension on usecases.SearchBasketsParams {
  /// Crée une copie avec des valeurs modifiées.
  usecases.SearchBasketsParams copyWith({
    String? query,
    List<String>? commerceTypes,
    double? maxPrice,
    List<String>? dietaryTags,
    DateTime? availableFrom,
    DateTime? availableUntil,
    double? latitude,
    double? longitude,
    double? radius,
    int? limit,
    int? offset,
  }) {
    return usecases.SearchBasketsParams(
      query: query ?? this.query,
      commerceTypes: commerceTypes ?? this.commerceTypes,
      maxPrice: maxPrice ?? this.maxPrice,
      dietaryTags: dietaryTags ?? this.dietaryTags,
      availableFrom: availableFrom ?? this.availableFrom,
      availableUntil: availableUntil ?? this.availableUntil,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radius: radius ?? this.radius,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}