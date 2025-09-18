import 'package:foodsave_app/domain/entities/reservation.dart';

/// Repository abstrait pour la gestion des réservations.
/// 
/// Définit les contrats pour les opérations sur les réservations,
/// du processus de réservation jusqu'à la récupération.
abstract class ReservationRepository {
  /// Crée une nouvelle réservation.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [basketId] identifiant du panier à réserver.
  /// [pickupTimeStart] heure de début de récupération souhaitée.
  /// [pickupTimeEnd] heure de fin de récupération souhaitée.
  /// [paymentMethod] méthode de paiement choisie.
  /// [specialInstructions] instructions spéciales (optionnel).
  /// [promoCode] code promo à appliquer (optionnel).
  Future<Reservation?> createReservation({
    required String userId,
    required String basketId,
    required DateTime pickupTimeStart,
    required DateTime pickupTimeEnd,
    required PaymentMethod paymentMethod,
    String? specialInstructions,
    String? promoCode,
  });

  /// Récupère une réservation par son ID.
  /// 
  /// [reservationId] identifiant de la réservation.
  /// [includeRelatedEntities] inclure les entités liées (panier, commerce).
  Future<Reservation?> getReservationById(
    String reservationId, {
    bool includeRelatedEntities = false,
  });

  /// Récupère les réservations d'un utilisateur.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [status] filtrer par statut (optionnel).
  /// [limit] nombre maximum de résultats.
  /// [offset] pour la pagination.
  Future<List<Reservation>> getUserReservations(
    String userId, {
    ReservationStatus? status,
    int limit = 20,
    int offset = 0,
  });

  /// Récupère les réservations actives d'un utilisateur.
  /// 
  /// [userId] identifiant de l'utilisateur.
  Future<List<Reservation>> getActiveReservations(String userId);

  /// Récupère l'historique des réservations d'un utilisateur.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [startDate] date de début de l'historique.
  /// [endDate] date de fin de l'historique.
  /// [limit] nombre maximum de résultats.
  /// [offset] pour la pagination.
  Future<List<Reservation>> getReservationHistory(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int limit = 20,
    int offset = 0,
  });

  /// Confirme une réservation (côté commerce).
  /// 
  /// [reservationId] identifiant de la réservation.
  /// [confirmationCode] code de confirmation généré.
  Future<bool> confirmReservation(String reservationId, String confirmationCode);

  /// Marque une réservation comme prête.
  /// 
  /// [reservationId] identifiant de la réservation.
  /// [actualItems] articles effectivement préparés.
  /// [actualWeight] poids effectif du panier.
  Future<bool> markReservationReady(
    String reservationId, {
    List<String>? actualItems,
    double? actualWeight,
  });

  /// Confirme la récupération d'une réservation.
  /// 
  /// [reservationId] identifiant de la réservation.
  /// [confirmationCode] code de confirmation pour vérification.
  Future<bool> confirmPickup(String reservationId, String confirmationCode);

  /// Annule une réservation.
  /// 
  /// [reservationId] identifiant de la réservation.
  /// [reason] raison de l'annulation.
  /// [refundRequested] si un remboursement est demandé.
  Future<bool> cancelReservation(
    String reservationId, {
    required String reason,
    bool refundRequested = false,
  });

  /// Traite un remboursement.
  /// 
  /// [reservationId] identifiant de la réservation.
  /// [refundAmount] montant à rembourser.
  /// [reason] raison du remboursement.
  Future<bool> processRefund(
    String reservationId, {
    required double refundAmount,
    required String reason,
  });

  /// Ajoute une évaluation à une réservation.
  /// 
  /// [reservationId] identifiant de la réservation.
  /// [rating] note de 1 à 5.
  /// [review] commentaire (optionnel).
  Future<bool> addReview(
    String reservationId, {
    required double rating,
    String? review,
  });

  /// Récupère les réservations à récupérer bientôt.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [hoursAhead] nombre d'heures à l'avance pour l'alerte.
  Future<List<Reservation>> getUpcomingPickups(
    String userId, {
    int hoursAhead = 2,
  });

  /// Récupère les réservations expirées non récupérées.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [daysSince] nombre de jours depuis l'expiration.
  Future<List<Reservation>> getExpiredReservations(
    String userId, {
    int daysSince = 7,
  });

  /// Vérifie si un utilisateur peut réserver un panier.
  /// 
  /// [userId] identifiant de l'utilisateur.
  /// [basketId] identifiant du panier.
  Future<bool> canUserReserveBasket(String userId, String basketId);

  /// Calcule le prix final d'une réservation avec promotions.
  /// 
  /// [basketId] identifiant du panier.
  /// [promoCode] code promo à appliquer (optionnel).
  /// [userId] identifiant de l'utilisateur pour les réductions personnalisées.
  Future<double> calculateFinalPrice(
    String basketId, {
    String? promoCode,
    String? userId,
  });

  /// Stream pour écouter les changements d'une réservation.
  /// 
  /// [reservationId] identifiant de la réservation.
  Stream<Reservation?> watchReservation(String reservationId);

  /// Stream pour écouter les réservations actives d'un utilisateur.
  /// 
  /// [userId] identifiant de l'utilisateur.
  Stream<List<Reservation>> watchActiveReservations(String userId);
}