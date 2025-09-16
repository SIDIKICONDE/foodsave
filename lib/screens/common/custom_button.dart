import 'package:flutter/material.dart';

/// Bouton personnalisé réutilisable pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
class CustomButton extends StatelessWidget {
  /// Texte affiché sur le bouton
  final String text;
  
  /// Callback appelé lors du tap
  final VoidCallback? onPressed;
  
  /// Icône optionnelle
  final IconData? icon;
  
  /// Type de bouton
  final ButtonType type;
  
  /// Taille du bouton
  final ButtonSize size;
  
  /// Indique si le bouton prend toute la largeur
  final bool isFullWidth;
  
  /// Indique si le bouton est en état de chargement
  final bool isLoading;
  
  /// Couleur personnalisée du bouton
  final Color? backgroundColor;
  
  /// Couleur personnalisée du texte
  final Color? textColor;

  /// Constructeur du bouton personnalisé
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isFullWidth = true,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  /// Factory pour un bouton primaire
  factory CustomButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
    bool isFullWidth = true,
    bool isLoading = false,
  }) =>
      CustomButton(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        type: ButtonType.primary,
        size: size,
        isFullWidth: isFullWidth,
        isLoading: isLoading,
      );

  /// Factory pour un bouton secondaire
  factory CustomButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
    bool isFullWidth = true,
    bool isLoading = false,
  }) =>
      CustomButton(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        type: ButtonType.secondary,
        size: size,
        isFullWidth: isFullWidth,
        isLoading: isLoading,
      );

  /// Factory pour un bouton outlined
  factory CustomButton.outlined({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
    bool isFullWidth = true,
    bool isLoading = false,
  }) =>
      CustomButton(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        type: ButtonType.outlined,
        size: size,
        isFullWidth: isFullWidth,
        isLoading: isLoading,
      );

  /// Factory pour un bouton text
  factory CustomButton.text({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
    bool isFullWidth = false,
    bool isLoading = false,
  }) =>
      CustomButton(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        type: ButtonType.text,
        size: size,
        isFullWidth: isFullWidth,
        isLoading: isLoading,
      );

  /// Factory pour un bouton danger
  factory CustomButton.danger({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    IconData? icon,
    ButtonSize size = ButtonSize.medium,
    bool isFullWidth = true,
    bool isLoading = false,
  }) =>
      CustomButton(
        key: key,
        text: text,
        onPressed: onPressed,
        icon: icon,
        type: ButtonType.danger,
        size: size,
        isFullWidth: isFullWidth,
        isLoading: isLoading,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Récupérer les dimensions selon la taille
    final dimensions = _getButtonDimensions();
    
    // Récupérer les couleurs selon le type
    final colors = _getButtonColors(colorScheme);
    
    // Créer le contenu du bouton
    Widget buttonContent = _buildButtonContent(theme);
    
    // Créer le bouton selon le type
    Widget button = _buildButtonByType(context, buttonContent, colors, dimensions);
    
    // Appliquer la largeur si nécessaire
    if (isFullWidth) {
      button = SizedBox(
        width: double.infinity,
        child: button,
      );
    }
    
    return button;
  }

  /// Récupère les dimensions selon la taille du bouton
  ButtonDimensions _getButtonDimensions() {
    switch (size) {
      case ButtonSize.small:
        return const ButtonDimensions(
          height: 36,
          horizontalPadding: 12,
          verticalPadding: 8,
          fontSize: 14,
          iconSize: 16,
        );
      case ButtonSize.medium:
        return const ButtonDimensions(
          height: 48,
          horizontalPadding: 16,
          verticalPadding: 12,
          fontSize: 16,
          iconSize: 18,
        );
      case ButtonSize.large:
        return const ButtonDimensions(
          height: 56,
          horizontalPadding: 24,
          verticalPadding: 16,
          fontSize: 18,
          iconSize: 20,
        );
    }
  }

  /// Récupère les couleurs selon le type de bouton
  ButtonColors _getButtonColors(ColorScheme colorScheme) {
    switch (type) {
      case ButtonType.primary:
        return ButtonColors(
          backgroundColor: backgroundColor ?? colorScheme.primary,
          textColor: textColor ?? colorScheme.onPrimary,
          borderColor: backgroundColor ?? colorScheme.primary,
        );
      case ButtonType.secondary:
        return ButtonColors(
          backgroundColor: backgroundColor ?? colorScheme.secondary,
          textColor: textColor ?? colorScheme.onSecondary,
          borderColor: backgroundColor ?? colorScheme.secondary,
        );
      case ButtonType.outlined:
        return ButtonColors(
          backgroundColor: backgroundColor ?? Colors.transparent,
          textColor: textColor ?? colorScheme.primary,
          borderColor: colorScheme.primary,
        );
      case ButtonType.text:
        return ButtonColors(
          backgroundColor: backgroundColor ?? Colors.transparent,
          textColor: textColor ?? colorScheme.primary,
          borderColor: Colors.transparent,
        );
      case ButtonType.danger:
        return ButtonColors(
          backgroundColor: backgroundColor ?? colorScheme.error,
          textColor: textColor ?? colorScheme.onError,
          borderColor: backgroundColor ?? colorScheme.error,
        );
    }
  }

  /// Construit le contenu du bouton (texte + icône)
  Widget _buildButtonContent(ThemeData theme) {
    final dimensions = _getButtonDimensions();
    
    if (isLoading) {
      return SizedBox(
        width: dimensions.iconSize,
        height: dimensions.iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? theme.colorScheme.onPrimary,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: dimensions.iconSize,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.labelLarge?.copyWith(
              fontSize: dimensions.fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: theme.textTheme.labelLarge?.copyWith(
        fontSize: dimensions.fontSize,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Construit le bouton selon son type
  Widget _buildButtonByType(
    BuildContext context,
    Widget content,
    ButtonColors colors,
    ButtonDimensions dimensions,
  ) {
    final borderRadius = BorderRadius.circular(12);
    
    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
      case ButtonType.danger:
        return ElevatedButton(
          onPressed: (isLoading || onPressed == null) ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.backgroundColor,
            foregroundColor: colors.textColor,
            minimumSize: Size(0, dimensions.height),
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.horizontalPadding,
              vertical: dimensions.verticalPadding,
            ),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            elevation: type == ButtonType.primary ? 2 : 1,
            shadowColor: colors.backgroundColor.withOpacity(0.3),
          ),
          child: content,
        );

      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: (isLoading || onPressed == null) ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: colors.textColor,
            backgroundColor: colors.backgroundColor,
            minimumSize: Size(0, dimensions.height),
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.horizontalPadding,
              vertical: dimensions.verticalPadding,
            ),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
            side: BorderSide(color: colors.borderColor, width: 1.5),
          ),
          child: content,
        );

      case ButtonType.text:
        return TextButton(
          onPressed: (isLoading || onPressed == null) ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: colors.textColor,
            backgroundColor: colors.backgroundColor,
            minimumSize: Size(0, dimensions.height),
            padding: EdgeInsets.symmetric(
              horizontal: dimensions.horizontalPadding,
              vertical: dimensions.verticalPadding,
            ),
            shape: RoundedRectangleBorder(borderRadius: borderRadius),
          ),
          child: content,
        );
    }
  }
}

/// Types de boutons disponibles
enum ButtonType {
  primary,
  secondary,
  outlined,
  text,
  danger,
}

/// Tailles de boutons disponibles
enum ButtonSize {
  small,
  medium,
  large,
}

/// Classe pour stocker les dimensions du bouton
class ButtonDimensions {
  final double height;
  final double horizontalPadding;
  final double verticalPadding;
  final double fontSize;
  final double iconSize;

  const ButtonDimensions({
    required this.height,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.fontSize,
    required this.iconSize,
  });
}

/// Classe pour stocker les couleurs du bouton
class ButtonColors {
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const ButtonColors({
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });
}