import 'package:flutter/material.dart';

/// Palette de couleurs centralisée pour l'application FoodSave.
/// 
/// Cette classe contient toutes les couleurs utilisées dans l'application,
/// organisées par catégorie selon les directives strictes Dart.
class AppColors {
  /// Constructeur privé pour empêcher l'instanciation.
  const AppColors._();

  // === COULEURS PRIMAIRES ===
  
  /// Couleur primaire de l'application (vert écologique).
  static const Color primary = Color(0xFF4CAF50);
  
  /// Variante claire de la couleur primaire.
  static const Color primaryLight = Color(0xFF81C784);
  
  /// Variante foncée de la couleur primaire.
  static const Color primaryDark = Color(0xFF388E3C);

  // === COULEURS SECONDAIRES ===
  
  /// Couleur secondaire (orange pour les commerçants).
  static const Color secondary = Color(0xFFFF9800);
  
  /// Variante claire de la couleur secondaire.
  static const Color secondaryLight = Color(0xFFFFB74D);
  
  /// Variante foncée de la couleur secondaire.
  static const Color secondaryDark = Color(0xFFF57C00);

  // === COULEURS D'ÉTAT ===
  
  /// Couleur de succès.
  static const Color success = Color(0xFF4CAF50);
  
  /// Couleur d'erreur.
  static const Color error = Color(0xFFF44336);
  
  /// Couleur d'avertissement.
  static const Color warning = Color(0xFFFF9800);
  
  /// Couleur d'information.
  static const Color info = Color(0xFF2196F3);

  // === COULEURS DE TEXTE ===
  
  /// Couleur de texte principal.
  static const Color textPrimary = Color(0xFF212121);
  
  /// Couleur de texte secondaire.
  static const Color textSecondary = Color(0xFF757575);
  
  /// Couleur de texte sur fond sombre.
  static const Color textOnDark = Color(0xFFFFFFFF);
  
  /// Couleur de texte désactivé.
  static const Color textDisabled = Color(0xFFBDBDBD);

  // === COULEURS DE SURFACE ===
  
  /// Couleur de fond principal.
  static const Color background = Color(0xFFFAFAFA);

  /// Couleur de fond légère.
  static const Color backgroundLight = Color(0xFFFFFFFF);
  
  /// Couleur de surface (cartes, conteneurs).
  static const Color surface = Color(0xFFFFFFFF);

  /// Couleur de surface légère.
  static const Color surfaceLight = Color(0xFFF8F8F8);
  
  /// Couleur de surface secondaire.
  static const Color surfaceSecondary = Color(0xFFF5F5F5);
  
  /// Couleur de bordure.
  static const Color border = Color(0xFFE0E0E0);

  /// Couleur de bordure légère.
  static const Color borderLight = Color(0xFFEEEEEE);
  
  /// Couleur de divider.
  static const Color divider = Color(0xFFBDBDBD);

  // === COULEURS SPÉCIFIQUES À FOODSAVE ===
  
  /// Couleur pour les éléments écologiques.
  static const Color eco = Color(0xFF66BB6A);
  
  /// Couleur pour les badges et récompenses.
  static const Color badge = Color(0xFFFFD700);
  
  /// Couleur pour les promotions et offres spéciales.
  static const Color promotion = Color(0xFFE91E63);
  
  /// Couleur pour les éléments "dernière chance".
  static const Color lastChance = Color(0xFFFF5722);
  
  /// Couleur pour les nouveaux éléments.
  static const Color newItem = Color(0xFF00BCD4);

  // === COULEURS D'OVERLAY ET TRANSPARENCE ===
  
  /// Overlay sombre avec transparence.
  static const Color overlayDark = Color(0x80000000);
  
  /// Overlay clair avec transparence.
  static const Color overlayLight = Color(0x80FFFFFF);
  
  /// Couleur de shadow légère.
  static const Color shadowLight = Color(0x1A000000);
  
  /// Couleur de shadow normale.
  static const Color shadow = Color(0x33000000);

  // === DÉGRADÉS ===
  
  /// Dégradé principal de l'application.
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
  
  /// Dégradé secondaire.
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryDark],
  );
  
  /// Dégradé écologique.
  static const LinearGradient ecoGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [eco, primary],
  );

  // === MÉTHODES UTILITAIRES ===
  
  /// Retourne une couleur avec l'opacité spécifiée.
  /// 
  /// [color] : Couleur de base.
  /// [opacity] : Opacité entre 0.0 et 1.0.
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
  
  /// Retourne la couleur de texte appropriée pour un fond donné.
  /// 
  /// [backgroundColor] : Couleur de fond.
  static Color getTextColorForBackground(Color backgroundColor) {
    final double luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? textPrimary : textOnDark;
  }
  
  /// Retourne une couleur plus claire.
  /// 
  /// [color] : Couleur de base.
  /// [amount] : Montant d'éclaircissement (0.0 à 1.0).
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    
    final int red = ((color.r * 255.0) + ((255 - (color.r * 255.0)) * amount)).round() & 0xff;
    final int green = ((color.g * 255.0) + ((255 - (color.g * 255.0)) * amount)).round() & 0xff;
    final int blue = ((color.b * 255.0) + ((255 - (color.b * 255.0)) * amount)).round() & 0xff;
    
    return Color.fromARGB((color.a * 255.0).round() & 0xff, red, green, blue);
  }
  
  /// Retourne une couleur plus foncée.
  /// 
  /// [color] : Couleur de base.
  /// [amount] : Montant d'assombrissement (0.0 à 1.0).
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');
    
    final int red = ((color.r * 255.0) * (1 - amount)).round() & 0xff;
    final int green = ((color.g * 255.0) * (1 - amount)).round() & 0xff;
    final int blue = ((color.b * 255.0) * (1 - amount)).round() & 0xff;
    
    return Color.fromARGB((color.a * 255.0).round() & 0xff, red, green, blue);
  }
}