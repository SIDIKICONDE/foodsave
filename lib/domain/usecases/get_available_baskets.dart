import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/domain/repositories/basket_repository.dart';
import 'package:foodsave_app/domain/usecases/usecase.dart';

/// Use case pour récupérer la liste des paniers disponibles.
/// 
/// Récupère les paniers disponibles selon la localisation
/// et les critères de filtrage de l'utilisateur.
class GetAvailableBaskets extends UseCase<List<Basket>, GetAvailableBasketsParams> {
  /// Crée une nouvelle instance de [GetAvailableBaskets].
  GetAvailableBaskets(this._repository);

  /// Repository des paniers.
  final BasketRepository _repository;

  @override
  Future<List<Basket>> call(GetAvailableBasketsParams params) async {
    return await _repository.getAvailableBaskets(
      latitude: params.latitude,
      longitude: params.longitude,
      radius: params.radius,
      limit: params.limit,
      offset: params.offset,
    );
  }
}

/// Paramètres pour récupérer les paniers disponibles.
class GetAvailableBasketsParams extends UseCaseParams {
  /// Crée une nouvelle instance de [GetAvailableBasketsParams].
  const GetAvailableBasketsParams({
    this.latitude,
    this.longitude,
    this.radius = 10.0,
    this.limit = 20,
    this.offset = 0,
  });

  /// Latitude de l'utilisateur.
  final double? latitude;

  /// Longitude de l'utilisateur.
  final double? longitude;

  /// Rayon de recherche en kilomètres.
  final double radius;

  /// Nombre maximum de résultats.
  final int limit;

  /// Offset pour la pagination.
  final int offset;

  @override
  List<Object?> get props => [
        latitude,
        longitude,
        radius,
        limit,
        offset,
      ];
}