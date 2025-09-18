import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/presentation/pages/auth/login_page.dart';
import 'package:foodsave_app/presentation/pages/auth/email_verification/constants/email_verification_constants.dart';
import 'package:foodsave_app/presentation/pages/auth/email_verification/services/email_verification_service.dart';
import 'package:foodsave_app/presentation/pages/auth/email_verification/widgets/widgets.dart';

/// Page de vérification d'email pour l'application FoodSave.
///
/// Cette page informe l'utilisateur qu'il doit vérifier son email
/// et permet de renvoyer l'email de vérification.
/// Suit les directives strictes Dart pour la sécurité et la maintenabilité.
class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({
    super.key,
    required this.email,
    this.showBackButton = true,
  });

  /// L'adresse email à vérifier.
  final String email;

  /// Indique si le bouton de retour doit être affiché.
  final bool showBackButton;

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage>
    with TickerProviderStateMixin {
  // États de l'interface utilisateur
  bool _isResending = false;
  bool _isCheckingStatus = false;
  String? _errorMessage;
  String? _successMessage;

  // Animation pour l'icône email
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;

  // Compte à rebours pour le renvoi
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startPeriodicStatusCheck();
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  /// Configure les animations.
  void _setupAnimations() {
    _iconAnimationController = AnimationController(
      duration: EmailVerificationConstants.animationDuration,
      vsync: this,
    );

    _iconAnimation = Tween<double>(
      begin: EmailVerificationConstants.iconScaleBegin,
      end: EmailVerificationConstants.iconScaleEnd,
    ).animate(CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeInOut,
    ));

    // Animation en boucle
    _iconAnimationController.repeat(reverse: true);
  }

  /// Démarre la vérification périodique du statut de l'email.
  void _startPeriodicStatusCheck() {
    // Note: En production, vous pourriez vouloir implémenter
    // une vérification périodique du statut d'authentification
    _checkEmailVerificationStatus();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: widget.showBackButton ? AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: AppDimensions.iconM,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ) : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.getResponsiveSpacing(screenWidth),
            vertical: AppDimensions.spacingL,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight - (widget.showBackButton ? 
                AppDimensions.appBarHeight + AppDimensions.spacingXXL : 
                AppDimensions.spacingXXL),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VerificationHeader(
                  email: widget.email,
                  animationController: _iconAnimationController,
                  iconAnimation: _iconAnimation,
                ),
                SizedBox(height: AppDimensions.spacingGiant),
                _buildVerificationCard(screenWidth),
                SizedBox(height: AppDimensions.spacingXL),
                ActionButtons(
                  isCheckingStatus: _isCheckingStatus,
                  onCheckStatusPressed: _checkEmailVerificationStatus,
                  onBackToLoginPressed: _navigateToLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  /// Construit la carte de vérification principale.
  Widget _buildVerificationCard(double screenWidth) {
    return Container(
      constraints: const BoxConstraints(maxWidth: AppDimensions.cardMaxWidth),
      padding: EdgeInsets.all(AppDimensions.spacingXL),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: AppDimensions.shadowBlurLight,
            offset: const Offset(0, AppDimensions.shadowOffsetY),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          const InstructionsSection(),
          if (_errorMessage != null) ...<Widget>[
            SizedBox(height: AppDimensions.spacingL),
            ErrorMessageWidget(errorMessage: _errorMessage!),
          ],
          if (_successMessage != null) ...<Widget>[
            SizedBox(height: AppDimensions.spacingL),
            SuccessMessageWidget(successMessage: _successMessage!),
          ],
          SizedBox(height: AppDimensions.spacingXL),
          ResendSection(
            isResending: _isResending,
            resendCountdown: _resendCountdown,
            onResendPressed: _resendVerificationEmail,
          ),
          SizedBox(height: AppDimensions.spacingL),
          CheckStatusButton(
            isCheckingStatus: _isCheckingStatus,
            onCheckStatusPressed: _checkEmailVerificationStatus,
          )
        ],
      ),
    );
  }


  /// Gère le renvoi de l'email de vérification.
  Future<void> _resendVerificationEmail() async {
    if (_isResending) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final result = await EmailVerificationService.resendVerificationEmail(widget.email);

      if (!mounted) return;

      result.fold(
        (String error) {
          setState(() {
            _errorMessage = error;
          });
        },
        (_) {
          setState(() {
            _successMessage = EmailVerificationConstants.emailResentSuccess;
            _resendCountdown = EmailVerificationConstants.resendDelaySeconds;
          });

          // Démarre le compte à rebours
          _startResendCountdown();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(EmailVerificationConstants.emailResentSnackBar),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 3),
            ),
          );
        },
      );
    } catch (error) {
      setState(() {
        _errorMessage = EmailVerificationConstants.resendError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  /// Démarre le compte à rebours pour le renvoi.
  void _startResendCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
        _startResendCountdown();
      }
    });
  }

  /// Navigue vers la page de connexion.
  void _navigateToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  /// Vérifie le statut de vérification de l'email.
  Future<void> _checkEmailVerificationStatus() async {
    if (_isCheckingStatus) return;

    setState(() {
      _isCheckingStatus = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final result = await EmailVerificationService.checkEmailVerificationStatus();

      if (!mounted) return;

      result.fold(
        (String error) {
          setState(() {
            _errorMessage = error;
          });
        },
        (bool isVerified) {
          if (isVerified) {
            // Email vérifié avec succès
            setState(() {
              _successMessage = EmailVerificationConstants.emailVerifiedSuccess;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(EmailVerificationConstants.emailVerifiedSnackBar),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 3),
              ),
            );

            // Redirection vers la page principale après un court délai
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                // TODO: Naviguer vers la page d'accueil de l'application
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              }
            });
          } else {
            setState(() {
              _errorMessage = EmailVerificationConstants.emailNotVerifiedError;
            });
          }
        },
      );
    } catch (error) {
      setState(() {
        _errorMessage = EmailVerificationConstants.checkError;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingStatus = false;
        });
      }
    }
  }

}