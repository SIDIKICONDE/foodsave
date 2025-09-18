/// Constantes utilisées dans la page d'inscription générale.
///
/// Ce fichier contient toutes les constantes statiques pour éviter
/// la répétition de valeurs magiques dans le code.
class RegisterConstants {
  // Dimensions
  static const int minNameLength = 2;
  static const int minPasswordLength = 6;
  static const int logoSize = 80;
  static const int loadingIndicatorSize = 20;

  // Chaînes de caractères
  static const String pageTitle = 'Inscription';
  static const String pageHeading = 'Rejoignez FoodSave';
  static const String pageSubtitle = 'Créez votre compte pour lutter contre le gaspillage alimentaire';
  static const String userTypeSectionTitle = 'Type de compte';
  static const String createAccountButtonText = 'Créer mon compte';
  static const String alreadyHaveAccountText = 'Déjà un compte ? ';
  static const String loginButtonText = 'Se connecter';
  static const String termsAndConditions = 'En créant un compte, vous acceptez nos conditions d\'utilisation et notre politique de confidentialité.';

  // Types d'utilisateur
  static const String consumerTitle = 'Consommateur';
  static const String consumerSubtitle = 'Je recherche des paniers anti-gaspi';
  static const String merchantTitle = 'Commerçant';
  static const String merchantSubtitle = 'Je propose mes invendus à prix réduit';

  // Labels des champs
  static const String nameLabel = 'Nom complet';
  static const String nameHint = 'Entrez votre nom complet';
  static const String emailLabel = 'Email';
  static const String emailHint = 'exemple@email.com';
  static const String passwordLabel = 'Mot de passe';
  static const String passwordHint = 'Minimum 6 caractères';
  static const String confirmPasswordLabel = 'Confirmer le mot de passe';
  static const String confirmPasswordHint = 'Répétez votre mot de passe';

  // Messages d'erreur
  static const String nameRequiredError = 'Veuillez entrer votre nom complet';
  static const String nameTooShortError = 'Le nom doit contenir au moins 2 caractères';
  static const String emailRequiredError = 'Veuillez entrer votre email';
  static const String emailInvalidError = 'Veuillez entrer un email valide';
  static const String passwordRequiredError = 'Veuillez entrer un mot de passe';
  static const String passwordTooShortError = 'Le mot de passe doit contenir au moins 6 caractères';
  static const String passwordMismatchError = 'Les mots de passe ne correspondent pas';
  static const String confirmPasswordRequiredError = 'Veuillez confirmer votre mot de passe';
  static const String registrationError = 'Erreur lors de l\'inscription : ';
  static const String unexpectedError = 'Une erreur inattendue s\'est produite. Veuillez réessayer.';
  static const String accountCreationError = 'Erreur lors de la création du compte. Veuillez réessayer.';

  // Messages d'erreur Supabase localisés
  static const String emailAlreadyUsedError = 'Cette adresse email est déjà utilisée ou invalide.';
  static const String weakPasswordError = 'Le mot de passe est trop faible. Utilisez au moins 6 caractères.';
  static const String networkError = 'Problème de connexion. Vérifiez votre connexion internet.';

  // Messages de succès
  static const String successDialogTitle = 'Compte créé !';
  static const String successDialogContent =
      'Votre compte a été créé avec succès. '
      'Vérifiez votre email pour confirmer votre inscription, '
      'puis connectez-vous à votre compte.';
  static const String successDialogButton = 'Se connecter';

  // Regex patterns
  static const String emailRegexPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
}
