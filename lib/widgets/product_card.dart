import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';

/// Modèle de données pour un produit affiché dans [ProductCard].
/// Représente les informations essentielles d'un produit dans l'application.
class ProductModel {
  /// Identifiant unique du produit
  final String id;

  /// Nom du produit
  final String name;

  /// Nom du magasin
  final String shop;

  /// Prix actuel du produit
  final double price;

  /// Prix original avant réduction
  final double originalPrice;

  /// Note moyenne du produit
  final double rating;

  /// URL de l'image du produit
  final String imageUrl;

  /// Indique si le produit est en dernière chance
  final bool isLastChance;

  /// Indique si le produit est dans les favoris
  final bool isFavorite;

  /// Constructeur constant pour l'immuabilité
  const ProductModel({
    required this.id,
    required this.name,
    required this.shop,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.imageUrl,
    this.isLastChance = false,
    this.isFavorite = false,
  });

  /// Calcule le pourcentage de réduction
  /// Retourne 0.0 si le prix original est nul pour éviter la division par zéro
  double get reductionPercentage {
    if (originalPrice == 0.0) return 0.0;
    return ((originalPrice - price) / originalPrice * 100).roundToDouble();
  }
}

/// Une carte générique pour afficher un produit ou un panier.
/// Cette carte présente les informations essentielles du produit de manière élégante
/// et interactive, avec support pour les favoris et les dernières chances.
/// Inclut des animations fluides pour améliorer l'expérience utilisateur.
class ProductCard extends StatefulWidget {
  /// Modèle de données du produit à afficher
  final ProductModel product;

  /// Callback appelé lorsque l'utilisateur appuie sur la carte
  final VoidCallback? onTap;

  /// Callback appelé lorsque l'état favori change
  final ValueChanged<bool>? onFavoriteToggle;

  /// Index optionnel pour les animations ou l'identification
  final int? index;

  /// Constructeur constant pour l'immuabilité
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteToggle,
    this.index,
  });

  @override
  ProductCardState createState() => ProductCardState();
}

/// État du ProductCard avec gestion des animations
class ProductCardState extends State<ProductCard>
    with TickerProviderStateMixin {
  /// Constantes pour les dimensions de la carte
  static const double _cardWidth = 280.0;
  static const double _imageHeight = 160.0; // Hauteur optimisée pour le meilleur équilibre visuel
  static const double _cardHeight = 280.0; // Hauteur totale de la carte pour contenu compact
  static const double _favoriteButtonSize = 20.0;
  static const double _badgeIconSize = 12.0;
  static const double _storeIconSize = 14.0;

  /// Constantes pour les rayons d'arrondi (réduits pour un style plus moderne)
  static const double _cardBorderRadius = 12.0; // Réduit de 16.0 à 12.0
  static const double _imageBorderRadius = 10.0; // Réduit pour cohérence
  static const double _badgeBorderRadius = 6.0; // Réduit pour les badges

  /// Contrôleur pour l'animation d'échelle de la carte
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  /// Contrôleur pour l'animation du bouton favori
  late AnimationController _favoriteController;
  late Animation<double> _favoriteScaleAnimation;
  late Animation<double> _favoriteOpacityAnimation;

  /// Contrôleur pour l'animation du badge "Dernière chance"
  late AnimationController _badgeController;
  late Animation<double> _badgeSlideAnimation;
  late Animation<double> _badgeFadeAnimation;

  /// Contrôleur pour l'animation de l'image
  late AnimationController _imageController;
  late Animation<double> _imageScaleAnimation;
  late Animation<double> _imageFadeAnimation;

  /// État du bouton pressé
  bool _isPressed = false;

  /// État du bouton favori en cours d'animation
  bool _isFavoriteAnimating = false;

  /// État de chargement de l'image
  bool _isImageLoaded = false;

  /// Nettoie le texte en remplaçant les nouvelles lignes et caractères problématiques
  String _cleanText(String text) {
    return text
        .replaceAll('\n', ' ')      // Remplacer les sauts de ligne
        .replaceAll('\r', ' ')      // Remplacer les retours chariot
        .replaceAll('\t', ' ')      // Remplacer les tabulations
        .replaceAll(RegExp(r'\s+'), ' ')  // Remplacer les espaces multiples par un seul
        .trim();                    // Supprimer les espaces au début et à la fin
  }

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _favoriteController.dispose();
    _badgeController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  /// Initialise tous les contrôleurs d'animation
  void _initializeAnimations() {
    // Animation d'échelle pour la carte
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    // Animation pour le bouton favori
    _favoriteController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _favoriteScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _favoriteController,
      curve: Curves.elasticOut,
    ));
    _favoriteOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _favoriteController,
      curve: Curves.easeInOut,
    ));

    // Animation pour le badge "Dernière chance"
    _badgeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _badgeSlideAnimation = Tween<double>(
      begin: -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _badgeController,
      curve: Curves.elasticOut,
    ));
    _badgeFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _badgeController,
      curve: Curves.easeIn,
    ));

    // Animation pour l'image
    _imageController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _imageScaleAnimation = Tween<double>(
      begin: 1.1,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _imageController,
      curve: Curves.easeOutBack,
    ));
    _imageFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _imageController,
      curve: Curves.easeIn,
    ));

    // Démarre l'animation du badge si nécessaire
    if (widget.product.isLastChance) {
      _badgeController.forward();
    }

    // Démarre l'animation de l'image
    _imageController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleController, _badgeController, _imageController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: _cardWidth,
            height: _cardHeight,
            child: Container(
              margin: const EdgeInsets.only(
                right: AppDimensions.spacingL,
                bottom: AppDimensions.spacingM,
              ),
              child: GestureDetector(
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                onTap: widget.onTap,
                child: Stack(
                  children: [
                    _buildCardContent(),
                    if (widget.product.isLastChance) _buildAnimatedLastChanceBadge(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Gère l'événement de pression sur la carte
  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _scaleController.forward();
  }

  /// Gère l'événement de relâchement sur la carte
  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  /// Gère l'annulation de l'appui sur la carte
  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  /// Construit le contenu principal de la carte avec décoration et mise en page
  Widget _buildCardContent() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: _isPressed ? AppColors.surfaceLight : AppColors.surface,
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: _isPressed ? 0.25 : 0.15),
            blurRadius: _isPressed ? 15 : 10,
            offset: Offset(0, _isPressed ? 8 : 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: _cardWidth - (AppDimensions.spacingM * 2),
                ),
                child: _buildInfoSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit la section image avec superposition du bouton favori et animation de chargement
  Widget _buildImageSection() {
    return Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _cardWidth,
            maxHeight: _imageHeight,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _imageHeight,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(_imageBorderRadius),
              ),
              boxShadow: _isPressed ? [
                BoxShadow(
                  color: AppColors.shadow.withAlpha(50),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ] : null,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(_imageBorderRadius),
              ),
              child: SizedBox(
                width: _cardWidth,
                height: _imageHeight,
                child: Opacity(
                  opacity: _imageFadeAnimation.value,
                  child: Transform.scale(
                    scale: (_isPressed ? 1.02 : 1.0) * _imageScaleAnimation.value,
                    child: CachedNetworkImage(
                      imageUrl: _getImageUrl(),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => _buildImagePlaceholder(),
                      errorWidget: (context, url, error) => _buildImageErrorPlaceholder(),
                      fadeInDuration: const Duration(milliseconds: 300),
                      fadeOutDuration: const Duration(milliseconds: 200),
                      imageBuilder: (context, imageProvider) {
                        // Animation de succès quand l'image est chargée
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (!_isImageLoaded) {
                            setState(() => _isImageLoaded = true);
                          }
                        });
                        return Container(
                          constraints: BoxConstraints(
                            maxWidth: _cardWidth,
                            maxHeight: _imageHeight,
                          ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Overlay subtil pour améliorer la lisibilité du bouton favori
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(_imageBorderRadius),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  AppColors.shadow.withAlpha(20),
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          top: AppDimensions.spacingS,
          right: AppDimensions.spacingS,
          child: _buildFavoriteButton(),
        ),
      ],
    );
  }

  /// Construit un placeholder animé avec effet shimmer pendant le chargement de l'image
  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.surfaceLight,
      child: Center(
        child: AnimatedOpacity(
          opacity: _isPressed ? 0.7 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withAlpha(100),
                    width: 2,
                  ),
                ),
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              Text(
                'Chargement...',
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white.withAlpha(180),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit un placeholder d'erreur amélioré pour l'image
  Widget _buildImageErrorPlaceholder() {
    return Container(
      color: AppColors.surfaceLight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.white.withAlpha(150),
                size: 32,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'Image indisponible',
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white.withAlpha(150),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Obtient l'URL de l'image à afficher, avec fallback par défaut
  String _getImageUrl() {
    if (widget.product.imageUrl.isNotEmpty) {
      return widget.product.imageUrl;
    }

    // Images de test fiables pour le développement
    const testImages = [
      'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=400&h=300&fit=crop&auto=format',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop&auto=format',
      'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=300&fit=crop&auto=format',
      'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=300&fit=crop&auto=format',
      'https://images.unsplash.com/photo-1551782450-17144efb5723?w=400&h=300&fit=crop&auto=format',
      'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop&auto=format',
      'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&h=300&fit=crop&auto=format',
      'https://images.unsplash.com/photo-1556909114-4c36e03c9c0e?w=400&h=300&fit=crop&auto=format',
    ];

    // Utiliser l'ID du produit pour sélectionner une image de test cohérente
    final productId = widget.product.id;
    final hash = productId.hashCode.abs();
    final imageIndex = hash % testImages.length;

    return testImages[imageIndex];
  }

  /// Construit le bouton favori avec icône interactive et animations
  Widget _buildFavoriteButton() {
    return AnimatedBuilder(
      animation: _favoriteController,
      builder: (context, child) {
        return Transform.scale(
          scale: _favoriteScaleAnimation.value,
          child: Opacity(
            opacity: _favoriteOpacityAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface.withAlpha(230),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  widget.product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: widget.product.isFavorite ? AppColors.error : AppColors.textSecondary,
                  size: _favoriteButtonSize,
                ),
                onPressed: _handleFavoriteToggle,
                padding: const EdgeInsets.all(AppDimensions.spacingS),
                constraints: const BoxConstraints(),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Gère le basculement de l'état favori avec animation
  void _handleFavoriteToggle() {
    if (_isFavoriteAnimating) return;

    setState(() => _isFavoriteAnimating = true);
    _favoriteController.forward().then((_) {
      _favoriteController.reverse().then((_) {
        setState(() => _isFavoriteAnimating = false);
      });
    });

    widget.onFavoriteToggle?.call(!widget.product.isFavorite);
  }

  /// Construit la section d'informations avec nom, magasin et prix
  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProductName(),
        const SizedBox(height: AppDimensions.spacingXS),
        _buildShopInfo(),
        const SizedBox(height: AppDimensions.spacingL), // Espace optimal entre description et prix
        _buildPriceSection(),
      ],
    );
  }

  /// Construit le nom du produit avec style approprié
  Widget _buildProductName() {
    final cleanedText = _cleanText(widget.product.name);
    final truncatedText = cleanedText.length > 27
        ? '${cleanedText.substring(0, 27)}...'
        : cleanedText;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Text(
          truncatedText,
          style: AppTextStyles.headline6.copyWith(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        );
      },
    );
  }

  /// Construit les informations du magasin avec icône
  Widget _buildShopInfo() {
    return Row(
      children: [
        Icon(
          Icons.store,
          size: _storeIconSize,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Text(
                _cleanText(widget.product.shop),
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              );
            },
          ),
        ),
      ],
    );
  }

  /// Construit la section prix avec prix actuel, barré et réduction
  Widget _buildPriceSection() {
    return Row(
      children: [
        Flexible(
          child: _buildCurrentPrice(),
        ),
        const SizedBox(width: AppDimensions.spacingS),
        Flexible(
          child: _buildOriginalPrice(),
        ),
        const Spacer(),
        Flexible(
          child: _buildReductionBadge(),
        ),
      ],
    );
  }

  /// Construit le prix actuel avec style mis en évidence
  Widget _buildCurrentPrice() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Text(
          '€${widget.product.price.toStringAsFixed(2)}',
          style: AppTextStyles.price.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        );
      },
    );
  }

  /// Construit le prix original barré
  Widget _buildOriginalPrice() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Text(
          '€${widget.product.originalPrice.toStringAsFixed(2)}',
          style: AppTextStyles.priceStriked,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        );
      },
    );
  }

  /// Construit le badge de réduction avec pourcentage
  Widget _buildReductionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: 2,
      ),
          decoration: BoxDecoration(
            color: AppColors.success.withAlpha(25),
            borderRadius: BorderRadius.circular(_badgeBorderRadius),
          ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Text(
            '-${widget.product.reductionPercentage.toInt()}%',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          );
        },
      ),
    );
  }

  /// Construit le badge "Dernière chance" avec animations d'entrée
  Widget _buildAnimatedLastChanceBadge() {
    return AnimatedBuilder(
      animation: _badgeController,
      builder: (context, child) {
        return Positioned(
          top: AppDimensions.spacingL + _badgeSlideAnimation.value,
          left: AppDimensions.spacingL,
          child: Opacity(
            opacity: _badgeFadeAnimation.value,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: _cardWidth - (AppDimensions.spacingL * 2),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingS,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lastChance,
                  borderRadius: BorderRadius.circular(_badgeBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.lastChance.withAlpha(100),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer,
                      size: _badgeIconSize,
                      color: AppColors.textOnDark,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Text(
                            _cleanText('Dernière chance'),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textOnDark,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
