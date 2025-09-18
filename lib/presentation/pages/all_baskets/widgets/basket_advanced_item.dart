import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/domain/entities/basket.dart';
import 'components/components.dart';

/// Élément de panier avancé avec plus de détails et d'actions.
///
/// Version améliorée du BasketListItem avec plus d'informations et d'interactions.
class BasketAdvancedItem extends StatefulWidget {
  /// Crée une nouvelle instance de [BasketAdvancedItem].
  ///
  /// [basket] : Le panier à afficher.
  /// [isFavorite] : Indique si le panier est en favori.
  /// [onFavoriteToggle] : Callback appelé lors du toggle favori.
  /// [onTap] : Callback appelé lors du tap sur l'élément.
  const BasketAdvancedItem({
    super.key,
    required this.basket,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onTap,
  });

  /// Le panier à afficher.
  final Basket basket;

  /// Indique si le panier est en favori.
  final bool isFavorite;

  /// Callback appelé lors du toggle favori.
  final ValueChanged<bool>? onFavoriteToggle;

  /// Callback appelé lors du tap sur l'élément.
  final VoidCallback? onTap;

  @override
  State<BasketAdvancedItem> createState() => _BasketAdvancedItemState();
}

class _BasketAdvancedItemState extends State<BasketAdvancedItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Initialise les animations.
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() => _isPressed = true);
              _animationController.forward();
            },
            onTapUp: (_) {
              setState(() => _isPressed = false);
              _animationController.reverse();
              widget.onTap?.call();
            },
            onTapCancel: () {
              setState(() => _isPressed = false);
              _animationController.reverse();
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : AppColors.shadow,
                    blurRadius: _isPressed ? 12 : 8,
                    offset: Offset(0, _isPressed ? 6 : 3),
                  ),
                ],
                border: Border.all(
                  color: _isPressed
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  // En-tête avec image et badges
                  BasketItemHeader(
                    basket: widget.basket,
                    isFavorite: widget.isFavorite,
                    onFavoriteToggle: widget.onFavoriteToggle,
                  ),

                  // Contenu principal
                  Padding(
                    padding: EdgeInsets.all(responsiveSpacing * 0.8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Titre et commerce
                        BasketItemTitleSection(basket: widget.basket),
                        
                        SizedBox(height: responsiveSpacing * 0.4),
                        
                        // Description
                        _buildDescription(responsiveSpacing),
                        
                        SizedBox(height: responsiveSpacing * 0.6),
                        
                        // Informations pratiques
                        BasketItemInfoSection(basket: widget.basket),
                        
                        SizedBox(height: responsiveSpacing * 0.8),
                        
                        // Prix et action
                        BasketItemPriceAction(
                          basket: widget.basket,
                          onReserve: () => _handleReserve(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  /// Construit la description.
  Widget _buildDescription(double spacing) {
    return Text(
      widget.basket.description,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }




  /// Gère l'action de réservation.
  void _handleReserve(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🛒 ${widget.basket.title} ajouté au panier'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

}