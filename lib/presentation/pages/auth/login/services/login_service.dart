import 'package:foodsave_app/presentation/pages/auth/login/constants/login_constants.dart';

/// Service gérant la logique métier de la page de connexion.
///
/// Cette classe encapsule toute la logique de validation et de traitement
/// pour séparer les responsabilités et faciliter les tests unitaires.
class LoginService {
  /// Valide l'email fourni.
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return LoginConstants.emailRequiredError;
    }
    if (!RegExp(LoginConstants.emailRegexPattern).hasMatch(value)) {
      return LoginConstants.emailInvalidError;
    }
    return null;
  }

  /// Valide le mot de passe fourni.
  ///
  /// Retourne null si valide, sinon un message d'erreur.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return LoginConstants.passwordRequiredError;
    }
    if (value.length < 6) {
      return LoginConstants.passwordTooShortError;
    }
    return null;
  }

  /// Valide tous les champs du formulaire de connexion.
  ///
  /// [email] - L'adresse email
  /// [password] - Le mot de passe
  ///
  /// Retourne une map des erreurs, vide si tout est valide.
  static Map<String, String?> validateLoginForm({
    required String email,
    required String password,
  }) {
    return {
      'email': validateEmail(email),
      'password': validatePassword(password),
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

  /// Nettoie et prépare l'email pour l'envoi.
  ///
  /// [email] - L'adresse email brute
  ///
  /// Retourne l'email nettoyé.
  static String prepareEmail(String email) {
    return email.trim().toLowerCase();
  }

  /// Prépare le mot de passe pour l'envoi.
  ///
  /// [password] - Le mot de passe brut
  ///
  /// Retourne le mot de passe tel quel (pas de modification nécessaire).
  static String preparePassword(String password) {
    return password;
  }
}
