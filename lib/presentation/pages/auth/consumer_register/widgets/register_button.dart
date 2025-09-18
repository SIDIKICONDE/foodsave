import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/consumer_register/constants/consumer_register_constants.dart';

/// Widget pour le bouton d'inscription consommateur.
///
/// Affiche un bouton d'inscription avec gestion des états de chargement.
class RegisterButton extends StatelessWidget {
  /// Indique si l'inscription est en cours.
  final bool isLoading;

  /// Callback appelé lors de l'appui sur le bouton.
  final VoidCallback onPressed;

  /// Crée un bouton d'inscription.
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
        backgroundColor: AppColors.primary,
        minimumSize: const Size(0, AppDimensions.buttonMinHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: ConsumerRegisterConstants.loadingIndicatorSize.toDouble(),
              width: ConsumerRegisterConstants.loadingIndicatorSize.toDouble(),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              ConsumerRegisterConstants.registerButtonText,
              style: AppTextStyles.buttonPrimary,
            ),
    );
  }
}
