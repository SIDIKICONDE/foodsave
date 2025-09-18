import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/domain/entities/basket.dart';

/// SliverAppBar pour la page de détail du panier.
///
/// Affiche l'image du panier avec des boutons de navigation et favoris, ainsi qu'un badge "dernière chance".
class BasketSliverAppBar extends StatefulWidget {
  /// Crée une nouvelle instance de [BasketSliverAppBar].
  const BasketSliverAppBar({
    super.key,
    required this.basket,
  });

  /// Le panier dont on affiche l'image dans l'AppBar.
  final Basket basket;

  @override
  State<BasketSliverAppBar> createState() => _BasketSliverAppBarState();
}

class _BasketSliverAppBarState extends State<BasketSliverAppBar>
    with TickerProviderStateMixin {
  bool _isFavorite = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    // Animation d'échelle pour les boutons
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Animation de fondu pour les éléments
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Démarrer l'animation
    _fadeController.forward();
  }

  void _handleFavoriteToggle() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    // Animation du bouton favori
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    // Feedback utilisateur
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? '❤️ Ajouté aux favoris'
              : '💔 Retiré des favoris',
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'OK',
          textColor: AppColors.textOnDark,
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleController, _fadeController]),
      builder: (context, child) {
        return SliverAppBar(
          expandedHeight: 320.0, // Légèrement augmenté pour plus d'impact
          floating: false,
          pinned: true,
          backgroundColor: AppColors.primary.withValues(alpha: _fadeAnimation.value),
          elevation: 0,
          leading: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.95),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(50),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Retour',
              ),
            ),
          ),
          actions: [
            Opacity(
              opacity: _fadeAnimation.value,
              child: AnimatedBuilder(
                animation: _scaleController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(50),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: Icon(
                            _isFavorite ? Icons.favorite : Icons.favorite_border,
                            key: ValueKey<bool>(_isFavorite),
                            color: _isFavorite ? AppColors.error : AppColors.textPrimary,
                          ),
                        ),
                        onPressed: _handleFavoriteToggle,
                        tooltip: _isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image avec effet de parallax
                    widget.basket.imageUrls.isNotEmpty
                        ? Hero(
                            tag: 'basket_image_${widget.basket.id}',
                            child: Image.network(
                              widget.basket.imageUrls.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.surfaceSecondary,
                                  child: Icon(
                                    Icons.shopping_basket,
                                    size: 80,
                                    color: AppColors.textSecondary,
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            color: AppColors.surfaceSecondary,
                            child: Icon(
                              Icons.shopping_basket,
                              size: 80,
                              color: AppColors.textSecondary,
                            ),
                          ),

                    // Overlay dégradé sophistiqué
                    Opacity(
                      opacity: _fadeAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              AppColors.primary.withValues(alpha: 0.1),
                              AppColors.primary.withValues(alpha: 0.3),
                              AppColors.primary.withValues(alpha: 0.6),
                            ],
                            stops: const [0.0, 0.5, 0.7, 0.85, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Badge d'urgence avec animation
                    if (widget.basket.isLastChance)
                      Positioned(
                        top: 80,
                        right: 20,
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Opacity(
                                opacity: value,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.error,
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.error.withValues(alpha: 0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: AppColors.textOnDark.withAlpha(50),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        size: 16,
                                        color: AppColors.textOnDark,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'DERNIÈRE CHANCE',
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: AppColors.textOnDark,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                    // Informations en bas
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.basket.title,
                              style: AppTextStyles.headline4.copyWith(
                                color: AppColors.textOnDark,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withAlpha(100),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.store,
                                  size: 18,
                                  color: AppColors.textOnDark.withAlpha(200),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  widget.basket.commerce.name,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.textOnDark.withAlpha(200),
                                    fontWeight: FontWeight.w500,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withAlpha(100),
                                        offset: const Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.surfaceSecondary,
      child: Icon(
        Icons.shopping_basket,
        size: 80,
        color: AppColors.textSecondary,
      ),
    );
  }
}
