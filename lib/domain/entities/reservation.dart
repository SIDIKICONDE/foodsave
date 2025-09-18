import 'package:equatable/equatable.dart';
import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/domain/entities/commerce.dart';
import 'package:foodsave_app/domain/entities/user.dart';

/// Énumération du statut d'une réservation.
enum ReservationStatus {
  /// Réservation en attente de confirmation.
  pending,
  /// Réservation confirmée.
  confirmed,
  /// Réservation prête à être récupérée.
  ready,
  /// Réservation récupérée avec succès.
  collected,
  /// Réservation annulée par l'utilisateur.
  cancelledByUser,
  /// Réservation annulée par le commerce.
  cancelledByCommerce,
  /// Réservation expirée (non récupérée à temps).
  expired,
  /// Réservation remboursée.
  refunded,
}

/// Énumération des méthodes de paiement.
enum PaymentMethod {
  /// Carte de crédit.
  creditCard,
  /// PayPal.
  paypal,
  /// Apple Pay.
  applePay,
  /// Google Pay.
  googlePay,
  /// Portefeuille FoodSave.
  foodsaveWallet,
  /// Paiement à la récupération.
  cashOnPickup,
}

/// Entité représentant une réservation de panier.
/// 
/// Cette entité gère le cycle de vie complet d'une réservation,
/// du moment de la réservation jusqu'à la récupération ou l'annulation.
class Reservation extends Equatable {
  /// Crée une nouvelle instance de [Reservation].
  const Reservation({
    required this.id,
    required this.userId,
    required this.basketId,
    required this.commerceId,
    required this.reservedAt,
    required this.pickupTimeStart,
    required this.pickupTimeEnd,
    required this.status,
    required this.totalAmount,
    required this.paymentMethod,
    this.user,
    this.basket,
    this.commerce,
    this.confirmationCode,
    this.specialInstructions,
    this.confirmedAt,
    this.readyAt,
    this.collectedAt,
    this.cancelledAt,
    this.cancellationReason,
    this.refundedAt,
    this.refundAmount,
    this.actualItems,
    this.actualWeight,
    this.rating,
    this.review,
    this.reviewedAt,
    this.promoCode,
    this.discountAmount,
    this.loyaltyPointsEarned,
    this.co2Saved,
    this.notificationsSent = const [],
  });

  /// Identifiant unique de la réservation.
  final String id;

  /// Identifiant de l'utilisateur qui a réservé.
  final String userId;

  /// Identifiant du panier réservé.
  final String basketId;

  /// Identifiant du commerce.
  final String commerceId;

  /// Date et heure de la réservation.
  final DateTime reservedAt;

  /// Heure de début de récupération.
  final DateTime pickupTimeStart;

  /// Heure de fin de récupération.
  final DateTime pickupTimeEnd;

  /// Statut actuel de la réservation.
  final ReservationStatus status;

  /// Montant total payé.
  final double totalAmount;

  /// Méthode de paiement utilisée.
  final PaymentMethod paymentMethod;

  /// Utilisateur qui a réservé (optionnel, chargé selon les besoins).
  final User? user;

  /// Panier réservé (optionnel, chargé selon les besoins).
  final Basket? basket;

  /// Commerce (optionnel, chargé selon les besoins).
  final Commerce? commerce;

  /// Code de confirmation pour la récupération.
  final String? confirmationCode;

  /// Instructions spéciales de l'utilisateur.
  final String? specialInstructions;

  /// Date et heure de confirmation par le commerce.
  final DateTime? confirmedAt;

  /// Date et heure où le panier est prêt.
  final DateTime? readyAt;

  /// Date et heure de récupération effective.
  final DateTime? collectedAt;

  /// Date et heure d'annulation.
  final DateTime? cancelledAt;

  /// Raison de l'annulation.
  final String? cancellationReason;

  /// Date et heure de remboursement.
  final DateTime? refundedAt;

  /// Montant remboursé.
  final double? refundAmount;

  /// Articles effectivement récupérés.
  final List<String>? actualItems;

  /// Poids effectif du panier récupéré.
  final double? actualWeight;

  /// Note donnée par l'utilisateur (1-5).
  final double? rating;

  /// Avis laissé par l'utilisateur.
  final String? review;

  /// Date et heure de l'avis.
  final DateTime? reviewedAt;

  /// Code promo utilisé.
  final String? promoCode;

  /// Montant de réduction appliqué.
  final double? discountAmount;

  /// Points de fidélité gagnés.
  final int? loyaltyPointsEarned;

  /// CO2 économisé par cette réservation.
  final double? co2Saved;

  /// Liste des notifications envoyées.
  final List<String> notificationsSent;

  /// Calcule le montant net payé (après remboursement).
  double get netAmountPaid {
    return totalAmount - (refundAmount ?? 0.0);
  }

  /// Vérifie si la réservation peut être annulée.
  bool get canBeCancelled {
    return status == ReservationStatus.pending ||
        status == ReservationStatus.confirmed;
  }

  /// Vérifie si la récupération peut avoir lieu maintenant.
  bool get canBePickedUpNow {
    final DateTime now = DateTime.now();
    return (status == ReservationStatus.confirmed || 
            status == ReservationStatus.ready) &&
        now.isAfter(pickupTimeStart) &&
        now.isBefore(pickupTimeEnd);
  }

  /// Vérifie si la période de récupération est bientôt expirée.
  bool get isPickupSoon {
    final DateTime now = DateTime.now();
    final Duration timeUntilEnd = pickupTimeEnd.difference(now);
    return status == ReservationStatus.confirmed &&
        timeUntilEnd.inHours <= 2 &&
        timeUntilEnd.inMinutes > 0;
  }

  /// Vérifie si la réservation est expirée.
  bool get isExpired {
    return status == ReservationStatus.expired ||
        (DateTime.now().isAfter(pickupTimeEnd) && 
         status != ReservationStatus.collected);
  }

  /// Vérifie si la réservation peut être évaluée.
  bool get canBeReviewed {
    return status == ReservationStatus.collected &&
        rating == null &&
        review == null;
  }

  /// Temps restant avant expiration en minutes.
  int get minutesUntilExpiry {
    if (isExpired) return 0;
    final Duration remaining = pickupTimeEnd.difference(DateTime.now());
    return remaining.inMinutes.clamp(0, double.infinity).toInt();
  }

  /// Retourne la couleur appropriée selon le statut.
  String get statusColor {
    switch (status) {
      case ReservationStatus.pending:
        return '#FFD93D';
      case ReservationStatus.confirmed:
        return '#74C0FC';
      case ReservationStatus.ready:
        return '#51CF66';
      case ReservationStatus.collected:
        return '#51CF66';
      case ReservationStatus.cancelledByUser:
      case ReservationStatus.cancelledByCommerce:
        return '#FF8787';
      case ReservationStatus.expired:
        return '#ADB5BD';
      case ReservationStatus.refunded:
        return '#94D82D';
    }
  }

  /// Retourne le texte de statut localisé.
  String get statusText {
    switch (status) {
      case ReservationStatus.pending:
        return 'En attente';
      case ReservationStatus.confirmed:
        return 'Confirmé';
      case ReservationStatus.ready:
        return 'Prêt';
      case ReservationStatus.collected:
        return 'Récupéré';
      case ReservationStatus.cancelledByUser:
        return 'Annulé par vous';
      case ReservationStatus.cancelledByCommerce:
        return 'Annulé par le commerce';
      case ReservationStatus.expired:
        return 'Expiré';
      case ReservationStatus.refunded:
        return 'Remboursé';
    }
  }

  /// Retourne le texte de la méthode de paiement.
  String get paymentMethodText {
    switch (paymentMethod) {
      case PaymentMethod.creditCard:
        return 'Carte bancaire';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.applePay:
        return 'Apple Pay';
      case PaymentMethod.googlePay:
        return 'Google Pay';
      case PaymentMethod.foodsaveWallet:
        return 'Portefeuille FoodSave';
      case PaymentMethod.cashOnPickup:
        return 'Paiement à la récupération';
    }
  }

  /// Crée une copie de la réservation avec des valeurs modifiées.
  Reservation copyWith({
    String? id,
    String? userId,
    String? basketId,
    String? commerceId,
    DateTime? reservedAt,
    DateTime? pickupTimeStart,
    DateTime? pickupTimeEnd,
    ReservationStatus? status,
    double? totalAmount,
    PaymentMethod? paymentMethod,
    User? user,
    Basket? basket,
    Commerce? commerce,
    String? confirmationCode,
    String? specialInstructions,
    DateTime? confirmedAt,
    DateTime? readyAt,
    DateTime? collectedAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    DateTime? refundedAt,
    double? refundAmount,
    List<String>? actualItems,
    double? actualWeight,
    double? rating,
    String? review,
    DateTime? reviewedAt,
    String? promoCode,
    double? discountAmount,
    int? loyaltyPointsEarned,
    double? co2Saved,
    List<String>? notificationsSent,
  }) {
    return Reservation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      basketId: basketId ?? this.basketId,
      commerceId: commerceId ?? this.commerceId,
      reservedAt: reservedAt ?? this.reservedAt,
      pickupTimeStart: pickupTimeStart ?? this.pickupTimeStart,
      pickupTimeEnd: pickupTimeEnd ?? this.pickupTimeEnd,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      user: user ?? this.user,
      basket: basket ?? this.basket,
      commerce: commerce ?? this.commerce,
      confirmationCode: confirmationCode ?? this.confirmationCode,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      readyAt: readyAt ?? this.readyAt,
      collectedAt: collectedAt ?? this.collectedAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      refundedAt: refundedAt ?? this.refundedAt,
      refundAmount: refundAmount ?? this.refundAmount,
      actualItems: actualItems ?? this.actualItems,
      actualWeight: actualWeight ?? this.actualWeight,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      promoCode: promoCode ?? this.promoCode,
      discountAmount: discountAmount ?? this.discountAmount,
      loyaltyPointsEarned: loyaltyPointsEarned ?? this.loyaltyPointsEarned,
      co2Saved: co2Saved ?? this.co2Saved,
      notificationsSent: notificationsSent ?? this.notificationsSent,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        basketId,
        commerceId,
        reservedAt,
        pickupTimeStart,
        pickupTimeEnd,
        status,
        totalAmount,
        paymentMethod,
        user,
        basket,
        commerce,
        confirmationCode,
        specialInstructions,
        confirmedAt,
        readyAt,
        collectedAt,
        cancelledAt,
        cancellationReason,
        refundedAt,
        refundAmount,
        actualItems,
        actualWeight,
        rating,
        review,
        reviewedAt,
        promoCode,
        discountAmount,
        loyaltyPointsEarned,
        co2Saved,
        notificationsSent,
      ];

  @override
  String toString() {
    return 'Reservation(id: $id, status: $status, amount: $totalAmount€)';
  }
}