import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/presentation/pages/auth/merchant_register/constants/merchant_register_constants.dart';
import 'package:foodsave_app/presentation/pages/auth/merchant_register/services/merchant_register_service.dart';

/// Widget pour le formulaire d'inscription commerçant.
///
/// Gère tous les champs du formulaire avec leur validation respective.
class MerchantRegistrationForm extends StatefulWidget {
  /// Contrôleur pour le champ nom du responsable.
  final TextEditingController managerNameController;

  /// Contrôleur pour le champ nom du commerce.
  final TextEditingController businessNameController;

  /// Contrôleur pour le champ téléphone.
  final TextEditingController phoneController;

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

  /// Crée un formulaire d'inscription commerçant.
  const MerchantRegistrationForm({
    super.key,
    required this.managerNameController,
    required this.businessNameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
  });

  @override
  State<MerchantRegistrationForm> createState() => _MerchantRegistrationFormState();
}

class _MerchantRegistrationFormState extends State<MerchantRegistrationForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Nom du responsable
        TextFormField(
          controller: widget.managerNameController,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: MerchantRegisterConstants.managerNameLabel,
            prefixIcon: Icon(Icons.person_outline),
            hintText: MerchantRegisterConstants.managerNameHint,
          ),
          validator: MerchantRegisterService.validateManagerName,
        ),

        const SizedBox(height: AppDimensions.spacingL),

        // Nom du commerce
        TextFormField(
          controller: widget.businessNameController,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: MerchantRegisterConstants.businessNameLabel,
            prefixIcon: Icon(Icons.business),
            hintText: MerchantRegisterConstants.businessNameHint,
          ),
          validator: MerchantRegisterService.validateBusinessName,
        ),

        const SizedBox(height: AppDimensions.spacingL),

        // Téléphone
        TextFormField(
          controller: widget.phoneController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: MerchantRegisterConstants.phoneLabel,
            prefixIcon: Icon(Icons.phone),
            hintText: MerchantRegisterConstants.phoneHint,
          ),
          validator: MerchantRegisterService.validatePhone,
        ),

        const SizedBox(height: AppDimensions.spacingL),

        // Email professionnel
        TextFormField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: const InputDecoration(
            labelText: MerchantRegisterConstants.emailLabel,
            prefixIcon: Icon(Icons.email_outlined),
            hintText: MerchantRegisterConstants.emailHint,
          ),
          validator: MerchantRegisterService.validateEmail,
        ),

        const SizedBox(height: AppDimensions.spacingL),

        // Mot de passe
        TextFormField(
          controller: widget.passwordController,
          obscureText: widget.obscurePassword,
          decoration: InputDecoration(
            labelText: MerchantRegisterConstants.passwordLabel,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(widget.obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: widget.onTogglePasswordVisibility,
            ),
            hintText: MerchantRegisterConstants.passwordHint,
          ),
          validator: MerchantRegisterService.validatePassword,
        ),

        const SizedBox(height: AppDimensions.spacingL),

        // Confirmation mot de passe
        TextFormField(
          controller: widget.confirmPasswordController,
          obscureText: widget.obscureConfirmPassword,
          decoration: InputDecoration(
            labelText: MerchantRegisterConstants.confirmPasswordLabel,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(widget.obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
              onPressed: widget.onToggleConfirmPasswordVisibility,
            ),
            hintText: MerchantRegisterConstants.confirmPasswordHint,
          ),
          validator: (String? value) => MerchantRegisterService.validateConfirmPassword(
            value,
            widget.passwordController.text,
          ),
        ),
      ],
    );
  }
}
