import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:foodsave_app/presentation/pages/auth/email_verification/constants/email_verification_constants.dart';

/// Service gérant la logique métier de la vérification d'email.
///
/// Cette classe encapsule toute la logique de vérification d'email
/// pour séparer les responsabilités et faciliter les tests unitaires.
class EmailVerificationService {
  /// Renvoie l'email de vérification.
  ///
  /// [email] - L'adresse email à vérifier
  ///
  /// Retourne un Either contenant soit une erreur, soit un succès.
  static Future<Either<String, void>> resendVerificationEmail(String email) async {
    try {
      await Supabase.instance.client.auth.resend(
        type: OtpType.signup,
        email: email,
      );
      return Either.right(() {}); // Success without value
    } catch (error) {
      return Either.left(_getLocalizedErrorMessage(error.toString()));
    }
  }

  /// Vérifie le statut de vérification de l'email.
  ///
  /// Retourne un Either contenant soit une erreur, soit le statut de vérification.
  static Future<Either<String, bool>> checkEmailVerificationStatus() async {
    try {
      // Rafraîchit la session utilisateur
      await Supabase.instance.client.auth.refreshSession();

      final User? user = Supabase.instance.client.auth.currentUser;

      if (user?.emailConfirmedAt != null) {
        return Either.right(true); // Email vérifié
      } else {
        return Either.left(EmailVerificationConstants.emailNotVerifiedError);
      }
    } catch (error) {
      return Either.left(_getLocalizedErrorMessage(error.toString()));
    }
  }

  /// Traduit les messages d'erreur en français.
  ///
  /// [originalMessage] - Le message d'erreur original
  ///
  /// Retourne le message d'erreur localisé.
  static String _getLocalizedErrorMessage(String originalMessage) {
    // Recherche dans les traductions prédéfinies
    for (final entry in EmailVerificationConstants.errorTranslations.entries) {
      if (originalMessage.contains(entry.key)) {
        return entry.value;
      }
    }

    // Retour du message par défaut si aucune traduction trouvée
    return '${EmailVerificationConstants.defaultError}$originalMessage';
  }

  /// Valide le format d'une adresse email.
  ///
  /// [email] - L'adresse email à valider
  ///
  /// Retourne true si l'email est valide.
  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Formate le temps restant pour le compte à rebours.
  ///
  /// [seconds] - Le nombre de secondes restantes
  ///
  /// Retourne une chaîne formatée.
  static String formatCountdown(int seconds) {
    return '$seconds${EmailVerificationConstants.countdownUnit}';
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
