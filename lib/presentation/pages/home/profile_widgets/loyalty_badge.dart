import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Badge de niveau de fidélité.
///
/// Affiche le niveau actuel de l'utilisateur avec une couleur distinctive.
class LoyaltyBadge extends StatelessWidget {
  /// Crée une nouvelle instance de [LoyaltyBadge].
  ///
  /// [level] : Niveau de fidélité (ex: 'Bronze', 'Silver', 'Gold').
  const LoyaltyBadge({
    super.key,
    required this.level,
  });

  /// Niveau de fidélité de l'utilisateur.
  final String level;

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);

    // Couleur basée sur le niveau
    final Color badgeColor = switch (level.toLowerCase()) {
      'bronze' => AppColors.warning,
      'silver' => Colors.grey.shade500,
      'gold' => AppColors.badge,
      _ => AppColors.primary,
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsiveSpacing * 0.8,
        vertical: responsiveSpacing * 0.3,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            badgeColor,
            badgeColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: AppDimensions.iconS,
            color: AppColors.textOnDark,
          ),
          SizedBox(width: responsiveSpacing * 0.25),
          Text(
            level,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textOnDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
