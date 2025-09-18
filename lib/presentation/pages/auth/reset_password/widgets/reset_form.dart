import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/reset_password/constants/reset_password_constants.dart';
import 'package:foodsave_app/presentation/pages/auth/reset_password/services/reset_password_service.dart';
import 'error_message.dart';
import 'success_message.dart';

/// Widget pour le formulaire de réinitialisation de mot de passe.
///
/// Gère le champ email avec validation et décoration d'input.
class ResetForm extends StatefulWidget {
  /// Contrôleur pour le champ email.
  final TextEditingController emailController;

  /// Message d'erreur à afficher (optionnel).
  final String? errorMessage;

  /// Message de succès à afficher (optionnel).
  final String? successMessage;

  /// Crée un formulaire de réinitialisation.
  const ResetForm({
    super.key,
    required this.emailController,
    this.errorMessage,
    this.successMessage,
  });

  @override
  State<ResetForm> createState() => _ResetFormState();
}

class _ResetFormState extends State<ResetForm> {
  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Champ email
          TextFormField(
            controller: widget.emailController,
            decoration: _buildInputDecoration(),
            style: AppTextStyles.bodyMedium,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: ResetPasswordService.validateEmail,
          ),

          // Message d'erreur
          if (widget.errorMessage != null) ...<Widget>[
            const SizedBox(height: AppDimensions.spacingM),
            ErrorMessage(errorMessage: widget.errorMessage!),
          ],

          // Message de succès
          if (widget.successMessage != null) ...<Widget>[
            const SizedBox(height: AppDimensions.spacingM),
            SuccessMessage(successMessage: widget.successMessage!),
          ],
        ],
      ),
    );
  }

  /// Construit la décoration d'input standardisée.
  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      labelText: ResetPasswordConstants.emailLabel,
      hintText: ResetPasswordConstants.emailHint,
      labelStyle: AppTextStyles.labelMedium.copyWith(
        color: AppColors.textSecondary,
      ),
      hintStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textSecondary.withValues(alpha: 0.6),
      ),
      prefixIcon: Icon(
        ResetPasswordConstants.emailIcon,
        color: AppColors.textSecondary,
        size: AppDimensions.iconM,
      ),
      filled: true,
      fillColor: AppColors.backgroundLight,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingL,
        vertical: AppDimensions.spacingM,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide(
          color: AppColors.borderLight,
          width: AppDimensions.borderWidth,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide(
          color: AppColors.borderLight,
          width: AppDimensions.borderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: AppDimensions.borderWidthThick,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide(
          color: AppColors.error,
          width: AppDimensions.borderWidth,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        borderSide: BorderSide(
          color: AppColors.error,
          width: AppDimensions.borderWidthThick,
        ),
      ),
    );
  }
}
