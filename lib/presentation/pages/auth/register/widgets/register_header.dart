import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/register/constants/register_constants.dart';

/// Widget d'en-tête pour la page d'inscription générale.
///
/// Affiche le logo, le titre et le sous-titre de la page d'inscription.
class RegisterHeader extends StatelessWidget {
  /// Crée un nouvel en-tête d'inscription.
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Logo
        Icon(
          Icons.eco,
          size: RegisterConstants.logoSize.toDouble(),
          color: AppColors.primary,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Titre principal
        Text(
          RegisterConstants.pageHeading,
          style: AppTextStyles.headline4.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppDimensions.spacingS),

        // Sous-titre
        Text(
          RegisterConstants.pageSubtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
