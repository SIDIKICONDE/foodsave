import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/presentation/pages/auth/consumer_register/constants/consumer_register_constants.dart';
import 'package:foodsave_app/presentation/pages/auth/consumer_register/services/consumer_register_service.dart';

/// Widget pour le formulaire d'inscription consommateur.
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

  /// Crée un formulaire d'inscription.
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
        // Champ nom
        TextFormField(
          controller: widget.nameController,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: ConsumerRegisterConstants.nameLabel,
            prefixIcon: Icon(Icons.person_outline),
            hintText: ConsumerRegisterConstants.nameHint,
          ),
          validator: ConsumerRegisterService.validateName,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Champ email
        TextFormField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: ConsumerRegisterConstants.emailLabel,
            prefixIcon: Icon(Icons.email_outlined),
            hintText: ConsumerRegisterConstants.emailHint,
          ),
          validator: ConsumerRegisterService.validateEmail,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Champ mot de passe
        TextFormField(
          controller: widget.passwordController,
          obscureText: widget.obscurePassword,
          decoration: InputDecoration(
            labelText: ConsumerRegisterConstants.passwordLabel,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(widget.obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: widget.onTogglePasswordVisibility,
            ),
            hintText: ConsumerRegisterConstants.passwordHint,
          ),
          validator: ConsumerRegisterService.validatePassword,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Champ confirmation mot de passe
        TextFormField(
          controller: widget.confirmPasswordController,
          obscureText: widget.obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: ConsumerRegisterConstants.confirmPasswordLabel,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(widget.obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: widget.onToggleConfirmPasswordVisibility,
            ),
            hintText: ConsumerRegisterConstants.confirmPasswordHint,
          ),
          validator: (String? value) => ConsumerRegisterService.validateConfirmPassword(
            value,
            widget.passwordController.text,
          ),
        ),
      ],
    );
  }
}
