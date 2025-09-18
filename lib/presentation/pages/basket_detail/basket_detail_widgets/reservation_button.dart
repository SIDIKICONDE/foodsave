import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/domain/entities/basket.dart';

/// Bouton de réservation du panier.
///
/// Affiche un bouton stylisé pour réserver le panier, avec gestion des états disponible/non disponible.
class ReservationButton extends StatelessWidget {
  /// Crée une nouvelle instance de [ReservationButton].
  const ReservationButton({
    super.key,
    required this.basket,
  });

  /// Le panier à réserver.
  final Basket basket;

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = basket.isAvailable;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isAvailable
            ? () {
                // Navigation vers le processus de réservation
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('🛒 Réservation en cours...'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }
            : null,
        icon: Icon(
          isAvailable ? Icons.shopping_cart : Icons.block,
          color: AppColors.textOnDark,
        ),
        label: Text(
          isAvailable ? 'Réserver ce panier' : 'Non disponible',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textOnDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isAvailable ? AppColors.primary : AppColors.textSecondary,
          foregroundColor: AppColors.textOnDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          elevation: isAvailable ? 8 : 0,
        ),
      ),
    );
  }
}
