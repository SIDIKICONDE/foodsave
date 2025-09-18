import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Boutons d'action pour le dialogue de filtres.
///
/// Contient les boutons "Annuler" et "Appliquer les filtres".
class FilterActionButtons extends StatelessWidget {
  /// Crée une nouvelle instance de [FilterActionButtons].
  ///
  /// [onCancel] : Callback appelé lors de l'annulation.
  /// [onApply] : Callback appelé lors de l'application des filtres.
  const FilterActionButtons({
    super.key,
    required this.onCancel,
    required this.onApply,
  });

  /// Callback appelé lors de l'annulation.
  final VoidCallback onCancel;

  /// Callback appelé lors de l'application des filtres.
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(
      MediaQuery.of(context).size.width
    );

    return Container(
      padding: EdgeInsets.all(responsiveSpacing),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Bouton Annuler
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: responsiveSpacing * 0.7),
                side: BorderSide(color: AppColors.border, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
              child: Text(
                'Annuler',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(width: responsiveSpacing),

          // Bouton Appliquer
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: onApply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: responsiveSpacing * 0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                child: Text(
                  'Appliquer',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textOnDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
