import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Utilitaires de responsivité pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
class ResponsiveUtils {
  /// Constructeur privé pour empêcher l'instanciation
  ResponsiveUtils._();

  // Points de rupture pour différentes tailles d'écran
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  /// Obtient la largeur de l'écran
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Obtient la hauteur de l'écran
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Indique si l'écran est de taille mobile
  static bool isMobile(BuildContext context) {
    return screenWidth(context) < mobileBreakpoint;
  }

  /// Indique si l'écran est de taille tablette
  static bool isTablet(BuildContext context) {
    final width = screenWidth(context);
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Indique si l'écran est de taille desktop
  static bool isDesktop(BuildContext context) {
    return screenWidth(context) >= desktopBreakpoint;
  }

  /// Obtient un padding adaptatif basé sur la taille de l'écran
  static EdgeInsets getAdaptivePadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }

  /// Obtient un padding horizontal adaptatif
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.symmetric(horizontal: 16.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 32.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 64.0);
    }
  }

  /// Obtient une marge adaptative
  static EdgeInsets getAdaptiveMargin(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(8.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.all(16.0);
    } else {
      return const EdgeInsets.all(24.0);
    }
  }

  /// Calcule une taille de police adaptative
  static double getAdaptiveFontSize(BuildContext context, double baseFontSize) {
    final screenFactor = screenWidth(context) / 375.0; // iPhone SE comme base
    return baseFontSize * math.min(math.max(screenFactor, 0.85), 1.3);
  }

  /// Obtient un espacement adaptatif
  static double getAdaptiveSpacing(BuildContext context, double baseSpacing) {
    if (isMobile(context)) {
      return baseSpacing;
    } else if (isTablet(context)) {
      return baseSpacing * 1.5;
    } else {
      return baseSpacing * 2.0;
    }
  }

  /// Calcule le nombre de colonnes optimal pour une grille
  static int getOptimalGridColumns(BuildContext context, double itemWidth) {
    final screenWidth = ResponsiveUtils.screenWidth(context);
    final availableWidth = screenWidth - 32; // Padding des côtés
    final columns = (availableWidth / itemWidth).floor();
    return math.max(1, math.min(columns, 4)); // Entre 1 et 4 colonnes
  }

  /// Obtient une hauteur adaptative pour les cartes
  static double getAdaptiveCardHeight(BuildContext context, double baseHeight) {
    if (isMobile(context)) {
      return baseHeight;
    } else if (isTablet(context)) {
      return baseHeight * 1.2;
    } else {
      return baseHeight * 1.4;
    }
  }

  /// Obtient une largeur maximale pour le contenu
  static double getMaxContentWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    } else if (isTablet(context)) {
      return 800.0;
    } else {
      return 1200.0;
    }
  }

  /// Widget pour centrer le contenu avec une largeur maximale
  static Widget constrainedContent({
    required BuildContext context,
    required Widget child,
    double? maxWidth,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? getMaxContentWidth(context),
        ),
        child: child,
      ),
    );
  }

  /// Obtient l'orientation de l'écran
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Obtient l'orientation de l'écran
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  /// Calcule une hauteur basée sur le pourcentage de l'écran
  static double getScreenHeightPercent(BuildContext context, double percent) {
    return screenHeight(context) * (percent / 100);
  }

  /// Calcule une largeur basée sur le pourcentage de l'écran
  static double getScreenWidthPercent(BuildContext context, double percent) {
    return screenWidth(context) * (percent / 100);
  }

  /// Obtient la densité de pixels
  static double getPixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /// Indique si l'appareil a une haute densité de pixels
  static bool isHighDensity(BuildContext context) {
    return getPixelRatio(context) >= 2.0;
  }

  /// Obtient les informations sur le clavier virtuel
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  /// Obtient la hauteur disponible en excluant le clavier
  static double getAvailableHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height - 
           mediaQuery.viewInsets.bottom - 
           mediaQuery.viewPadding.top - 
           mediaQuery.viewPadding.bottom;
  }

  /// Adapte la taille d'une image selon l'écran
  static double getAdaptiveImageSize(BuildContext context, double baseSize) {
    if (isMobile(context)) {
      return baseSize;
    } else if (isTablet(context)) {
      return baseSize * 1.3;
    } else {
      return baseSize * 1.6;
    }
  }

  /// Obtient un BorderRadius adaptatif
  static BorderRadius getAdaptiveBorderRadius(BuildContext context) {
    if (isMobile(context)) {
      return BorderRadius.circular(8.0);
    } else if (isTablet(context)) {
      return BorderRadius.circular(12.0);
    } else {
      return BorderRadius.circular(16.0);
    }
  }

  /// Adapte la taille des icônes
  static double getAdaptiveIconSize(BuildContext context, double baseSize) {
    if (isMobile(context)) {
      return baseSize;
    } else if (isTablet(context)) {
      return baseSize * 1.2;
    } else {
      return baseSize * 1.4;
    }
  }
}

/// Extension pour faciliter l'utilisation des utilitaires de responsivité
extension ResponsiveContext on BuildContext {
  /// Obtient la largeur de l'écran
  double get screenWidth => ResponsiveUtils.screenWidth(this);
  
  /// Obtient la hauteur de l'écran
  double get screenHeight => ResponsiveUtils.screenHeight(this);
  
  /// Indique si l'écran est mobile
  bool get isMobile => ResponsiveUtils.isMobile(this);
  
  /// Indique si l'écran est tablette
  bool get isTablet => ResponsiveUtils.isTablet(this);
  
  /// Indique si l'écran est desktop
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
  
  /// Obtient un padding adaptatif
  EdgeInsets get adaptivePadding => ResponsiveUtils.getAdaptivePadding(this);
  
  /// Obtient un padding horizontal adaptatif
  EdgeInsets get horizontalPadding => ResponsiveUtils.getHorizontalPadding(this);
  
  /// Obtient une marge adaptative
  EdgeInsets get adaptiveMargin => ResponsiveUtils.getAdaptiveMargin(this);
  
  /// Indique si l'écran est en mode paysage
  bool get isLandscape => ResponsiveUtils.isLandscape(this);
  
  /// Indique si l'écran est en mode portrait
  bool get isPortrait => ResponsiveUtils.isPortrait(this);
  
  /// Indique si le clavier est visible
  bool get isKeyboardVisible => ResponsiveUtils.isKeyboardVisible(this);
  
  /// Obtient la hauteur disponible
  double get availableHeight => ResponsiveUtils.getAvailableHeight(this);
  
  /// Obtient un BorderRadius adaptatif
  BorderRadius get adaptiveBorderRadius => ResponsiveUtils.getAdaptiveBorderRadius(this);
}

/// Widget adaptatif pour gérer différentes mises en page
class AdaptiveLayout extends StatelessWidget {
  /// Widget pour mobile
  final Widget mobile;
  
  /// Widget pour tablette (optionnel)
  final Widget? tablet;
  
  /// Widget pour desktop (optionnel)
  final Widget? desktop;
  
  /// Constructeur
  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (ResponsiveUtils.isTablet(context) && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

/// Widget pour créer des grilles adaptatives
class AdaptiveGrid extends StatelessWidget {
  /// Liste des éléments à afficher
  final List<Widget> children;
  
  /// Largeur minimale d'un élément
  final double itemWidth;
  
  /// Espacement entre les éléments
  final double spacing;
  
  /// Espacement vertical entre les lignes
  final double runSpacing;
  
  /// Padding autour de la grille
  final EdgeInsetsGeometry? padding;

  /// Constructeur
  const AdaptiveGrid({
    super.key,
    required this.children,
    this.itemWidth = 200.0,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveUtils.getOptimalGridColumns(context, itemWidth);
    
    return Padding(
      padding: padding ?? ResponsiveUtils.getAdaptivePadding(context),
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: children.map((child) {
          return SizedBox(
            width: (context.screenWidth - (columns + 1) * spacing) / columns,
            child: child,
          );
        }).toList(),
      ),
    );
  }
}

/// Constantes pour des tailles communes
class ResponsiveSizes {
  /// Tailles de police adaptatives
  static const double titleFontSize = 24.0;
  static const double subtitleFontSize = 18.0;
  static const double bodyFontSize = 16.0;
  static const double captionFontSize = 12.0;
  
  /// Tailles d'icônes adaptatives
  static const double smallIcon = 16.0;
  static const double mediumIcon = 24.0;
  static const double largeIcon = 32.0;
  
  /// Espacements adaptatifs
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;
  
  /// Hauteurs de composants
  static const double buttonHeight = 48.0;
  static const double textFieldHeight = 56.0;
  static const double cardHeight = 120.0;
}