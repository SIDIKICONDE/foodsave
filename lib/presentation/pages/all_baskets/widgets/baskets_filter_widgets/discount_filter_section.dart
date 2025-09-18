import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Section de filtrage par réduction.
///
/// Permet de sélectionner une fourchette de réduction minimale avec des RadioListTile.
class DiscountFilterSection extends StatelessWidget {
  /// Crée une nouvelle instance de [DiscountFilterSection].
  ///
  /// [selectedDiscountRange] : Fourchette de réduction sélectionnée.
  /// [onDiscountRangeChanged] : Callback appelé lors du changement de fourchette.
  const DiscountFilterSection({
    super.key,
    required this.selectedDiscountRange,
    required this.onDiscountRangeChanged,
  });

  /// Fourchette de réduction sélectionnée.
  final String? selectedDiscountRange;

  /// Callback appelé lors du changement de fourchette de réduction.
  final Function(String? range, int min, int max) onDiscountRangeChanged;

  /// Options de fourchette de réduction disponibles.
  static const List<Map<String, dynamic>> discountRanges = [
    {'label': 'Toutes réductions', 'min': 0, 'max': 100},
    {'label': '30% ou plus', 'min': 30, 'max': 100},
    {'label': '50% ou plus', 'min': 50, 'max': 100},
    {'label': '70% ou plus', 'min': 70, 'max': 100},
  ];

  @override
  Widget build(BuildContext context) {
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(
      MediaQuery.of(context).size.width
    );

    return _buildSection(
      title: 'Réduction minimale',
      icon: Icons.local_offer,
      child: Column(
        children: discountRanges.map((range) {
          final bool isSelected = selectedDiscountRange == range['label'];
          return Container(
            margin: EdgeInsets.only(bottom: responsiveSpacing * 0.4),
            child: GestureDetector(
              onTap: () {
                onDiscountRangeChanged(
                  range['label'] as String,
                  range['min'] as int,
                  range['max'] as int,
                );
              },
              child: Container(
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.secondary : Colors.grey,
                          width: 2,
                        ),
                        color: isSelected ? AppColors.secondary : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.circle,
                              size: 12,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        range['label'] as String,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isSelected ? AppColors.secondary : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
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
