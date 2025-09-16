import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../models/order.dart';

/// Service de paiement pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
class PaymentService {
  /// Instance de Dio pour les requêtes HTTP
  final Dio _dio;

  /// Constructeur du service de paiement
  PaymentService({required Dio dio}) : _dio = dio;

  /// Traite un paiement par carte bancaire
  Future<PaymentResult> processCardPayment({
    required String orderId,
    required double amount,
    required String currency,
    required CardPaymentDetails cardDetails,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/card',
        data: {
          'order_id': orderId,
          'amount': amount,
          'currency': currency,
          'card_number': cardDetails.cardNumber,
          'expiry_month': cardDetails.expiryMonth,
          'expiry_year': cardDetails.expiryYear,
          'cvv': cardDetails.cvv,
          'cardholder_name': cardDetails.cardholderName,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return PaymentResult.success(
          transactionId: data['transaction_id'],
          amount: amount,
          currency: currency,
        );
      }

      return PaymentResult.failure(
        error: response.data['message'] ?? 'Échec du paiement',
      );
    } on DioException catch (e) {
      return PaymentResult.failure(
        error: _handlePaymentError(e),
      );
    } catch (e) {
      return PaymentResult.failure(
        error: 'Erreur inconnue lors du paiement',
      );
    }
  }

  /// Traite un paiement mobile (Apple Pay, Google Pay)
  Future<PaymentResult> processMobilePayment({
    required String orderId,
    required double amount,
    required String currency,
    required MobilePaymentProvider provider,
    required String paymentToken,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/mobile',
        data: {
          'order_id': orderId,
          'amount': amount,
          'currency': currency,
          'provider': provider.name,
          'payment_token': paymentToken,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return PaymentResult.success(
          transactionId: data['transaction_id'],
          amount: amount,
          currency: currency,
        );
      }

      return PaymentResult.failure(
        error: response.data['message'] ?? 'Échec du paiement mobile',
      );
    } on DioException catch (e) {
      return PaymentResult.failure(
        error: _handlePaymentError(e),
      );
    } catch (e) {
      return PaymentResult.failure(
        error: 'Erreur inconnue lors du paiement mobile',
      );
    }
  }

  /// Traite un paiement avec les points étudiants
  Future<PaymentResult> processStudentPointsPayment({
    required String orderId,
    required String studentId,
    required int pointsRequired,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/student-points',
        data: {
          'order_id': orderId,
          'student_id': studentId,
          'points_required': pointsRequired,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return PaymentResult.success(
          transactionId: data['transaction_id'],
          amount: 0.0, // Points payment
          currency: 'POINTS',
        );
      }

      return PaymentResult.failure(
        error: response.data['message'] ?? 'Points insuffisants',
      );
    } on DioException catch (e) {
      return PaymentResult.failure(
        error: _handlePaymentError(e),
      );
    } catch (e) {
      return PaymentResult.failure(
        error: 'Erreur lors du paiement par points',
      );
    }
  }

  /// Initie un remboursement
  Future<RefundResult> processRefund({
    required String transactionId,
    required double amount,
    required String reason,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/refund',
        data: {
          'transaction_id': transactionId,
          'amount': amount,
          'reason': reason,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return RefundResult.success(
          refundId: data['refund_id'],
          amount: amount,
          estimatedDays: data['estimated_days'] ?? 3,
        );
      }

      return RefundResult.failure(
        error: response.data['message'] ?? 'Échec du remboursement',
      );
    } on DioException catch (e) {
      return RefundResult.failure(
        error: _handlePaymentError(e),
      );
    } catch (e) {
      return RefundResult.failure(
        error: 'Erreur lors du remboursement',
      );
    }
  }

  /// Vérifie le statut d'un paiement
  Future<PaymentStatus> checkPaymentStatus(String transactionId) async {
    try {
      final response = await _dio.get(
        '/payments/status/$transactionId',
      );

      if (response.statusCode == 200) {
        final status = response.data['status'] as String;
        return PaymentStatus.values.firstWhere(
          (s) => s.name == status,
          orElse: () => PaymentStatus.failed,
        );
      }

      return PaymentStatus.failed;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking payment status: $e');
      }
      return PaymentStatus.failed;
    }
  }

  /// Calcule les frais de traitement
  Future<PaymentFees> calculateFees({
    required double amount,
    required PaymentMethod paymentMethod,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/calculate-fees',
        data: {
          'amount': amount,
          'payment_method': paymentMethod.name,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return PaymentFees(
          processingFee: data['processing_fee']?.toDouble() ?? 0.0,
          platformFee: data['platform_fee']?.toDouble() ?? 0.0,
          totalFees: data['total_fees']?.toDouble() ?? 0.0,
        );
      }

      return const PaymentFees(
        processingFee: 0.0,
        platformFee: 0.0,
        totalFees: 0.0,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error calculating payment fees: $e');
      }
      return const PaymentFees(
        processingFee: 0.0,
        platformFee: 0.0,
        totalFees: 0.0,
      );
    }
  }

  /// Sauvegarde les informations de paiement (tokenisées)
  Future<bool> savePaymentMethod({
    required String userId,
    required String paymentToken,
    required PaymentMethod paymentMethod,
    String? nickname,
  }) async {
    try {
      final response = await _dio.post(
        '/payments/save-method',
        data: {
          'user_id': userId,
          'payment_token': paymentToken,
          'payment_method': paymentMethod.name,
          if (nickname != null) 'nickname': nickname,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving payment method: $e');
      }
      return false;
    }
  }

  /// Récupère les méthodes de paiement sauvegardées
  Future<List<SavedPaymentMethod>> getSavedPaymentMethods(String userId) async {
    try {
      final response = await _dio.get(
        '/payments/saved-methods/$userId',
      );

      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data
            .map((item) => SavedPaymentMethod.fromJson(item))
            .toList();
      }

      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching saved payment methods: $e');
      }
      return [];
    }
  }

  /// Valide les informations de carte bancaire
  bool validateCardDetails(CardPaymentDetails cardDetails) {
    // Validation du numéro de carte (algorithme de Luhn)
    if (!_isValidCardNumber(cardDetails.cardNumber)) {
      return false;
    }

    // Validation de la date d'expiration
    if (!_isValidExpiryDate(cardDetails.expiryMonth, cardDetails.expiryYear)) {
      return false;
    }

    // Validation du CVV
    if (!_isValidCVV(cardDetails.cvv)) {
      return false;
    }

    return true;
  }

  /// Gère les erreurs de paiement
  String _handlePaymentError(DioException error) {
    switch (error.response?.statusCode) {
      case 400:
        return 'Informations de paiement invalides';
      case 402:
        return 'Paiement refusé par votre banque';
      case 403:
        return 'Transaction non autorisée';
      case 404:
        return 'Commande introuvable';
      case 409:
        return 'Cette commande a déjà été payée';
      case 422:
        return 'Données de paiement incorrectes';
      case 429:
        return 'Trop de tentatives, veuillez réessayer plus tard';
      default:
        return 'Erreur de paiement, veuillez réessayer';
    }
  }

  /// Valide un numéro de carte avec l'algorithme de Luhn
  bool _isValidCardNumber(String cardNumber) {
    final digits = cardNumber.replaceAll(RegExp(r'\s+'), '');
    if (digits.length < 13 || digits.length > 19) return false;

    int sum = 0;
    bool isEven = false;

    for (int i = digits.length - 1; i >= 0; i--) {
      int digit = int.tryParse(digits[i]) ?? 0;

      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit = digit ~/ 10 + digit % 10;
        }
      }

      sum += digit;
      isEven = !isEven;
    }

    return sum % 10 == 0;
  }

  /// Valide la date d'expiration
  bool _isValidExpiryDate(String month, String year) {
    final monthNum = int.tryParse(month) ?? 0;
    final yearNum = int.tryParse(year) ?? 0;

    if (monthNum < 1 || monthNum > 12) return false;
    if (yearNum < DateTime.now().year % 100) return false;

    final expiryDate = DateTime(2000 + yearNum, monthNum + 1, 0);
    return expiryDate.isAfter(DateTime.now());
  }

  /// Valide le CVV
  bool _isValidCVV(String cvv) {
    return cvv.length >= 3 && cvv.length <= 4 && int.tryParse(cvv) != null;
  }
}

/// Détails de paiement par carte
class CardPaymentDetails {
  /// Numéro de carte
  final String cardNumber;
  
  /// Mois d'expiration
  final String expiryMonth;
  
  /// Année d'expiration
  final String expiryYear;
  
  /// Code CVV
  final String cvv;
  
  /// Nom du porteur
  final String cardholderName;

  /// Constructeur
  const CardPaymentDetails({
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvv,
    required this.cardholderName,
  });
}

/// Fournisseurs de paiement mobile
enum MobilePaymentProvider {
  applePay,
  googlePay,
  samsungPay,
}

/// Résultat d'un paiement
class PaymentResult {
  /// Indique si le paiement a réussi
  final bool isSuccess;
  
  /// ID de transaction
  final String? transactionId;
  
  /// Montant payé
  final double? amount;
  
  /// Devise
  final String? currency;
  
  /// Message d'erreur
  final String? error;

  /// Constructeur privé
  const PaymentResult._({
    required this.isSuccess,
    this.transactionId,
    this.amount,
    this.currency,
    this.error,
  });

  /// Constructeur pour un succès
  factory PaymentResult.success({
    required String transactionId,
    required double amount,
    required String currency,
  }) => PaymentResult._(
    isSuccess: true,
    transactionId: transactionId,
    amount: amount,
    currency: currency,
  );

  /// Constructeur pour un échec
  factory PaymentResult.failure({
    required String error,
  }) => PaymentResult._(
    isSuccess: false,
    error: error,
  );
}

/// Résultat d'un remboursement
class RefundResult {
  /// Indique si le remboursement a réussi
  final bool isSuccess;
  
  /// ID du remboursement
  final String? refundId;
  
  /// Montant remboursé
  final double? amount;
  
  /// Jours estimés pour le remboursement
  final int? estimatedDays;
  
  /// Message d'erreur
  final String? error;

  /// Constructeur privé
  const RefundResult._({
    required this.isSuccess,
    this.refundId,
    this.amount,
    this.estimatedDays,
    this.error,
  });

  /// Constructeur pour un succès
  factory RefundResult.success({
    required String refundId,
    required double amount,
    required int estimatedDays,
  }) => RefundResult._(
    isSuccess: true,
    refundId: refundId,
    amount: amount,
    estimatedDays: estimatedDays,
  );

  /// Constructeur pour un échec
  factory RefundResult.failure({
    required String error,
  }) => RefundResult._(
    isSuccess: false,
    error: error,
  );
}

/// Frais de paiement
class PaymentFees {
  /// Frais de traitement
  final double processingFee;
  
  /// Frais de plateforme
  final double platformFee;
  
  /// Total des frais
  final double totalFees;

  /// Constructeur
  const PaymentFees({
    required this.processingFee,
    required this.platformFee,
    required this.totalFees,
  });
}

/// Méthode de paiement sauvegardée
class SavedPaymentMethod {
  /// ID de la méthode
  final String id;
  
  /// Type de paiement
  final PaymentMethod type;
  
  /// Surnom donné par l'utilisateur
  final String? nickname;
  
  /// Derniers chiffres (pour les cartes)
  final String? lastFourDigits;
  
  /// Marque de carte
  final String? cardBrand;

  /// Constructeur
  const SavedPaymentMethod({
    required this.id,
    required this.type,
    this.nickname,
    this.lastFourDigits,
    this.cardBrand,
  });

  /// Factory depuis JSON
  factory SavedPaymentMethod.fromJson(Map<String, dynamic> json) {
    return SavedPaymentMethod(
      id: json['id'],
      type: PaymentMethod.values.firstWhere(
        (m) => m.name == json['type'],
        orElse: () => PaymentMethod.creditCard,
      ),
      nickname: json['nickname'],
      lastFourDigits: json['last_four_digits'],
      cardBrand: json['card_brand'],
    );
  }
}

/// Provider Riverpod pour le service de paiement
final paymentServiceProvider = Provider<PaymentService>((ref) {
  throw UnimplementedError('PaymentService provider must be overridden');
});