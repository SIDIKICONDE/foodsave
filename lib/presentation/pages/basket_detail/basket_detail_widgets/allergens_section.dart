import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/presentation/pages/basket_detail/basket_detail_widgets/custom_chip.dart';

/// Section des allergènes du panier.
///
/// Affiche les allergènes avec une icône d'avertissement et des chips colorés.
class AllergensSection extends StatelessWidget {
  /// Crée une nouvelle instance de [AllergensSection].
  const AllergensSection({
    super.key,
    required this.basket,
  });

  /// Le panier dont on affiche les allergènes.
  final Basket basket;

  @override
  Widget build(BuildContext context) {
    if (basket.allergens.isEmpty) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: AppColors.warning, size: 20),
                const SizedBox(width: AppDimensions.spacingS),
                Text(
                  'Allergènes',
                  style: AppTextStyles.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Wrap(
              spacing: AppDimensions.spacingS,
              runSpacing: AppDimensions.spacingS,
              children: basket.allergens
                  .map((allergen) => CustomChip(
                        text: allergen,
                        backgroundColor: AppColors.warning.withValues(alpha: 0.2),
                        textColor: AppColors.warning,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
