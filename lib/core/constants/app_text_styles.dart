import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';

/// Styles de texte centralisés pour l'application FoodSave.
/// 
/// Cette classe contient tous les styles de texte utilisés dans l'application,
/// organisés par catégorie selon les directives strictes Dart.
class AppTextStyles {
  /// Constructeur privé pour empêcher l'instanciation.
  const AppTextStyles._();

  // === TITRES PRINCIPAUX ===
  
  /// Style pour les titres de niveau 1 (headlines).
  static const TextStyle headline1 = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );
  
  /// Style pour les titres de niveau 2.
  static const TextStyle headline2 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.25,
    height: 1.3,
  );
  
  /// Style pour les titres de niveau 3.
  static const TextStyle headline3 = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.0,
    height: 1.3,
  );
  
  /// Style pour les titres de niveau 4.
  static const TextStyle headline4 = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.25,
    height: 1.4,
  );
  
  /// Style pour les titres de niveau 5.
  static const TextStyle headline5 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.0,
    height: 1.4,
  );
  
  /// Style pour les titres de niveau 6.
  static const TextStyle headline6 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.15,
    height: 1.5,
  );

  // === TEXTE DE CORPS ===
  
  /// Style pour le texte de corps large.
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.6,
  );
  
  /// Style pour le texte de corps moyen.
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    letterSpacing: 0.25,
    height: 1.5,
  );
  
  /// Style pour le texte de corps petit.
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
    height: 1.4,
  );

  // === LABELS ET LÉGENDES ===
  
  /// Style pour les labels larges.
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 1.25,
    height: 1.4,
  );
  
  /// Style pour les labels moyens.
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 1.5,
    height: 1.3,
  );
  
  /// Style pour les labels petits.
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 1.5,
    height: 1.3,
  );

  // === STYLES SPÉCIALISÉS FOODSAVE ===
  
  /// Style pour les prix.
  static const TextStyle price = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    letterSpacing: 0.0,
    height: 1.2,
  );
  
  /// Style pour les prix barrés.
  static const TextStyle priceStriked = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    letterSpacing: 0.0,
    height: 1.2,
    decoration: TextDecoration.lineThrough,
  );
  
  /// Style pour les badges.
  static const TextStyle badge = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnDark,
    letterSpacing: 0.5,
    height: 1.2,
  );
  
  /// Style pour les éléments "dernière chance".
  static const TextStyle lastChance = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    color: AppColors.lastChance,
    letterSpacing: 0.5,
    height: 1.2,
  );
  
  /// Style pour les nouveaux éléments.
  static const TextStyle newItem = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    color: AppColors.newItem,
    letterSpacing: 0.5,
    height: 1.2,
  );

  // === BOUTONS ===
  
  /// Style pour les boutons primaires.
  static const TextStyle buttonPrimary = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnDark,
    letterSpacing: 1.25,
    height: 1.0,
  );
  
  /// Style pour les boutons secondaires.
  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    letterSpacing: 1.25,
    height: 1.0,
  );
  
  /// Style pour les liens.
  static const TextStyle link = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.primary,
    letterSpacing: 0.25,
    height: 1.4,
    decoration: TextDecoration.underline,
  );

  // === MESSAGES D'ERREUR ET SUCCÈS ===
  
  /// Style pour les messages d'erreur.
  static const TextStyle error = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
    letterSpacing: 0.25,
    height: 1.3,
  );
  
  /// Style pour les messages de succès.
  static const TextStyle success = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.success,
    letterSpacing: 0.25,
    height: 1.3,
  );
  
  /// Style pour les messages d'avertissement.
  static const TextStyle warning = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.warning,
    letterSpacing: 0.25,
    height: 1.3,
  );

  // === MÉTHODES UTILITAIRES ===
  
  /// Retourne un style de texte avec une couleur personnalisée.
  /// 
  /// [baseStyle] : Style de base.
  /// [color] : Nouvelle couleur.
  static TextStyle withColor(TextStyle baseStyle, Color color) {
    return baseStyle.copyWith(color: color);
  }
  
  /// Retourne un style de texte avec une taille personnalisée.
  /// 
  /// [baseStyle] : Style de base.
  /// [fontSize] : Nouvelle taille de police.
  static TextStyle withFontSize(TextStyle baseStyle, double fontSize) {
    return baseStyle.copyWith(fontSize: fontSize);
  }
  
  /// Retourne un style de texte avec un poids personnalisé.
  /// 
  /// [baseStyle] : Style de base.
  /// [fontWeight] : Nouveau poids de police.
  static TextStyle withFontWeight(TextStyle baseStyle, FontWeight fontWeight) {
    return baseStyle.copyWith(fontWeight: fontWeight);
  }
  
  /// Crée un style de texte responsive basé sur la taille d'écran.
  /// 
  /// [baseStyle] : Style de base.
  /// [screenWidth] : Largeur de l'écran.
  static TextStyle responsive(TextStyle baseStyle, double screenWidth) {
    if (screenWidth < 600) {
      // Mobile : réduction de 10%
      return baseStyle.copyWith(
        fontSize: (baseStyle.fontSize ?? 14.0) * 0.9,
      );
    } else if (screenWidth > 1200) {
      // Desktop : augmentation de 10%
      return baseStyle.copyWith(
        fontSize: (baseStyle.fontSize ?? 14.0) * 1.1,
      );
    }
    // Tablette : pas de changement
    return baseStyle;
  }
  
  /// Crée un TextTheme complet pour l'application.
  static TextTheme createTextTheme() {
    return const TextTheme(
      displayLarge: headline1,
      displayMedium: headline2,
      displaySmall: headline3,
      headlineLarge: headline2,
      headlineMedium: headline3,
      headlineSmall: headline4,
      titleLarge: headline5,
      titleMedium: headline6,
      titleSmall: labelLarge,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelMedium: labelMedium,
      labelSmall: labelSmall,
    );
  }
}