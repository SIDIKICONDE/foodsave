import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Section de filtrage par tags diététiques.
///
/// Permet de sélectionner plusieurs tags alimentaires avec des FilterChips.
class DietaryTagsFilterSection extends StatelessWidget {
  /// Crée une nouvelle instance de [DietaryTagsFilterSection].
  ///
  /// [selectedTags] : Liste des tags sélectionnés.
  /// [onTagToggle] : Callback appelé lors de la sélection/désélection d'un tag.
  const DietaryTagsFilterSection({
    super.key,
    required this.selectedTags,
    required this.onTagToggle,
  });

  /// Liste des tags diététiques sélectionnés.
  final List<String> selectedTags;

  /// Callback appelé lors de la sélection/désélection d'un tag.
  final Function(String tag, bool selected) onTagToggle;

  /// Liste des tags diététiques disponibles.
  static const List<String> dietaryTags = [
    'Bio',
    'Végétarien',
    'Végan',
    'Sans gluten',
    'Sans lactose',
    'Halal',
    'Casher',
    'Local',
  ];

  @override
  Widget build(BuildContext context) {
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(
      MediaQuery.of(context).size.width
    );

    return _buildSection(
      title: 'Régimes alimentaires',
      icon: Icons.eco,
      child: Wrap(
        spacing: responsiveSpacing * 0.6,
        runSpacing: responsiveSpacing * 0.4,
        children: dietaryTags.map((tag) {
          final bool isSelected = selectedTags.contains(tag);
          return FilterChip(
            label: Text(tag),
            selected: isSelected,
            onSelected: (selected) => onTagToggle(tag, selected),
            backgroundColor: AppColors.surfaceSecondary,
            selectedColor: AppColors.eco.withValues(alpha: 0.2),
            checkmarkColor: AppColors.eco,
            labelStyle: AppTextStyles.labelSmall.copyWith(
              color: isSelected ? AppColors.eco : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            side: BorderSide(
              color: isSelected ? AppColors.eco : AppColors.border,
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
