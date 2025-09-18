import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/register/constants/register_constants.dart';

/// Widget pour le bouton d'inscription générale.
///
/// Affiche un bouton d'inscription avec gestion des états de chargement.
class RegisterButton extends StatelessWidget {
  /// Indique si l'inscription est en cours.
  final bool isLoading;

  /// Callback appelé lors de l'appui sur le bouton.
  final VoidCallback onPressed;

  /// Crée un bouton d'inscription générale.
  const RegisterButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, AppDimensions.buttonMinHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: RegisterConstants.loadingIndicatorSize.toDouble(),
              width: RegisterConstants.loadingIndicatorSize.toDouble(),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              RegisterConstants.createAccountButtonText,
              style: AppTextStyles.buttonPrimary,
            ),
    );
  }
}
