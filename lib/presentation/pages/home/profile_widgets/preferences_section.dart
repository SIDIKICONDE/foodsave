import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/home/profile_widgets/preference_chip.dart';

/// Section des préférences alimentaires.
///
/// Affiche et permet de modifier les préférences alimentaires de l'utilisateur.
class PreferencesSection extends StatelessWidget {
  /// Crée une nouvelle instance de [PreferencesSection].
  ///
  /// [preferences] : Liste des préférences alimentaires.
  /// [onEdit] : Callback appelé pour modifier les préférences.
  const PreferencesSection({
    super.key,
    required this.preferences,
    this.onEdit,
  });

  /// Liste des préférences alimentaires.
  final List<String> preferences;

  /// Callback appelé pour modifier les préférences.
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête avec bouton modifier
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.restaurant_menu,
                    color: AppColors.textOnDark,
                    size: 20,
                  ),
                ),
                SizedBox(width: responsiveSpacing * 0.8),
                Text(
                  'Préférences alimentaires',
                  style: AppTextStyles.headline5.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton.icon(
                onPressed: () {
                  onEdit?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('🛠️ Modifier les préférences'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  size: 16,
                  color: AppColors.textOnDark,
                ),
                label: Text(
                  'Modifier',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textOnDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsiveSpacing * 0.8,
                    vertical: responsiveSpacing * 0.4,
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: responsiveSpacing),

        // Conteneur des préférences
        Container(
          padding: EdgeInsets.all(responsiveSpacing),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.surfaceSecondary.withValues(alpha: 0.3),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vos préférences actuelles',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: responsiveSpacing),
              preferences.isEmpty
                  ? Container(
                      padding: EdgeInsets.all(responsiveSpacing),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                        border: Border.all(
                          color: AppColors.info.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: AppColors.info,
                            size: 20,
                          ),
                          SizedBox(width: responsiveSpacing * 0.8),
                          Expanded(
                            child: Text(
                              'Aucune préférence définie. Cliquez sur "Modifier" pour en ajouter.',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.info,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Wrap(
                      spacing: responsiveSpacing * 0.6,
                      runSpacing: responsiveSpacing * 0.6,
                      children: preferences.map((preference) {
                        return PreferenceChip(
                          label: preference,
                          isSelected: true,
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),

        // Conseils
        if (preferences.isNotEmpty)
          Container(
            margin: EdgeInsets.only(top: responsiveSpacing),
            padding: EdgeInsets.all(responsiveSpacing),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.thumb_up,
                  color: AppColors.success,
                  size: 20,
                ),
                SizedBox(width: responsiveSpacing * 0.8),
                Expanded(
                  child: Text(
                    '👍 Vos préférences nous aident à vous proposer de meilleurs paniers !',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
