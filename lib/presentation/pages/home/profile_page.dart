import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_constants.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/home/profile_widgets/profile_header.dart';
import 'package:foodsave_app/presentation/pages/home/profile_widgets/stats_section.dart';
import 'package:foodsave_app/presentation/pages/home/profile_widgets/loyalty_section.dart';
import 'package:foodsave_app/presentation/pages/home/profile_widgets/badges_section.dart';
import 'package:foodsave_app/presentation/pages/home/profile_widgets/preferences_section.dart';
import 'package:foodsave_app/presentation/pages/home/profile_widgets/settings_section.dart';

/// Page de profil utilisateur avec préférences et statistiques.
///
/// Cette page affiche les informations utilisateur, ses préférences alimentaires,
/// ses badges, son niveau de fidélité et ses statistiques écologiques.
///
/// Utilise une architecture modulaire avec des widgets séparés pour
/// chaque section (profil, statistiques, fidélité, badges, préférences, paramètres).
class ProfilePage extends StatefulWidget {
  /// Crée une nouvelle instance de [ProfilePage].
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // Utilisation des constantes responsives
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveSpacing = AppDimensions.getResponsiveSpacing(screenWidth);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withValues(alpha: 0.08),
              AppColors.background,
              AppColors.surfaceSecondary.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: kToolbarHeight + 20, // Espace pour l'AppBar transparente
            left: responsiveSpacing,
            right: responsiveSpacing,
            bottom: responsiveSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeader(
                userName: 'Utilisateur FoodSave',
                memberSince: 'Membre depuis janvier 2024',
                loyaltyLevel: 'Bronze',
              ),
              SizedBox(height: responsiveSpacing * 1.5),
              StatsSection(stats: StatsSection.getDefaultStats()),
              SizedBox(height: responsiveSpacing * 1.5),
              const LoyaltySection(
                currentLevel: 'Bronze',
                points: 420,
                nextLevelPoints: 500,
                progress: 0.84,
              ),
              SizedBox(height: responsiveSpacing * 1.5),
              BadgesSection(badges: BadgesSection.getDefaultBadges()),
              SizedBox(height: responsiveSpacing * 1.5),
              PreferencesSection(
                preferences: const ['Végétarien', 'Bio', 'Sans gluten'],
              ),
              SizedBox(height: responsiveSpacing * 1.5),
              SettingsSection(settings: SettingsSection.getDefaultSettings()),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit la barre d'application.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary.withValues(alpha: 0.95),
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.95),
              AppColors.secondary.withValues(alpha: 0.8),
            ],
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surface.withValues(alpha: 0.25),
                  AppColors.surface.withValues(alpha: 0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.surface.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.person,
              color: AppColors.textOnDark,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            AppConstants.profileTabLabel,
            style: AppTextStyles.headline6.copyWith(
              color: AppColors.textOnDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.settings,
              color: AppColors.textOnDark,
              size: AppDimensions.iconM,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('⚙️ Paramètres avancés'),
                  backgroundColor: AppColors.secondary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

}