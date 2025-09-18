import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:foodsave_app/presentation/pages/auth/reset_password/constants/reset_password_constants.dart';

/// Service gérant la logique métier de la réinitialisation de mot de passe.
///
/// Cette classe encapsule toute la logique de réinitialisation et de validation
/// pour séparer les responsabilités et faciliter les tests unitaires.
class ResetPasswordService {
  /// Envoie un email de réinitialisation de mot de passe.
  ///
  /// [email] - L'adresse email de l'utilisateur
  ///
  /// Retourne un Either contenant soit une erreur, soit un succès.
  static Future<Either<String, void>> sendResetPasswordEmail({
    required String email,
  }) async {
    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email.trim(),
        redirectTo: ResetPasswordConstants.resetPasswordRedirectUrl,
      );
      return Either.right(null);
    } catch (error) {
      return Either.left(ResetPasswordConstants.unexpectedError);
    }
  }

  /// Valide l'email fourni.
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ResetPasswordConstants.emailRequiredError;
    }
    if (!RegExp(ResetPasswordConstants.emailRegexPattern).hasMatch(value.trim())) {
      return ResetPasswordConstants.emailInvalidError;
    }
    return null;
  }

  /// Traduit les messages d'erreur Supabase en français.
  ///
  /// [originalMessage] - Le message d'erreur original
  ///
  /// Retourne le message d'erreur localisé.
  static String getLocalizedErrorMessage(String originalMessage) {
    return ResetPasswordConstants.errorTranslations[originalMessage] ??
           'Erreur : $originalMessage';
  }

  /// Valide tous les champs du formulaire de réinitialisation.
  ///
  /// [email] - L'adresse email
  ///
  /// Retourne une map des erreurs, vide si tout est valide.
  static Map<String, String?> validateResetForm({
    required String email,
  }) {
    return {
      'email': validateEmail(email),
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

  /// Vérifie si l'erreur est liée à Supabase Auth.
  ///
  /// [error] - L'erreur à vérifier
  ///
  /// Retourne true si c'est une AuthException.
  static bool isAuthException(dynamic error) {
    return error is AuthException;
  }

  /// Extrait le message d'une AuthException.
  ///
  /// [error] - L'AuthException
  ///
  /// Retourne le message de l'exception.
  static String getAuthExceptionMessage(AuthException error) {
    return error.message;
  }
}

/// Classe utilitaire pour gérer les types Either (succès/erreur).
class Either<L, R> {
  final L? left;
  final R? right;
  final bool isLeft;

  Either._(this.left, this.right, this.isLeft);

  factory Either.left(L value) => Either._(value, null, true);
  factory Either.right(R? value) => Either._(null, value, false);

  T fold<T>(T Function(L) leftFn, T Function(R?) rightFn) {
    return isLeft ? leftFn(left as L) : rightFn(right);
  }

  bool get isRight => !isLeft;
}
