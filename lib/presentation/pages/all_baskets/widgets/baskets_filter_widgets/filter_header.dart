import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// En-tête du dialogue de filtres.
///
/// Contient le titre, l'indicateur de glissement et le bouton de réinitialisation.
class FilterHeader extends StatelessWidget {
  /// Crée une nouvelle instance de [FilterHeader].
  ///
  /// [onReset] : Callback appelé lors de la réinitialisation des filtres.
  const FilterHeader({
    super.key,
    required this.onReset,
  });

  /// Callback appelé lors de la réinitialisation des filtres.
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(
      MediaQuery.of(context).size.width
    );

    return Container(
      padding: EdgeInsets.all(responsiveSpacing),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Indicateur de glissement
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: responsiveSpacing),

          // Titre et actions
          Row(
            children: [
              Expanded(
                child: Text(
                  'Filtrer les paniers',
                  style: AppTextStyles.headline6.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: onReset,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Réinitialiser',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
