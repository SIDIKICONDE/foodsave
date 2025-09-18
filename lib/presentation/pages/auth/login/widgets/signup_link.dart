import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/login/constants/login_constants.dart';

/// Widget pour le lien vers l'inscription.
///
/// Affiche un texte avec un lien cliquable pour accéder à la page d'inscription.
class SignupLink extends StatelessWidget {
  /// Callback appelé lors du clic sur le lien d'inscription.
  final VoidCallback onPressed;

  /// Crée un lien vers l'inscription.
  const SignupLink({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          LoginConstants.noAccountText,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingXs),
        TextButton(
          onPressed: onPressed,
          child: Text(
            LoginConstants.signupButtonText,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
