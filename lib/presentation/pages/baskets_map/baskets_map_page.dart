import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/core/constants/app_text_styles.dart';
import 'package:foodsave_app/core/services/maps_service.dart';
import 'package:foodsave_app/core/config/maps_config.dart';
import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/presentation/blocs/basket/basket_bloc.dart';
import 'package:foodsave_app/presentation/blocs/basket/basket_event.dart';
import 'package:foodsave_app/presentation/blocs/basket/basket_state.dart';
import 'package:foodsave_app/presentation/pages/baskets_map/widgets/map_bottom_sheet.dart';
import 'package:foodsave_app/presentation/pages/baskets_map/widgets/map_floating_search.dart';
import 'package:foodsave_app/presentation/pages/baskets_map/widgets/map_controls.dart';

/// Page affichant les paniers anti-gaspi sur une carte Google Maps.
///
/// Cette page combine une carte interactive avec une liste de paniers,
/// permettant aux utilisateurs de visualiser et explorer les paniers
/// disponibles de manière géographique.
class BasketsMapPage extends StatefulWidget {
  /// Crée une nouvelle instance de [BasketsMapPage].
  const BasketsMapPage({super.key});

  @override
  State<BasketsMapPage> createState() => _BasketsMapPageState();
}

class _BasketsMapPageState extends State<BasketsMapPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _bottomSheetController;
  late Animation<double> _mapAnimation;

  final MapsService _mapsService = MapsService();
  final TextEditingController _searchController = TextEditingController();
  
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng _currentMapCenter = const LatLng(
    MapsConfig.defaultLatitude,
    MapsConfig.defaultLongitude,
  );
  
  Basket? _selectedBasket;
  bool _isBottomSheetExpanded = false;
  bool _isLocationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _requestLocationAndLoadBaskets();
  }

  /// Initialise les animations de la page.
  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _bottomSheetController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _mapAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  /// Demande la permission de géolocalisation et charge les paniers.
  void _requestLocationAndLoadBaskets() async {
    final hasPermission = await _mapsService.requestLocationPermission();
    setState(() {
      _isLocationPermissionGranted = hasPermission;
    });

    if (hasPermission) {
      final userLocation = await _mapsService.getCurrentPosition();
      if (userLocation != null) {
        setState(() {
          _currentMapCenter = userLocation;
        });
        _loadBaskets();
      }
    } else {
      _loadBaskets();
    }
  }

  /// Charge les paniers depuis le BLoC.
  void _loadBaskets() {
    context.read<BasketBloc>().add(LoadAvailableBaskets(
      latitude: _currentMapCenter.latitude,
      longitude: _currentMapCenter.longitude,
      radius: 10.0,
      refresh: true,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _bottomSheetController.dispose();
    _searchController.dispose();
    _mapsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: AnimatedBuilder(
        animation: _mapAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _mapAnimation.value,
            child: Stack(
              children: [
                // Carte Google Maps
                _buildGoogleMap(),

                // Barre de recherche flottante
                Positioned(
                  top: kToolbarHeight + MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                  child: MapFloatingSearch(
                    controller: _searchController,
                    onSearchChanged: _handleSearch,
                    onFilterPressed: _showFiltersDialog,
                  ),
                ),

                // Contrôles de la carte
                Positioned(
                  right: 16,
                  bottom: _isBottomSheetExpanded ? 400 : 200,
                  child: MapControls(
                    onCurrentLocationPressed: _goToCurrentLocation,
                    onLayersPressed: _showLayersDialog,
                    isLocationEnabled: _isLocationPermissionGranted,
                  ),
                ),

                // Bottom sheet avec détails
                _buildBottomSheet(),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Construit la barre d'application.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          'Carte des paniers',
          style: AppTextStyles.headline6.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.list, color: AppColors.textPrimary),
            onPressed: () {
              // Basculer vers la vue liste
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }

  /// Construit la carte Google Maps.
  Widget _buildGoogleMap() {
    return BlocConsumer<BasketBloc, BasketState>(
      listener: (context, state) {
        if (state is BasketLoaded) {
          _updateMapMarkers(state.baskets);
        }
      },
      builder: (context, state) {
        return GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _currentMapCenter,
            zoom: MapsConfig.defaultZoom,
          ),
          markers: _markers,
          onTap: _onMapTapped,
          onCameraMove: _onCameraMove,
          myLocationEnabled: _isLocationPermissionGranted,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          style: _getMapStyle(),
          minMaxZoomPreference: const MinMaxZoomPreference(
            MapsConfig.minZoom,
            MapsConfig.maxZoom,
          ),
        );
      },
    );
  }

  /// Construit le bottom sheet avec les détails.
  Widget _buildBottomSheet() {
    return BlocBuilder<BasketBloc, BasketState>(
      builder: (context, state) {
        if (state is! BasketLoaded || _selectedBasket == null) {
          return const SizedBox.shrink();
        }

        return MapBottomSheet(
          basket: _selectedBasket!,
          isExpanded: _isBottomSheetExpanded,
          onToggleExpanded: () {
            setState(() {
              _isBottomSheetExpanded = !_isBottomSheetExpanded;
            });
            if (_isBottomSheetExpanded) {
              _bottomSheetController.forward();
            } else {
              _bottomSheetController.reverse();
            }
          },
          onClose: () {
            setState(() {
              _selectedBasket = null;
              _isBottomSheetExpanded = false;
            });
            _bottomSheetController.reverse();
            _updateMarkerSelection(null);
          },
          onReserve: () {
            _handleBasketReservation(_selectedBasket!);
          },
          onGetDirections: () {
            _getDirectionsToBasket(_selectedBasket!);
          },
        );
      },
    );
  }

  /// Callback appelé lors de la création de la carte.
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapsService.setMapController(controller);
  }

  /// Callback appelé lors du tap sur la carte.
  void _onMapTapped(LatLng position) {
    if (_selectedBasket != null) {
      setState(() {
        _selectedBasket = null;
        _isBottomSheetExpanded = false;
      });
      _updateMarkerSelection(null);
    }
  }

  /// Callback appelé lors du mouvement de la caméra.
  void _onCameraMove(CameraPosition position) {
    _currentMapCenter = position.target;
  }

  /// Met à jour les marqueurs sur la carte.
  void _updateMapMarkers(List<Basket> baskets) async {
    final newMarkers = await _mapsService.basketsToMarkers(
      baskets,
      onMarkerTap: _onMarkerTapped,
      selectedBasketId: _selectedBasket?.id,
    );

    if (mounted) {
      setState(() {
        _markers = newMarkers;
      });

      // Ajuster la vue pour afficher tous les marqueurs
      if (baskets.isNotEmpty) {
        final positions = baskets.map((basket) => 
          LatLng(basket.commerce.latitude, basket.commerce.longitude)
        ).toList();
        await _mapsService.fitBounds(positions);
      }
    }
  }

  /// Callback appelé lors du tap sur un marqueur.
  void _onMarkerTapped(Basket basket) {
    setState(() {
      _selectedBasket = basket;
      _isBottomSheetExpanded = false;
    });
    _updateMarkerSelection(basket.id);
    _bottomSheetController.forward();
  }

  /// Met à jour la sélection des marqueurs.
  void _updateMarkerSelection(String? selectedBasketId) async {
    final state = context.read<BasketBloc>().state;
    if (state is BasketLoaded) {
      final updatedMarkers = await _mapsService.basketsToMarkers(
        state.baskets,
        onMarkerTap: _onMarkerTapped,
        selectedBasketId: selectedBasketId,
      );
      
      if (mounted) {
        setState(() {
          _markers = updatedMarkers;
        });
      }
    }
  }

  /// Gère la recherche de paniers.
  void _handleSearch(String query) {
    if (query.isNotEmpty) {
      context.read<BasketBloc>().add(SearchBasketsEvent(
        query: query,
        latitude: _currentMapCenter.latitude,
        longitude: _currentMapCenter.longitude,
        radius: 10.0,
      ));
    } else {
      _loadBaskets();
    }
  }

  /// Va à la position actuelle de l'utilisateur.
  void _goToCurrentLocation() async {
    if (!_isLocationPermissionGranted) {
      final hasPermission = await _mapsService.requestLocationPermission();
      if (!hasPermission) return;
      
      setState(() {
        _isLocationPermissionGranted = true;
      });
    }

    final userLocation = await _mapsService.getCurrentPosition();
    if (userLocation != null && _mapController != null) {
      await _mapsService.moveCamera(userLocation, zoom: 16.0);
      setState(() {
        _currentMapCenter = userLocation;
      });
    }
  }

  /// Affiche le dialogue des filtres.
  void _showFiltersDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                '🔍 Filtres de recherche',
                style: AppTextStyles.headline6.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Expanded(
                child: Center(
                  child: Text('Filtres à implémenter...'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Affiche le dialogue des couches de carte.
  void _showLayersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🗺️ Style de carte'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Standard'),
              onTap: () {
                Navigator.of(context).pop();
                // Appliquer le style standard
              },
            ),
            ListTile(
              leading: const Icon(Icons.satellite),
              title: const Text('Satellite'),
              onTap: () {
                Navigator.of(context).pop();
                // Appliquer le style satellite
              },
            ),
            ListTile(
              leading: const Icon(Icons.terrain),
              title: const Text('Terrain'),
              onTap: () {
                Navigator.of(context).pop();
                // Appliquer le style terrain
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Gère la réservation d'un panier.
  void _handleBasketReservation(Basket basket) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🛒 ${basket.title} ajouté au panier'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Obtient les directions vers un panier.
  void _getDirectionsToBasket(Basket basket) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🗺️ Directions vers ${basket.commerce.name}'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Retourne le style de carte approprié.
  String? _getMapStyle() {
    // Retourner null pour le style par défaut
    // ou MapsConfig.darkMapStyle pour le mode sombre
    return null;
  }
}