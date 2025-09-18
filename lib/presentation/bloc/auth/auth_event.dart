import 'package:equatable/equatable.dart';

/// Classe de base abstraite pour tous les événements d'authentification.
/// 
/// Utilise [Equatable] pour permettre la comparaison des événements.
abstract class AuthEvent extends Equatable {
  /// Crée un nouvel événement d'authentification.
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Événement déclenché pour démarrer une connexion.
class LoginRequested extends AuthEvent {
  /// Crée un événement [LoginRequested].
  /// 
  /// [email] : Adresse email de l'utilisateur.
  /// [password] : Mot de passe de l'utilisateur.
  const LoginRequested({
    required this.email,
    required this.password,
  });

  /// Adresse email de l'utilisateur.
  final String email;

  /// Mot de passe de l'utilisateur.
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Événement déclenché pour démarrer une inscription.
class SignupRequested extends AuthEvent {
  /// Crée un événement [SignupRequested].
  /// 
  /// [email] : Adresse email de l'utilisateur.
  /// [password] : Mot de passe de l'utilisateur.
  /// [confirmPassword] : Confirmation du mot de passe.
  /// [name] : Nom complet de l'utilisateur.
  const SignupRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.name,
  });

  /// Adresse email de l'utilisateur.
  final String email;

  /// Mot de passe de l'utilisateur.
  final String password;

  /// Confirmation du mot de passe.
  final String confirmPassword;

  /// Nom complet de l'utilisateur.
  final String name;

  @override
  List<Object?> get props => [email, password, confirmPassword, name];
}

/// Événement déclenché pour continuer en mode invité.
class GuestModeRequested extends AuthEvent {
  /// Crée un événement [GuestModeRequested].
  const GuestModeRequested();
}

/// Événement déclenché pour se déconnecter.
class LogoutRequested extends AuthEvent {
  /// Crée un événement [LogoutRequested].
  const LogoutRequested();
}

/// Événement déclenché pour vérifier l'état de connexion.
class AuthStatusChecked extends AuthEvent {
  /// Crée un événement [AuthStatusChecked].
  const AuthStatusChecked();
}