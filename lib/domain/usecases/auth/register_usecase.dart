import 'package:dartz/dartz.dart';
import 'package:foodsave_app/core/error/failures.dart';
import 'package:foodsave_app/domain/entities/user.dart';
import 'package:foodsave_app/domain/repositories/auth_repository.dart';
import 'package:foodsave_app/domain/usecases/usecase.dart';

/// Paramètres pour l'inscription.
class RegisterParams {
  final String email;
  final String password;
  final String name;
  final UserType userType;
  
  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    required this.userType,
  });
}

/// Use case pour l'inscription d'un utilisateur.
/// 
/// Encapsule la logique métier d'inscription.
class RegisterUseCase implements UseCase<Either<Failure, User>, RegisterParams> {
  final AuthRepository _authRepository;
  
  /// Crée une nouvelle instance de [RegisterUseCase].
  const RegisterUseCase(this._authRepository);
  
  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await _authRepository.register(
      params.email,
      params.password,
      params.name,
      params.userType,
    );
  }
}
