import 'package:dartz/dartz.dart';
import 'package:foodsave_app/core/error/failures.dart';
import 'package:foodsave_app/domain/entities/user.dart';

/// Interface pour la gestion de l'authentification.
/// 
/// Définit les contrats pour les opérations d'authentification
/// telles que la connexion, l'inscription et la déconnexion.
abstract class AuthRepository {
  /// Connecte un utilisateur avec son email et mot de passe.
  /// 
  /// Retourne l'utilisateur connecté en cas de succès.
  /// Retourne une Failure en cas d'échec.
  Future<Either<Failure, User>> login(String email, String password);
  
  /// Inscrit un nouvel utilisateur.
  /// 
  /// Retourne l'utilisateur créé en cas de succès.
  /// Retourne une Failure en cas d'échec.
  Future<Either<Failure, User>> register(
    String email, 
    String password, 
    String name, 
    UserType userType,
  );
  
  /// Déconnecte l'utilisateur actuel.
  /// 
  /// Retourne void en cas de succès.
  /// Retourne une Failure en cas d'échec.
  Future<Either<Failure, void>> logout();
  
  /// Vérifie si un utilisateur est actuellement connecté.
  /// 
  /// Retourne l'utilisateur connecté en cas de succès.
  /// Retourne une Failure en cas d'échec.
  Future<Either<Failure, User>> getCurrentUser();
}
