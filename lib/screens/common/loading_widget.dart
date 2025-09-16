import 'package:flutter/material.dart';

/// Widget de chargement réutilisable pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
class LoadingWidget extends StatelessWidget {
  /// Taille du loading
  final LoadingSize size;
  
  /// Couleur personnalisée
  final Color? color;
  
  /// Message de chargement
  final String? message;
  
  /// Indique si le loading doit être centré
  final bool centered;
  
  /// Indique si le loading a un fond
  final bool hasBackground;

  /// Constructeur du widget de chargement
  const LoadingWidget({
    super.key,
    this.size = LoadingSize.medium,
    this.color,
    this.message,
    this.centered = true,
    this.hasBackground = false,
  });

  /// Factory pour un loading petit
  factory LoadingWidget.small({
    Key? key,
    Color? color,
    String? message,
    bool centered = true,
    bool hasBackground = false,
  }) =>
      LoadingWidget(
        key: key,
        size: LoadingSize.small,
        color: color,
        message: message,
        centered: centered,
        hasBackground: hasBackground,
      );

  /// Factory pour un loading medium
  factory LoadingWidget.medium({
    Key? key,
    Color? color,
    String? message,
    bool centered = true,
    bool hasBackground = false,
  }) =>
      LoadingWidget(
        key: key,
        size: LoadingSize.medium,
        color: color,
        message: message,
        centered: centered,
        hasBackground: hasBackground,
      );

  /// Factory pour un loading large
  factory LoadingWidget.large({
    Key? key,
    Color? color,
    String? message,
    bool centered = true,
    bool hasBackground = false,
  }) =>
      LoadingWidget(
        key: key,
        size: LoadingSize.large,
        color: color,
        message: message,
        centered: centered,
        hasBackground: hasBackground,
      );

  /// Factory pour un loading en overlay
  factory LoadingWidget.overlay({
    Key? key,
    Color? color,
    String? message,
  }) =>
      LoadingWidget(
        key: key,
        size: LoadingSize.large,
        color: color,
        message: message,
        centered: true,
        hasBackground: true,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Créer le contenu principal
    Widget loadingContent = _buildLoadingContent(theme);
    
    // Centrer si nécessaire
    if (centered) {
      loadingContent = Center(child: loadingContent);
    }
    
    // Ajouter un fond si nécessaire
    if (hasBackground) {
      loadingContent = Container(
        color: Colors.black.withOpacity(0.3),
        child: loadingContent,
      );
    }
    
    return loadingContent;
  }

  /// Construit le contenu du loading
  Widget _buildLoadingContent(ThemeData theme) {
    final dimensions = _getLoadingDimensions();
    final loadingColor = color ?? theme.primaryColor;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Indicateur de progression circulaire
        SizedBox(
          width: dimensions.indicatorSize,
          height: dimensions.indicatorSize,
          child: CircularProgressIndicator(
            strokeWidth: dimensions.strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
          ),
        ),
        
        // Message si présent
        if (message != null) ...[
          SizedBox(height: dimensions.spacing),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: dimensions.textSize,
              color: hasBackground ? Colors.white : theme.textTheme.bodyMedium?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  /// Récupère les dimensions selon la taille
  LoadingDimensions _getLoadingDimensions() {
    switch (size) {
      case LoadingSize.small:
        return const LoadingDimensions(
          indicatorSize: 20,
          strokeWidth: 2,
          textSize: 12,
          spacing: 8,
        );
      case LoadingSize.medium:
        return const LoadingDimensions(
          indicatorSize: 32,
          strokeWidth: 3,
          textSize: 14,
          spacing: 12,
        );
      case LoadingSize.large:
        return const LoadingDimensions(
          indicatorSize: 48,
          strokeWidth: 4,
          textSize: 16,
          spacing: 16,
        );
    }
  }
}

/// Widget de loading avec points animés
class DotLoadingWidget extends StatefulWidget {
  /// Couleur des points
  final Color? color;
  
  /// Taille des points
  final double dotSize;
  
  /// Nombre de points
  final int dotCount;
  
  /// Durée de l'animation
  final Duration duration;

  /// Constructeur du widget de loading avec points
  const DotLoadingWidget({
    super.key,
    this.color,
    this.dotSize = 8,
    this.dotCount = 3,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<DotLoadingWidget> createState() => _DotLoadingWidgetState();
}

class _DotLoadingWidgetState extends State<DotLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = widget.color ?? Theme.of(context).primaryColor;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(widget.dotCount, (index) {
            final delay = index / widget.dotCount;
            final animationValue = (_animationController.value - delay) % 1.0;
            final scale = animationValue < 0.5 
                ? 0.5 + (animationValue * 2 * 0.5)  // Scale up
                : 1.0 - ((animationValue - 0.5) * 2 * 0.5); // Scale down
                
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: widget.dotSize * 0.2),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    color: dotColor.withOpacity(scale),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Widget de loading linéaire
class LinearLoadingWidget extends StatelessWidget {
  /// Couleur de la barre de progression
  final Color? color;
  
  /// Couleur de fond
  final Color? backgroundColor;
  
  /// Hauteur de la barre
  final double height;
  
  /// Message de chargement
  final String? message;

  /// Constructeur du widget de loading linéaire
  const LinearLoadingWidget({
    super.key,
    this.color,
    this.backgroundColor,
    this.height = 4,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? theme.primaryColor,
          ),
          backgroundColor: backgroundColor ?? theme.primaryColor.withOpacity(0.2),
          minHeight: height,
        ),
        
        if (message != null) ...[
          const SizedBox(height: 8),
          Text(
            message!,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Tailles disponibles pour le loading
enum LoadingSize {
  small,
  medium,
  large,
}

/// Classe pour stocker les dimensions du loading
class LoadingDimensions {
  final double indicatorSize;
  final double strokeWidth;
  final double textSize;
  final double spacing;

  const LoadingDimensions({
    required this.indicatorSize,
    required this.strokeWidth,
    required this.textSize,
    required this.spacing,
  });
}