import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/domain/entities/user.dart';
import 'package:foodsave_app/presentation/pages/auth/register/constants/register_constants.dart';
import 'package:foodsave_app/presentation/pages/auth/register/services/register_service.dart';
import 'package:foodsave_app/presentation/pages/auth/register/widgets/widgets.dart';

/// Page d'inscription pour l'application FoodSave
/// 
/// Permet aux utilisateurs de créer un compte avec Supabase
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;
  UserType _selectedUserType = UserType.consumer;
  
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
      appBar: AppBar(
        title: Text(RegisterConstants.pageTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const RegisterHeader(),
                const SizedBox(height: AppDimensions.spacingXL),

                UserTypeSelector(
                  selectedUserType: _selectedUserType,
                  onUserTypeChanged: _onUserTypeChanged,
                ),

                const SizedBox(height: AppDimensions.spacingL),

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

                LoginLink(
                  onPressed: () => Navigator.of(context).pop(),
                ),

                const SizedBox(height: AppDimensions.spacingXL),

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

  /// Gère le changement de type d'utilisateur.
  void _onUserTypeChanged(UserType? value) {
    if (value != null) {
      setState(() {
        _selectedUserType = value;
      });
    }
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
      final result = await RegisterService.registerUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        userType: _selectedUserType,
      );

      result.fold(
        (error) {
          // Erreur lors de l'inscription
          setState(() {
            _errorMessage = RegisterService.getLocalizedErrorMessage(error);
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
              _errorMessage = RegisterConstants.accountCreationError;
            });
          }
        },
      );
    } catch (error) {
      setState(() {
        _errorMessage = RegisterConstants.unexpectedError;
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
          title: Text(RegisterConstants.successDialogTitle),
          content: Text(RegisterConstants.successDialogContent),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialog
                Navigator.of(context).pop(); // Retourner à la page de connexion
              },
              child: Text(RegisterConstants.successDialogButton),
            ),
          ],
        );
      },
    );
  }
}
