/// Constantes utilisées dans la page de vérification d'email.
///
/// Ce fichier contient toutes les constantes statiques pour éviter
/// la répétition de valeurs magiques dans le code.
class EmailVerificationConstants {
  // Durées et délais
  static const Duration checkInterval = Duration(seconds: 3);
  static const Duration animationDuration = Duration(seconds: 2);
  static const int resendDelaySeconds = 60;

  // Animations
  static const double iconScaleBegin = 0.8;
  static const double iconScaleEnd = 1.2;

  // Chaînes de caractères
  static const String pageTitle = 'Vérifiez votre email';
  static const String pageSubtitle = 'Nous avons envoyé un email de vérification à';
  static const String instructionsTitle = 'Instructions';
  static const String resendQuestion = 'Vous n\'avez pas reçu l\'email ?';
  static const String resendButtonText = 'Renvoyer l\'email';
  static const String checkStatusButtonText = 'J\'ai vérifié mon email';
  static const String backToLoginText = 'Retour à la connexion';
  static const String contactText = 'Problème avec votre email ? Contactez-nous';
  static const String countdownText = 'Vous pourrez renvoyer l\'email dans';
  static const String countdownUnit = 's';

  // Instructions
  static const String instruction1 = 'Ouvrez votre boîte email';
  static const String instruction2 = 'Recherchez l\'email de FoodSave (vérifiez les spams)';
  static const String instruction3 = 'Cliquez sur le lien de vérification';
  static const String instruction4 = 'Revenez ici pour vous connecter';

  // Messages de succès
  static const String emailResentSuccess = 'Email de vérification renvoyé avec succès !';
  static const String emailVerifiedSuccess = 'Email vérifié avec succès ! Redirection...';
  static const String emailResentSnackBar = '✅ Email de vérification renvoyé !';
  static const String emailVerifiedSnackBar = '✅ Email vérifié ! Bienvenue sur FoodSave.';

  // Messages d'erreur
  static const String resendError = 'Erreur lors du renvoi. Veuillez réessayer.';
  static const String checkError = 'Erreur lors de la vérification. Veuillez réessayer.';
  static const String emailNotVerifiedError = 'Email pas encore vérifié. Veuillez cliquer sur le lien dans votre email.';
  static const String defaultError = 'Erreur : ';

  // Messages d'erreur Supabase localisés
  static const Map<String, String> errorTranslations = {
    'Email not confirmed': 'Email pas encore confirmé',
    'Invalid email': 'Adresse email invalide',
    'Email address is invalid': 'L\'adresse email n\'est pas valide',
    'Too many requests': 'Trop de tentatives. Veuillez réessayer plus tard',
    'Rate limit exceeded': 'Limite de demandes dépassée. Veuillez patienter',
    'User not found': 'Utilisateur non trouvé',
  };

  // Icônes
  static const double instructionIconSize = 16.0;
  static const double errorIconSize = 16.0;
  static const double successIconSize = 16.0;
}
