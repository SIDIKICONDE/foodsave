import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/email_verification/constants/email_verification_constants.dart';

/// Widget d'en-tête pour la page de vérification d'email.
///
/// Affiche l'icône animée, le titre et l'adresse email à vérifier.
class VerificationHeader extends StatelessWidget {
  /// L'adresse email à vérifier.
  final String email;

  /// Le contrôleur d'animation pour l'icône.
  final AnimationController animationController;

  /// L'animation de l'icône.
  final Animation<double> iconAnimation;

  /// Crée un en-tête de vérification.
  const VerificationHeader({
    super.key,
    required this.email,
    required this.animationController,
    required this.iconAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        // Icône animée
        AnimatedBuilder(
          animation: iconAnimation,
          builder: (BuildContext context, Widget? child) {
            return Transform.scale(
              scale: iconAnimation.value,
              child: Container(
                width: AppDimensions.iconGiant * 2,
                height: AppDimensions.iconGiant * 2,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    width: AppDimensions.borderWidthThick,
                  ),
                ),
                child: Icon(
                  Icons.mark_email_unread_outlined,
                  size: AppDimensions.getResponsiveIconSize(screenWidth, AppDimensions.iconGiant),
                  color: AppColors.primary,
                ),
              ),
            );
          },
        ),

        SizedBox(height: AppDimensions.spacingXL),

        // Titre
        Text(
          EmailVerificationConstants.pageTitle,
          style: AppTextStyles.responsive(AppTextStyles.headline2, screenWidth),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: AppDimensions.spacingM),

        // Sous-titre
        Text(
          EmailVerificationConstants.pageSubtitle,
          style: AppTextStyles.responsive(AppTextStyles.bodyMedium, screenWidth)
              .copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: AppDimensions.spacingS),

        // Adresse email
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingS,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Text(
            email,
            style: AppTextStyles.responsive(AppTextStyles.bodyMedium, screenWidth)
                .copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
