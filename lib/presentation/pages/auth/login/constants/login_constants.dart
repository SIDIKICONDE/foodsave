/// Constantes utilisées dans la page de connexion.
///
/// Ce fichier contient toutes les constantes statiques pour éviter
/// la répétition de valeurs magiques dans le code.
class LoginConstants {
  // Dimensions
  static const double minHeightFactor = 0.8;
  static const int snackbarDurationMs = 3000;

  // Chaînes de caractères
  static const String appName = 'FoodSave';
  static const String loginSubtitle = 'Votre partenaire anti-gaspillage';
  static const String emailPlaceholder = 'Email';
  static const String passwordPlaceholder = 'Mot de passe';
  static const String forgotPasswordText = 'Mot de passe oublié ?';
  static const String loginButtonText = 'Se connecter';
  static const String continueWithoutAccountText = 'Continuer sans compte';
  static const String noAccountText = 'Pas de compte ?';
  static const String signupButtonText = 'S\'inscrire';
  static const String initializationText = 'Initialisation...';
  static const String welcomeMessage = 'Bienvenue ';

  // Messages de validation
  static const String emailRequiredError = 'Veuillez entrer votre email';
  static const String emailInvalidError = 'Adresse email invalide';
  static const String passwordRequiredError = 'Veuillez entrer votre mot de passe';
  static const String passwordTooShortError = 'Le mot de passe doit contenir au moins 6 caractères';

  // Regex patterns
  static const String emailRegexPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
}
