import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Tests pour toutes les constantes de style de l'application.
/// 
/// Ces tests vérifient que toutes les constantes de couleurs, dimensions
/// et styles de texte sont correctement définies et fonctionnent comme attendu.
/// Inclut les tests des méthodes responsives.
/// Suit les directives strictes Dart pour la sécurité et la maintenabilité.
void main() {
  group('AppColors Tests', () {
    group('Primary Colors', () {
      test('should have valid primary color', () {
        expect(AppColors.primary, isA<Color>());
        expect(AppColors.primary.value, isNotNull);
      });

      test('should have valid primary variants', () {
        expect(AppColors.primaryLight, isA<Color>());
        expect(AppColors.primaryDark, isA<Color>());
        expect(AppColors.primaryLight.value, isNotNull);
        expect(AppColors.primaryDark.value, isNotNull);
      });
    });

    group('Secondary Colors', () {
      test('should have valid secondary color', () {
        expect(AppColors.secondary, isA<Color>());
        expect(AppColors.secondary.value, isNotNull);
      });

      test('should have valid secondary variants', () {
        expect(AppColors.secondaryLight, isA<Color>());
        expect(AppColors.secondaryDark, isA<Color>());
        expect(AppColors.secondaryLight.value, isNotNull);
        expect(AppColors.secondaryDark.value, isNotNull);
      });
    });

    group('Status Colors', () {
      test('should have valid status colors', () {
        expect(AppColors.success, isA<Color>());
        expect(AppColors.error, isA<Color>());
        expect(AppColors.warning, isA<Color>());
        expect(AppColors.info, isA<Color>());
        
        // Vérification que les couleurs sont différentes
        expect(AppColors.success, isNot(equals(AppColors.error)));
        expect(AppColors.warning, isNot(equals(AppColors.info)));
      });
    });

    group('Text Colors', () {
      test('should have valid text colors', () {
        expect(AppColors.textPrimary, isA<Color>());
        expect(AppColors.textSecondary, isA<Color>());
        expect(AppColors.textOnDark, isA<Color>());
        expect(AppColors.textDisabled, isA<Color>());
      });

      test('text colors should provide good contrast', () {
        // Test que les couleurs de texte ont des valeurs distinctes
        expect(AppColors.textPrimary, isNot(equals(AppColors.textSecondary)));
        expect(AppColors.textOnDark, isNot(equals(AppColors.textDisabled)));
      });
    });

    group('Surface Colors', () {
      test('should have valid surface colors', () {
        expect(AppColors.surface, isA<Color>());
        expect(AppColors.surfaceLight, isA<Color>());
        expect(AppColors.surfaceSecondary, isA<Color>());
        expect(AppColors.background, isA<Color>());
        expect(AppColors.backgroundLight, isA<Color>());
      });
    });

    group('Special Colors', () {
      test('should have valid special colors', () {
        expect(AppColors.lastChance, isA<Color>());
        expect(AppColors.newItem, isA<Color>());
        expect(AppColors.eco, isA<Color>());
        expect(AppColors.badge, isA<Color>());
        expect(AppColors.promotion, isA<Color>());
        expect(AppColors.border, isA<Color>());
        expect(AppColors.borderLight, isA<Color>());
        expect(AppColors.divider, isA<Color>());
        expect(AppColors.shadowLight, isA<Color>());
        expect(AppColors.shadow, isA<Color>());
      });
    });
  });

  group('AppDimensions Tests', () {
    group('Spacing Constants', () {
      test('should have valid spacing values', () {
        expect(AppDimensions.spacingXs, 4.0);
        expect(AppDimensions.spacingS, 8.0);
        expect(AppDimensions.spacingM, 12.0);
        expect(AppDimensions.spacingL, 16.0);
        expect(AppDimensions.spacingXL, 24.0);
        expect(AppDimensions.spacingXXL, 32.0);
        expect(AppDimensions.spacingGiant, 48.0);
      });

      test('spacing values should be in ascending order', () {
        expect(AppDimensions.spacingXs, lessThan(AppDimensions.spacingS));
        expect(AppDimensions.spacingS, lessThan(AppDimensions.spacingM));
        expect(AppDimensions.spacingM, lessThan(AppDimensions.spacingL));
        expect(AppDimensions.spacingL, lessThan(AppDimensions.spacingXL));
        expect(AppDimensions.spacingXL, lessThan(AppDimensions.spacingXXL));
        expect(AppDimensions.spacingXXL, lessThan(AppDimensions.spacingGiant));
      });
    });

    group('Border Radius Constants', () {
      test('should have valid radius values', () {
        expect(AppDimensions.radiusS, 4.0);
        expect(AppDimensions.radiusM, 8.0);
        expect(AppDimensions.radiusL, 12.0);
        expect(AppDimensions.radiusXl, 16.0);
        expect(AppDimensions.radiusCircular, 24.0);
      });

      test('radius values should be positive', () {
        expect(AppDimensions.radiusS, greaterThan(0));
        expect(AppDimensions.radiusM, greaterThan(0));
        expect(AppDimensions.radiusL, greaterThan(0));
        expect(AppDimensions.radiusXl, greaterThan(0));
        expect(AppDimensions.radiusCircular, greaterThan(0));
      });
    });

    group('Icon Size Constants', () {
      test('should have valid icon sizes', () {
        expect(AppDimensions.iconXs, 12.0);
        expect(AppDimensions.iconS, 16.0);
        expect(AppDimensions.iconM, 20.0);
        expect(AppDimensions.iconL, 24.0);
        expect(AppDimensions.iconXl, 32.0);
        expect(AppDimensions.iconGiant, 48.0);
      });

      test('icon sizes should be in ascending order', () {
        expect(AppDimensions.iconXs, lessThan(AppDimensions.iconS));
        expect(AppDimensions.iconS, lessThan(AppDimensions.iconM));
        expect(AppDimensions.iconM, lessThan(AppDimensions.iconL));
        expect(AppDimensions.iconL, lessThan(AppDimensions.iconXl));
        expect(AppDimensions.iconXl, lessThan(AppDimensions.iconGiant));
      });
    });

    group('Component Dimensions', () {
      test('should have valid component dimensions', () {
        expect(AppDimensions.buttonMinHeight, 44.0);
        expect(AppDimensions.inputHeight, 48.0);
        expect(AppDimensions.appBarHeight, 56.0);
        expect(AppDimensions.listItemHeight, 72.0);
        expect(AppDimensions.cardMaxWidth, 400.0);
      });

      test('button height should meet accessibility guidelines', () {
        // Minimum 44px pour l'accessibilité tactile
        expect(AppDimensions.buttonMinHeight, greaterThanOrEqualTo(44.0));
      });
    });

    group('Responsive Breakpoints', () {
      test('should have valid breakpoint values', () {
        expect(AppDimensions.breakpointMobile, 600.0);
        expect(AppDimensions.breakpointTablet, 900.0);
        expect(AppDimensions.breakpointDesktop, 1200.0);
      });

      test('breakpoints should be in ascending order', () {
        expect(AppDimensions.breakpointMobile, lessThan(AppDimensions.breakpointTablet));
        expect(AppDimensions.breakpointTablet, lessThan(AppDimensions.breakpointDesktop));
      });
    });
  });

  group('AppDimensions Responsive Methods Tests', () {
    group('Screen Size Detection', () {
      test('isSmallScreen should work correctly', () {
        expect(AppDimensions.isSmallScreen(300), isTrue);
        expect(AppDimensions.isSmallScreen(599), isTrue);
        expect(AppDimensions.isSmallScreen(600), isFalse);
        expect(AppDimensions.isSmallScreen(800), isFalse);
      });

      test('isMediumScreen should work correctly', () {
        expect(AppDimensions.isMediumScreen(300), isFalse);
        expect(AppDimensions.isMediumScreen(600), isTrue);
        expect(AppDimensions.isMediumScreen(700), isTrue);
        expect(AppDimensions.isMediumScreen(899), isTrue);
        expect(AppDimensions.isMediumScreen(900), isFalse);
      });

      test('isLargeScreen should work correctly', () {
        expect(AppDimensions.isLargeScreen(300), isFalse);
        expect(AppDimensions.isLargeScreen(600), isFalse);
        expect(AppDimensions.isLargeScreen(899), isFalse);
        expect(AppDimensions.isLargeScreen(900), isTrue);
        expect(AppDimensions.isLargeScreen(1200), isTrue);
      });
    });

    group('Responsive Spacing', () {
      test('getResponsiveSpacing should return correct values', () {
        // Mobile (< 600)
        expect(AppDimensions.getResponsiveSpacing(400), equals(AppDimensions.spacingS));
        // Tablet (600-899)
        expect(AppDimensions.getResponsiveSpacing(700), equals(AppDimensions.spacingM));
        // Desktop (>= 900)
        expect(AppDimensions.getResponsiveSpacing(1000), equals(AppDimensions.spacingXL));
      });
    });

    group('Responsive Icon Size', () {
      test('getResponsiveIconSize should scale correctly', () {
        const double baseSize = 24.0;
        
        // Mobile (< 600) : 80% de la taille
        final double mobileSize = AppDimensions.getResponsiveIconSize(400, baseSize);
        expect(mobileSize, equals(baseSize * 0.8));
        
        // Tablet (600-899) : 100% de la taille
        final double tabletSize = AppDimensions.getResponsiveIconSize(700, baseSize);
        expect(tabletSize, equals(baseSize));
        
        // Desktop (>= 900) : 120% de la taille
        final double desktopSize = AppDimensions.getResponsiveIconSize(1000, baseSize);
        expect(desktopSize, equals(baseSize * 1.2));
      });
    });

    group('Responsive Text Size', () {
      test('getResponsiveTextSize should scale correctly', () {
        const double baseSize = 16.0;
        
        // Mobile : 90% de la taille
        final double mobileSize = AppDimensions.getResponsiveTextSize(400, baseSize);
        expect(mobileSize, equals(baseSize * 0.9));
        
        // Tablet : 100% de la taille
        final double tabletSize = AppDimensions.getResponsiveTextSize(700, baseSize);
        expect(tabletSize, equals(baseSize));
        
        // Desktop : 110% de la taille
        final double desktopSize = AppDimensions.getResponsiveTextSize(1000, baseSize);
        expect(desktopSize, equals(baseSize * 1.1));
      });
    });

    group('Grid Columns', () {
      test('getOptimalGridColumns should return correct values', () {
        // Mobile : 1 colonne
        expect(AppDimensions.getOptimalGridColumns(400), equals(1));
        // Tablet : 2 colonnes
        expect(AppDimensions.getOptimalGridColumns(700), equals(2));
        // Desktop : 3 colonnes
        expect(AppDimensions.getOptimalGridColumns(1000), equals(3));
      });
    });

    group('Utility Methods', () {
      test('getSpacingForContext should return correct values', () {
        expect(AppDimensions.getSpacingForContext('tight'), equals(AppDimensions.spacingS));
        expect(AppDimensions.getSpacingForContext('normal'), equals(AppDimensions.spacingL));
        expect(AppDimensions.getSpacingForContext('loose'), equals(AppDimensions.spacingXL));
        expect(AppDimensions.getSpacingForContext('unknown'), equals(AppDimensions.spacingM));
      });

      test('getIconSizeForContext should return correct values', () {
        expect(AppDimensions.getIconSizeForContext('small'), equals(AppDimensions.iconS));
        expect(AppDimensions.getIconSizeForContext('medium'), equals(AppDimensions.iconM));
        expect(AppDimensions.getIconSizeForContext('large'), equals(AppDimensions.iconL));
        expect(AppDimensions.getIconSizeForContext('unknown'), equals(AppDimensions.iconM));
      });

      test('proportionalSpacing should calculate correctly', () {
        const double baseSpacing = 16.0;
        const double multiplier = 1.5;
        final double result = AppDimensions.proportionalSpacing(baseSpacing, multiplier);
        expect(result, equals(baseSpacing * multiplier));
      });
    });
  });

  group('AppTextStyles Tests', () {
    group('Headline Styles', () {
      test('should have valid headline styles', () {
        expect(AppTextStyles.headline1.fontSize, 32.0);
        expect(AppTextStyles.headline2.fontSize, 28.0);
        expect(AppTextStyles.headline3.fontSize, 24.0);
        expect(AppTextStyles.headline4.fontSize, 20.0);
        expect(AppTextStyles.headline5.fontSize, 18.0);
        expect(AppTextStyles.headline6.fontSize, 16.0);
      });

      test('headline font sizes should be in descending order', () {
        expect(AppTextStyles.headline1.fontSize!, greaterThan(AppTextStyles.headline2.fontSize!));
        expect(AppTextStyles.headline2.fontSize!, greaterThan(AppTextStyles.headline3.fontSize!));
        expect(AppTextStyles.headline3.fontSize!, greaterThan(AppTextStyles.headline4.fontSize!));
        expect(AppTextStyles.headline4.fontSize!, greaterThan(AppTextStyles.headline5.fontSize!));
        expect(AppTextStyles.headline5.fontSize!, greaterThan(AppTextStyles.headline6.fontSize!));
      });

      test('headlines should have appropriate font weights', () {
        expect(AppTextStyles.headline1.fontWeight, FontWeight.bold);
        expect(AppTextStyles.headline2.fontWeight, FontWeight.bold);
        expect(AppTextStyles.headline3.fontWeight, FontWeight.w600);
        expect(AppTextStyles.headline4.fontWeight, FontWeight.w600);
        expect(AppTextStyles.headline5.fontWeight, FontWeight.w500);
        expect(AppTextStyles.headline6.fontWeight, FontWeight.w500);
      });
    });

    group('Body Text Styles', () {
      test('should have valid body text styles', () {
        expect(AppTextStyles.bodyLarge.fontSize, 16.0);
        expect(AppTextStyles.bodyMedium.fontSize, 14.0);
        expect(AppTextStyles.bodySmall.fontSize, 12.0);
      });

      test('body text font sizes should be in descending order', () {
        expect(AppTextStyles.bodyLarge.fontSize!, greaterThan(AppTextStyles.bodyMedium.fontSize!));
        expect(AppTextStyles.bodyMedium.fontSize!, greaterThan(AppTextStyles.bodySmall.fontSize!));
      });
    });

    group('Label Styles', () {
      test('should have valid label styles', () {
        expect(AppTextStyles.labelLarge.fontSize, 14.0);
        expect(AppTextStyles.labelMedium.fontSize, 12.0);
        expect(AppTextStyles.labelSmall.fontSize, 11.0);
      });

      test('labels should have medium font weight', () {
        expect(AppTextStyles.labelLarge.fontWeight, FontWeight.w500);
        expect(AppTextStyles.labelMedium.fontWeight, FontWeight.w500);
        expect(AppTextStyles.labelSmall.fontWeight, FontWeight.w500);
      });
    });

    group('Specialized Styles', () {
      test('should have valid specialized styles', () {
        expect(AppTextStyles.price.fontSize, 18.0);
        expect(AppTextStyles.price.fontWeight, FontWeight.bold);
        expect(AppTextStyles.price.color, AppColors.primary);

        expect(AppTextStyles.priceStriked.decoration, TextDecoration.lineThrough);
        
        expect(AppTextStyles.buttonPrimary.color, AppColors.textOnDark);
        expect(AppTextStyles.buttonSecondary.color, AppColors.primary);
        
        expect(AppTextStyles.link.decoration, TextDecoration.underline);
        expect(AppTextStyles.link.color, AppColors.primary);
      });

      test('error and success styles should have correct colors', () {
        expect(AppTextStyles.error.color, AppColors.error);
        expect(AppTextStyles.success.color, AppColors.success);
        expect(AppTextStyles.warning.color, AppColors.warning);
      });
    });

    group('Responsive Text Styles', () {
      test('responsive method should scale text correctly', () {
        const TextStyle baseStyle = TextStyle(fontSize: 16.0);
        
        // Mobile : 90% de la taille
        final TextStyle mobileStyle = AppTextStyles.responsive(baseStyle, 400);
        expect(mobileStyle.fontSize, equals(16.0 * 0.9));
        
        // Tablet : pas de changement
        final TextStyle tabletStyle = AppTextStyles.responsive(baseStyle, 700);
        expect(tabletStyle.fontSize, equals(16.0));
        
        // Desktop : 110% de la taille
        final TextStyle desktopStyle = AppTextStyles.responsive(baseStyle, 1300);
        expect(desktopStyle.fontSize, equals(16.0 * 1.1));
      });
    });

    group('Utility Methods', () {
      test('withColor should change color correctly', () {
        const TextStyle baseStyle = TextStyle(fontSize: 16.0);
        const Color newColor = Colors.red;
        
        final TextStyle newStyle = AppTextStyles.withColor(baseStyle, newColor);
        expect(newStyle.color, equals(newColor));
        expect(newStyle.fontSize, equals(baseStyle.fontSize));
      });

      test('withFontSize should change font size correctly', () {
        const TextStyle baseStyle = TextStyle(fontSize: 16.0);
        const double newFontSize = 20.0;
        
        final TextStyle newStyle = AppTextStyles.withFontSize(baseStyle, newFontSize);
        expect(newStyle.fontSize, equals(newFontSize));
      });

      test('withFontWeight should change font weight correctly', () {
        const TextStyle baseStyle = TextStyle(fontWeight: FontWeight.normal);
        const FontWeight newWeight = FontWeight.bold;
        
        final TextStyle newStyle = AppTextStyles.withFontWeight(baseStyle, newWeight);
        expect(newStyle.fontWeight, equals(newWeight));
      });
    });

    group('TextTheme Creation', () {
      test('createTextTheme should return valid TextTheme', () {
        final TextTheme textTheme = AppTextStyles.createTextTheme();
        
        expect(textTheme, isA<TextTheme>());
        expect(textTheme.displayLarge, equals(AppTextStyles.headline1));
        expect(textTheme.bodyLarge, equals(AppTextStyles.bodyLarge));
        expect(textTheme.labelLarge, equals(AppTextStyles.labelLarge));
      });
    });
  });

  group('Design System Consistency Tests', () {
    test('colors should be used consistently across styles', () {
      // Vérifie que les couleurs primaires sont utilisées correctement
      expect(AppTextStyles.price.color, equals(AppColors.primary));
      expect(AppTextStyles.buttonSecondary.color, equals(AppColors.primary));
      expect(AppTextStyles.link.color, equals(AppColors.primary));
    });

    test('dimensions should be consistent with design system', () {
      // Vérifie que les tailles suivent la progression logique
      expect(AppDimensions.spacingXs * 2, equals(AppDimensions.spacingS));
      // Vérifie que les icônes et texte ont des tailles cohérentes
      expect(AppDimensions.iconS, greaterThan(AppTextStyles.bodySmall.fontSize!));
      expect(AppDimensions.iconM, greaterThan(AppTextStyles.bodyMedium.fontSize!));
    });

    test('text styles should have appropriate line heights', () {
      // Vérifie que les hauteurs de ligne sont appropriées
      expect(AppTextStyles.headline1.height, lessThanOrEqualTo(1.5));
      expect(AppTextStyles.bodyMedium.height, greaterThanOrEqualTo(1.4));
    });
  });
}