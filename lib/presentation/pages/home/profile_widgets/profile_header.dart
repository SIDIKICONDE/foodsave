import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/home/profile_widgets/loyalty_badge.dart';

/// En-tête du profil utilisateur.
///
/// Affiche l'avatar, le nom, la date d'inscription et le niveau de fidélité.
class ProfileHeader extends StatelessWidget {
  /// Crée une nouvelle instance de [ProfileHeader].
  ///
  /// [userName] : Nom de l'utilisateur.
  /// [memberSince] : Date d'inscription.
  /// [loyaltyLevel] : Niveau de fidélité actuel.
  const ProfileHeader({
    super.key,
    required this.userName,
    required this.memberSince,
    required this.loyaltyLevel,
  });

  /// Nom de l'utilisateur.
  final String userName;

  /// Date d'inscription de l'utilisateur.
  final String memberSince;

  /// Niveau de fidélité actuel.
  final String loyaltyLevel;

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);
    final responsiveIconSize = AppDimensions.getResponsiveIconSize(screenWidth, AppDimensions.iconXl);

    return Container(
      padding: EdgeInsets.all(responsiveSpacing),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surfaceSecondary.withValues(alpha: 0.5),
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
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              size: responsiveIconSize,
              color: AppColors.textOnDark,
            ),
          ),
          SizedBox(width: responsiveSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: AppTextStyles.headline5.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: responsiveSpacing * 0.3),
                Text(
                  memberSince,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: responsiveSpacing * 0.6),
                LoyaltyBadge(level: loyaltyLevel),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
