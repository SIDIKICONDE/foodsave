import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/core/constants/app_constants.dart';
import 'package:foodsave_app/domain/entities/user.dart';
import 'package:foodsave_app/presentation/pages/auth/consumer_register_page.dart';
import 'package:foodsave_app/presentation/pages/auth/merchant_register_page.dart';

/// Page de sélection du type d'utilisateur pour l'inscription.
/// 
/// Permet aux nouveaux utilisateurs de choisir entre un compte consommateur
/// ou commerçant avant de procéder à l'inscription.
class UserTypeSelectionPage extends StatelessWidget {
  /// Crée une nouvelle instance de [UserTypeSelectionPage].
  const UserTypeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacingXL),
          child: Column(
            children: [
              const SizedBox(height: AppDimensions.spacingXL),
              _buildHeader(),
              const SizedBox(height: AppDimensions.spacingGiant),
              _buildUserTypeCards(context),
              const SizedBox(height: AppDimensions.spacingXxl),
              _buildLoginLink(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit l'en-tête avec le logo et le titre.
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: AppDimensions.avatarXl,
          height: AppDimensions.avatarXl,
          decoration: BoxDecoration(
            color: AppColors.lighten(AppColors.primary, 0.8),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.eco,
            size: AppDimensions.iconGiant,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXL),
        Text(
          AppConstants.appName,
          style: AppTextStyles.headline2.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingM),
        Text(
          'Quel type de compte souhaitez-vous créer ?',
          style: AppTextStyles.headline5.copyWith(
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(
          'Choisissez le type de compte qui correspond à votre profil',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Construit les boutons de sélection du type d'utilisateur.
  Widget _buildUserTypeCards(BuildContext context) {
    return Column(
      children: [
        _buildUserTypeButton(
          context: context,
          title: 'Consommateur',
          subtitle: 'Acheter des paniers anti-gaspi',
          icon: Icons.shopping_basket,
          color: AppColors.primary,
          onTap: () => _navigateToRegister(context, UserType.consumer),
        ),
        const SizedBox(height: AppDimensions.spacingL),
        _buildUserTypeButton(
          context: context,
          title: 'Commerçant',
          subtitle: 'Vendre mes invendus',
          icon: Icons.store,
          color: AppColors.secondary,
          onTap: () => _navigateToRegister(context, UserType.merchant),
        ),
      ],
    );
  }

  /// Construit un bouton de type d'utilisateur.
  Widget _buildUserTypeButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(AppDimensions.spacingXL),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          ),
          elevation: 2,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: Colors.white,
            ),
            const SizedBox(width: AppDimensions.spacingL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.headline6.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingXs),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withValues(alpha: 0.8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  /// Construit le lien vers la page de connexion.
  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Vous avez déjà un compte ? ',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Se connecter',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Navigue vers la page d'inscription appropriée.
  void _navigateToRegister(BuildContext context, UserType userType) {
    Widget page;
    
    switch (userType) {
      case UserType.consumer:
        page = const ConsumerRegisterPage();
        break;
      case UserType.merchant:
        page = const MerchantRegisterPage();
        break;
      case UserType.guest:
        // Ne devrait pas arriver dans ce contexte
        return;
    }
    
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }
}