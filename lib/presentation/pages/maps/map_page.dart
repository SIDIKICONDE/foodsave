import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/config/maps_config.dart';
import '../../../models/map_marker.dart';
import '../../../core/services/maps_service.dart';
import '../../../widgets/map/basket_info_card.dart';
import '../../../widgets/map/map_controls.dart';
import '../../../core/constants/app_colors.dart';

/// Page principale affichant la carte avec les paniers géolocalisés
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final MapsService _mapsService;
  GoogleMapController? _mapController;
  double _currentZoom = MapsConfig.defaultZoom;

  @override
  void initState() {
    super.initState();
    _mapsService = MapsService();
    _initializeMap();
  }

  /// Initialiser la carte et charger les données
  Future<void> _initializeMap() async {
    // Charger les marqueurs de démonstration
    _loadDemoMarkers();
    
      // Obtenir la position actuelle
    await _mapsService.getCurrentPosition();
  }

  /// Charger des marqueurs de démonstration
  void _loadDemoMarkers() {
    final List<MapMarker> demoMarkers = [
      MapMarker(
        id: 'marker_1',
        position: const LatLng(48.8566, 2.3522), // Paris
        type: MarkerType.boulangerie,
        title: 'Boulangerie du Coin',
        description: 'Panier surprise avec viennoiseries',
        price: 3.99,
        shopName: 'Au Bon Pain',
        address: '12 Rue de la Paix, Paris',
        rating: 4.5,
        quantity: 3,
        availableUntil: DateTime.now().add(const Duration(hours: 2)),
        imageUrl: 'https://images.unsplash.com/photo-1549931319-a545dcf3bc73',
      ),
      MapMarker(
        id: 'marker_2',
        position: const LatLng(48.8584, 2.3502),
        type: MarkerType.restaurant,
        title: 'Plat du jour',
        description: 'Reste de service midi - Cuisine française',
        price: 5.99,
        shopName: 'Le Bistrot',
        address: '45 Avenue Victor Hugo, Paris',
        rating: 4.2,
        quantity: 2,
        availableUntil: DateTime.now().add(const Duration(hours: 1)),
      ),
      MapMarker(
        id: 'marker_3',
        position: const LatLng(48.8530, 2.3499),
        type: MarkerType.supermarche,
        title: 'Panier légumes',
        description: 'Légumes proches de la date limite',
        price: 2.99,
        shopName: 'Carrefour City',
        address: '78 Boulevard Saint-Michel, Paris',
        rating: 3.8,
        quantity: 5,
        availableUntil: DateTime.now().add(const Duration(hours: 4)),
        imageUrl: 'https://images.unsplash.com/photo-1488459716781-31db52582fe9',
      ),
      MapMarker(
        id: 'marker_4',
        position: const LatLng(48.8600, 2.3475),
        type: MarkerType.primeur,
        title: 'Fruits de saison',
        description: 'Assortiment de fruits mûrs',
        price: 4.50,
        shopName: 'Primeur Martin',
        address: '23 Rue de Rivoli, Paris',
        rating: 4.7,
        quantity: 4,
        availableUntil: DateTime.now().add(const Duration(hours: 3)),
      ),
      MapMarker(
        id: 'marker_5',
        position: const LatLng(48.8545, 2.3560),
        type: MarkerType.autre,
        title: 'Box surprise',
        description: 'Produits variés à découvrir',
        price: 6.99,
        shopName: 'Épicerie Fine',
        address: '90 Rue du Faubourg Saint-Antoine, Paris',
        rating: 4.0,
        quantity: 1,
        availableUntil: DateTime.now().add(const Duration(minutes: 45)),
      ),
    ];

    _mapsService.addMarkers(demoMarkers);
  }

  /// Callback quand la carte est créée
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapsService.setMapController(controller);
    
    // Style appliqué directement dans GoogleMap.style
  }

  /// Centrer sur la position actuelle
  Future<void> _centerOnLocation() async {
    if (_mapsService.isTrackingLocation) {
      _mapsService.stopLocationTracking();
    } else {
      await _mapsService.startLocationTracking();
      await _mapsService.centerOnCurrentLocation();
    }
  }

  /// Zoomer
  void _zoomIn() async {
    if (_mapController != null) {
      _currentZoom++;
      await _mapController!.animateCamera(CameraUpdate.zoomIn());
    }
  }

  /// Dézoomer
  void _zoomOut() async {
    if (_mapController != null) {
      _currentZoom--;
      await _mapController!.animateCamera(CameraUpdate.zoomOut());
    }
  }

  /// Afficher tous les marqueurs
  void _showAll() {
    _mapsService.fitAllMarkers();
  }

  /// Naviguer vers un panier
  void _navigateToBasket() {
    // TODO: Implémenter la navigation GPS
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Navigation vers le panier...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  /// Basculer favori
  void _toggleFavorite(MapMarker marker) {
    // TODO: Implémenter la gestion des favoris
    final updatedMarker = marker.copyWith(isFavorite: !marker.isFavorite);
    _mapsService.addMarker(updatedMarker);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des paniers'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implémenter la recherche
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Carte Google Maps
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _mapsService.currentLatLng,
              zoom: _currentZoom,
            ),
            markers: _mapsService.getFilteredGoogleMarkers(),
            myLocationEnabled: false, // Géré manuellement
            myLocationButtonEnabled: false, // Bouton personnalisé
            zoomControlsEnabled: false, // Contrôles personnalisés
            mapToolbarEnabled: false,
            compassEnabled: true,
            style: MapsConfig.mapStyle, // Utilisation directe du style
          ),

          // Contrôles de la carte
          Positioned(
            right: 16,
            bottom: _mapsService.selectedMarker != null ? 280 : 100,
            child: MapControls(
              onMyLocation: _centerOnLocation,
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
              onShowAll: _showAll,
              isTrackingLocation: _mapsService.isTrackingLocation,
            ),
          ),

          // Carte d'information du panier sélectionné
          if (_mapsService.selectedMarker != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BasketInfoCard(
                marker: _mapsService.selectedMarker!,
                onClose: _mapsService.clearSelection,
                onNavigate: _navigateToBasket,
                onToggleFavorite: () => _toggleFavorite(_mapsService.selectedMarker!),
              ),
            ),
        ],
      ),
    );
  }

  /// Afficher la feuille de filtres
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barre de titre
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Filtres',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // TODO: Implémenter les filtres sans provider
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Filtres à implémenter'),
            ),

            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}