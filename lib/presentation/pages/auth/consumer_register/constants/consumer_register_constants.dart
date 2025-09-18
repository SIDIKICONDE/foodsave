/// Constantes utilisées dans la page d'inscription consommateur.
///
/// Ce fichier contient toutes les constantes statiques pour éviter
/// la répétition de valeurs magiques dans le code.
class ConsumerRegisterConstants {
  // Dimensions
  static const int minNameLength = 2;
  static const int minPasswordLength = 6;
  static const int headerIconSize = 50;
  static const int headerContainerSize = 100;
  static const int loadingIndicatorSize = 20;

  // Chaînes de caractères
  static const String pageTitle = 'Compte Consommateur';
  static const String pageSubtitle = 'Découvrez des paniers anti-gaspi près de chez vous';
  static const String registerButtonText = 'Créer mon compte consommateur';
  static const String successDialogTitle = 'Compte consommateur créé !';
  static const String successDialogContent =
      'Votre compte consommateur a été créé avec succès. '
      'Vérifiez votre email pour confirmer votre inscription, '
      'puis connectez-vous pour découvrir des paniers anti-gaspi près de chez vous !';
  static const String termsAndConditions =
      'En créant un compte consommateur, vous acceptez nos conditions d\'utilisation et notre politique de confidentialité. Vous pourrez découvrir et acheter des paniers anti-gaspi auprès de nos commerçants partenaires.';

  // Labels des champs
  static const String nameLabel = 'Nom complet';
  static const String nameHint = 'Entrez votre nom complet';
  static const String emailLabel = 'Email';
  static const String emailHint = 'votre@email.com';
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

  // Boutons
  static const String connectButtonText = 'Se connecter';
}
