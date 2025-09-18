import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/login/constants/login_constants.dart';

/// Widget pour les boutons de la page de connexion.
///
/// Gère les boutons de connexion et mode invité avec leurs états de chargement.
class LoginButtons extends StatelessWidget {
  /// Indique si l'opération est en cours.
  final bool isLoading;

  /// Callback pour la connexion.
  final VoidCallback onLoginPressed;

  /// Callback pour le mode invité.
  final VoidCallback onGuestModePressed;

  /// Crée des boutons de connexion.
  const LoginButtons({
    super.key,
    required this.isLoading,
    required this.onLoginPressed,
    required this.onGuestModePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Bouton de connexion
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onLoginPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isLoading ? AppColors.textDisabled : AppColors.primary,
              foregroundColor: AppColors.textOnDark,
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    height: AppDimensions.iconL,
                    width: AppDimensions.iconL,
                    child: CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.textOnDark),
                      strokeWidth: AppDimensions.borderWidth,
                    ),
                  )
                : Text(
                    LoginConstants.loginButtonText,
                    style: AppTextStyles.buttonPrimary,
                  ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Bouton mode invité
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: isLoading ? null : onGuestModePressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.info,
              side: BorderSide(
                color: isLoading ? AppColors.textDisabled : AppColors.info,
                width: AppDimensions.borderWidth,
              ),
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              ),
            ),
            child: Text(
              LoginConstants.continueWithoutAccountText,
              style: AppTextStyles.buttonSecondary.copyWith(
                color: isLoading ? AppColors.textDisabled : AppColors.info,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
