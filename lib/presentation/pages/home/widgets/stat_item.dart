import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Élément de statistique pour la section statistiques personnelles.
///
/// Affiche une valeur, un libellé et une icône pour représenter une statistique.
class StatItem extends StatelessWidget {
  /// Crée une nouvelle instance de [StatItem].
  ///
  /// [value] : La valeur de la statistique.
  /// [label] : Le libellé descriptif.
  /// [icon] : L'icône à afficher.
  const StatItem({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
  });

  /// La valeur de la statistique.
  final String value;

  /// Le libellé descriptif.
  final String label;

  /// L'icône à afficher.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: AppDimensions.iconL,
          color: AppColors.success,
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(
          value,
          style: AppTextStyles.headline4.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.darken(AppColors.success, 0.3),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
