import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:foodsave_app/presentation/pages/auth/merchant_register/constants/merchant_register_constants.dart';

/// Service gérant la logique métier de l'inscription commerçant.
///
/// Cette classe encapsule toute la logique d'inscription et de validation
/// pour séparer les responsabilités et faciliter les tests unitaires.
class MerchantRegisterService {
  /// Inscrit un nouveau commerçant avec les informations fournies.
  ///
  /// [managerName] - Le nom du responsable
  /// [businessName] - Le nom du commerce
  /// [phone] - Le numéro de téléphone
  /// [email] - L'adresse email professionnelle
  /// [password] - Le mot de passe
  ///
  /// Retourne un Either contenant soit une erreur, soit la réponse d'inscription.
  static Future<Either<String, AuthResponse>> registerMerchant({
    required String managerName,
    required String businessName,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final result = await Supabase.instance.client.auth.signUp(
        email: email.trim(),
        password: password,
        data: <String, dynamic>{
          'full_name': managerName.trim(),
          'business_name': businessName.trim(),
          'phone': phone.trim(),
          'app_name': 'FoodSave',
          'user_type': 'merchant',
          'account_status': 'pending',
          'created_at': DateTime.now().toIso8601String(),
        },
      );
      return Either.right(result);
    } catch (error) {
      return Either.left(MerchantRegisterConstants.unexpectedError);
    }
  }

  /// Valide le nom du responsable.
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validateManagerName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return MerchantRegisterConstants.managerNameRequiredError;
    }
    if (value.trim().length < MerchantRegisterConstants.minNameLength) {
      return MerchantRegisterConstants.managerNameTooShortError;
    }
    return null;
  }

  /// Valide le nom du commerce.
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validateBusinessName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return MerchantRegisterConstants.businessNameRequiredError;
    }
    if (value.trim().length < MerchantRegisterConstants.minNameLength) {
      return MerchantRegisterConstants.businessNameTooShortError;
    }
    return null;
  }

  /// Valide le numéro de téléphone.
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return MerchantRegisterConstants.phoneRequiredError;
    }
    if (value.trim().length < MerchantRegisterConstants.minPhoneLength) {
      return MerchantRegisterConstants.phoneTooShortError;
    }
    return null;
  }

  /// Valide l'email professionnel.
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return MerchantRegisterConstants.emailRequiredError;
    }
    if (!RegExp(MerchantRegisterConstants.emailRegexPattern).hasMatch(value.trim())) {
      return MerchantRegisterConstants.emailInvalidError;
    }
    return null;
  }

  /// Valide le mot de passe.
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return MerchantRegisterConstants.passwordRequiredError;
    }
    if (value.length < MerchantRegisterConstants.minPasswordLength) {
      return MerchantRegisterConstants.passwordTooShortError;
    }
    return null;
  }

  /// Valide la confirmation du mot de passe.
  ///
  /// [password] - Le mot de passe original
  /// [confirmPassword] - La confirmation du mot de passe
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validateConfirmPassword(String? confirmPassword, String password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return MerchantRegisterConstants.confirmPasswordRequiredError;
    }
    if (confirmPassword != password) {
      return MerchantRegisterConstants.passwordMismatchError;
    }
    return null;
  }

  /// Traduit les messages d'erreur Supabase en français.
  ///
  /// [originalMessage] - Le message d'erreur original
  ///
  /// Retourne le message d'erreur localisé.
  static String getLocalizedErrorMessage(String originalMessage) {
    final String lowerMessage = originalMessage.toLowerCase();

    if (lowerMessage.contains('email')) {
      return MerchantRegisterConstants.emailAlreadyUsedError;
    }
    if (lowerMessage.contains('password')) {
      return MerchantRegisterConstants.weakPasswordError;
    }
    if (lowerMessage.contains('network')) {
      return MerchantRegisterConstants.networkError;
    }

    return '${MerchantRegisterConstants.registrationError}$originalMessage';
  }
}

/// Classe utilitaire pour gérer les types Either (succès/erreur).
class Either<L, R> {
  final L? left;
  final R? right;
  final bool isLeft;

  Either._(this.left, this.right, this.isLeft);

  factory Either.left(L value) => Either._(value, null, true);
  factory Either.right(R value) => Either._(null, value, false);

  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) {
    return isLeft ? leftFn(left as L) : rightFn(right as R);
  }

  bool get isRight => !isLeft;
}
