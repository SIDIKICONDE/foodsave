import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Section des filtres rapides pour la page de découverte.
///
/// Affiche une liste horizontale de filtres rapides sous forme de chips.
class QuickFilters extends StatelessWidget {
  /// Crée une nouvelle instance de [QuickFilters].
  const QuickFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> filters = ['Proche', 'Végétarien', 'Bio', 'Dernière chance'];

    return SizedBox(
      height: AppDimensions.buttonMinHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index < filters.length - 1 ? AppDimensions.spacingM : 0,
            ),
            child: FilterChip(
              label: Text(filters[index]),
              labelStyle: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.lighten(AppColors.primary, 0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                side: const BorderSide(color: AppColors.border),
              ),
              onSelected: (selected) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Filtre ${filters[index]} ${selected ? 'activé' : 'désactivé'}'),
                    backgroundColor: AppColors.info,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
