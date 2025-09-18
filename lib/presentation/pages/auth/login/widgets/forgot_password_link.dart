import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/login/constants/login_constants.dart';

/// Widget pour le lien "Mot de passe oublié".
///
/// Affiche un lien cliquable pour accéder à la page de réinitialisation de mot de passe.
class ForgotPasswordLink extends StatelessWidget {
  /// Callback appelé lors du clic sur le lien.
  final VoidCallback onPressed;

  /// Crée un lien "Mot de passe oublié".
  const ForgotPasswordLink({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          LoginConstants.forgotPasswordText,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
