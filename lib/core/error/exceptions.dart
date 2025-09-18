/// Exception de base pour toutes les exceptions personnalisées de l'application.
abstract class AppException implements Exception {
  /// Message décrivant l'exception.
  final String message;

  /// Crée une nouvelle instance de [AppException].
  const AppException(this.message);

  @override
  String toString() => 'AppException: $message';
}

/// Exception lancée lors d'erreurs d'authentification.
class AuthException extends AppException {
  /// Crée une nouvelle instance de [AuthException].
  const AuthException(super.message);

  @override
  String toString() => 'AuthException: $message';
}

/// Exception lancée lors d'erreurs de serveur.
class ServerException extends AppException {
  /// Code d'erreur HTTP.
  final int? statusCode;

  /// Crée une nouvelle instance de [ServerException].
  const ServerException(super.message, {this.statusCode});

  @override
  String toString() => 'ServerException: $message ${statusCode != null ? '($statusCode)' : ''}';
}

/// Exception lancée lors d'erreurs de réseau.
class NetworkException extends AppException {
  /// Crée une nouvelle instance de [NetworkException].
  const NetworkException(super.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception lancée lors d'erreurs de cache local.
class CacheException extends AppException {
  /// Crée une nouvelle instance de [CacheException].
  const CacheException(super.message);

  @override
  String toString() => 'CacheException: $message';
}

/// Exception lancée lors d'erreurs de validation.
class ValidationException extends AppException {
  /// Champ qui a causé l'erreur de validation.
  final String field;

  /// Crée une nouvelle instance de [ValidationException].
  const ValidationException(super.message, this.field);

  @override
  String toString() => 'ValidationException: $message (Field: $field)';
}