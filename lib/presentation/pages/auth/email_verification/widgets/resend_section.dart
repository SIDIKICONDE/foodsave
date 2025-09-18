import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/email_verification/constants/email_verification_constants.dart';
import 'package:foodsave_app/presentation/pages/auth/email_verification/services/email_verification_service.dart';

/// Widget pour la section de renvoi d'email.
///
/// Gère l'affichage du bouton de renvoi avec le compte à rebours.
class ResendSection extends StatelessWidget {
  /// Indique si l'email est en cours de renvoi.
  final bool isResending;

  /// Le compte à rebours en secondes.
  final int resendCountdown;

  /// Callback appelé lors du clic sur le bouton de renvoi.
  final VoidCallback onResendPressed;

  /// Crée une section de renvoi.
  const ResendSection({
    super.key,
    required this.isResending,
    required this.resendCountdown,
    required this.onResendPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          EmailVerificationConstants.resendQuestion,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spacingM),

        if (resendCountdown > 0) ...<Widget>[
          Text(
            '${EmailVerificationConstants.countdownText} ${EmailVerificationService.formatCountdown(resendCountdown)}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.spacingS),
          LinearProgressIndicator(
            value: (EmailVerificationConstants.resendDelaySeconds - resendCountdown) /
                   EmailVerificationConstants.resendDelaySeconds,
            backgroundColor: AppColors.borderLight,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ] else ...<Widget>[
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: isResending ? null : onResendPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                minimumSize: Size(double.infinity, AppDimensions.buttonMinHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
              child: isResending
                  ? SizedBox(
                      height: AppDimensions.iconS,
                      width: AppDimensions.iconS,
                      child: CircularProgressIndicator(
                        strokeWidth: AppDimensions.borderWidth,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    )
                  : Text(
                      EmailVerificationConstants.resendButtonText,
                      style: AppTextStyles.buttonSecondary,
                    ),
            ),
          ),
        ],
      ],
    );
  }
}
