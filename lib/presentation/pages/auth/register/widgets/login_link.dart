import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/register/constants/register_constants.dart';

/// Widget pour le lien vers la page de connexion.
///
/// Affiche un texte avec un lien cliquable pour accéder à la page de connexion.
class LoginLink extends StatelessWidget {
  /// Callback appelé lors du clic sur le lien de connexion.
  final VoidCallback onPressed;

  /// Crée un lien vers la connexion.
  const LoginLink({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          RegisterConstants.alreadyHaveAccountText,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingXs),
        TextButton(
          onPressed: onPressed,
          child: Text(
            RegisterConstants.loginButtonText,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
