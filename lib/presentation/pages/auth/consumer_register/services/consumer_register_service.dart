import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:foodsave_app/presentation/pages/auth/consumer_register/constants/consumer_register_constants.dart';

/// Service gérant la logique métier de l'inscription consommateur.
///
/// Cette classe encapsule toute la logique d'inscription et de validation
/// pour séparer les responsabilités et faciliter les tests unitaires.
class ConsumerRegisterService {
  /// Inscrit un nouveau consommateur avec les informations fournies.
  ///
  /// [name] - Le nom complet du consommateur
  /// [email] - L'adresse email du consommateur
  /// [password] - Le mot de passe du consommateur
  ///
  /// Retourne un [Either] contenant soit une erreur, soit la réponse d'inscription.
  static Future<Either<String, AuthResponse>> registerConsumer({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final result = await Supabase.instance.client.auth.signUp(
        email: email.trim(),
        password: password,
        data: <String, dynamic>{
          'full_name': name.trim(),
          'app_name': 'FoodSave',
          'user_type': 'consumer',
          'created_at': DateTime.now().toIso8601String(),
        },
      );
      return Either.right(result);
    } catch (error) {
      return Either.left(ConsumerRegisterConstants.unexpectedError);
    }
  }

  /// Valide le nom fourni.
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ConsumerRegisterConstants.nameRequiredError;
    }
    if (value.trim().length < ConsumerRegisterConstants.minNameLength) {
      return ConsumerRegisterConstants.nameTooShortError;
    }
    return null;
  }

  /// Valide l'email fourni.
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ConsumerRegisterConstants.emailRequiredError;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return ConsumerRegisterConstants.emailInvalidError;
    }
    return null;
  }

  /// Valide le mot de passe fourni.
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return ConsumerRegisterConstants.passwordRequiredError;
    }
    if (value.length < ConsumerRegisterConstants.minPasswordLength) {
      return ConsumerRegisterConstants.passwordTooShortError;
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
      return ConsumerRegisterConstants.confirmPasswordRequiredError;
    }
    if (confirmPassword != password) {
      return ConsumerRegisterConstants.passwordMismatchError;
    }
    return null;
  }

  /// Convertit les messages d'erreur Supabase en français.
  ///
  /// [error] - Le message d'erreur original
  ///
  /// Retourne le message d'erreur localisé.
  static String getLocalizedErrorMessage(String error) {
    final String lowerError = error.toLowerCase();

    if (lowerError.contains('email')) {
      return ConsumerRegisterConstants.emailAlreadyUsedError;
    }
    if (lowerError.contains('password')) {
      return ConsumerRegisterConstants.weakPasswordError;
    }
    if (lowerError.contains('network')) {
      return ConsumerRegisterConstants.networkError;
    }

    return '${ConsumerRegisterConstants.registrationError}$error';
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
