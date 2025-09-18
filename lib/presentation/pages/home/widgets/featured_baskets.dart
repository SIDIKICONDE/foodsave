import 'package:flutter/material.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/demo/demo_data_service.dart';
import 'package:foodsave_app/core/routes/app_routes.dart';
import 'package:foodsave_app/widgets/product_card.dart';

/// Widget affichant les paniers en vedette.
///
/// Liste horizontale des meilleurs paniers disponibles
/// avec des cartes attrayantes et interactives.
class FeaturedBaskets extends StatefulWidget {
  /// Crée une nouvelle instance de [FeaturedBaskets].
  const FeaturedBaskets({super.key});

  @override
  State<FeaturedBaskets> createState() => _FeaturedBasketsState();
}

class _FeaturedBasketsState extends State<FeaturedBaskets>
    with TickerProviderStateMixin {
  late List<FeaturedBasketData> _featuredBaskets;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation d'entrée en fondu
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _loadFeaturedBaskets();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _loadFeaturedBaskets() {
    // Charger les vrais paniers de démonstration
    final demoBaskets = DemoDataService.getDemoBaskets();
    // Prendre seulement les 4 premiers paniers pour les vedettes
    _featuredBaskets = demoBaskets.take(4).map((basket) {
      return FeaturedBasketData(
        id: basket.id,
        name: basket.title,
        shop: basket.commerce.name,
        price: basket.discountedPrice,
        originalPrice: basket.originalPrice,
        rating: basket.commerce.averageRating,
        imageUrl: basket.imageUrls.isNotEmpty ? basket.imageUrls.first : '',
        isLastChance: basket.isLastChance,
        isFavorite: false, // On peut ajouter une logique de favoris persistés plus tard
      );
    }).toList();
  }

  void _toggleFavorite(String basketId) {
    setState(() {
      final basketIndex =
          _featuredBaskets.indexWhere((basket) => basket.id == basketId);
      if (basketIndex != -1) {
        _featuredBaskets[basketIndex] = _featuredBaskets[basketIndex].copyWith(
          isFavorite: !_featuredBaskets[basketIndex].isFavorite,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeController,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre de la section avec animation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
                child: Text(
                  'Paniers Vedettes',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),

              // Liste des paniers
              SizedBox(
                height: 290, // Ajusté pour la nouvelle hauteur des cartes (280px + petite marge)
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingL,
                  ),
                  itemCount: _featuredBaskets.length,
                  itemBuilder: (context, index) {
                    final basket = _featuredBaskets[index];
                    final product = ProductModel(
                      id: basket.id,
                      name: basket.name,
                      shop: basket.shop,
                      price: basket.price,
                      originalPrice: basket.originalPrice,
                      rating: basket.rating,
                      imageUrl: basket.imageUrl,
                      isLastChance: basket.isLastChance,
                      isFavorite: basket.isFavorite,
                    );

                    return ProductCard(
                      product: product,
                      index: index,
                      onTap: () => AppRoutes.navigateToBasketDetail(context, basket.id),
                      onFavoriteToggle: (_) => _toggleFavorite(basket.id),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}

/// Modèle de données pour un panier vedette.
/// Version simplifiée pour l'affichage des paniers en vedette.
class FeaturedBasketData {
  /// Identifiant unique du panier.
  final String id;

  /// Nom du panier.
  final String name;

  /// Nom du commerce.
  final String shop;

  /// Prix réduit.
  final double price;

  /// Prix original.
  final double originalPrice;

  /// Note moyenne.
  final double rating;

  /// URL de l'image.
  final String imageUrl;

  /// Indique si c'est une dernière chance.
  final bool isLastChance;

  /// Indique si c'est un favori.
  final bool isFavorite;

  /// Crée une nouvelle instance de [FeaturedBasketData].
  const FeaturedBasketData({
    required this.id,
    required this.name,
    required this.shop,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.imageUrl,
    required this.isLastChance,
    required this.isFavorite,
  });

  /// Crée une copie avec des valeurs modifiées.
  FeaturedBasketData copyWith({
    bool? isFavorite,
  }) {
    return FeaturedBasketData(
      id: id,
      name: name,
      shop: shop,
      price: price,
      originalPrice: originalPrice,
      rating: rating,
      imageUrl: imageUrl,
      isLastChance: isLastChance,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}