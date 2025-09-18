import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Élément de paramètre dans la liste des paramètres.
///
/// Affiche un paramètre avec une icône, un titre, un sous-titre et une flèche.
class SettingItem extends StatelessWidget {
  /// Crée une nouvelle instance de [SettingItem].
  ///
  /// [icon] : Icône du paramètre.
  /// [title] : Titre du paramètre.
  /// [subtitle] : Sous-titre descriptif.
  /// [isDestructive] : Indique si c'est une action destructive (comme la déconnexion).
  /// [onTap] : Callback appelé lors du tap.
  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isDestructive = false,
    this.onTap,
  });

  /// Icône du paramètre.
  final IconData icon;

  /// Titre du paramètre.
  final String title;

  /// Sous-titre descriptif.
  final String subtitle;

  /// Indique si c'est une action destructive.
  final bool isDestructive;

  /// Callback appelé lors du tap.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);
    final responsiveIconSize = AppDimensions.getResponsiveIconSize(screenWidth, AppDimensions.iconL);

    final Color itemColor = isDestructive ? AppColors.error : AppColors.primary;

    return Container(
      margin: EdgeInsets.only(bottom: responsiveSpacing * 0.5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface,
            AppColors.surfaceSecondary.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          onTap?.call();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isDestructive ? '🚪 $title...' : '⚙️ $title'),
              backgroundColor: itemColor,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                itemColor,
                itemColor.withValues(alpha: 0.8),
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: itemColor.withValues(alpha: 0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: responsiveIconSize * 0.8,
            color: AppColors.textOnDark,
          ),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: isDestructive ? AppColors.error : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary.withValues(alpha: 0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.chevron_right,
            size: responsiveIconSize * 0.6,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
