import 'package:freezed_annotation/freezed_annotation.dart';

part 'order.freezed.dart';
part 'order.g.dart';

/// Modèle de commande/réservation pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
@freezed
class Order with _$Order {
  /// Constructeur du modèle Order
  const factory Order({
    /// Identifiant unique de la commande
    required String id,
    
    /// Identifiant de l'étudiant
    required String studentId,
    
    /// Identifiant du commerçant
    required String merchantId,
    
    /// Identifiant du repas
    required String mealId,
    
    /// Quantité commandée
    required int quantity,
    
    /// Prix total de la commande
    required double totalPrice,
    
    /// Prix unitaire au moment de la commande
    required double unitPrice,
    
    /// Statut de la commande
    @Default(OrderStatus.pending) OrderStatus status,
    
    /// Mode de paiement
    PaymentMethod? paymentMethod,
    
    /// Statut du paiement
    @Default(PaymentStatus.pending) PaymentStatus paymentStatus,
    
    /// ID de transaction de paiement
    String? paymentTransactionId,
    
    /// Code de récupération (QR Code)
    String? pickupCode,
    
    /// Instructions spéciales
    String? specialInstructions,
    
    /// Note de l'étudiant (1-5)
    int? studentRating,
    
    /// Commentaire de l'étudiant
    String? studentComment,
    
    /// Date de création de la commande
    required DateTime createdAt,
    
    /// Date de confirmation
    DateTime? confirmedAt,
    
    /// Date de paiement
    DateTime? paidAt,
    
    /// Date de préparation
    DateTime? preparedAt,
    
    /// Date de récupération
    DateTime? pickedUpAt,
    
    /// Date d'annulation
    DateTime? cancelledAt,
    
    /// Raison d'annulation
    String? cancellationReason,
    
    /// Date de dernière mise à jour
    DateTime? updatedAt,
  }) = _Order;

  /// Factory pour la désérialisation JSON
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

/// Statut de la commande
enum OrderStatus {
  /// En attente de confirmation
  @JsonValue('pending')
  pending,
  
  /// Confirmée par le commerçant
  @JsonValue('confirmed')
  confirmed,
  
  /// En préparation
  @JsonValue('preparing')
  preparing,
  
  /// Prête à être récupérée
  @JsonValue('ready')
  ready,
  
  /// Récupérée
  @JsonValue('picked_up')
  pickedUp,
  
  /// Annulée
  @JsonValue('cancelled')
  cancelled,
  
  /// Expirée (non récupérée à temps)
  @JsonValue('expired')
  expired,
}

/// Méthodes de paiement
enum PaymentMethod {
  /// Carte bancaire
  @JsonValue('credit_card')
  creditCard,
  
  /// Paiement mobile
  @JsonValue('mobile_payment')
  mobilePayment,
  
  /// Porte-monnaie numérique
  @JsonValue('digital_wallet')
  digitalWallet,
  
  /// Points étudiants
  @JsonValue('student_points')
  studentPoints,
  
  /// Paiement sur place
  @JsonValue('pay_on_pickup')
  payOnPickup,
}

/// Statut du paiement
enum PaymentStatus {
  /// En attente de paiement
  @JsonValue('pending')
  pending,
  
  /// Paiement réussi
  @JsonValue('paid')
  paid,
  
  /// Paiement échoué
  @JsonValue('failed')
  failed,
  
  /// Remboursé
  @JsonValue('refunded')
  refunded,
  
  /// En cours de remboursement
  @JsonValue('refunding')
  refunding,
}

/// Extensions utiles pour Order
extension OrderExtension on Order {
  /// Indique si la commande peut être annulée
  bool get canBeCancelled {
    return status == OrderStatus.pending || 
           status == OrderStatus.confirmed;
  }
  
  /// Indique si la commande est terminée
  bool get isCompleted {
    return status == OrderStatus.pickedUp;
  }
  
  /// Indique si la commande est annulée ou expirée
  bool get isCancelledOrExpired {
    return status == OrderStatus.cancelled || 
           status == OrderStatus.expired;
  }
  
  /// Indique si la commande est payée
  bool get isPaid {
    return paymentStatus == PaymentStatus.paid;
  }
  
  /// Indique si la commande nécessite un paiement
  bool get requiresPayment {
    return paymentMethod != PaymentMethod.payOnPickup &&
           paymentStatus == PaymentStatus.pending;
  }
  
  /// Temps écoulé depuis la création
  Duration get timeSinceCreation {
    return DateTime.now().difference(createdAt);
  }
  
  /// Temps écoulé depuis la confirmation
  Duration? get timeSinceConfirmation {
    return confirmedAt?.let((confirmed) => 
        DateTime.now().difference(confirmed));
  }
  
  /// Économies réalisées (si prix original était disponible)
  double get potentialSavings {
    // Cette valeur devrait être calculée en comparant avec le prix original du repas
    // Pour l'instant on retourne 0, mais cela peut être enrichi avec plus de données
    return 0.0;
  }
}

/// Extension pour les valeurs nullables
extension NullableExtension<T> on T? {
  /// Applique une fonction si la valeur n'est pas nulle
  R? let<R>(R Function(T) block) {
    final value = this;
    return value != null ? block(value) : null;
  }
}