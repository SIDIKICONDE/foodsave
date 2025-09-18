import 'package:dartz/dartz.dart';
import 'package:foodsave_app/core/error/failures.dart';
import 'package:foodsave_app/domain/repositories/auth_repository.dart';
import 'package:foodsave_app/domain/usecases/usecase.dart';

/// Use case pour la déconnexion d'un utilisateur.
/// 
/// Encapsule la logique métier de déconnexion.
class LogoutUseCase implements UseCase<Either<Failure, void>, NoParams> {
  final AuthRepository _authRepository;
  
  /// Crée une nouvelle instance de [LogoutUseCase].
  const LogoutUseCase(this._authRepository);
  
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _authRepository.logout();
  }
}
