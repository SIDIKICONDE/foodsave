import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/blocs/basket/basket_bloc.dart';
import 'package:foodsave_app/presentation/blocs/basket/basket_event.dart';
import 'package:foodsave_app/presentation/blocs/basket/basket_state.dart';
import 'package:foodsave_app/presentation/pages/all_baskets/widgets/basket_advanced_item.dart';

/// Widget principal pour afficher la liste des paniers.
///
/// Gère l'affichage des paniers avec pagination, pull-to-refresh et états de chargement.
class AllBasketsList extends StatefulWidget {
  /// Crée une nouvelle instance de [AllBasketsList].
  ///
  /// [scrollController] : Contrôleur de défilement pour la pagination.
  /// [animationController] : Contrôleur d'animation pour les éléments.
  const AllBasketsList({
    super.key,
    required this.scrollController,
    required this.animationController,
  });

  /// Contrôleur de défilement pour la pagination.
  final ScrollController scrollController;

  /// Contrôleur d'animation pour les éléments.
  final AnimationController animationController;

  @override
  State<AllBasketsList> createState() => _AllBasketsListState();
}

class _AllBasketsListState extends State<AllBasketsList> {
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  /// Configure les animations pour les éléments de la liste.
  void _setupAnimations() {
    // Créer des animations pour les premiers éléments
    _fadeAnimations = List.generate(10, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          index * 0.1,
          (index + 1) * 0.1 + 0.4,
          curve: Curves.easeOut,
        ),
      ));
    });

    _slideAnimations = List.generate(10, (index) {
      return Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          index * 0.1,
          (index + 1) * 0.1 + 0.4,
          curve: Curves.easeOutBack,
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);

    return BlocBuilder<BasketBloc, BasketState>(
      builder: (context, state) {
        if (state is BasketLoading) {
          return _buildLoadingState(responsiveSpacing);
        } else if (state is BasketEmpty) {
          return _buildEmptyState(state, responsiveSpacing);
        } else if (state is BasketError) {
          return _buildErrorState(state, responsiveSpacing);
        } else if (state is BasketLoaded) {
          return _buildLoadedState(state, responsiveSpacing);
        } else if (state is BasketLoadingMore) {
          return _buildLoadingMoreState(state, responsiveSpacing);
        }
        
        return _buildInitialState(responsiveSpacing);
      },
    );
  }

  /// Construit l'état de chargement initial.
  Widget _buildLoadingState(double spacing) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(spacing * 2),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: spacing * 1.5),
          Text(
            'Recherche des paniers...',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: spacing * 0.5),
          Text(
            '🌍 Exploration de votre région',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Construit l'état vide.
  Widget _buildEmptyState(BasketEmpty state, double spacing) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(spacing * 2),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary.withValues(alpha: 0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border,
                  width: 2,
                ),
              ),
              child: Icon(
                state.isSearchResult ? Icons.search_off : Icons.inventory_2_outlined,
                size: 64,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: spacing * 1.5),
            Text(
              state.isSearchResult 
                  ? 'Aucun résultat trouvé' 
                  : 'Aucun panier disponible',
              style: AppTextStyles.headline6.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: spacing),
            Text(
              state.isSearchResult
                  ? 'Essayez de modifier vos critères de recherche'
                  : 'Il n\'y a pas de paniers disponibles dans votre région pour le moment',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: spacing * 2),
            if (state.isSearchResult)
              OutlinedButton.icon(
                onPressed: () => context.read<BasketBloc>().add(const ResetBasketSearch()),
                icon: Icon(Icons.clear, color: AppColors.primary, size: 16),
                label: Text(
                  'Effacer les filtres',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primary, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing,
                    vertical: spacing,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Construit l'état d'erreur.
  Widget _buildErrorState(BasketError state, double spacing) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(spacing * 2),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: spacing * 1.5),
            Text(
              'Erreur de chargement',
              style: AppTextStyles.headline6.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: spacing),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: spacing * 2),
            ElevatedButton.icon(
              onPressed: () => context.read<BasketBloc>().add(const LoadAvailableBaskets(latitude: 48.8566, longitude: 2.3522, radius: 10, refresh: true)),
              icon: Icon(Icons.refresh, color: AppColors.textOnDark, size: 16),
              label: Text(
                'Réessayer',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textOnDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: spacing * 1.2,
                  vertical: spacing * 0.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit l'état avec données chargées.
  Widget _buildLoadedState(BasketLoaded state, double spacing) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<BasketBloc>().add(const LoadAvailableBaskets(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 10.0,
          refresh: true,
        ));
      },
      color: AppColors.primary,
      child: ListView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.all(spacing),
        itemCount: state.baskets.length + (state.hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.baskets.length) {
            // Indicateur de chargement pour plus de données
            return Container(
              padding: EdgeInsets.all(spacing),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            );
          }

          final basket = state.baskets[index];
          
          // Animation pour les premiers éléments
          if (index < _fadeAnimations.length) {
            return FadeTransition(
              opacity: _fadeAnimations[index],
              child: SlideTransition(
                position: _slideAnimations[index],
                child: Padding(
                  padding: EdgeInsets.only(bottom: spacing),
                  child: BasketAdvancedItem(
                    basket: basket,
                    isFavorite: state.favoriteBasketIds.contains(basket.id),
                    onFavoriteToggle: (isFavorite) {
                      _handleFavoriteToggle(basket.id, isFavorite);
                    },
                    onTap: () {
                      _handleBasketTap(basket);
                    },
                  ),
                ),
              ),
            );
          } else {
            // Éléments sans animation (pagination)
            return Padding(
              padding: EdgeInsets.only(bottom: spacing),
              child: BasketAdvancedItem(
                basket: basket,
                isFavorite: state.favoriteBasketIds.contains(basket.id),
                onFavoriteToggle: (isFavorite) {
                  _handleFavoriteToggle(basket.id, isFavorite);
                },
                onTap: () {
                  _handleBasketTap(basket);
                },
              ),
            );
          }
        },
      ),
    );
  }

  /// Construit l'état de chargement de plus de données.
  Widget _buildLoadingMoreState(BasketLoadingMore state, double spacing) {
    return ListView.builder(
      controller: widget.scrollController,
      padding: EdgeInsets.all(spacing),
      itemCount: state.currentBaskets.length + 1,
      itemBuilder: (context, index) {
        if (index >= state.currentBaskets.length) {
          return Container(
            padding: EdgeInsets.all(spacing * 2),
            child: Column(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                SizedBox(height: spacing),
                Text(
                  'Chargement de plus de paniers...',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        final basket = state.currentBaskets[index];
        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: BasketAdvancedItem(
            basket: basket,
            isFavorite: false, // TODO: Gérer les favoris
            onFavoriteToggle: (isFavorite) {
              _handleFavoriteToggle(basket.id, isFavorite);
            },
            onTap: () {
              _handleBasketTap(basket);
            },
          ),
        );
      },
    );
  }

  /// Construit l'état initial.
  Widget _buildInitialState(double spacing) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 64,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: spacing),
          Text(
            'Prêt à découvrir les paniers !',
            style: AppTextStyles.headline6.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: spacing * 0.5),
          Text(
            'Utilisez les filtres pour commencer',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// Gère le toggle des favoris.
  void _handleFavoriteToggle(String basketId, bool isFavorite) {
    if (isFavorite) {
      context.read<BasketBloc>().add(AddBasketToFavorites(
        userId: 'current_user_id', // TODO: Obtenir l'ID utilisateur
        basketId: basketId,
      ));
    } else {
      context.read<BasketBloc>().add(RemoveBasketFromFavorites(
        userId: 'current_user_id', // TODO: Obtenir l'ID utilisateur
        basketId: basketId,
      ));
    }
  }

  /// Gère le tap sur un panier.
  void _handleBasketTap(dynamic basket) {
    // Navigation vers les détails du panier
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📱 Détails de ${basket.title}'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}