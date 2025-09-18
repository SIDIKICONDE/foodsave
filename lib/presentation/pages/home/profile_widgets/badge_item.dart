import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Élément de badge dans la grille des badges.
///
/// Affiche un badge avec une icône, un nom et un indicateur de déverrouillage.
class BadgeItem extends StatelessWidget {
  /// Crée une nouvelle instance de [BadgeItem].
  ///
  /// [icon] : Icône représentant le badge.
  /// [name] : Nom du badge.
  /// [isUnlocked] : Indique si le badge est débloqué.
  const BadgeItem({
    super.key,
    required this.icon,
    required this.name,
    this.isUnlocked = false,
  });

  /// Icône représentant le badge.
  final IconData icon;

  /// Nom du badge.
  final String name;

  /// Indique si le badge est débloqué.
  final bool isUnlocked;

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);
    final responsiveIconSize = AppDimensions.getResponsiveIconSize(screenWidth, AppDimensions.iconL);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isUnlocked
              ? [
                  AppColors.lighten(AppColors.success, 0.9),
                  AppColors.lighten(AppColors.success, 0.95),
                ]
              : [
                  AppColors.lighten(AppColors.textDisabled, 0.9),
                  AppColors.lighten(AppColors.textDisabled, 0.95),
                ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: isUnlocked
              ? AppColors.success
              : AppColors.textDisabled,
          width: 1,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icône du badge
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isUnlocked
                    ? [
                        AppColors.success,
                        AppColors.success.withValues(alpha: 0.8),
                      ]
                    : [
                        AppColors.textDisabled,
                        AppColors.textDisabled.withValues(alpha: 0.8),
                      ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isUnlocked ? AppColors.success : AppColors.textDisabled).withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: responsiveIconSize * 0.8, // Icône légèrement plus petite dans le badge
              color: AppColors.textOnDark,
            ),
          ),

          SizedBox(height: responsiveSpacing * 0.4),

          // Nom du badge
          Text(
            name,
            style: AppTextStyles.labelSmall.copyWith(
              color: isUnlocked ? AppColors.success : AppColors.textDisabled,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          // Indicateur de verrouillage
          if (!isUnlocked)
            Container(
              margin: EdgeInsets.only(top: responsiveSpacing * 0.3),
              child: Icon(
                Icons.lock,
                size: responsiveIconSize * 0.4,
                color: AppColors.textDisabled.withValues(alpha: 0.7),
              ),
            ),
        ],
      ),
    );
  }
}
