import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/reset_password/constants/reset_password_constants.dart';

/// Widget pour afficher les messages d'erreur.
///
/// Affiche un message d'erreur dans un conteneur stylisé avec une icône.
class ErrorMessage extends StatelessWidget {
  /// Le message d'erreur à afficher.
  final String errorMessage;

  /// Crée un widget de message d'erreur.
  const ErrorMessage({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
          width: AppDimensions.borderWidth,
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            ResetPasswordConstants.errorOutlineIcon,
            color: AppColors.error,
            size: ResetPasswordConstants.errorIconSize,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Text(
              errorMessage,
              style: AppTextStyles.error,
            ),
          ),
        ],
      ),
    );
  }
}
