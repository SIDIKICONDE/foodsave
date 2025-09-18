import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/presentation/pages/basket_detail/basket_detail_widgets/custom_chip.dart';

/// Section des ingrédients du panier.
///
/// Affiche les ingrédients principaux sous forme de chips colorés.
class IngredientsSection extends StatelessWidget {
  /// Crée une nouvelle instance de [IngredientsSection].
  const IngredientsSection({
    super.key,
    required this.basket,
  });

  /// Le panier dont on affiche les ingrédients.
  final Basket basket;

  @override
  Widget build(BuildContext context) {
    if (basket.ingredients.isEmpty) return const SizedBox.shrink();

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
            Text(
              'Ingrédients principaux',
              style: AppTextStyles.headline6.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Wrap(
              spacing: AppDimensions.spacingS,
              runSpacing: AppDimensions.spacingS,
              children: basket.ingredients
                  .map((ingredient) => CustomChip(
                        text: ingredient,
                        backgroundColor: AppColors.eco.withValues(alpha: 0.2),
                        textColor: AppColors.eco,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
