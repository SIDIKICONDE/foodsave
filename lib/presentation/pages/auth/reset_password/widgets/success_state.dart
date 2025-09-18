import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/reset_password/constants/reset_password_constants.dart';

/// Widget pour l'état de succès après envoi de l'email.
///
/// Affiche un message de confirmation avec l'email destinataire et option de renvoi.
class SuccessState extends StatelessWidget {
  /// L'adresse email du destinataire.
  final String email;

  /// Callback pour renvoyer l'email.
  final VoidCallback onResendEmail;

  /// Indique si le renvoi est en cours.
  final bool isLoading;

  /// Crée un état de succès.
  const SuccessState({
    super.key,
    required this.email,
    required this.onResendEmail,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      constraints: const BoxConstraints(maxWidth: AppDimensions.cardMaxWidth),
      padding: const EdgeInsets.all(AppDimensions.spacingXL),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: AppDimensions.shadowBlurLight,
            offset: const Offset(0, AppDimensions.shadowOffsetY),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          // Section de succès
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingL),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
                width: AppDimensions.borderWidth,
              ),
            ),
            child: Column(
              children: <Widget>[
                Icon(
                  ResetPasswordConstants.checkCircleIcon,
                  color: AppColors.success,
                  size: ResetPasswordConstants.successIconSize,
                ),
                const SizedBox(height: AppDimensions.spacingM),
                Text(
                  ResetPasswordConstants.checkEmailTitle,
                  style: AppTextStyles.responsive(AppTextStyles.headline6, screenWidth)
                      .copyWith(color: AppColors.success),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingS),
                Text(
                  ResetPasswordConstants.checkEmailDescription,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacingXs),
                Text(
                  email,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingL),

          // Section de renvoi
          Text(
            ResetPasswordConstants.notReceivedEmailText,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppDimensions.spacingS),

          TextButton(
            onPressed: isLoading ? null : onResendEmail,
            child: Text(
              ResetPasswordConstants.resendEmailText,
              style: AppTextStyles.link,
            ),
          ),
        ],
      ),
    );
  }
}
