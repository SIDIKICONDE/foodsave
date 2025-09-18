import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Section du programme de fidélité.
///
/// Affiche le niveau actuel, les points et la progression vers le niveau suivant.
class LoyaltySection extends StatelessWidget {
  /// Crée une nouvelle instance de [LoyaltySection].
  ///
  /// [currentLevel] : Niveau actuel de fidélité.
  /// [points] : Nombre de points actuels.
  /// [nextLevelPoints] : Points requis pour le niveau suivant.
  /// [progress] : Valeur de progression (0.0 à 1.0).
  const LoyaltySection({
    super.key,
    required this.currentLevel,
    required this.points,
    required this.nextLevelPoints,
    required this.progress,
  });

  /// Niveau actuel de fidélité.
  final String currentLevel;

  /// Nombre de points actuels.
  final int points;

  /// Points requis pour le niveau suivant.
  final int nextLevelPoints;

  /// Valeur de progression vers le niveau suivant (0.0 à 1.0).
  final double progress;

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);
    final responsiveIconSize = AppDimensions.getResponsiveIconSize(screenWidth, AppDimensions.iconL);

    // Couleur basée sur le niveau
    final Color levelColor = switch (currentLevel.toLowerCase()) {
      'bronze' => AppColors.warning,
      'silver' => Colors.grey.shade500,
      'gold' => AppColors.badge,
      _ => AppColors.primary,
    };

    return Container(
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
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec icône et titre
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          levelColor,
                          levelColor.withValues(alpha: 0.8),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: levelColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.loyalty,
                      color: AppColors.textOnDark,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: responsiveSpacing * 0.8),
                  Text(
                    'Programme de fidélité',
                    style: AppTextStyles.headline6.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsiveSpacing * 0.8,
                  vertical: responsiveSpacing * 0.4,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      levelColor,
                      levelColor.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: levelColor.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '$points points',
                  style: AppTextStyles.headline6.copyWith(
                    color: AppColors.textOnDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: responsiveSpacing),

          // Informations sur le niveau
          Container(
            padding: EdgeInsets.all(responsiveSpacing),
            decoration: BoxDecoration(
              color: levelColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: levelColor.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: levelColor,
                  size: responsiveIconSize,
                ),
                SizedBox(width: responsiveSpacing * 0.8),
                Expanded(
                  child: Text(
                    'Niveau $currentLevel • ${nextLevelPoints - points} points pour ${currentLevel == 'Bronze' ? 'Silver' : 'Gold'}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: responsiveSpacing),

          // Barre de progression
          Container(
            padding: EdgeInsets.all(responsiveSpacing),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$points / $nextLevelPoints',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: levelColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsiveSpacing * 0.5),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(levelColor),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Message de motivation
          if (progress < 1.0)
            Container(
              margin: EdgeInsets.only(top: responsiveSpacing),
              padding: EdgeInsets.all(responsiveSpacing),
              decoration: BoxDecoration(
                color: levelColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: levelColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    color: levelColor,
                    size: 20,
                  ),
                  SizedBox(width: responsiveSpacing * 0.8),
                  Expanded(
                    child: Text(
                      '🎯 Plus que ${nextLevelPoints - points} points pour passer au niveau supérieur !',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: levelColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
