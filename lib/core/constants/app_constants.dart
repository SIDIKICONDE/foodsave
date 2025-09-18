/// Constantes globales de l'application FoodSave.
/// 
/// Cette classe contient toutes les constantes utilisées dans l'application,
/// organisées par catégorie pour faciliter la maintenance.
class AppConstants {
  /// Constructeur privé pour empêcher l'instanciation.
  const AppConstants._();

  // === TEXTES DE L'APPLICATION ===
  
  /// Nom de l'application.
  static const String appName = 'FoodSave';
  
  /// Slogan de l'application.
  static const String appSlogan = 'Sauvons la planète, un panier à la fois';

  // === CONNEXION/AUTHENTIFICATION ===
  
  /// Titre de la page de connexion.
  static const String loginTitle = 'Connexion';
  
  /// Sous-titre de la page de connexion.
  static const String loginSubtitle = 'Connectez-vous à votre compte $appName';
  
  /// Titre de la page d'inscription.
  static const String signupTitle = 'Créer un compte';
  
  /// Sous-titre de la page d'inscription.
  static const String signupSubtitle = 'Rejoignez la communauté $appName';
  
  /// Texte du bouton de connexion.
  static const String loginButtonText = 'Se connecter';
  
  /// Texte du bouton d'inscription.
  static const String signupButtonText = 'Créer un compte';
  
  /// Texte du bouton "Continuer sans compte".
  static const String continueWithoutAccountText = 'Continuer sans compte';
  
  /// Texte du lien vers l'inscription.
  static const String noAccountText = 'Pas encore de compte ?';
  
  /// Texte du lien vers la connexion.
  static const String hasAccountText = 'Déjà un compte ?';
  
  /// Texte du lien "Mot de passe oublié".
  static const String forgotPasswordText = 'Mot de passe oublié ?';
  
  /// Placeholder pour l'email.
  static const String emailPlaceholder = 'Adresse email';
  
  /// Placeholder pour le mot de passe.
  static const String passwordPlaceholder = 'Mot de passe';
  
  /// Placeholder pour confirmer le mot de passe.
  static const String confirmPasswordPlaceholder = 'Confirmer le mot de passe';
  
  // === ONBOARDING ===
  
  /// Titre de la page de bienvenue.
  static const String welcomeTitle = 'Bienvenue sur $appName';
  
  /// Description de la page de bienvenue.
  static const String welcomeDescription = 
      'Rejoignez la révolution anti-gaspillage alimentaire et découvrez '
      'des paniers surprise à prix réduits près de chez vous.';
  
  /// Titre de la page de sélection du type de compte.
  static const String accountTypeTitle = 'Quel est votre profil ?';
  
  /// Description consommateur.
  static const String consumerDescription = 
      'Découvrez des paniers anti-gaspi près de chez vous';
  
  /// Description commerçant.
  static const String merchantDescription = 
      'Proposez vos invendus et réduisez le gaspillage';
  
  /// Description mode invité.
  static const String guestDescription = 
      'Explorez l\'application sans créer de compte';

  // === NAVIGATION PRINCIPALE ===
  
  /// Libellé de l'onglet Découverte.
  static const String discoveryTabLabel = 'Découverte';
  
  /// Libellé de l'onglet Paniers.
  static const String basketsTabLabel = 'Paniers';
  
  /// Libellé de l'onglet Profil.
  static const String profileTabLabel = 'Profil';
  
  /// Libellé de l'onglet Social.
  static const String socialTabLabel = 'Social';
  
  // === PAGE D'ACCUEIL ===
  
  /// Titre de bienvenue sur la page d'accueil.
  static const String homeWelcomeTitle = 'Bonjour';
  
  /// Sous-titre de la page d'accueil.
  static const String homeSubtitle = 'Découvrez les paniers anti-gaspi près de chez vous';
  
  /// Titre de la section paniers du jour.
  static const String todayBasketsTitle = 'Paniers du jour';
  
  /// Titre de la section commerces favoris.
  static const String favoriteStoresTitle = 'Vos commerces favoris';
  
  /// Titre des statistiques personnelles.
  static const String personalStatsTitle = 'Votre impact écologique';
  
  /// Unité pour les kilogrammes.
  static const String kgUnit = 'kg';
  
  /// Unité pour le CO2.
  static const String co2Unit = 'kg CO₂';
  
  /// Texte "sauvés".
  static const String savedText = 'sauvés';
  
  /// Texte "évités".
  static const String avoidedText = 'évités';

  // === PRÉFÉRENCES ALIMENTAIRES ===
  
  /// Liste des préférences alimentaires disponibles.
  static const List<String> availablePreferences = [
    'Végétarien',
    'Végan',
    'Sans gluten',
    'Bio',
    'Local',
    'Sans lactose',
    'Halal',
    'Casher',
  ];
  
  /// Liste des allergènes courants.
  static const List<String> commonAllergens = [
    'Arachides',
    'Fruits à coque',
    'Lait',
    'Œufs',
    'Poisson',
    'Crustacés',
    'Soja',
    'Gluten',
    'Sésame',
    'Moutarde',
    'Céleri',
    'Lupin',
    'Mollusques',
    'Anhydride sulfureux',
  ];

  // === URLS ET ENDPOINTS ===
  
  /// URL de base de l'API (développement).
  static const String baseUrlDev = 'https://dev-api.foodsave.app';
  
  /// URL de base de l'API (production).
  static const String baseUrlProd = 'https://api.foodsave.app';

  // === DURÉES ET TIMEOUTS ===
  
  /// Timeout par défaut pour les requêtes réseau (en secondes).
  static const int defaultTimeoutSeconds = 30;
  
  /// Durée d'affichage des snackbars (en millisecondes).
  static const int snackbarDurationMs = 3000;
  
  /// Durée de l'animation de transition (en millisecondes).
  static const int transitionDurationMs = 300;

  // === STOCKAGE LOCAL ===
  
  /// Clé pour le stockage de l'état d'onboarding.
  static const String onboardingCompletedKey = 'onboarding_completed';
  
  /// Clé pour le stockage des données utilisateur.
  static const String userDataKey = 'user_data';
  
  /// Clé pour le stockage du token d'authentification.
  static const String authTokenKey = 'auth_token';

  // === GAMIFICATION ===
  
  /// Points attribués pour la première connexion.
  static const int firstLoginPoints = 50;
  
  /// Points attribués pour une réservation.
  static const int reservationPoints = 10;
  
  /// Points attribués pour un avis laissé.
  static const int reviewPoints = 5;
  
  /// Seuil de points pour le niveau Silver.
  static const int silverLevelThreshold = 500;
  
  /// Seuil de points pour le niveau Gold.
  static const int goldLevelThreshold = 1500;

  // === FILTRES ET RECHERCHE ===
  
  /// Types de commerce disponibles pour les filtres.
  static const List<String> commerceTypes = [
    'Boulangerie',
    'Restaurant',
    'Fruits & Légumes',
    'Supermarché',
    'Boucherie',
    'Poissonnerie',
    'Pâtisserie',
    'Traiteur',
    'Café',
    'Épicerie',
  ];
  
  /// Options de tri disponibles.
  static const Map<String, String> sortOptions = {
    'proximity': 'Proximité',
    'price': 'Prix croissant',
    'discount': 'Réduction',
    'newest': 'Plus récents',
    'rating': 'Note',
    'expiry': 'Expiration proche',
  };
  
  /// Plages de réduction prédéfinies.
  static const List<Map<String, dynamic>> discountRanges = [
    {'label': 'Toutes réductions', 'min': 0, 'max': 100},
    {'label': '30% ou plus', 'min': 30, 'max': 100},
    {'label': '50% ou plus', 'min': 50, 'max': 100},
    {'label': '70% ou plus', 'min': 70, 'max': 100},
  ];
  
  /// Distance maximale par défaut (en km).
  static const double defaultMaxDistance = 5.0;
  
  /// Prix maximal par défaut pour les filtres.
  static const double defaultMaxPrice = 50.0;
  
  /// Recherches populaires suggérées.
  static const List<String> popularSearches = [
    'boulangerie',
    'fruits et légumes',
    'restaurant',
    'bio',
    'vegan',
    'sans gluten',
    'dernière chance',
    'pizza',
    'sandwich',
    'pâtisserie',
  ];
  
  // === PAGINATION ===
  
  /// Nombre d'éléments par page par défaut.
  static const int defaultPageSize = 20;
  
  /// Nombre maximum d'éléments par page.
  static const int maxPageSize = 50;
}
