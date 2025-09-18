import 'package:foodsave_app/domain/entities/reservation.dart';
import 'package:foodsave_app/domain/repositories/reservation_repository.dart';
import 'package:foodsave_app/domain/usecases/usecase.dart';

/// Use case pour créer une nouvelle réservation.
/// 
/// Gère le processus complet de création d'une réservation,
/// incluant la validation et le calcul du prix.
class CreateReservation extends UseCase<Reservation?, CreateReservationParams> {
  /// Crée une nouvelle instance de [CreateReservation].
  CreateReservation(this._repository);

  /// Repository des réservations.
  final ReservationRepository _repository;

  @override
  Future<Reservation?> call(CreateReservationParams params) async {
    // Validation des paramètres
    if (params.pickupTimeStart.isAfter(params.pickupTimeEnd)) {
      throw ArgumentError('L\'heure de début doit être avant l\'heure de fin');
    }

    if (params.pickupTimeStart.isBefore(DateTime.now())) {
      throw ArgumentError('L\'heure de récupération ne peut pas être dans le passé');
    }

    return await _repository.createReservation(
      userId: params.userId,
      basketId: params.basketId,
      pickupTimeStart: params.pickupTimeStart,
      pickupTimeEnd: params.pickupTimeEnd,
      paymentMethod: params.paymentMethod,
      specialInstructions: params.specialInstructions,
      promoCode: params.promoCode,
    );
  }
}

/// Paramètres pour créer une réservation.
class CreateReservationParams extends UseCaseParams {
  /// Crée une nouvelle instance de [CreateReservationParams].
  const CreateReservationParams({
    required this.userId,
    required this.basketId,
    required this.pickupTimeStart,
    required this.pickupTimeEnd,
    required this.paymentMethod,
    this.specialInstructions,
    this.promoCode,
  });

  /// Identifiant de l'utilisateur.
  final String userId;

  /// Identifiant du panier à réserver.
  final String basketId;

  /// Heure de début de récupération souhaitée.
  final DateTime pickupTimeStart;

  /// Heure de fin de récupération souhaitée.
  final DateTime pickupTimeEnd;

  /// Méthode de paiement choisie.
  final PaymentMethod paymentMethod;

  /// Instructions spéciales (optionnel).
  final String? specialInstructions;

  /// Code promo à appliquer (optionnel).
  final String? promoCode;

  @override
  List<Object?> get props => [
        userId,
        basketId,
        pickupTimeStart,
        pickupTimeEnd,
        paymentMethod,
        specialInstructions,
        promoCode,
      ];
}