import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:foodsave_app/domain/entities/user.dart';
import 'package:foodsave_app/presentation/pages/auth/register/constants/register_constants.dart';

/// Service gérant la logique métier de l'inscription générale.
///
/// Cette classe encapsule toute la logique d'inscription et de validation
/// pour séparer les responsabilités et faciliter les tests unitaires.
class RegisterService {
  /// Inscrit un nouveau utilisateur avec les informations fournies.
  ///
  /// [name] - Le nom complet de l'utilisateur
  /// [email] - L'adresse email de l'utilisateur
  /// [password] - Le mot de passe de l'utilisateur
  /// [userType] - Le type d'utilisateur (consommateur/commerçant)
  ///
  /// Retourne un Either contenant soit une erreur, soit la réponse d'inscription.
  static Future<Either<String, AuthResponse>> registerUser({
    required String name,
    required String email,
    required String password,
    required UserType userType,
  }) async {
    try {
      final result = await Supabase.instance.client.auth.signUp(
        email: email.trim(),
        password: password,
        data: <String, dynamic>{
          'full_name': name.trim(),
          'app_name': 'FoodSave',
          'user_type': userType.name,
          'created_at': DateTime.now().toIso8601String(),
        },
      );
      return Either.right(result);
    } catch (error) {
      return Either.left(RegisterConstants.unexpectedError);
    }
  }

  /// Valide le nom fourni.
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return RegisterConstants.nameRequiredError;
    }
    if (value.trim().length < RegisterConstants.minNameLength) {
      return RegisterConstants.nameTooShortError;
    }
    return null;
  }

  /// Valide l'email fourni.
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return RegisterConstants.emailRequiredError;
    }
    if (!RegExp(RegisterConstants.emailRegexPattern).hasMatch(value.trim())) {
      return RegisterConstants.emailInvalidError;
    }
    return null;
  }

  /// Valide le mot de passe fourni.
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return RegisterConstants.passwordRequiredError;
    }
    if (value.length < RegisterConstants.minPasswordLength) {
      return RegisterConstants.passwordTooShortError;
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
      return RegisterConstants.confirmPasswordRequiredError;
    }
    if (confirmPassword != password) {
      return RegisterConstants.passwordMismatchError;
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
      return RegisterConstants.emailAlreadyUsedError;
    }
    if (lowerMessage.contains('password')) {
      return RegisterConstants.weakPasswordError;
    }
    if (lowerMessage.contains('network')) {
      return RegisterConstants.networkError;
    }

    return '${RegisterConstants.registrationError}$originalMessage';
  }

  /// Valide tous les champs du formulaire d'inscription.
  ///
  /// [name] - Le nom de l'utilisateur
  /// [email] - L'adresse email
  /// [password] - Le mot de passe
  /// [confirmPassword] - La confirmation du mot de passe
  ///
  /// Retourne une map des erreurs, vide si tout est valide.
  static Map<String, String?> validateRegistrationForm({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return {
      'name': validateName(name),
      'email': validateEmail(email),
      'password': validatePassword(password),
      'confirmPassword': validateConfirmPassword(confirmPassword, password),
    };
  }

  /// Vérifie si le formulaire est valide.
  ///
  /// [errors] - Map des erreurs de validation
  ///
  /// Retourne true si aucune erreur n'est présente.
  static bool isFormValid(Map<String, String?> errors) {
    return errors.values.every((error) => error == null);
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
