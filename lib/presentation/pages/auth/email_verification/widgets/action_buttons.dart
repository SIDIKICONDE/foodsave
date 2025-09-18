import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/email_verification/constants/email_verification_constants.dart';

/// Widget pour les boutons d'action de la page de vérification.
///
/// Contient le bouton de vérification du statut et le lien de retour.
class ActionButtons extends StatelessWidget {
  /// Indique si la vérification est en cours.
  final bool isCheckingStatus;

  /// Callback pour vérifier le statut.
  final VoidCallback onCheckStatusPressed;

  /// Callback pour retourner à la connexion.
  final VoidCallback onBackToLoginPressed;

  /// Crée des boutons d'action.
  const ActionButtons({
    super.key,
    required this.isCheckingStatus,
    required this.onCheckStatusPressed,
    required this.onBackToLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Lien de retour à la connexion
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.arrow_back,
              color: AppColors.textSecondary,
              size: AppDimensions.iconS,
            ),
            SizedBox(width: AppDimensions.spacingXs),
            TextButton(
              onPressed: onBackToLoginPressed,
              child: Text(
                EmailVerificationConstants.backToLoginText,
                style: AppTextStyles.link,
              ),
            ),
          ],
        ),

        SizedBox(height: AppDimensions.spacingM),

        // Texte de contact
        Text(
          EmailVerificationConstants.contactText,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// Widget pour le bouton de vérification du statut.
///
/// Bouton séparé pour vérifier le statut de vérification de l'email.
class CheckStatusButton extends StatelessWidget {
  /// Indique si la vérification est en cours.
  final bool isCheckingStatus;

  /// Callback pour vérifier le statut.
  final VoidCallback onCheckStatusPressed;

  /// Crée un bouton de vérification du statut.
  const CheckStatusButton({
    super.key,
    required this.isCheckingStatus,
    required this.onCheckStatusPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isCheckingStatus ? null : onCheckStatusPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnDark,
          minimumSize: Size(double.infinity, AppDimensions.buttonMinHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          elevation: AppDimensions.elevationCard,
        ),
        child: isCheckingStatus
            ? SizedBox(
                height: AppDimensions.iconS,
                width: AppDimensions.iconS,
                child: CircularProgressIndicator(
                  strokeWidth: AppDimensions.borderWidth,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.textOnDark),
                ),
              )
            : Text(
                EmailVerificationConstants.checkStatusButtonText,
                style: AppTextStyles.buttonPrimary,
              ),
      ),
    );
  }
}
