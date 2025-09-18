import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/presentation/pages/auth/consumer_register/constants/consumer_register_constants.dart';
import 'package:foodsave_app/presentation/pages/auth/consumer_register/services/consumer_register_service.dart';
import 'package:foodsave_app/presentation/pages/auth/consumer_register/widgets/widgets.dart';

/// Page d'inscription dédiée aux consommateurs de l'application FoodSave.
/// 
/// Cette page est spécialement conçue pour les consommateurs avec un contenu
/// et des visuels adaptés à leur besoin de trouver des paniers anti-gaspi.
class ConsumerRegisterPage extends StatefulWidget {
  /// Crée une nouvelle instance de [ConsumerRegisterPage].
  const ConsumerRegisterPage({super.key});

  @override
  State<ConsumerRegisterPage> createState() => _ConsumerRegisterPageState();
}

class _ConsumerRegisterPageState extends State<ConsumerRegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
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
                const ConsumerHeader(),
                const SizedBox(height: AppDimensions.spacingXL),
                if (_errorMessage != null) ErrorMessage(errorMessage: _errorMessage!),
                RegistrationForm(
                  nameController: _nameController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  obscurePassword: _obscurePassword,
                  obscureConfirmPassword: _obscureConfirmPassword,
                  onTogglePasswordVisibility: _togglePasswordVisibility,
                  onToggleConfirmPasswordVisibility: _toggleConfirmPasswordVisibility,
                ),
                const SizedBox(height: AppDimensions.spacingXL),
                RegisterButton(
                  isLoading: _isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: AppDimensions.spacingL),
                const TermsAndConditions(),
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
      final result = await ConsumerRegisterService.registerConsumer(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      result.fold(
        (error) {
          // Erreur lors de l'inscription
          setState(() {
            _errorMessage = ConsumerRegisterService.getLocalizedErrorMessage(error);
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
              _errorMessage = ConsumerRegisterConstants.accountCreationError;
            });
          }
        },
      );
    } catch (error) {
      setState(() {
        _errorMessage = ConsumerRegisterConstants.unexpectedError;
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
            Icons.check_circle,
            color: AppColors.success,
            size: 60,
          ),
          title: Text(ConsumerRegisterConstants.successDialogTitle),
          content: Text(ConsumerRegisterConstants.successDialogContent),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialog
                Navigator.of(context).pop(); // Retourner à la sélection
                Navigator.of(context).pop(); // Retourner à la page de connexion
              },
              child: Text(ConsumerRegisterConstants.connectButtonText),
            ),
          ],
        );
      },
    );
  }
}