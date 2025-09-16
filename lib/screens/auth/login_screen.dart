import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../utils/validators.dart';
import '../../utils/responsive_utils.dart';
import '../../utils/animation_utils.dart';
import '../../services/security_service.dart';
import '../../providers/supabase_providers.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';
import '../../widgets/notification_bell.dart';
import '../common/custom_button.dart';
import '../common/loading_widget.dart';

/// Écran de connexion pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
class LoginScreen extends ConsumerStatefulWidget {
  /// Constructeur de l'écran de connexion
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Gère la connexion de l'utilisateur
  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Utiliser notre AuthProvider
      final auth = ref.read(authProvider.notifier);
      final success = await auth.signInWithEmail(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success) {
        // Afficher une notification de succès
        if (mounted) {
          context.showSuccessNotification('Connexion réussie !');
        }
        
        // La redirection est gérée automatiquement par le routeur
        // selon le type d'utilisateur et les protections de route
      } else {
        setState(() {
          _errorMessage = ref.read(authProvider).errorMessage ?? 'Email ou mot de passe incorrect';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de connexion. Veuillez réessayer.';
      });
      if (mounted) {
        context.showErrorNotification('Erreur de connexion');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Navigue vers l'écran d'inscription
  void _navigateToSignUp() {
    context.push('/auth/signup');
  }

  /// Navigue vers la réinitialisation du mot de passe
  void _navigateToForgotPassword() {
    // TODO: Implémenter la navigation vers forgot password
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité à venir'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Logo et titre
                _buildHeader(),
                
                const SizedBox(height: 48),
                
                // Formulaire de connexion
                _buildLoginForm(),
                
                const SizedBox(height: 24),
                
                // Message d'erreur
                if (_errorMessage != null) _buildErrorMessage(),
                
                const SizedBox(height: 24),
                
                // Bouton de connexion
                _buildSignInButton(),
                
                const SizedBox(height: 16),
                
                // Mot de passe oublié
                _buildForgotPasswordButton(),
                
                const SizedBox(height: 32),
                
                // Divider
                _buildDivider(),
                
                const SizedBox(height: 32),
                
                // Lien vers inscription
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construit l'en-tête avec logo et titre
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.restaurant,
            size: 40,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Titre
        Text(
          'Bon retour !',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Sous-titre
        Text(
          'Connectez-vous pour continuer votre aventure anti-gaspillage',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Construit le formulaire de connexion
  Widget _buildLoginForm() {
    return Column(
      children: [
        // Champ email
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'votre@email.com',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: Validators.email,
        ),
        
        const SizedBox(height: 16),
        
        // Champ mot de passe
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _handleSignIn(),
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            hintText: 'Votre mot de passe',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: Validators.password,
        ),
      ],
    );
  }

  /// Construit le message d'erreur
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
          Icon(
            Icons.error_outline,
            color: Colors.red[600],
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
  Widget _buildSignInButton() {
    if (_isLoading) {
      return const LoadingWidget();
    }

    return CustomButton(
      text: 'Se connecter',
      onPressed: _handleSignIn,
      icon: Icons.login,
    );
  }

  /// Construit le bouton "Mot de passe oublié"
  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: _navigateToForgotPassword,
      child: Text(
        'Mot de passe oublié ?',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Construit le séparateur
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OU',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  /// Construit le lien vers l'inscription
  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Pas encore inscrit ? ',
          style: TextStyle(color: Colors.grey[600]),
        ),
        GestureDetector(
          onTap: _navigateToSignUp,
          child: Text(
            'Créer un compte',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}