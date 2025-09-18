import 'package:flutter/material.dart';

/// Constantes utilisées dans la page de réinitialisation de mot de passe.
///
/// Ce fichier contient toutes les constantes statiques pour éviter
/// la répétition de valeurs magiques dans le code.
class ResetPasswordConstants {
  // Dimensions et tailles
  static const double headerIconSize = 96.0; // iconGiant * 1.5
  static const double successIconSize = 48.0; // iconL
  static const double errorIconSize = 20.0; // iconS
  static const double loadingIndicatorSize = 20.0; // iconS

  // Chaînes de caractères
  static const String pageTitle = 'Mot de passe oublié ?';
  static const String pageSubtitle = 'Pas de souci ! Entrez votre adresse email et nous vous enverrons un lien pour réinitialiser votre mot de passe';
  static const String emailSentTitle = 'Email envoyé !';
  static const String emailSentSubtitle = 'Nous avons envoyé un lien de réinitialisation à votre adresse email';
  static const String emailLabel = 'Adresse email';
  static const String emailHint = 'votre@email.com';
  static const String resetButtonText = 'Envoyer le lien de réinitialisation';
  static const String backToLoginText = 'Retour à la connexion';
  static const String checkEmailTitle = 'Vérifiez votre boîte email';
  static const String checkEmailDescription = 'Un lien de réinitialisation a été envoyé à :';
  static const String notReceivedEmailText = 'Vous n\'avez pas reçu l\'email ?';
  static const String resendEmailText = 'Renvoyer l\'email';

  // Messages d'erreur
  static const String emailRequiredError = 'L\'adresse email est obligatoire';
  static const String emailInvalidError = 'Veuillez entrer une adresse email valide';
  static const String unexpectedError = 'Une erreur inattendue s\'est produite. Veuillez réessayer.';
  static const String resendError = 'Erreur lors du renvoi. Veuillez réessayer.';
  static const String resetSuccessMessage = 'Email de réinitialisation envoyé avec succès !';
  static const String resendSuccessMessage = '✅ Email renvoyé avec succès !';
  static const String resetSuccessSnackBar = '✅ Email de réinitialisation envoyé !';

  // Regex patterns
  static const String emailRegexPattern = r'^[^@]+@[^@]+\.[^@]+';

  // Traductions d'erreurs Supabase
  static const Map<String, String> errorTranslations = {
    'User not found': 'Aucun compte trouvé avec cette adresse email',
    'Invalid email': 'Adresse email invalide',
    'Email address is invalid': 'L\'adresse email n\'est pas valide',
    'Too many requests': 'Trop de tentatives. Veuillez réessayer plus tard',
    'Rate limit exceeded': 'Limite de demandes dépassée. Veuillez patienter',
  };

  // URL de redirection (à remplacer par l'URL réelle)
  static const String resetPasswordRedirectUrl = 'https://votre-app.com/reset-password';

  // Durées
  static const Duration snackBarDuration = Duration(seconds: 3);

  // Icônes
  static const IconData lockResetIcon = Icons.lock_reset_outlined;
  static const IconData emailReadIcon = Icons.mark_email_read_outlined;
  static const IconData checkCircleIcon = Icons.check_circle_outline;
  static const IconData errorOutlineIcon = Icons.error_outline;
  static const IconData arrowBackIcon = Icons.arrow_back;
  static const IconData emailIcon = Icons.email_outlined;
}
