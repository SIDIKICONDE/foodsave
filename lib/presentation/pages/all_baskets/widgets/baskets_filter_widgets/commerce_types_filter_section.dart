import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Section de filtrage par types de commerce.
///
/// Permet de sélectionner plusieurs types de commerce avec des FilterChips.
class CommerceTypesFilterSection extends StatelessWidget {
  /// Crée une nouvelle instance de [CommerceTypesFilterSection].
  ///
  /// [selectedTypes] : Liste des types sélectionnés.
  /// [onTypeToggle] : Callback appelé lors de la sélection/désélection d'un type.
  const CommerceTypesFilterSection({
    super.key,
    required this.selectedTypes,
    required this.onTypeToggle,
  });

  /// Liste des types de commerce sélectionnés.
  final List<String> selectedTypes;

  /// Callback appelé lors de la sélection/désélection d'un type.
  final Function(String type, bool selected) onTypeToggle;

  /// Liste des types de commerce disponibles.
  static const List<String> commerceTypes = [
    'Boulangerie',
    'Restaurant',
    'Fruits & Légumes',
    'Supermarché',
    'Boucherie',
    'Poissonnerie',
    'Pâtisserie',
    'Traiteur',
  ];

  @override
  Widget build(BuildContext context) {
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(
      MediaQuery.of(context).size.width
    );

    return _buildSection(
      title: 'Types de commerce',
      icon: Icons.store,
      child: Wrap(
        spacing: responsiveSpacing * 0.6,
        runSpacing: responsiveSpacing * 0.4,
        children: commerceTypes.map((type) {
          final bool isSelected = selectedTypes.contains(type);
          return FilterChip(
            label: Text(type),
            selected: isSelected,
            onSelected: (selected) => onTypeToggle(type, selected),
            backgroundColor: AppColors.surfaceSecondary,
            selectedColor: AppColors.primary.withValues(alpha: 0.2),
            checkmarkColor: AppColors.primary,
            labelStyle: AppTextStyles.labelSmall.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
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
