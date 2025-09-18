import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Bottom sheet de partage.
///
/// Permet aux utilisateurs de partager différents types de contenu.
class ShareBottomSheet extends StatelessWidget {
  /// Crée une nouvelle instance de [ShareBottomSheet].
  const ShareBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Partager',
            style: AppTextStyles.headline6.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildShareOption(Icons.shopping_basket, 'Panier'),
              _buildShareOption(Icons.article, 'Recette'),
              _buildShareOption(Icons.store, 'Commerce'),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit une option de partage.
  Widget _buildShareOption(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          decoration: BoxDecoration(
            color: AppColors.lighten(AppColors.primary, 0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: AppDimensions.iconL,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(
          label,
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
