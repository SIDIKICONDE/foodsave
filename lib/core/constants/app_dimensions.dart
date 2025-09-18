/// Dimensions et espacements centralisés pour l'application FoodSave.
///
/// Cette classe contient toutes les constantes de taille, espacement et dimensions
/// utilisées dans l'application selon les directives strictes Dart.
///
/// Inclut également des utilitaires responsives pour adapter l'interface
/// aux différentes tailles d'écran (mobile, tablette, desktop).
///
/// Utilisation des breakpoints responsives :
/// - Mobile : < 600px
/// - Tablette : 600px - 899px
/// - Desktop : >= 900px
class AppDimensions {
  /// Constructeur privé pour empêcher l'instanciation.
  const AppDimensions._();

  // === ESPACEMENTS ===
  
  /// Espacement très très petit (2px).
  static const double spacingXXS = 2.0;
  
  /// Espacement très petit (4px).
  static const double spacingXS = 4.0;
  static const double spacingXs = 4.0;
  
  /// Espacement petit (8px).
  static const double spacingS = 8.0;
  
  /// Espacement moyen (12px).
  static const double spacingM = 12.0;
  
  /// Espacement large (16px).
  static const double spacingL = 16.0;
  
  /// Espacement extra-large - 24px.
  static const double spacingXL = 24.0;

  /// Espacement XXL - 32px.
  static const double spacingXXL = 32.0;
  
  /// Espacement extra large (32px).
  static const double spacingXxl = 32.0;
  
  /// Espacement géant (48px).
  static const double spacingGiant = 48.0;

  // === BORDURES ET RAYONS ===
  
  /// Rayon de bordure petit (4px).
  static const double radiusS = 4.0;
  
  /// Rayon de bordure moyen (8px).
  static const double radiusM = 8.0;
  
  /// Rayon de bordure large (12px).
  static const double radiusL = 12.0;
  
  /// Rayon de bordure très large (16px).
  static const double radiusXl = 16.0;
  static const double radiusXL = 16.0;
  
  /// Rayon de bordure extra large (20px).
  static const double radiusXXL = 20.0;
  
  /// Rayon de bordure pour éléments circulaires (24px).
  static const double radiusCircular = 24.0;
  
  /// Épaisseur de bordure standard (1px).
  static const double borderWidth = 1.0;
  
  /// Épaisseur de bordure épaisse (2px).
  static const double borderWidthThick = 2.0;

  // === TAILLES D'ICÔNES ===
  
  /// Taille d'icône très petite (12px).
  static const double iconXs = 12.0;
  
  /// Taille d'icône petite (16px).
  static const double iconS = 16.0;
  
  /// Taille d'icône moyenne (20px).
  static const double iconM = 20.0;
  
  /// Taille d'icône large (24px).
  static const double iconL = 24.0;
  
  /// Taille d'icône très large (32px).
  static const double iconXl = 32.0;
  
  /// Taille d'icône géante (48px).
  static const double iconGiant = 48.0;

  // === DIMENSIONS DES COMPOSANTS ===
  
  /// Hauteur minimale des boutons (44px pour accessibilité).
  static const double buttonMinHeight = 44.0;
  
  /// Hauteur des champs de saisie (48px).
  static const double inputHeight = 48.0;
  
  /// Hauteur de la barre d'application (56px).
  static const double appBarHeight = 56.0;
  
  /// Hauteur des éléments de liste (72px).
  static const double listItemHeight = 72.0;
  
  /// Largeur maximale des cartes (400px).
  static const double cardMaxWidth = 400.0;
  
  /// Hauteur des cartes de paniers (200px).
  static const double basketCardHeight = 200.0;

  // === AVATARS ET IMAGES ===
  
  /// Taille d'avatar petit (32px).
  static const double avatarS = 32.0;
  
  /// Taille d'avatar moyen (48px).
  static const double avatarM = 48.0;
  
  /// Taille d'avatar large (64px).
  static const double avatarL = 64.0;
  
  /// Taille d'avatar très large (96px).
  static const double avatarXl = 96.0;
  
  /// Hauteur des images de bannière (120px).
  static const double bannerImageHeight = 120.0;
  
  /// Hauteur des images de produits (150px).
  static const double productImageHeight = 150.0;

  // === DIALOGUES ET MODALS ===
  
  /// Largeur minimale des dialogues (280px).
  static const double dialogMinWidth = 280.0;
  
  /// Largeur maximale des dialogues (400px).
  static const double dialogMaxWidth = 400.0;
  
  /// Padding interne des dialogues.
  static const double dialogPadding = spacingXL;
  
  /// Hauteur maximale des bottom sheets (80% de l'écran).
  static const double bottomSheetMaxHeightRatio = 0.8;

  // === BARRES DE PROGRESSION ===
  
  /// Hauteur de la barre de progression fine (2px).
  static const double progressBarThin = 2.0;
  
  /// Hauteur de la barre de progression standard (4px).
  static const double progressBarStandard = 4.0;
  
  /// Hauteur de la barre de progression épaisse (8px).
  static const double progressBarThick = 8.0;

  // === OMBRES ===
  
  /// Élévation pour les cartes (2dp).
  static const double elevationCard = 2.0;
  
  /// Élévation pour les dialogues (8dp).
  static const double elevationDialog = 8.0;
  
  /// Élévation pour les éléments flottants (16dp).
  static const double elevationFloating = 16.0;
  
  /// Blur radius pour les ombres légères (4px).
  static const double shadowBlurLight = 4.0;
  
  /// Blur radius pour les ombres standards (8px).
  static const double shadowBlurStandard = 8.0;
  
  /// Offset vertical des ombres (2px).
  static const double shadowOffsetY = 2.0;

  // === RESPONSIVE BREAKPOINTS ===
  
  /// Point de rupture pour mobile (600px).
  static const double breakpointMobile = 600.0;
  
  /// Point de rupture pour tablette (900px).
  static const double breakpointTablet = 900.0;
  
  /// Point de rupture pour desktop (1200px).
  static const double breakpointDesktop = 1200.0;

  // === MÉTHODES UTILITAIRES ===
  
  /// Retourne l'espacement approprié pour le contexte donné.
  /// 
  /// [context] : Contexte de l'espacement ('tight', 'normal', 'loose').
  static double getSpacingForContext(String context) {
    switch (context.toLowerCase()) {
      case 'tight':
        return spacingS;
      case 'normal':
        return spacingL;
      case 'loose':
        return spacingXL;
      default:
        return spacingM;
    }
  }
  
  /// Retourne la taille d'icône appropriée pour le contexte donné.
  /// 
  /// [context] : Contexte de l'icône ('small', 'medium', 'large').
  static double getIconSizeForContext(String context) {
    switch (context.toLowerCase()) {
      case 'small':
        return iconS;
      case 'medium':
        return iconM;
      case 'large':
        return iconL;
      default:
        return iconM;
    }
  }
  
  /// Calcule un espacement proportionnel.
  ///
  /// [baseSpacing] : Espacement de base.
  /// [multiplier] : Multiplicateur (ex: 1.5 pour 150% de l'espacement).
  static double proportionalSpacing(double baseSpacing, double multiplier) {
    return baseSpacing * multiplier;
  }

  // === RESPONSIVE UTILITIES ===
  //
  // Exemple d'utilisation :
  // ```dart
  // final screenWidth = MediaQuery.of(context).size.width;
  // final cardWidth = AppDimensions.getBasketCardWidth(screenWidth);
  // final spacing = AppDimensions.getResponsiveSpacing(screenWidth);
  // final iconSize = AppDimensions.getResponsiveIconSize(screenWidth, AppDimensions.iconM);
  // ```

  /// Détermine si l'écran est considéré comme petit (mobile).
  ///
  /// [screenWidth] : Largeur de l'écran.
  static bool isSmallScreen(double screenWidth) => screenWidth < breakpointMobile;

  /// Détermine si l'écran est considéré comme moyen (mobile large).
  ///
  /// [screenWidth] : Largeur de l'écran.
  static bool isMediumScreen(double screenWidth) =>
      screenWidth >= breakpointMobile && screenWidth < breakpointTablet;

  /// Détermine si l'écran est considéré comme grand (tablet/desktop).
  ///
  /// [screenWidth] : Largeur de l'écran.
  static bool isLargeScreen(double screenWidth) => screenWidth >= breakpointTablet;

  /// Calcule la largeur responsive d'une carte de panier.
  ///
  /// [screenWidth] : Largeur de l'écran.
  static double getBasketCardWidth(double screenWidth) {
    if (isSmallScreen(screenWidth)) {
      return screenWidth * 0.75; // 75% sur petit écran
    } else if (isLargeScreen(screenWidth)) {
      return 200.0; // Largeur fixe sur grand écran
    } else {
      return screenWidth * 0.45; // 45% sur écran moyen
    }
  }

  /// Calcule le nombre de colonnes optimal pour une grille responsive.
  ///
  /// [screenWidth] : Largeur de l'écran.
  static int getOptimalGridColumns(double screenWidth) {
    if (isSmallScreen(screenWidth)) {
      return 1; // 1 colonne sur petit écran
    } else if (isLargeScreen(screenWidth)) {
      return 3; // 3 colonnes sur grand écran
    } else {
      return 2; // 2 colonnes sur écran moyen
    }
  }

  /// Calcule l'espacement responsive entre les éléments.
  ///
  /// [screenWidth] : Largeur de l'écran.
  static double getResponsiveSpacing(double screenWidth) {
    if (isSmallScreen(screenWidth)) {
      return spacingS; // Espacement réduit sur petit écran
    } else if (isLargeScreen(screenWidth)) {
      return spacingXL; // Espacement augmenté sur grand écran
    } else {
      return spacingM; // Espacement normal sur écran moyen
    }
  }

  /// Calcule la taille d'icône responsive.
  ///
  /// [screenWidth] : Largeur de l'écran.
  /// [baseSize] : Taille de base de l'icône.
  static double getResponsiveIconSize(double screenWidth, double baseSize) {
    if (isSmallScreen(screenWidth)) {
      return baseSize * 0.8; // 80% sur petit écran
    } else if (isLargeScreen(screenWidth)) {
      return baseSize * 1.2; // 120% sur grand écran
    } else {
      return baseSize; // 100% sur écran moyen
    }
  }

  /// Calcule la taille de texte responsive.
  ///
  /// [screenWidth] : Largeur de l'écran.
  /// [baseSize] : Taille de base du texte.
  static double getResponsiveTextSize(double screenWidth, double baseSize) {
    if (isSmallScreen(screenWidth)) {
      return baseSize * 0.9; // 90% sur petit écran
    } else if (isLargeScreen(screenWidth)) {
      return baseSize * 1.1; // 110% sur grand écran
    } else {
      return baseSize; // 100% sur écran moyen
    }
  }
}