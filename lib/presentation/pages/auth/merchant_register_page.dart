import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/presentation/pages/auth/merchant_register/constants/merchant_register_constants.dart';
import 'package:foodsave_app/presentation/pages/auth/merchant_register/services/merchant_register_service.dart';
import 'package:foodsave_app/presentation/pages/auth/merchant_register/widgets/widgets.dart';

/// Page d'inscription dédiée aux commerçants de l'application FoodSave.
/// 
/// Cette page est spécialement conçue pour les commerçants avec un contenu
/// et des visuels adaptés à leur besoin de vendre leurs invendus.
class MerchantRegisterPage extends StatefulWidget {
  /// Crée une nouvelle instance de [MerchantRegisterPage].
  const MerchantRegisterPage({super.key});

  @override
  State<MerchantRegisterPage> createState() => _MerchantRegisterPageState();
}

class _MerchantRegisterPageState extends State<MerchantRegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _managerNameController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _managerNameController.dispose();
    _businessNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Form(
            key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const BackButtonWidget(),
                      const SizedBox(height: AppDimensions.spacingM),
                      const MerchantHeader(),
                      const SizedBox(height: AppDimensions.spacingXL),
                      if (_errorMessage != null) ErrorMessage(errorMessage: _errorMessage!),
                      MerchantRegistrationForm(
                        managerNameController: _managerNameController,
                        businessNameController: _businessNameController,
                        phoneController: _phoneController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        obscurePassword: _obscurePassword,
                        obscureConfirmPassword: _obscureConfirmPassword,
                        onTogglePasswordVisibility: _togglePasswordVisibility,
                        onToggleConfirmPasswordVisibility: _toggleConfirmPasswordVisibility,
                      ),
                      const SizedBox(height: AppDimensions.spacingXL),
                      MerchantRegisterButton(
                        isLoading: _isLoading,
                        onPressed: _handleRegister,
                      ),
                      const SizedBox(height: AppDimensions.spacingL),
                      const MerchantTermsAndConditions(),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Bascule la visibilité du mot de passe.
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  /// Bascule la visibilité de la confirmation du mot de passe.
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  /// Gère le processus d'inscription.
  Future<void> _handleRegister() async {
    // Cacher le clavier
    FocusScope.of(context).unfocus();

    // Valider le formulaire
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Utiliser le service pour l'inscription
      final result = await MerchantRegisterService.registerMerchant(
        managerName: _managerNameController.text.trim(),
        businessName: _businessNameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      result.fold(
        (error) {
          // Erreur lors de l'inscription
          setState(() {
            _errorMessage = MerchantRegisterService.getLocalizedErrorMessage(error);
            _isLoading = false;
          });
        },
        (response) {
          // Inscription réussie
          setState(() {
            _isLoading = false;
          });

          if (response.user?.id != null) {
            // L'utilisateur est créé
            _showSuccessDialog();
          } else {
            setState(() {
              _errorMessage = MerchantRegisterConstants.accountCreationError;
            });
          }
        },
      );
    } catch (error) {
      setState(() {
        _errorMessage = MerchantRegisterConstants.unexpectedError;
        _isLoading = false;
      });
    }
  }


  /// Affiche le dialogue de succès.
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          icon: const Icon(
            Icons.pending,
            color: AppColors.warning,
            size: 60,
          ),
          title: Text(MerchantRegisterConstants.successDialogTitle),
          content: Text(MerchantRegisterConstants.successDialogContent),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialog
                Navigator.of(context).pop(); // Retourner à la sélection
                Navigator.of(context).pop(); // Retourner à la page de connexion
              },
              child: Text(MerchantRegisterConstants.understandButtonText),
            ),
          ],
        );
      },
    );
  }
}