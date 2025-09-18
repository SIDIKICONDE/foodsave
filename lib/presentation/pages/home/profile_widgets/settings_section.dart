import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/home/profile_widgets/setting_item.dart';

/// Section des paramètres utilisateur.
///
/// Affiche une liste des paramètres disponibles pour l'utilisateur.
class SettingsSection extends StatelessWidget {
  /// Crée une nouvelle instance de [SettingsSection].
  ///
  /// [settings] : Liste des paramètres à afficher.
  /// Chaque paramètre contient : icon, title, subtitle, isDestructive
  const SettingsSection({
    super.key,
    required this.settings,
  });

  /// Liste des paramètres à afficher.
  final List<Map<String, dynamic>> settings;

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
                AppColors.secondary.withValues(alpha: 0.1),
                AppColors.secondary.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.settings,
                color: AppColors.secondary,
                size: 24,
              ),
              SizedBox(width: responsiveSpacing * 0.6),
              Text(
                'Paramètres',
                style: AppTextStyles.headline5.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Liste des paramètres
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
          child: Column(
            children: settings.map((setting) {
              final index = settings.indexOf(setting);
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < settings.length - 1 ? responsiveSpacing * 0.5 : 0,
                ),
                child: SettingItem(
                  icon: setting['icon'] as IconData,
                  title: setting['title'] as String,
                  subtitle: setting['subtitle'] as String,
                  isDestructive: setting['isDestructive'] as bool? ?? false,
                ),
              );
            }).toList(),
          ),
        ),

        // Footer avec version
        Container(
          margin: EdgeInsets.only(top: responsiveSpacing),
          padding: EdgeInsets.all(responsiveSpacing),
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: AppColors.border.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info,
                size: 16,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: responsiveSpacing * 0.5),
              Text(
                'FoodSave v1.0.0',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Crée une liste de paramètres par défaut.
  static List<Map<String, dynamic>> getDefaultSettings() {
    return [
      {
        'icon': Icons.notifications,
        'title': 'Notifications',
        'subtitle': 'Gérer vos notifications',
        'isDestructive': false,
      },
      {
        'icon': Icons.location_on,
        'title': 'Localisation',
        'subtitle': 'Définir votre zone de recherche',
        'isDestructive': false,
      },
      {
        'icon': Icons.help,
        'title': 'Aide et support',
        'subtitle': 'FAQ et contact',
        'isDestructive': false,
      },
      {
        'icon': Icons.logout,
        'title': 'Déconnexion',
        'subtitle': 'Se déconnecter de l\'application',
        'isDestructive': true,
      },
    ];
  }
}
