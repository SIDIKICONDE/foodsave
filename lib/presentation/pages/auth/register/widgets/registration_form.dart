import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/presentation/pages/auth/register/constants/register_constants.dart';
import 'package:foodsave_app/presentation/pages/auth/register/services/register_service.dart';

/// Widget pour le formulaire d'inscription générale.
///
/// Gère tous les champs du formulaire avec leur validation respective.
class RegistrationForm extends StatefulWidget {
  /// Contrôleur pour le champ nom.
  final TextEditingController nameController;

  /// Contrôleur pour le champ email.
  final TextEditingController emailController;

  /// Contrôleur pour le champ mot de passe.
  final TextEditingController passwordController;

  /// Contrôleur pour le champ confirmation mot de passe.
  final TextEditingController confirmPasswordController;

  /// État d'obscurcissement du mot de passe.
  final bool obscurePassword;

  /// État d'obscurcissement de la confirmation du mot de passe.
  final bool obscureConfirmPassword;

  /// Callback pour changer l'état d'obscurcissement du mot de passe.
  final VoidCallback onTogglePasswordVisibility;

  /// Callback pour changer l'état d'obscurcissement de la confirmation du mot de passe.
  final VoidCallback onToggleConfirmPasswordVisibility;

  /// Crée un formulaire d'inscription générale.
  const RegistrationForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
  });

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Champ nom complet
        TextFormField(
          controller: widget.nameController,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: RegisterConstants.nameLabel,
            prefixIcon: Icon(Icons.person_outline),
            hintText: RegisterConstants.nameHint,
          ),
          validator: RegisterService.validateName,
        ),

        const SizedBox(height: AppDimensions.spacingL),

        // Champ email
        TextFormField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: RegisterConstants.emailLabel,
            prefixIcon: Icon(Icons.email_outlined),
            hintText: RegisterConstants.emailHint,
          ),
          validator: RegisterService.validateEmail,
        ),

        const SizedBox(height: AppDimensions.spacingL),

        // Champ mot de passe
        TextFormField(
          controller: widget.passwordController,
          obscureText: widget.obscurePassword,
          decoration: InputDecoration(
            labelText: RegisterConstants.passwordLabel,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(widget.obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: widget.onTogglePasswordVisibility,
            ),
            hintText: RegisterConstants.passwordHint,
          ),
          validator: RegisterService.validatePassword,
        ),

        const SizedBox(height: AppDimensions.spacingL),

        // Champ confirmation mot de passe
        TextFormField(
          controller: widget.confirmPasswordController,
          obscureText: widget.obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: RegisterConstants.confirmPasswordLabel,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(widget.obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: widget.onToggleConfirmPasswordVisibility,
            ),
            hintText: RegisterConstants.confirmPasswordHint,
          ),
          validator: (String? value) => RegisterService.validateConfirmPassword(
            value,
            widget.passwordController.text,
          ),
        ),
      ],
    );
  }
}
