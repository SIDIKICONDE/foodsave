import 'package:equatable/equatable.dart';
import 'package:foodsave_app/core/error/failures.dart';
import 'package:foodsave_app/domain/entities/user.dart';

/// Classe de base abstraite pour tous les états d'authentification.
/// 
/// Utilise [Equatable] pour permettre la comparaison des états.
abstract class AuthState extends Equatable {
  /// Crée un nouvel état d'authentification.
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// État initial de l'authentification.
class AuthInitial extends AuthState {
  /// Crée un état [AuthInitial].
  const AuthInitial();
}

/// État indiquant que l'authentification est en cours.
class AuthLoading extends AuthState {
  /// Crée un état [AuthLoading].
  const AuthLoading();
}

/// État indiquant que l'utilisateur est authentifié.
class AuthAuthenticated extends AuthState {
  /// Crée un état [AuthAuthenticated].
  /// 
  /// [user] : Utilisateur authentifié.
  const AuthAuthenticated({
    required this.user,
  });

  /// Utilisateur authentifié.
  final User user;

  @override
  List<Object?> get props => [user];
}

/// État indiquant que l'utilisateur est en mode invité.
class AuthGuest extends AuthState {
  /// Crée un état [AuthGuest].
  const AuthGuest();
}

/// État indiquant que l'utilisateur n'est pas authentifié.
class AuthUnauthenticated extends AuthState {
  /// Crée un état [AuthUnauthenticated].
  const AuthUnauthenticated();
}

/// État indiquant une erreur d'authentification.
class AuthError extends AuthState {
  /// Crée un état [AuthError].
  /// 
  /// [failure] : Détails de l'erreur survenue.
  const AuthError({
    required this.failure,
  });

  /// Détails de l'erreur survenue.
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

/// État indiquant qu'une inscription est nécessaire.
class AuthSignupRequired extends AuthState {
  /// Crée un état [AuthSignupRequired].
  const AuthSignupRequired();
}