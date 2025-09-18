import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/home/profile_widgets/badge_item.dart';

/// Section des badges utilisateur.
///
/// Affiche une grille des badges obtenus et à obtenir par l'utilisateur.
class BadgesSection extends StatelessWidget {
  /// Crée une nouvelle instance de [BadgesSection].
  ///
  /// [badges] : Liste des badges à afficher.
  /// Chaque badge contient : icon, name, isUnlocked
  const BadgesSection({
    super.key,
    required this.badges,
  });

  /// Liste des badges à afficher.
  final List<Map<String, dynamic>> badges;

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);
    final crossAxisCount = AppDimensions.isSmallScreen(screenWidth) ? 3 : 4;

    final unlockedBadges = badges.where((badge) => badge['isUnlocked'] as bool).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête avec compteur
        Container(
          margin: EdgeInsets.only(bottom: responsiveSpacing),
          padding: EdgeInsets.all(responsiveSpacing * 0.8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.warning.withValues(alpha: 0.1),
                AppColors.warning.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: AppColors.warning.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.emoji_events,
                    color: AppColors.warning,
                    size: 24,
                  ),
                  SizedBox(width: responsiveSpacing * 0.6),
                  Text(
                    'Vos badges',
                    style: AppTextStyles.headline5.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsiveSpacing * 0.6,
                  vertical: responsiveSpacing * 0.3,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.success,
                      AppColors.success.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '$unlockedBadges/${badges.length}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textOnDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Grille des badges
        Container(
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
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: responsiveSpacing * 0.8,
              mainAxisSpacing: responsiveSpacing * 0.8,
              childAspectRatio: 1.0,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              return BadgeItem(
                icon: badge['icon'] as IconData,
                name: badge['name'] as String,
                isUnlocked: badge['isUnlocked'] as bool,
              );
            },
          ),
        ),

        // Message de progression
        if (unlockedBadges < badges.length)
          Container(
            margin: EdgeInsets.only(top: responsiveSpacing),
            padding: EdgeInsets.all(responsiveSpacing),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: AppColors.info,
                  size: 20,
                ),
                SizedBox(width: responsiveSpacing * 0.8),
                Expanded(
                  child: Text(
                    '💡 Continuez à utiliser l\'app pour débloquer plus de badges !',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.info,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// Crée une liste de badges par défaut.
  static List<Map<String, dynamic>> getDefaultBadges() {
    return [
      {'icon': Icons.eco, 'name': 'Éco-guerrier', 'isUnlocked': true},
      {'icon': Icons.shopping_basket, 'name': 'Sauveur', 'isUnlocked': true},
      {'icon': Icons.star, 'name': 'VIP', 'isUnlocked': true},
      {'icon': Icons.local_pizza, 'name': 'Pizza lover', 'isUnlocked': false},
      {'icon': Icons.cake, 'name': 'Boulanger', 'isUnlocked': false},
      {'icon': Icons.coffee, 'name': 'Café addict', 'isUnlocked': false},
    ];
  }
}
