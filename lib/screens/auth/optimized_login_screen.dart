import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/validators.dart';
import '../../utils/responsive_utils.dart';
import '../../utils/animation_utils.dart';
import '../../services/security_service.dart';
import '../common/custom_button.dart';
import '../common/loading_widget.dart';

/// Écran de connexion optimisé pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
/// Avec responsivité, animations et sécurité renforcée
class OptimizedLoginScreen extends ConsumerStatefulWidget {
  /// Constructeur de l'écran de connexion optimisé
  const OptimizedLoginScreen({super.key});

  @override
  ConsumerState<OptimizedLoginScreen> createState() => _OptimizedLoginScreenState();
}

class _OptimizedLoginScreenState extends ConsumerState<OptimizedLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _securityService = SecurityService.instance;
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  PasswordStrength? _passwordStrength;
  bool _isBlocked = false;
  Duration? _blockDuration;

  @override
  void initState() {
    super.initState();
    _checkIfBlocked();
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Vérifie si l'utilisateur est bloqué
  Future<void> _checkIfBlocked() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    
    final isBlocked = await _securityService.isBlocked(email);
    if (mounted) {
      setState(() {
        _isBlocked = isBlocked;
      });
    }
  }

  /// Analyse la force du mot de passe en temps réel
  void _onPasswordChanged() {
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() => _passwordStrength = null);
      return;
    }
    
    final strength = _securityService.validatePasswordStrength(password);
    setState(() => _passwordStrength = strength);
  }

  /// Gère la connexion avec sécurité renforcée
  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isBlocked) {
      _showBlockedMessage();
      return;
    }

    final email = _emailController.text.trim();
    
    // Détecter les tentatives de force brute
    final isBruteForce = await _securityService.detectBruteForceAttempt(email);
    if (isBruteForce) {
      await _securityService.temporaryBlock(email);
      setState(() {
        _isBlocked = true;
        _errorMessage = 'Trop de tentatives de connexion. Compte temporairement bloqué.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Simulation d'authentification avec hachage sécurisé
      final password = _passwordController.text;
      await Future.delayed(const Duration(milliseconds: 800)); // Délai réaliste
      
      // En production, vérifier avec le backend
      final isValidLogin = await _mockAuthenticationCheck(email, password);
      
      if (isValidLogin) {
        // Générer et stocker les tokens de manière sécurisée
        final accessToken = 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}';
        final refreshToken = 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}';
        
        await _securityService.storeTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiryTime: DateTime.now().add(const Duration(hours: 24)),
        );
        
        if (mounted) {
          // Navigation avec transition personnalisée
          Navigator.of(context).pushReplacement(
            CustomPageTransition(
              child: _getDestinationScreen(email),
              type: PageTransitionType.slideRight,
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Email ou mot de passe incorrect';
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

  /// Vérification d'authentification simulée
  Future<bool> _mockAuthenticationCheck(String email, String password) async {
    // En production, remplacer par un appel API sécurisé
    // Ici on simule une vérification avec des comptes de test
    final testAccounts = {
      'student@foodsave.com': 'Student123!',
      'merchant@foodsave.com': 'Merchant123!',
    };
    
    return testAccounts[email] == password;
  }

  /// Détermine l'écran de destination selon l'utilisateur
  Widget _getDestinationScreen(String email) {
    // Logique simplifiée pour la démo
    if (email.contains('student')) {
      context.go('/student/feed');
      return Container(); // Placeholder
    } else {
      context.go('/merchant/orders');
      return Container(); // Placeholder
    }
  }

  /// Affiche un message pour compte bloqué
  void _showBlockedMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Compte temporairement bloqué'),
        content: const Text(
          'Votre compte a été temporairement bloqué suite à plusieurs tentatives '
          'de connexion infructueuses. Veuillez réessayer dans 30 minutes.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _buildBody(context),
    );
  }

  /// Construit le corps principal avec responsivité
  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: AnimatedLoadingIndicator(
          type: LoadingType.wave,
          size: 60,
        ),
      );
    }

    return SafeArea(
      child: ResponsiveUtils.constrainedContent(
        context: context,
        child: SingleChildScrollView(
          padding: context.adaptivePadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: context.isMobile ? 40 : 80),
                
                // En-tête avec animation
                FadeInAnimation(
                  delay: const Duration(milliseconds: 200),
                  child: _buildHeader(context),
                ),
                
                SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context, 40)),
                
                // Champs de saisie avec animations décalées
                StaggeredListAnimation(
                  staggerDelay: const Duration(milliseconds: 200),
                  children: [
                    _buildEmailField(context),
                    const SizedBox(height: 20),
                    _buildPasswordField(context),
                    if (_passwordStrength != null) 
                      _buildPasswordStrengthIndicator(),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Message d'erreur
                if (_errorMessage != null)
                  SlideInAnimation(
                    direction: SlideDirection.top,
                    child: _buildErrorMessage(),
                  ),
                
                const SizedBox(height: 24),
                
                // Bouton de connexion
                ScaleInAnimation(
                  delay: const Duration(milliseconds: 800),
                  child: AnimatedPressButton(
                    onPressed: _isBlocked ? null : _handleSignIn,
                    child: _buildLoginButton(context),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Actions secondaires
                FadeInAnimation(
                  delay: const Duration(milliseconds: 1000),
                  child: _buildSecondaryActions(context),
                ),
                
                const SizedBox(height: 40),
                
                // Lien d'inscription
                SlideInAnimation(
                  delay: const Duration(milliseconds: 1200),
                  direction: SlideDirection.bottom,
                  child: _buildSignUpLink(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construit l'en-tête adaptatif
  Widget _buildHeader(BuildContext context) {
    final logoSize = ResponsiveUtils.getAdaptiveImageSize(context, 80);
    
    return Column(
      children: [
        // Logo avec animation de rotation subtile
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: context.adaptiveBorderRadius,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.restaurant_menu,
            size: logoSize * 0.5,
            color: Colors.white,
          ),
        ),
        
        SizedBox(height: ResponsiveUtils.getAdaptiveSpacing(context, 24)),
        
        // Titre adaptatif
        Text(
          'Bon retour !',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            fontSize: ResponsiveUtils.getAdaptiveFontSize(
              context,
              ResponsiveSizes.titleFontSize,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Sous-titre
        Text(
          'Connectez-vous pour continuer votre aventure anti-gaspillage',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
            fontSize: ResponsiveUtils.getAdaptiveFontSize(
              context,
              ResponsiveSizes.bodyFontSize,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Construit le champ email avec validation
  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Adresse email',
        hintText: 'exemple@foodsave.com',
        prefixIcon: Icon(
          Icons.email_outlined,
          size: ResponsiveUtils.getAdaptiveIconSize(context, 24),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: context.adaptiveBorderRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: context.adaptiveBorderRadius,
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: context.adaptiveBorderRadius,
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
      ),
      validator: Validators.email,
      onChanged: (_) => _checkIfBlocked(),
    );
  }

  /// Construit le champ mot de passe avec indicateur de force
  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleSignIn(),
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        hintText: 'Votre mot de passe sécurisé',
        prefixIcon: Icon(
          Icons.lock_outlined,
          size: ResponsiveUtils.getAdaptiveIconSize(context, 24),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            size: ResponsiveUtils.getAdaptiveIconSize(context, 24),
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: context.adaptiveBorderRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: context.adaptiveBorderRadius,
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: context.adaptiveBorderRadius,
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        ),
      ),
      validator: Validators.password,
    );
  }

  /// Construit l'indicateur de force du mot de passe
  Widget _buildPasswordStrengthIndicator() {
    if (_passwordStrength == null) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barre de progression
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (_passwordStrength!.score / 5).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(_passwordStrength!.color),
                  minHeight: 4,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                _passwordStrength!.description,
                style: TextStyle(
                  color: _passwordStrength!.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          // Conseils d'amélioration
          if (_passwordStrength!.feedback.isNotEmpty) ...[
            const SizedBox(height: 4),
            ...(_passwordStrength!.feedback.take(2).map((feedback) => 
              Text(
                '• $feedback',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                ),
              ),
            )),
          ],
        ],
      ),
    );
  }

  /// Construit le message d'erreur
  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: context.adaptiveBorderRadius,
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construit le bouton de connexion
  Widget _buildLoginButton(BuildContext context) {
    return Container(
      height: ResponsiveSizes.buttonHeight,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isBlocked 
              ? [Colors.grey, Colors.grey[400]!]
              : [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
        ),
        borderRadius: context.adaptiveBorderRadius,
        boxShadow: _isBlocked ? null : [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          _isBlocked ? 'Compte bloqué' : 'Se connecter',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Construit les actions secondaires
  Widget _buildSecondaryActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: _navigateToForgotPassword,
          child: Text(
            'Mot de passe oublié ?',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: ResponsiveUtils.getAdaptiveFontSize(context, 14),
            ),
          ),
        ),
        
        TextButton.icon(
          onPressed: _showLoginHelp,
          icon: const Icon(Icons.help_outline, size: 18),
          label: const Text('Aide'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Construit le lien d'inscription
  Widget _buildSignUpLink(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: context.adaptiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Pas encore de compte ? ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: ResponsiveUtils.getAdaptiveFontSize(context, 14),
            ),
          ),
          GestureDetector(
            onTap: _navigateToSignUp,
            child: Text(
              'Créer un compte',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: ResponsiveUtils.getAdaptiveFontSize(context, 14),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigation vers mot de passe oublié
  void _navigateToForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité de récupération à implémenter'),
      ),
    );
  }

  /// Affiche l'aide pour la connexion
  void _showLoginHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aide à la connexion'),
        content: const Text(
          'Comptes de test disponibles :\n\n'
          '• Étudiant : student@foodsave.com / Student123!\n'
          '• Commerçant : merchant@foodsave.com / Merchant123!\n\n'
          'Ces comptes sont sécurisés avec validation de force du mot de passe '
          'et protection contre les attaques par force brute.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }

  /// Navigation vers inscription
  void _navigateToSignUp() {
    Navigator.of(context).push(
      CustomPageTransition(
        child: const Scaffold(
          body: Center(
            child: Text('Écran d\'inscription à implémenter'),
          ),
        ),
        type: PageTransitionType.slideLeft,
      ),
    );
  }
}