import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodsave_app/core/error/failures.dart';
import 'package:foodsave_app/domain/entities/user.dart';
import 'package:foodsave_app/presentation/bloc/auth/auth_event.dart';
import 'package:foodsave_app/presentation/bloc/auth/auth_state.dart';

/// BLoC gérant l'authentification des utilisateurs.
/// 
/// Cette classe gère tous les événements et états liés à l'authentification,
/// incluant la connexion, l'inscription, et le mode invité.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Crée une nouvelle instance d'[AuthBloc].
  AuthBloc() : super(const AuthInitial()) {
    on<AuthStatusChecked>(_onAuthStatusChecked);
    on<LoginRequested>(_onLoginRequested);
    on<SignupRequested>(_onSignupRequested);
    on<GuestModeRequested>(_onGuestModeRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  /// Vérifie l'état actuel de l'authentification.
  Future<void> _onAuthStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      // TODO: Implémenter la vérification du token stocké
      // Pour l'instant, on considère l'utilisateur comme non authentifié
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(failure: ServerFailure(message: 'Erreur lors de la vérification de l\'état d\'authentification')));
    }
  }

  /// Gère la demande de connexion.
  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      // Validation basique des champs
      if (event.email.isEmpty || event.password.isEmpty) {
        emit(const AuthError(failure: ValidationFailure(message: 'Veuillez remplir tous les champs')));
        return;
      }

      if (!_isValidEmail(event.email)) {
        emit(const AuthError(failure: ValidationFailure(message: 'Adresse email invalide')));
        return;
      }

      // Simulation d'une connexion
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implémenter l'authentification réelle
      // Pour l'instant, on simule une connexion réussie
      final User user = User(
        id: '1',
        name: 'Utilisateur Test',
        email: event.email,
        userType: UserType.consumer,
        createdAt: DateTime.now(),
        preferences: const UserPreferences(
          dietary: [],
          allergens: [],
          notifications: true,
        ),
      );

      emit(AuthAuthenticated(user: user));
    } catch (e) {
      emit(const AuthError(failure: ServerFailure(message: 'Erreur lors de la connexion')));
    }
  }

  /// Gère la demande d'inscription.
  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      // Validation des champs
      if (event.email.isEmpty || event.password.isEmpty || 
          event.confirmPassword.isEmpty || event.name.isEmpty) {
        emit(const AuthError(failure: ValidationFailure(message: 'Veuillez remplir tous les champs')));
        return;
      }

      if (!_isValidEmail(event.email)) {
        emit(const AuthError(failure: ValidationFailure(message: 'Adresse email invalide')));
        return;
      }

      if (event.password.length < 6) {
        emit(const AuthError(failure: ValidationFailure(message: 'Le mot de passe doit contenir au moins 6 caractères')));
        return;
      }

      if (event.password != event.confirmPassword) {
        emit(const AuthError(failure: ValidationFailure(message: 'Les mots de passe ne correspondent pas')));
        return;
      }

      // Simulation d'une inscription
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implémenter l'inscription réelle
      // Pour l'instant, on redirige vers l'onboarding
      emit(const AuthSignupRequired());
    } catch (e) {
      emit(const AuthError(failure: ServerFailure(message: 'Erreur lors de l\'inscription')));
    }
  }

  /// Gère la demande de mode invité.
  Future<void> _onGuestModeRequested(
    GuestModeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      // Simulation d'une initialisation en mode invité
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const AuthGuest());
    } catch (e) {
      emit(const AuthError(failure: ServerFailure(message: 'Erreur lors de l\'activation du mode invité')));
    }
  }

  /// Gère la demande de déconnexion.
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    
    try {
      // TODO: Implémenter la déconnexion (suppression du token, etc.)
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(const AuthError(failure: ServerFailure(message: 'Erreur lors de la déconnexion')));
    }
  }

  /// Valide le format d'une adresse email.
  bool _isValidEmail(String email) {
    const String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }
}