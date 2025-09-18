import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/core/constants/app_constants.dart';
import 'package:foodsave_app/presentation/pages/home/profile_widgets/stat_card.dart';

/// Section des statistiques écologiques.
///
/// Affiche l'impact écologique de l'utilisateur avec différentes métriques.
class StatsSection extends StatelessWidget {
  /// Crée une nouvelle instance de [StatsSection].
  ///
  /// [stats] : Liste des statistiques à afficher.
  /// Chaque statistique contient : icon, value, label, color
  const StatsSection({
    super.key,
    required this.stats,
  });

  /// Liste des statistiques à afficher.
  final List<Map<String, dynamic>> stats;

  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de la section
        Container(
          margin: EdgeInsets.only(bottom: responsiveSpacing),
          padding: EdgeInsets.all(responsiveSpacing * 0.8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.secondary.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.eco,
                color: AppColors.primary,
                size: 24,
              ),
              SizedBox(width: responsiveSpacing * 0.6),
              Text(
                'Votre impact écologique',
                style: AppTextStyles.headline5.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Grille des statistiques
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: responsiveSpacing,
            mainAxisSpacing: responsiveSpacing,
            childAspectRatio: 1.2,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) {
            final stat = stats[index];
            return StatCard(
              icon: stat['icon'] as IconData,
              value: stat['value'] as String,
              label: stat['label'] as String,
              color: stat['color'] as Color,
            );
          },
        ),

        // Message d'encouragement
        Container(
          margin: EdgeInsets.only(top: responsiveSpacing),
          padding: EdgeInsets.all(responsiveSpacing),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.celebration,
                color: AppColors.success,
                size: 20,
              ),
              SizedBox(width: responsiveSpacing * 0.8),
              Expanded(
                child: Text(
                  '🌱 Merci pour votre contribution à l\'environnement !',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.success,
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

  /// Crée une liste de statistiques par défaut.
  static List<Map<String, dynamic>> getDefaultStats() {
    return [
      {
        'icon': Icons.scale,
        'value': '8.5',
        'label': '${AppConstants.kgUnit} ${AppConstants.savedText}',
        'color': AppColors.success,
      },
      {
        'icon': Icons.eco,
        'value': '12.3',
        'label': '${AppConstants.co2Unit} ${AppConstants.avoidedText}',
        'color': AppColors.info,
      },
      {
        'icon': Icons.shopping_basket,
        'value': '15',
        'label': 'paniers récupérés',
        'color': AppColors.primary,
      },
      {
        'icon': Icons.euro,
        'value': '127€',
        'label': 'économisés',
        'color': AppColors.warning,
      },
    ];
  }
}
