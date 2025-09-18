import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/login/constants/login_constants.dart';

/// Widget d'en-tête pour la page de connexion.
///
/// Affiche le logo, le titre et le sous-titre de l'application.
class LoginHeader extends StatelessWidget {
  /// Crée un nouvel en-tête de connexion.
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
          LoginConstants.appName,
          style: AppTextStyles.headline2.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(
          LoginConstants.loginSubtitle,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
