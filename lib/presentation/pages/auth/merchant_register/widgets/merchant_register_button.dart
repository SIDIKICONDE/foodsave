import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/merchant_register/constants/merchant_register_constants.dart';

/// Widget pour le bouton d'inscription commerçant.
///
/// Affiche un bouton d'inscription avec gestion des états de chargement.
class MerchantRegisterButton extends StatelessWidget {
  /// Indique si l'inscription est en cours.
  final bool isLoading;

  /// Callback appelé lors de l'appui sur le bouton.
  final VoidCallback onPressed;

  /// Crée un bouton d'inscription commerçant.
  const MerchantRegisterButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        minimumSize: const Size(0, AppDimensions.buttonMinHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
      ),
      child: isLoading
          ? SizedBox(
              height: MerchantRegisterConstants.loadingIndicatorSize.toDouble(),
              width: MerchantRegisterConstants.loadingIndicatorSize.toDouble(),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(
              MerchantRegisterConstants.registerButtonText,
              style: AppTextStyles.buttonPrimary,
            ),
    );
  }
}
