/// Constantes utilisées dans la page d'inscription commerçant.
///
/// Ce fichier contient toutes les constantes statiques pour éviter
/// la répétition de valeurs magiques dans le code.
class MerchantRegisterConstants {
  // Dimensions
  static const int minNameLength = 2;
  static const int minPasswordLength = 6;
  static const int minPhoneLength = 10;
  static const int headerIconSize = 50;
  static const int headerContainerSize = 100;
  static const int loadingIndicatorSize = 20;

  // Chaînes de caractères
  static const String pageTitle = 'Compte Commerçant';
  static const String pageSubtitle = 'Valorisez vos invendus et réduisez vos pertes';
  static const String registerButtonText = 'Créer mon compte commerçant';
  static const String successDialogTitle = 'Demande d\'inscription envoyée !';
  static const String successDialogContent =
      'Votre demande de compte commerçant a été soumise avec succès. '
      'Notre équipe va examiner votre dossier et vous contacter dans les 48h pour activer votre compte. '
      'Vérifiez également vos emails pour confirmer votre adresse.';
  static const String termsAndConditions =
      'En créant un compte commerçant, vous acceptez nos conditions d\'utilisation et notre politique de confidentialité. Votre compte sera soumis à validation avant activation. Vous pourrez ensuite proposer vos paniers anti-gaspi à nos utilisateurs.';

  // Labels des champs
  static const String managerNameLabel = 'Nom du responsable';
  static const String managerNameHint = 'Entrez le nom du responsable';
  static const String businessNameLabel = 'Nom du commerce';
  static const String businessNameHint = 'Entrez le nom de votre commerce';
  static const String phoneLabel = 'Téléphone';
  static const String phoneHint = '+33 1 23 45 67 89';
  static const String emailLabel = 'Email professionnel';
  static const String emailHint = 'contact@moncommerce.com';
  static const String passwordLabel = 'Mot de passe';
  static const String passwordHint = 'Minimum 6 caractères';
  static const String confirmPasswordLabel = 'Confirmer le mot de passe';
  static const String confirmPasswordHint = 'Répétez votre mot de passe';

  // Messages d'erreur
  static const String managerNameRequiredError = 'Veuillez entrer le nom du responsable';
  static const String managerNameTooShortError = 'Le nom doit contenir au moins 2 caractères';
  static const String businessNameRequiredError = 'Veuillez entrer le nom de votre commerce';
  static const String businessNameTooShortError = 'Le nom du commerce doit contenir au moins 2 caractères';
  static const String phoneRequiredError = 'Veuillez entrer votre numéro de téléphone';
  static const String phoneTooShortError = 'Veuillez entrer un numéro de téléphone valide';
  static const String emailRequiredError = 'Veuillez entrer votre email professionnel';
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
  static const String understandButtonText = 'Compris';

  // Regex patterns
  static const String emailRegexPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
}
