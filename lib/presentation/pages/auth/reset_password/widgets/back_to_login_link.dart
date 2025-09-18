import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/login_page.dart';
import 'package:foodsave_app/presentation/pages/auth/reset_password/constants/reset_password_constants.dart';

/// Widget pour le lien de retour à la page de connexion.
///
/// Affiche un bouton avec icône pour retourner à la connexion.
class BackToLoginLink extends StatelessWidget {
  /// Crée un lien de retour à la connexion.
  const BackToLoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          ResetPasswordConstants.arrowBackIcon,
          color: AppColors.textSecondary,
          size: AppDimensions.iconS,
        ),
        const SizedBox(width: AppDimensions.spacingXs),
        TextButton(
          onPressed: () => _navigateToLogin(context),
          child: Text(
            ResetPasswordConstants.backToLoginText,
            style: AppTextStyles.responsive(AppTextStyles.link, screenWidth),
          ),
        ),
      ],
    );
  }

  /// Navigue vers la page de connexion.
  void _navigateToLogin(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
