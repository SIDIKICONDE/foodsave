import '../../../domain/entities/user.dart';

/// Interface abstraite pour les opérations d'authentification distantes.
///
/// Définit les contrats pour toutes les opérations d'authentification
/// qui nécessitent des appels vers un serveur distant (API REST, GraphQL, etc.).
abstract class AuthRemoteDataSource {
  /// Authentifie un utilisateur avec son email et mot de passe.
  ///
  /// [email] L'email de l'utilisateur
  /// [password] Le mot de passe de l'utilisateur
  ///
  /// Retourne un [User] si l'authentification réussit.
  /// Lance une exception si l'authentification échoue.
  Future<User> login(String email, String password);

  /// Inscrit un nouvel utilisateur.
  ///
  /// [email] L'email de l'utilisateur
  /// [password] Le mot de passe de l'utilisateur
  /// [name] Le nom complet de l'utilisateur
  ///
  /// Retourne un [User] si l'inscription réussit.
  /// Lance une exception si l'inscription échoue.
  Future<User> register(String email, String password, String name);

  /// Déconnecte l'utilisateur actuel.
  ///
  /// Invalidate le token d'authentification côté serveur.
  /// Lance une exception si la déconnexion échoue.
  Future<void> logout();

  /// Rafraîchit le token d'authentification.
  ///
  /// [refreshToken] Le token de rafraîchissement
  ///
  /// Retourne un nouvel objet [User] avec le token mis à jour.
  /// Lance une exception si le rafraîchissement échoue.
  Future<User> refreshToken(String refreshToken);

  /// Envoie un email de réinitialisation de mot de passe.
  ///
  /// [email] L'email de l'utilisateur
  ///
  /// Lance une exception si l'envoi échoue.
  Future<void> forgotPassword(String email);

  /// Vérifie l'email de l'utilisateur.
  ///
  /// [token] Le token de vérification reçu par email
  ///
  /// Lance une exception si la vérification échoue.
  Future<void> verifyEmail(String token);

  /// Récupère les informations du profil utilisateur actuel.
  ///
  /// Nécessite un token d'authentification valide.
  /// Retourne un [User] avec les informations à jour.
  /// Lance une exception si la récupération échoue.
  Future<User> getCurrentUser();
}