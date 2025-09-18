import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/config/maps_config.dart';
import '../../../models/map_marker.dart';
import '../../../services/maps_service.dart';
import '../../../services/demo_map_service.dart';
import '../../../services/navigation_service.dart';
import '../../../widgets/map/basket_info_card.dart';
import '../../../widgets/map/map_controls.dart';

/// Page de carte améliorée avec toutes les fonctionnalités avancées
class EnhancedMapPage extends StatefulWidget {
  const EnhancedMapPage({super.key});

  @override
  State<EnhancedMapPage> createState() => _EnhancedMapPageState();
}

class _EnhancedMapPageState extends State<EnhancedMapPage> {
  // Services
  late final MapsService _mapsService;
  late final DemoMapService _demoService;

  // Contrôleurs
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  // État
  Set<Marker> _markers = {};
  bool _isSearching = false;
  Timer? _searchDebouncer;
  Position? _currentPosition;

  // Zoom et position
  double _currentZoom = MapsConfig.defaultZoom;
  LatLng _currentCenter = MapsConfig.defaultPosition;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadData();
  }

  /// Initialiser les services
  void _initializeServices() {
    _mapsService = MapsService();
    _demoService = DemoMapService();
  }

  /// Charger les données initiales
  Future<void> _loadData() async {
    setState(() => _isSearching = true);

    try {
      // Initialiser le service de démonstration
      await _demoService.initialize();

      // Obtenir la position actuelle
      _currentPosition = await Geolocator.getCurrentPosition();
      if (_currentPosition != null && mounted) {
        setState(() {
          _currentCenter = LatLng(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
          );
        });
      }

      // Charger les paniers depuis le service de démonstration
      final markers = await _demoService.fetchBasketsFromSupabase(
        center: _currentCenter,
        radiusKm: 20,
      );

      // Convertir en marqueurs Google Maps
      final googleMarkers = markers.map((marker) => Marker(
        markerId: MarkerId(marker.id),
        position: marker.position,
        icon: marker.type.markerColor,
        infoWindow: InfoWindow(
          title: marker.title,
          snippet: marker.description,
        ),
        onTap: () => _onMarkerTap(marker),
      )).toSet();

      // Mettre à jour les marqueurs
      setState(() {
        _markers = googleMarkers;
      });
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }



  /// Gérer le clic sur un marqueur
  void _onMarkerTap(MapMarker marker) {
    _mapsService.selectMarker(marker.id);
    _showBasketDetails(marker);
  }

  /// Afficher les détails d'un panier
  void _showBasketDetails(MapMarker marker) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.8,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: BasketInfoCard(
            marker: marker,
            onClose: () => Navigator.pop(context),
            onNavigate: () => _navigateToBasket(marker),
            onToggleFavorite: () => _toggleFavorite(marker),
          ),
        ),
      ),
    );
  }

  /// Naviguer vers un panier
  void _navigateToBasket(MapMarker marker) {
    NavigationService.showNavigationOptions(
      context: context,
      destination: marker.position,
      destinationName: marker.shopName ?? marker.title,
    );
  }

  /// Basculer un favori
  Future<void> _toggleFavorite(MapMarker marker) async {
    final isFavorite = await _demoService.toggleFavorite(marker.id);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite 
              ? 'Ajouté aux favoris' 
              : 'Retiré des favoris',
          ),
          backgroundColor: isFavorite ? Colors.green : Colors.grey,
        ),
      );
    }
    
    // Recharger les marqueurs
    await _loadData();
  }

  /// Rechercher une adresse (version simplifiée)
  void _searchAddress(String query) {
    // Annuler le debouncer précédent
    _searchDebouncer?.cancel();

    if (query.isEmpty) {
      return;
    }

    // Débouncer la recherche (simplifiée)
    _searchDebouncer = Timer(const Duration(milliseconds: 500), () async {
      // TODO: Implémenter la recherche d'adresse avec une API compatible
      debugPrint('Recherche: $query');
    });
  }

  /// Construire la barre de recherche
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher une adresse...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _searchController.clear();
                  });
                },
              )
            : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        onChanged: _searchAddress,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Carte Google Maps avec clustering
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
              _mapsService.setMapController(controller);
            },
            initialCameraPosition: CameraPosition(
              target: _currentCenter,
              zoom: _currentZoom,
            ),
            markers: _markers,
            onCameraMove: (position) {
              _currentZoom = position.zoom;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: true,
          ),

          // Barre de recherche
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: _buildSearchBar(),
          ),

          // Contrôles de la carte
          Positioned(
            right: 16,
            bottom: 100,
            child: MapControls(
              onMyLocation: () async {
                if (_mapsService.isTrackingLocation) {
                  _mapsService.stopLocationTracking();
                } else {
                  await _mapsService.startLocationTracking();
                  await _mapsService.centerOnCurrentLocation();
                }
              },
              onZoomIn: () async {
                if (_mapController != null) {
                  await _mapController!.animateCamera(CameraUpdate.zoomIn());
                }
              },
              onZoomOut: () async {
                if (_mapController != null) {
                  await _mapController!.animateCamera(CameraUpdate.zoomOut());
                }
              },
              onShowAll: () => _mapsService.fitAllMarkers(),
              isTrackingLocation: _mapsService.isTrackingLocation,
            ),
          ),

          // Indicateur de chargement
          if (_isSearching)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebouncer?.cancel();
    _demoService.dispose();
    _mapController?.dispose();
    super.dispose();
  }
}
