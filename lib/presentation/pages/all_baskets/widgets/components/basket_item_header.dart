import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/domain/entities/basket.dart';

/// Header d'un élément de panier avec image et badges.
///
/// Affiche l'image de fond, le badge "dernière chance", le bouton favori
/// et le badge de réduction.
class BasketItemHeader extends StatefulWidget {
  /// Crée une nouvelle instance de [BasketItemHeader].
  ///
  /// [basket] : Le panier à afficher.
  /// [isFavorite] : Indique si le panier est en favori.
  /// [onFavoriteToggle] : Callback appelé lors du toggle favori.
  const BasketItemHeader({
    super.key,
    required this.basket,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  /// Le panier à afficher.
  final Basket basket;

  /// Indique si le panier est en favori.
  final bool isFavorite;

  /// Callback appelé lors du toggle favori.
  final ValueChanged<bool>? onFavoriteToggle;

  @override
  State<BasketItemHeader> createState() => _BasketItemHeaderState();
}

class _BasketItemHeaderState extends State<BasketItemHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _favoriteAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Initialise les animations pour le bouton favori.
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _favoriteAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = AppDimensions.getResponsiveSpacing(
      MediaQuery.of(context).size.width,
    );

    return Stack(
      children: [
        // Image de fond (placeholder)
        Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.secondary.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.radiusL),
              topRight: Radius.circular(AppDimensions.radiusL),
            ),
          ),
          child: Center(
            child: Icon(
              Icons.image_outlined,
              size: 24,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ),

        // Overlay gradient
        Container(
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppColors.overlayDark.withValues(alpha: 0.3),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.radiusL),
              topRight: Radius.circular(AppDimensions.radiusL),
            ),
          ),
        ),

        // Badge dernière chance
        if (widget.basket.isLastChance) _buildLastChanceBadge(spacing),

        // Bouton favori
        _buildFavoriteButton(spacing),

        // Badge de réduction
        _buildDiscountBadge(spacing),
      ],
    );
  }

  /// Construit le badge "dernière chance".
  Widget _buildLastChanceBadge(double spacing) {
    return Positioned(
      top: spacing,
      left: spacing,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing * 0.8,
          vertical: spacing * 0.4,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.error, AppColors.lastChance],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withValues(alpha: 0.4),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department,
              size: 16,
              color: AppColors.textOnDark,
            ),
            SizedBox(width: spacing * 0.3),
            Text(
              'Dernière chance',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le bouton favori.
  Widget _buildFavoriteButton(double spacing) {
    return Positioned(
      top: spacing,
      right: spacing,
      child: AnimatedBuilder(
        animation: _favoriteAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _favoriteAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => _animationController
                    .forward()
                    .then((_) => _animationController.reverse())
                    .then((_) => widget.onFavoriteToggle?.call(!widget.isFavorite)),
                icon: Icon(
                  widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: widget.isFavorite ? AppColors.error : AppColors.textSecondary,
                  size: 18,
                ),
                iconSize: 18,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Construit le badge de réduction.
  Widget _buildDiscountBadge(double spacing) {
    return Positioned(
      bottom: -spacing * 0.5,
      right: spacing,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: spacing,
          vertical: spacing * 0.5,
        ),
        decoration: BoxDecoration(
          gradient: AppColors.secondaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          '-${widget.basket.discountPercentage.toInt()}%',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textOnDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
