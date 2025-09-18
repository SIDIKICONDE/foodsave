import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:foodsave_app/presentation/bloc/auth/auth_event.dart';
import 'package:foodsave_app/presentation/bloc/auth/auth_state.dart';
import 'package:foodsave_app/presentation/pages/onboarding/onboarding_page.dart';
import 'package:foodsave_app/presentation/pages/home/main_page.dart';
import 'package:foodsave_app/presentation/pages/auth/user_type_selection_page.dart';
import 'package:foodsave_app/presentation/pages/auth/reset_password_page.dart';
import 'package:foodsave_app/presentation/pages/auth/login/constants/login_constants.dart';
import 'package:foodsave_app/presentation/pages/auth/login/services/login_service.dart';
import 'package:foodsave_app/presentation/pages/auth/login/widgets/widgets.dart';

/// Page de connexion de l'application FoodSave.
/// 
/// Permet à l'utilisateur de se connecter ou de continuer en mode invité.
class LoginPage extends StatelessWidget {
  /// Crée une nouvelle instance de [LoginPage].
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc()..add(const AuthStatusChecked()),
      child: const LoginView(),
    );
  }
}

/// Vue interne de la page de connexion.
class LoginView extends StatefulWidget {
  /// Crée une nouvelle instance de [LoginView].
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.failure.message),
                backgroundColor: AppColors.error,
                duration: Duration(milliseconds: LoginConstants.snackbarDurationMs),
              ),
            );
          } else if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${LoginConstants.welcomeMessage}${state.user.name} !'),
                backgroundColor: AppColors.success,
                duration: Duration(milliseconds: LoginConstants.snackbarDurationMs),
              ),
            );
            // Navigation vers la page principale
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MainPage(),
              ),
            );
          } else if (state is AuthGuest) {
            // Navigation directe vers la page principale en mode invité
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MainPage(),
              ),
            );
          } else if (state is AuthSignupRequired) {
            // Navigation vers l'onboarding pour les nouveaux utilisateurs
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const OnboardingPage(),
              ),
            );
          }
        },
        builder: (context, state) {
          // Affichage du loading pendant l'initialisation
          if (state is AuthInitial) {
            return Scaffold(
              body: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                    SizedBox(height: AppDimensions.spacingL),
                    Text(
                      LoginConstants.initializationText,
                      style: AppTextStyles.bodyLarge,
                    ),
                  ],
                ),
              ),
            );
          }
          
          // Interface de connexion pour les autres états
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXL),
              child: Form(
                key: _formKey,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const LoginHeader(),
                        const SizedBox(height: AppDimensions.spacingGiant),
                        LoginFormFields(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          obscurePassword: _obscurePassword,
                          onTogglePasswordVisibility: _togglePasswordVisibility,
                        ),
                        const SizedBox(height: AppDimensions.spacingM),
                        ForgotPasswordLink(
                          onPressed: () => _navigateToResetPassword(context),
                        ),
                        const SizedBox(height: AppDimensions.spacingXxl),
                        LoginButtons(
                          isLoading: state is AuthLoading,
                          onLoginPressed: () => _handleLogin(context),
                          onGuestModePressed: () => _handleGuestMode(context),
                        ),
                        const SizedBox(height: AppDimensions.spacingXxl),
                        SignupLink(
                          onPressed: () => _navigateToSignup(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  /// Bascule la visibilité du mot de passe.
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  /// Navigue vers la page de réinitialisation de mot de passe.
  void _navigateToResetPassword(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const ResetPasswordPage(),
      ),
    );
  }

  /// Navigue vers la page d'inscription.
  void _navigateToSignup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => const UserTypeSelectionPage(),
      ),
    );
  }

  /// Gère la connexion de l'utilisateur.
  void _handleLogin(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final String email = LoginService.prepareEmail(_emailController.text);
      final String password = LoginService.preparePassword(_passwordController.text);

      context.read<AuthBloc>().add(
        LoginRequested(
          email: email,
          password: password,
        ),
      );
    }
  }

  /// Gère le mode invité.
  void _handleGuestMode(BuildContext context) {
    context.read<AuthBloc>().add(const GuestModeRequested());
  }
}