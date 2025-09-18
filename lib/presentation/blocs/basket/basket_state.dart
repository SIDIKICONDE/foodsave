import 'package:equatable/equatable.dart';
import 'package:foodsave_app/domain/entities/basket.dart';

/// États du BLoC pour la gestion des paniers.
abstract class BasketState extends Equatable {
  const BasketState();

  @override
  List<Object?> get props => [];
}

/// État initial.
class BasketInitial extends BasketState {
  const BasketInitial();
}

/// État de chargement.
class BasketLoading extends BasketState {
  const BasketLoading();
}

/// État de chargement de plus de paniers (pagination).
class BasketLoadingMore extends BasketState {
  /// Crée une nouvelle instance de [BasketLoadingMore].
  const BasketLoadingMore({required this.currentBaskets});

  /// Paniers actuellement chargés.
  final List<Basket> currentBaskets;

  @override
  List<Object> get props => [currentBaskets];
}

/// État de succès avec des paniers chargés.
class BasketLoaded extends BasketState {
  /// Crée une nouvelle instance de [BasketLoaded].
  const BasketLoaded({
    required this.baskets,
    this.hasMoreData = true,
    this.isSearchResult = false,
    this.searchQuery,
    this.favoriteBasketIds = const [],
  });

  /// Liste des paniers.
  final List<Basket> baskets;

  /// Si plus de données sont disponibles pour la pagination.
  final bool hasMoreData;

  /// Si c'est le résultat d'une recherche.
  final bool isSearchResult;

  /// Requête de recherche actuelle.
  final String? searchQuery;

  /// IDs des paniers favoris.
  final List<String> favoriteBasketIds;

  /// Vérifie si un panier est favori.
  bool isBasketFavorite(String basketId) {
    return favoriteBasketIds.contains(basketId);
  }

  /// Crée une copie de l'état avec des valeurs modifiées.
  BasketLoaded copyWith({
    List<Basket>? baskets,
    bool? hasMoreData,
    bool? isSearchResult,
    String? searchQuery,
    List<String>? favoriteBasketIds,
  }) {
    return BasketLoaded(
      baskets: baskets ?? this.baskets,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      isSearchResult: isSearchResult ?? this.isSearchResult,
      searchQuery: searchQuery ?? this.searchQuery,
      favoriteBasketIds: favoriteBasketIds ?? this.favoriteBasketIds,
    );
  }

  @override
  List<Object?> get props => [
        baskets,
        hasMoreData,
        isSearchResult,
        searchQuery,
        favoriteBasketIds,
      ];
}

/// État d'erreur.
class BasketError extends BasketState {
  /// Crée une nouvelle instance de [BasketError].
  const BasketError({
    required this.message,
    this.previousBaskets,
  });

  /// Message d'erreur.
  final String message;

  /// Paniers précédemment chargés (pour maintenir l'état).
  final List<Basket>? previousBaskets;

  @override
  List<Object?> get props => [message, previousBaskets];
}

/// État pour les paniers favoris.
class FavoriteBasketsLoaded extends BasketState {
  /// Crée une nouvelle instance de [FavoriteBasketsLoaded].
  const FavoriteBasketsLoaded({required this.favoriteBaskets});

  /// Liste des paniers favoris.
  final List<Basket> favoriteBaskets;

  @override
  List<Object> get props => [favoriteBaskets];
}

/// État pour les paniers "dernière chance".
class LastChanceBasketsLoaded extends BasketState {
  /// Crée une nouvelle instance de [LastChanceBasketsLoaded].
  const LastChanceBasketsLoaded({required this.lastChanceBaskets});

  /// Liste des paniers "dernière chance".
  final List<Basket> lastChanceBaskets;

  @override
  List<Object> get props => [lastChanceBaskets];
}

/// État de succès pour l'ajout/suppression d'un favori.
class BasketFavoriteUpdated extends BasketState {
  /// Crée une nouvelle instance de [BasketFavoriteUpdated].
  const BasketFavoriteUpdated({
    required this.basketId,
    required this.isFavorite,
    required this.message,
  });

  /// Identifiant du panier.
  final String basketId;

  /// Si le panier est maintenant favori.
  final bool isFavorite;

  /// Message de confirmation.
  final String message;

  @override
  List<Object> get props => [basketId, isFavorite, message];
}

/// État vide (aucun panier trouvé).
class BasketEmpty extends BasketState {
  /// Crée une nouvelle instance de [BasketEmpty].
  const BasketEmpty({
    this.message = 'Aucun panier disponible',
    this.isSearchResult = false,
  });

  /// Message à afficher.
  final String message;

  /// Si c'est le résultat d'une recherche.
  final bool isSearchResult;

  @override
  List<Object> get props => [message, isSearchResult];
}