import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Bouton d'ouverture des filtres.
///
/// Bouton stylisé avec un dégradé pour accéder aux filtres avancés.
class FilterButton extends StatelessWidget {
  /// Crée une nouvelle instance de [FilterButton].
  ///
  /// [onPressed] : Callback appelé lors du clic sur le bouton.
  const FilterButton({
    super.key,
    required this.onPressed,
  });

  /// Callback appelé lors du clic sur le bouton.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(
      MediaQuery.of(context).size.width
    );

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.secondaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsiveSpacing,
              vertical: responsiveSpacing * 0.75,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tune,
                  color: AppColors.textOnDark,
                  size: 20,
                ),
                SizedBox(width: responsiveSpacing * 0.4),
                Text(
                  'Filtres',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textOnDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
