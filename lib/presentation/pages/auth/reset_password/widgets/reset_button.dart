import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/reset_password/constants/reset_password_constants.dart';

/// Widget pour le bouton de réinitialisation de mot de passe.
///
/// Affiche un bouton avec indicateur de chargement intégré.
class ResetButton extends StatelessWidget {
  /// Indique si l'opération est en cours.
  final bool isLoading;

  /// Callback appelé lors de l'appui sur le bouton.
  final VoidCallback onPressed;

  /// Crée un bouton de réinitialisation.
  const ResetButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnDark,
        minimumSize: const Size(double.infinity, AppDimensions.buttonMinHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        elevation: AppDimensions.elevationCard,
      ),
      child: isLoading
          ? SizedBox(
              height: ResetPasswordConstants.loadingIndicatorSize,
              width: ResetPasswordConstants.loadingIndicatorSize,
              child: CircularProgressIndicator(
                strokeWidth: AppDimensions.borderWidth,
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.textOnDark),
              ),
            )
          : Text(
              ResetPasswordConstants.resetButtonText,
              style: AppTextStyles.buttonPrimary,
            ),
    );
  }
}
