import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Section d'activité récente.
///
/// Affiche les dernières actions de la communauté.
class RecentActivity extends StatelessWidget {
  /// Crée une nouvelle instance de [RecentActivity].
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activité récente',
          style: AppTextStyles.headline5.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        _buildActivityItem(
          Icons.shopping_basket,
          'Marie a récupéré un panier chez Boulangerie Martin',
          'Il y a 2h',
          AppColors.primary,
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _buildActivityItem(
          Icons.star,
          'Thomas a obtenu le badge "Éco-guerrier"',
          'Il y a 4h',
          AppColors.warning,
        ),
        const SizedBox(height: AppDimensions.spacingM),
        _buildActivityItem(
          Icons.share,
          'Sophie a partagé une recette anti-gaspi',
          'Il y a 6h',
          AppColors.info,
        ),
      ],
    );
  }

  /// Construit un élément d'activité.
  Widget _buildActivityItem(IconData icon, String text, String time, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingS),
          decoration: BoxDecoration(
            color: AppColors.lighten(color, 0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: AppDimensions.iconM,
            color: color,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: AppTextStyles.bodyMedium,
              ),
              Text(
                time,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
