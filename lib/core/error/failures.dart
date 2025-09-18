import 'package:equatable/equatable.dart';

/// Classe de base abstraite pour toutes les erreurs dans FoodSave.
/// 
/// Utilise [Equatable] pour permettre la comparaison des instances d'erreurs.
/// Chaque erreur possède un message descriptif et un code d'erreur optionnel.
abstract class Failure extends Equatable {
  /// Crée une nouvelle instance de [Failure].
  /// 
  /// [message] : Description de l'erreur pour l'utilisateur.
  /// [code] : Code d'erreur optionnel pour le débogage.
  const Failure({
    required this.message,
    this.code,
  });

  /// Message d'erreur descriptif.
  final String message;

  /// Code d'erreur optionnel.
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

/// Erreur liée aux problèmes de serveur ou API.
class ServerFailure extends Failure {
  /// Crée une nouvelle instance de [ServerFailure].
  const ServerFailure({
    required super.message,
    super.code,
  });
}

/// Erreur liée aux problèmes de cache local.
class CacheFailure extends Failure {
  /// Crée une nouvelle instance de [CacheFailure].
  const CacheFailure({
    required super.message,
    super.code,
  });
}

/// Erreur liée aux problèmes de connexion réseau.
class NetworkFailure extends Failure {
  /// Crée une nouvelle instance de [NetworkFailure].
  const NetworkFailure({
    required super.message,
    super.code,
  });
}

/// Erreur de validation des données utilisateur.
class ValidationFailure extends Failure {
  /// Crée une nouvelle instance de [ValidationFailure].
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

/// Erreur d'authentification ou d'autorisation.
class AuthFailure extends Failure {
  /// Crée une nouvelle instance de [AuthFailure].
  const AuthFailure({
    required super.message,
    super.code,
  });
}

/// Erreur générique pour les erreurs inconnues.
class UnknownFailure extends Failure {
  /// Crée une nouvelle instance de [UnknownFailure].
  const UnknownFailure({
    required super.message,
    super.code,
  });
}
