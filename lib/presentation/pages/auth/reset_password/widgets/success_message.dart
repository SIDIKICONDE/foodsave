import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/reset_password/constants/reset_password_constants.dart';

/// Widget pour afficher les messages de succès.
///
/// Affiche un message de succès dans un conteneur stylisé avec une icône.
class SuccessMessage extends StatelessWidget {
  /// Le message de succès à afficher.
  final String successMessage;

  /// Crée un widget de message de succès.
  const SuccessMessage({
    super.key,
    required this.successMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        border: Border.all(
          color: AppColors.success.withValues(alpha: 0.3),
          width: AppDimensions.borderWidth,
        ),
      ),
      child: Row(
        children: <Widget>[
          Icon(
            ResetPasswordConstants.checkCircleIcon,
            color: AppColors.success,
            size: ResetPasswordConstants.successIconSize,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Text(
              successMessage,
              style: AppTextStyles.success,
            ),
          ),
        ],
      ),
    );
  }
}
