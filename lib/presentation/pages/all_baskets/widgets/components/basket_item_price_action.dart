import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/domain/entities/basket.dart';

/// Section prix et action d'un élément de panier.
///
/// Affiche le prix avec réduction et le bouton de réservation.
class BasketItemPriceAction extends StatelessWidget {
  /// Crée une nouvelle instance de [BasketItemPriceAction].
  ///
  /// [basket] : Le panier à afficher.
  /// [onReserve] : Callback appelé lors de la réservation.
  const BasketItemPriceAction({
    super.key,
    required this.basket,
    this.onReserve,
  });

  /// Le panier à afficher.
  final Basket basket;

  /// Callback appelé lors de la réservation.
  final VoidCallback? onReserve;

  @override
  Widget build(BuildContext context) {
    final spacing = AppDimensions.getResponsiveSpacing(MediaQuery.of(context).size.width);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: _buildPriceSection(spacing)),
        SizedBox(width: spacing),
        _buildReserveButton(spacing),
      ],
    );
  }

  Widget _buildPriceSection(double spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${basket.discountedPrice.toStringAsFixed(2)}€', 
             style: AppTextStyles.headline6.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
        Row(children: [
          Text('au lieu de ${basket.originalPrice.toStringAsFixed(2)}€',
               style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary, decoration: TextDecoration.lineThrough)),
          SizedBox(width: spacing * 0.3),
          Container(
            padding: EdgeInsets.symmetric(horizontal: spacing * 0.3, vertical: spacing * 0.1),
            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
            child: Text('Économie ${basket.savings.toStringAsFixed(2)}€',
                     style: AppTextStyles.labelSmall.copyWith(color: AppColors.success, fontWeight: FontWeight.w600, fontSize: 10)),
          ),
        ]),
      ],
    );
  }

  Widget _buildReserveButton(double spacing) {
    return Container(
      decoration: BoxDecoration(
        gradient: basket.isAvailable ? AppColors.primaryGradient : LinearGradient(colors: [AppColors.textDisabled, AppColors.textDisabled]),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: basket.isAvailable ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))] : null,
      ),
      child: ElevatedButton.icon(
        onPressed: basket.isAvailable ? _handleReserve : null,
        icon: Icon(basket.isAvailable ? Icons.add_shopping_cart : Icons.not_interested, size: 10, color: AppColors.textOnDark),
        label: Text(basket.isAvailable ? 'Réserver' : 'Indisponible',
                   style: AppTextStyles.labelSmall.copyWith(color: AppColors.textOnDark, fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: spacing * 0.3, vertical: spacing * 0.1),
          minimumSize: Size(0, 28),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusM)),
        ),
      ),
    );
  }

  /// Gère l'action de réservation.
  void _handleReserve() {
    onReserve?.call();
  }
}
