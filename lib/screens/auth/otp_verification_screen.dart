import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/responsive_utils.dart';
import '../common/custom_button.dart';
import '../common/loading_widget.dart';

/// Écran de vérification OTP pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
class OTPVerificationScreen extends ConsumerStatefulWidget {
  /// Email pour lequel vérifier l'OTP
  final String email;
  
  /// Type de vérification (signup, reset_password, etc.)
  final String type;

  const OTPVerificationScreen({
    super.key,
    required this.email,
    this.type = 'signup',
  });

  @override
  ConsumerState<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen>
    with TickerProviderStateMixin {
  
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isLoading = false;
  String? _errorMessage;
  int _timeLeft = 60;
  bool _canResend = false;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
    _startTimer();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
  
  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
        _startTimer();
      } else if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }
  
  String get _otp => _controllers.map((c) => c.text).join();
  
  bool get _isOtpComplete => _otp.length == 6;
  
  Future<void> _verifyOTP() async {
    if (!_isOtpComplete) {
      setState(() {
        _errorMessage = 'Veuillez saisir le code complet';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // TODO: Implémenter la vérification OTP avec Supabase
      // Simulation pour la démo
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulation de succès
      final success = _otp == '123456'; // Code de test
      
      if (success && mounted) {
        // Succès de la vérification
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vérification réussie ! Bienvenue sur FoodSave 🎉'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        
        // Redirection selon le type
        if (widget.type == 'signup') {
          context.go('/student/feed'); // Ou selon le type d'utilisateur
        } else if (widget.type == 'recovery') {
          context.go('/auth/reset-password');
        }
      } else {
        setState(() {
          _errorMessage = 'Code de vérification invalide. Utilisez 123456 pour tester.';
          // Effacer les champs en cas d'erreur
          for (var controller in _controllers) {
            controller.clear();
          }
          _focusNodes[0].requestFocus();
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de connexion. Veuillez réessayer.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  Future<void> _resendOTP() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _timeLeft = 60;
      _canResend = false;
    });
    
    try {
      // TODO: Implémenter le renvoi d'OTP avec Supabase
      // Simulation pour la démo
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nouveau code envoyé ! 📧 (Utilisez 123456)'),
            backgroundColor: Colors.blue,
          ),
        );
        _startTimer();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur lors du renvoi du code';
        _canResend = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    setState(() {
      _errorMessage = null;
    });
    
    // Auto-vérification quand le code est complet
    if (_isOtpComplete) {
      _verifyOTP();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.getAdaptivePadding(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const LoadingWidget(message: 'Vérification en cours...')
          : SafeArea(
              child: SingleChildScrollView(
                padding: padding,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        
                        // Header
                        _buildHeader(),
                        
                        const SizedBox(height: 40),
                        
                        // Champs OTP
                        _buildOTPFields(),
                        
                        const SizedBox(height: 24),
                        
                        // Message d'erreur
                        if (_errorMessage != null) _buildErrorMessage(),
                        
                        const SizedBox(height: 32),
                        
                        // Bouton de vérification
                        _buildVerifyButton(),
                        
                        const SizedBox(height: 24),
                        
                        // Lien de renvoi
                        _buildResendSection(),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
  
  Widget _buildHeader() {
    return Column(
      children: [
        // Icône
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.security,
            size: 50,
            color: Theme.of(context).primaryColor,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Titre
        Text(
          'Vérification',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 12),
        
        // Description
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              height: 1.5,
            ),
            children: [
              const TextSpan(
                text: 'Un code de vérification a été envoyé à\n',
              ),
              TextSpan(
                text: widget.email,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildOTPFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) => _buildOTPField(index)),
    );
  }
  
  Widget _buildOTPField(int index) {
    return SizedBox(
      width: 45,
      height: 55,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) => _onChanged(value, index),
        onTap: () {
          _controllers[index].selection = TextSelection.fromPosition(
            TextPosition(offset: _controllers[index].text.length),
          );
        },
      ),
    );
  }
  
  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVerifyButton() {
    return CustomButton(
      text: 'Vérifier',
      onPressed: _isOtpComplete ? _verifyOTP : null,
      icon: Icons.verified_user,
    );
  }
  
  Widget _buildResendSection() {
    return Column(
      children: [
        if (!_canResend) ...[
          Text(
            'Renvoyer le code dans ${_timeLeft}s',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Vous n\'avez pas reçu le code ? ',
                style: TextStyle(color: Colors.grey[600]),
              ),
              GestureDetector(
                onTap: _resendOTP,
                child: Text(
                  'Renvoyer',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
        
        const SizedBox(height: 16),
        
        // Aide
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Aide'),
                content: const Text(
                  'Si vous ne recevez pas le code :\n\n'
                  '• Vérifiez vos spams/indésirables\n'
                  '• Attendez quelques minutes\n'
                  '• Vérifiez que l\'adresse email est correcte\n'
                  '• Contactez le support si le problème persiste',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          child: Text(
            'Besoin d\'aide ?',
            style: TextStyle(
              color: Colors.grey[600],
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}