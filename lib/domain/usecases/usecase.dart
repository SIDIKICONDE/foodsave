import 'package:equatable/equatable.dart';

/// Classe abstraite de base pour tous les use cases.
/// 
/// [Params] : Type des paramètres d'entrée du use case.
/// [ReturnType] : Type de retour du use case.
abstract class UseCase<ReturnType, Params> {
  /// Exécute le use case avec les paramètres donnés.
  Future<ReturnType> call(Params params);
}

/// Use case sans paramètres.
abstract class NoParamsUseCase<ReturnType> {
  /// Exécute le use case sans paramètres.
  Future<ReturnType> call();
}

/// Classe de base pour les paramètres des use cases.
abstract class UseCaseParams extends Equatable {
  const UseCaseParams();
}

/// Classe pour les use cases sans paramètres.
class NoParams extends UseCaseParams {
  const NoParams();

  @override
  List<Object> get props => [];
}