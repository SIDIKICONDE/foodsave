import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Carte de statistique.
///
/// Affiche une statistique avec une icône, une valeur et un libellé.
class StatCard extends StatelessWidget {
  /// Crée une nouvelle instance de [StatCard].
  ///
  /// [icon] : Icône représentant la statistique.
  /// [value] : Valeur numérique de la statistique.
  /// [label] : Libellé descriptif.
  /// [color] : Couleur thématique de la carte.
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  /// Icône représentant la statistique.
  final IconData icon;

  /// Valeur numérique de la statistique.
  final String value;

  /// Libellé descriptif de la statistique.
  final String label;

  /// Couleur thématique de la carte.
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);
    final responsiveIconSize = AppDimensions.getResponsiveIconSize(screenWidth, AppDimensions.iconL);

    return Container(
      padding: EdgeInsets.all(responsiveSpacing),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.lighten(color, 0.9),
            AppColors.lighten(color, 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.lighten(color, 0.7),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color,
                  color.withValues(alpha: 0.8),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: responsiveIconSize,
              color: AppColors.textOnDark,
            ),
          ),
          SizedBox(height: responsiveSpacing * 0.6),
          Text(
            value,
            style: AppTextStyles.headline4.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: responsiveSpacing * 0.3),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.darken(color, 0.3),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
