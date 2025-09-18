import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/domain/entities/basket.dart';

/// Section du titre du panier.
///
/// Affiche le titre principal du panier avec ses informations de disponibilité.
class BasketTitleSection extends StatelessWidget {
  /// Crée une nouvelle instance de [BasketTitleSection].
  const BasketTitleSection({
    super.key,
    required this.basket,
  });

  /// Le panier dont on affiche le titre.
  final Basket basket;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          basket.title,
          style: AppTextStyles.headline4.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppDimensions.spacingXs),
            Text(
              'Disponible ${_formatAvailability()}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Formate la disponibilité.
  String _formatAvailability() {
    final DateTime now = DateTime.now();
    final Duration diff = basket.availableUntil.difference(now);

    if (diff.inDays > 0) {
      return 'encore ${diff.inDays} jour(s)';
    } else if (diff.inHours > 0) {
      return 'encore ${diff.inHours}h';
    } else if (diff.inMinutes > 0) {
      return 'encore ${diff.inMinutes}min';
    } else {
      return 'expiré';
    }
  }
}
