import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/reset_password/constants/reset_password_constants.dart';

/// Widget d'en-tête pour la page de réinitialisation de mot de passe.
///
/// Affiche l'icône, le titre et le sous-titre avec gestion des états.
class ResetPasswordHeader extends StatelessWidget {
  /// Indique si l'email a été envoyé avec succès.
  final bool emailSent;

  /// Crée un en-tête de réinitialisation de mot de passe.
  const ResetPasswordHeader({
    super.key,
    required this.emailSent,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        // Icône adaptative selon l'état
        Container(
          width: ResetPasswordConstants.headerIconSize,
          height: ResetPasswordConstants.headerIconSize,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
          ),
          child:                 Icon(
                  emailSent
                      ? ResetPasswordConstants.emailReadIcon
                      : ResetPasswordConstants.lockResetIcon,
                  size: AppDimensions.getResponsiveIconSize(screenWidth, AppDimensions.iconGiant),
                  color: AppColors.primary,
                ),
        ),
        const SizedBox(height: AppDimensions.spacingXL),

        // Titre adaptatif selon l'état
        Text(
          emailSent
              ? ResetPasswordConstants.emailSentTitle
              : ResetPasswordConstants.pageTitle,
          style: AppTextStyles.responsive(AppTextStyles.headline2, screenWidth),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppDimensions.spacingM),

        // Sous-titre adaptatif selon l'état
        Text(
          emailSent
              ? ResetPasswordConstants.emailSentSubtitle
              : ResetPasswordConstants.pageSubtitle,
          style: AppTextStyles.responsive(AppTextStyles.bodyMedium, screenWidth)
              .copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
