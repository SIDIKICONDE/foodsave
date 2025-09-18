import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/presentation/pages/auth/reset_password/constants/reset_password_constants.dart';
import 'package:foodsave_app/presentation/pages/auth/reset_password/services/reset_password_service.dart';
import 'package:foodsave_app/presentation/pages/auth/reset_password/widgets/widgets.dart';

/// Page de réinitialisation de mot de passe pour l'application FoodSave.
///
/// Cette page permet aux utilisateurs de demander une réinitialisation
/// de leur mot de passe via email.
/// Suit les directives strictes Dart pour la sécurité et la maintenabilité.
class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  // Contrôleur pour le champ email
  final TextEditingController _emailController = TextEditingController();

  // Clé du formulaire pour la validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // États de l'interface utilisateur
  bool _isLoading = false;
  bool _emailSent = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    // Nettoyage du contrôleur selon les directives strictes
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            ResetPasswordConstants.arrowBackIcon,
            color: AppColors.textPrimary,
            size: AppDimensions.iconM,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.getResponsiveSpacing(screenWidth),
            vertical: AppDimensions.spacingL,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - AppDimensions.spacingXXL * 2,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ResetPasswordHeader(emailSent: _emailSent),
                const SizedBox(height: AppDimensions.spacingGiant),
                if (!_emailSent) ...<Widget>[
                  _buildResetForm(),
                  const SizedBox(height: AppDimensions.spacingXL),
                  ResetButton(
                    isLoading: _isLoading,
                    onPressed: _handleResetPassword,
                  ),
                ] else ...<Widget>[
                  SuccessState(
                    email: _emailController.text,
                    onResendEmail: _resendEmail,
                    isLoading: _isLoading,
                  ),
                ],
                const SizedBox(height: AppDimensions.spacingXL),
                const BackToLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construit le formulaire de réinitialisation.
  Widget _buildResetForm() {
    return Form(
      key: _formKey,
      child: ResetForm(
        emailController: _emailController,
        errorMessage: _errorMessage,
        successMessage: _successMessage,
      ),
    );
  }

  /// Gère le processus de réinitialisation de mot de passe.
  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      // Utiliser le service pour envoyer l'email de réinitialisation
      final result = await ResetPasswordService.sendResetPasswordEmail(
        email: _emailController.text.trim(),
      );

      result.fold(
        (error) {
          // Erreur lors de l'envoi
          setState(() {
            _errorMessage = error;
            _isLoading = false;
          });
        },
        (_) {
          // Succès
          if (!mounted) return;

          setState(() {
            _emailSent = true;
            _successMessage = ResetPasswordConstants.resetSuccessMessage;
            _isLoading = false;
          });

          // Affichage d'un message de succès temporaire
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ResetPasswordConstants.resetSuccessSnackBar),
              backgroundColor: AppColors.success,
              duration: ResetPasswordConstants.snackBarDuration,
            ),
          );
        },
      );
    } catch (error) {
      setState(() {
        _errorMessage = ResetPasswordService.isAuthException(error)
            ? ResetPasswordService.getLocalizedErrorMessage(
                ResetPasswordService.getAuthExceptionMessage(error as dynamic),
              )
            : ResetPasswordConstants.unexpectedError;
        _isLoading = false;
      });
    }
  }

  /// Gère le renvoi d'email.
  Future<void> _resendEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Utiliser le service pour renvoyer l'email
      final result = await ResetPasswordService.sendResetPasswordEmail(
        email: _emailController.text.trim(),
      );

      result.fold(
        (error) {
          // Erreur lors du renvoi
          setState(() {
            _errorMessage = error;
            _isLoading = false;
          });
        },
        (_) {
          // Succès
          if (!mounted) return;

          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ResetPasswordConstants.resendSuccessMessage),
              backgroundColor: AppColors.success,
              duration: ResetPasswordConstants.snackBarDuration,
            ),
          );
        },
      );
    } catch (error) {
      setState(() {
        _errorMessage = ResetPasswordService.isAuthException(error)
            ? ResetPasswordService.getLocalizedErrorMessage(
                ResetPasswordService.getAuthExceptionMessage(error as dynamic),
              )
            : ResetPasswordConstants.resendError;
        _isLoading = false;
      });
    }
  }
}