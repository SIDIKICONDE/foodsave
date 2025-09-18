import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Chip de préférence alimentaire.
///
/// Affiche une préférence alimentaire sous forme de chip stylisé.
class PreferenceChip extends StatelessWidget {
  /// Crée une nouvelle instance de [PreferenceChip].
  ///
  /// [label] : Texte de la préférence.
  /// [isSelected] : Indique si la préférence est sélectionnée.
  /// [onTap] : Callback appelé lors du tap.
  const PreferenceChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  /// Texte de la préférence.
  final String label;

  /// Indique si la préférence est sélectionnée.
  final bool isSelected;

  /// Callback appelé lors du tap.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: responsiveSpacing,
          vertical: responsiveSpacing * 0.6,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8),
                  ]
                : [
                    AppColors.lighten(AppColors.primary, 0.8),
                    AppColors.lighten(AppColors.primary, 0.9),
                  ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.primary,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              Icon(
                Icons.check,
                size: 16,
                color: AppColors.textOnDark,
              ),
            if (isSelected) SizedBox(width: responsiveSpacing * 0.4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.textOnDark : AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
