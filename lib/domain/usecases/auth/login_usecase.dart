import 'package:dartz/dartz.dart';
import 'package:foodsave_app/core/error/failures.dart';
import 'package:foodsave_app/domain/entities/user.dart';
import 'package:foodsave_app/domain/repositories/auth_repository.dart';
import 'package:foodsave_app/domain/usecases/usecase.dart';

/// Paramètres pour la connexion.
class LoginParams {
  final String email;
  final String password;
  
  const LoginParams({
    required this.email,
    required this.password,
  });
}

/// Use case pour la connexion d'un utilisateur.
/// 
/// Encapsule la logique métier de connexion.
class LoginUseCase implements UseCase<Either<Failure, User>, LoginParams> {
  final AuthRepository _authRepository;
  
  /// Crée une nouvelle instance de [LoginUseCase].
  const LoginUseCase(this._authRepository);
  
  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await _authRepository.login(params.email, params.password);
  }
}
