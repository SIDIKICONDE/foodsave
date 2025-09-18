import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Widget pour afficher les messages d'erreur.
///
/// Affiche un message d'erreur dans un conteneur stylisé avec une icône.
class ErrorMessageWidget extends StatelessWidget {
  /// Le message d'erreur à afficher.
  final String errorMessage;

  /// Crée un widget de message d'erreur.
  const ErrorMessageWidget({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingM),
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
            Icons.error_outline,
            color: AppColors.error,
            size: AppDimensions.iconS,
          ),
          SizedBox(width: AppDimensions.spacingS),
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

/// Widget pour afficher les messages de succès.
///
/// Affiche un message de succès dans un conteneur stylisé avec une icône.
class SuccessMessageWidget extends StatelessWidget {
  /// Le message de succès à afficher.
  final String successMessage;

  /// Crée un widget de message de succès.
  const SuccessMessageWidget({
    super.key,
    required this.successMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.spacingM),
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
            Icons.check_circle_outline,
            color: AppColors.success,
            size: AppDimensions.iconS,
          ),
          SizedBox(width: AppDimensions.spacingS),
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
