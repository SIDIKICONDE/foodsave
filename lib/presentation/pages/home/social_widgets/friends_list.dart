import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Liste des amis FoodSave.
///
/// Affiche la liste des amis de l'utilisateur avec leur statut et statistiques.
class FriendsList extends StatelessWidget {
  /// Crée une nouvelle instance de [FriendsList].
  const FriendsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vos amis FoodSave',
          style: AppTextStyles.headline5.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        _buildFriendItem('Marie L.', '127 kg sauvés', true),
        _buildFriendItem('Thomas B.', '89 kg sauvés', false),
        _buildFriendItem('Sophie M.', '156 kg sauvés', true),
      ],
    );
  }

  /// Construit un élément d'ami.
  Widget _buildFriendItem(String name, String stats, bool isOnline) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: AppDimensions.avatarM / 2,
                backgroundColor: AppColors.lighten(AppColors.primary, 0.8),
                child: Text(
                  name.substring(0, 1),
                  style: AppTextStyles.headline6.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isOnline)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppDimensions.spacingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  stats,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.message,
              color: AppColors.primary,
              size: AppDimensions.iconL,
            ),
            onPressed: () {
              // TODO: Implémenter la messagerie
            },
          ),
        ],
      ),
    );
  }
}
