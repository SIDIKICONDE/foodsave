import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/pages/auth/login/constants/login_constants.dart';
import 'package:foodsave_app/presentation/pages/auth/login/services/login_service.dart';

/// Widget pour les champs du formulaire de connexion.
///
/// Gère les champs email et mot de passe avec leur validation respective.
class LoginFormFields extends StatefulWidget {
  /// Contrôleur pour le champ email.
  final TextEditingController emailController;

  /// Contrôleur pour le champ mot de passe.
  final TextEditingController passwordController;

  /// État d'obscurcissement du mot de passe.
  final bool obscurePassword;

  /// Callback pour changer l'état d'obscurcissement du mot de passe.
  final VoidCallback onTogglePasswordVisibility;

  /// Crée des champs de formulaire de connexion.
  const LoginFormFields({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
  });

  @override
  State<LoginFormFields> createState() => _LoginFormFieldsState();
}

class _LoginFormFieldsState extends State<LoginFormFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Champ email
        TextFormField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            labelText: LoginConstants.emailPlaceholder,
            labelStyle: AppTextStyles.labelMedium,
            hintText: 'votre@email.com',
            hintStyle: AppTextStyles.withColor(
              AppTextStyles.bodyMedium,
              AppColors.textSecondary,
            ),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: AppColors.primary,
              size: AppDimensions.iconL,
            ),
          ),
          validator: LoginService.validateEmail,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Champ mot de passe
        TextFormField(
          controller: widget.passwordController,
          obscureText: widget.obscurePassword,
          style: AppTextStyles.bodyMedium,
          decoration: InputDecoration(
            labelText: LoginConstants.passwordPlaceholder,
            labelStyle: AppTextStyles.labelMedium,
            hintText: 'Entrez votre mot de passe',
            hintStyle: AppTextStyles.withColor(
              AppTextStyles.bodyMedium,
              AppColors.textSecondary,
            ),
            prefixIcon: Icon(
              Icons.lock_outlined,
              color: AppColors.primary,
              size: AppDimensions.iconL,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                widget.obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.textSecondary,
                size: AppDimensions.iconL,
              ),
              onPressed: widget.onTogglePasswordVisibility,
            ),
          ),
          validator: LoginService.validatePassword,
        ),
      ],
    );
  }
}
