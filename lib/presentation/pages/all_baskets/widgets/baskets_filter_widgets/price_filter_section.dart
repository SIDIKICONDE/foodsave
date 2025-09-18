import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Section de filtrage par prix.
///
/// Permet de définir une fourchette de prix avec un RangeSlider.
class PriceFilterSection extends StatelessWidget {
  /// Crée une nouvelle instance de [PriceFilterSection].
  ///
  /// [currentMinPrice] : Prix minimum actuel.
  /// [currentMaxPrice] : Prix maximum actuel.
  /// [onPriceRangeChanged] : Callback appelé lors du changement de fourchette.
  const PriceFilterSection({
    super.key,
    required this.currentMinPrice,
    required this.currentMaxPrice,
    required this.onPriceRangeChanged,
  });

  /// Prix minimum actuel.
  final double currentMinPrice;

  /// Prix maximum actuel.
  final double currentMaxPrice;

  /// Callback appelé lors du changement de fourchette de prix.
  final Function(double min, double max) onPriceRangeChanged;

  @override
  Widget build(BuildContext context) {
    return _buildSection(
      title: 'Fourchette de prix',
      icon: Icons.euro,
      child: Column(
        children: [
          RangeSlider(
            values: RangeValues(currentMinPrice, currentMaxPrice),
            min: 0,
            max: 50,
            divisions: 50,
            labels: RangeLabels(
              '${currentMinPrice.toInt()}€',
              '${currentMaxPrice.toInt()}€',
            ),
            onChanged: (values) {
              onPriceRangeChanged(values.start, values.end);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${currentMinPrice.toInt()}€',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${currentMaxPrice.toInt()}€',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit une section avec titre et icône.
  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
