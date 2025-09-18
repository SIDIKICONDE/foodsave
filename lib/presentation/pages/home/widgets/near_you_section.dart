import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_dimensions.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/core/routes/app_routes.dart';

/// Section affichant les paniers proches de l'utilisateur.
/// 
/// Combine une mini-carte et une liste des commerces
/// les plus proches avec leurs paniers disponibles.
class NearYouSection extends StatelessWidget {
  /// Crée une nouvelle instance de [NearYouSection].
  const NearYouSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingL,
      ),
      child: Column(
        children: [
          // Mini carte
          _buildMiniMap(context),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Liste des commerces proches
          ..._nearbyShops.map((shop) => _NearbyShopTile(shop: shop)),
        ],
      ),
    );
  }

  /// Construit la mini-carte.
  Widget _buildMiniMap(BuildContext context) {
    return GestureDetector(
      onTap: () => AppRoutes.navigateToBasketsMap(context),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(48.8566, 2.3522), // Paris
                  zoom: 12,
                ),
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                markers: _demoMarkers,
                liteModeEnabled: true,
              ),

              // Bouton d'expansion
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingM,
                    vertical: AppDimensions.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.map,
                        color: AppColors.textOnDark,
                        size: 16,
                      ),
                      const SizedBox(width: AppDimensions.spacingS),
                      Text(
                        'Voir la carte',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textOnDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Position actuelle (étiquette)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingM,
                    vertical: AppDimensions.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.my_location,
                        color: AppColors.info,
                        size: 16,
                      ),
                      const SizedBox(width: AppDimensions.spacingS),
                      Text(
                        'Votre position',
                        style: AppTextStyles.labelSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Marqueurs de démonstration pour la mini carte.
  Set<Marker> get _demoMarkers {
    const LatLng center = LatLng(48.8566, 2.3522);
    return <Marker>{
      const Marker(
        markerId: MarkerId('center'),
        position: center,
        infoWindow: InfoWindow(title: 'Votre position (approx.)'),
      ),
      const Marker(
        markerId: MarkerId('shop1'),
        position: LatLng(48.8616, 2.3622),
        infoWindow: InfoWindow(title: 'Boulangerie du Coin'),
      ),
      const Marker(
        markerId: MarkerId('shop2'),
        position: LatLng(48.8516, 2.3422),
        infoWindow: InfoWindow(title: 'Super Marché Bio'),
      ),
      const Marker(
        markerId: MarkerId('shop3'),
        position: LatLng(48.8666, 2.3322),
        infoWindow: InfoWindow(title: 'Café Gourmand'),
      ),
    };
  }

  /// Liste des commerces proches.
  static final List<NearbyShop> _nearbyShops = [
    NearbyShop(
      name: 'Boulangerie du Coin',
      distance: 0.3,
      availableBaskets: 2,
      closingTime: '19:00',
      type: ShopType.bakery,
    ),
    NearbyShop(
      name: 'Super Marché Bio',
      distance: 0.8,
      availableBaskets: 5,
      closingTime: '20:30',
      type: ShopType.grocery,
    ),
    NearbyShop(
      name: 'Café Gourmand',
      distance: 1.1,
      availableBaskets: 1,
      closingTime: '18:00',
      type: ShopType.restaurant,
    ),
  ];
}

/// Tuile représentant un commerce proche.
class _NearbyShopTile extends StatelessWidget {
  /// Données du commerce.
  final NearbyShop shop;

  /// Crée une nouvelle instance de [_NearbyShopTile].
  const _NearbyShopTile({required this.shop});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onShopTap(context),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Row(
              children: [
                // Icône du type de commerce
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  decoration: BoxDecoration(
                    color: _getShopColor().withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getShopIcon(),
                    color: _getShopColor(),
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: AppDimensions.spacingM),
                
                // Informations du commerce
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shop.name,
                        style: AppTextStyles.headline6.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${shop.distance} km',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: AppDimensions.spacingM),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Jusqu\'à ${shop.closingTime}',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Badge nombre de paniers
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingM,
                    vertical: AppDimensions.spacingS,
                  ),
                  decoration: BoxDecoration(
                    color: shop.availableBaskets > 0
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  ),
                  child: Text(
                    shop.availableBaskets > 0
                        ? '${shop.availableBaskets} ${shop.availableBaskets > 1 ? 'paniers' : 'panier'}'
                        : 'Épuisé',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: shop.availableBaskets > 0
                          ? AppColors.success
                          : AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Retourne la couleur selon le type de commerce.
  Color _getShopColor() {
    switch (shop.type) {
      case ShopType.bakery:
        return const Color(0xFFFFA726);
      case ShopType.grocery:
        return AppColors.eco;
      case ShopType.restaurant:
        return const Color(0xFFEF5350);
    }
  }

  /// Retourne l'icône selon le type de commerce.
  IconData _getShopIcon() {
    switch (shop.type) {
      case ShopType.bakery:
        return Icons.bakery_dining;
      case ShopType.grocery:
        return Icons.shopping_basket;
      case ShopType.restaurant:
        return Icons.restaurant;
    }
  }

  /// Gère le tap sur un commerce.
  void _onShopTap(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Commerce : ${shop.name}'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// Modèle de données pour un commerce proche.
class NearbyShop {
  /// Nom du commerce.
  final String name;
  
  /// Distance en km.
  final double distance;
  
  /// Nombre de paniers disponibles.
  final int availableBaskets;
  
  /// Heure de fermeture.
  final String closingTime;
  
  /// Type de commerce.
  final ShopType type;

  /// Crée une nouvelle instance de [NearbyShop].
  const NearbyShop({
    required this.name,
    required this.distance,
    required this.availableBaskets,
    required this.closingTime,
    required this.type,
  });
}

/// Types de commerces.
enum ShopType {
  /// Boulangerie.
  bakery,
  
  /// Épicerie.
  grocery,
  
  /// Restaurant.
  restaurant,
}