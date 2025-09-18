import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/domain/entities/commerce.dart';
import 'package:foodsave_app/core/config/maps_config.dart';
import 'package:foodsave_app/core/constants/app_colors.dart';
import 'package:foodsave_app/models/map_marker.dart';

/// Service de gestion des cartes Google Maps.
///
/// Centralise toute la logique liée aux cartes : géolocalisation,
/// marqueurs, permissions, et interactions avec l'API Google Maps.
class MapsService extends ChangeNotifier {
  /// Instance singleton du service.
  static final MapsService _instance = MapsService._internal();
  
  /// Factory constructor pour obtenir l'instance singleton.
  factory MapsService() => _instance;
  
  /// Constructeur privé.
  MapsService._internal();

  /// Contrôleur de la carte Google Maps.
  GoogleMapController? _mapController;

  /// Liste des marqueurs affichés sur la carte.
  final List<MapMarker> _markers = [];

  /// Marqueur actuellement sélectionné.
  MapMarker? _selectedMarker;

  /// Filtres actifs pour les marqueurs.
  final Set<MarkerType> _activeFilters = {};
  
  /// Position actuelle de l'utilisateur.
  LatLng? _currentPosition;
  
  /// Stream pour écouter les changements de position.
  StreamSubscription<Position>? _positionStream;

  // === PERMISSIONS ET GÉOLOCALISATION ===

  /// Vérifie et demande les permissions de géolocalisation.
  Future<bool> requestLocationPermission() async {
    try {
      final PermissionStatus permission = await Permission.location.request();
      return permission == PermissionStatus.granted;
    } catch (e) {
      return false;
    }
  }

  /// Obtient la position actuelle de l'utilisateur.
  Future<LatLng?> getCurrentPosition() async {
    try {
      final bool hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        return null;
      }

      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      _currentPosition = LatLng(position.latitude, position.longitude);
      return _currentPosition;
    } catch (e) {
      return null;
    }
  }

  /// Démarre l'écoute des changements de position.
  void startLocationUpdates({
    required Function(LatLng) onLocationChanged,
  }) {
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Mise à jour tous les 10 mètres
      ),
    ).listen((Position position) {
      final newPosition = LatLng(position.latitude, position.longitude);
      _currentPosition = newPosition;
      onLocationChanged(newPosition);
    });
  }

  /// Arrête l'écoute des changements de position.
  void stopLocationUpdates() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  // === GESTION DE LA CARTE ===

  /// Initialise le contrôleur de la carte.
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  /// Déplace la caméra vers une position donnée.
  Future<void> moveCamera(LatLng position, {double zoom = 14.0}) async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: zoom,
          ),
        ),
      );
    }
  }

  /// Ajuste la caméra pour afficher tous les marqueurs.
  Future<void> fitBounds(List<LatLng> positions) async {
    if (_mapController == null || positions.isEmpty) return;

    if (positions.length == 1) {
      await moveCamera(positions.first);
      return;
    }

    double minLat = positions.first.latitude;
    double maxLat = positions.first.latitude;
    double minLng = positions.first.longitude;
    double maxLng = positions.first.longitude;

    for (final position in positions) {
      minLat = position.latitude < minLat ? position.latitude : minLat;
      maxLat = position.latitude > maxLat ? position.latitude : maxLat;
      minLng = position.longitude < minLng ? position.longitude : minLng;
      maxLng = position.longitude > maxLng ? position.longitude : maxLng;
    }

    await _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        100.0, // Padding
      ),
    );
  }

  // === MARQUEURS PERSONNALISÉS ===

  /// Crée un marqueur personnalisé pour un commerce.
  Future<BitmapDescriptor> createCommerceMarker(
    CommerceType commerceType, {
    bool isSelected = false,
  }) async {
    final String colorHex = _getMarkerColorForCommerce(commerceType);
    final String iconName = _getIconNameForCommerce(commerceType);
    
    return await _createCustomMarker(
      iconName: iconName,
      color: colorHex,
      isSelected: isSelected,
    );
  }

  /// Crée un marqueur pour la position actuelle de l'utilisateur.
  Future<BitmapDescriptor> createUserLocationMarker() async {
    return await _createCustomMarker(
      iconName: 'person_pin',
      color: AppColors.info.toARGB32().toRadixString(16),
      isSelected: true,
    );
  }

  /// Crée un marqueur personnalisé.
  Future<BitmapDescriptor> _createCustomMarker({
    required String iconName,
    required String color,
    bool isSelected = false,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(pictureRecorder);
    final double size = isSelected ? 120.0 : 100.0;

    // Dessiner le cercle de fond
    final ui.Paint circlePaint = ui.Paint()
      ..color = _hexToColor(color)
      ..style = ui.PaintingStyle.fill;

    canvas.drawCircle(
      ui.Offset(size / 2, size / 2),
      size / 2,
      circlePaint,
    );

    // Dessiner la bordure si sélectionné
    if (isSelected) {
      final ui.Paint borderPaint = ui.Paint()
        ..color = AppColors.surface
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 4.0;

      canvas.drawCircle(
        ui.Offset(size / 2, size / 2),
        size / 2 - 2,
        borderPaint,
      );
    }
    
    final ui.Picture picture = pictureRecorder.endRecording();
    final ui.Image image = await picture.toImage(size.toInt(), size.toInt());
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  /// Convertit une couleur hexadécimale en Color.
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Retourne la couleur du marqueur selon le type de commerce.
  String _getMarkerColorForCommerce(CommerceType commerceType) {
    switch (commerceType) {
      case CommerceType.bakery:
        return MapsConfig.bakeryMarkerColor;
      case CommerceType.restaurant:
        return MapsConfig.restaurantMarkerColor;
      case CommerceType.grocery:
        return MapsConfig.groceryMarkerColor;
      case CommerceType.supermarket:
        return MapsConfig.supermarketMarkerColor;
      default:
        return MapsConfig.defaultMarkerColor;
    }
  }

  /// Retourne le nom de l'icône selon le type de commerce.
  String _getIconNameForCommerce(CommerceType commerceType) {
    switch (commerceType) {
      case CommerceType.bakery:
        return 'bakery';
      case CommerceType.restaurant:
        return 'restaurant';
      case CommerceType.grocery:
        return 'local_grocery_store';
      case CommerceType.supermarket:
        return 'store';
      default:
        return 'store';
    }
  }

  // === CALCULS DE DISTANCE ===

  /// Calcule la distance entre deux points en kilomètres.
  double calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    ) / 1000; // Conversion en kilomètres
  }

  /// Filtre les paniers selon la distance.
  List<Basket> filterBasketsByDistance({
    required List<Basket> baskets,
    required LatLng userLocation,
    required double maxDistanceKm,
  }) {
    return baskets.where((basket) {
      final commerceLocation = LatLng(
        basket.commerce.latitude,
        basket.commerce.longitude,
      );
      final distance = calculateDistance(userLocation, commerceLocation);
      return distance <= maxDistanceKm;
    }).toList();
  }

  /// Trie les paniers par distance.
  List<Basket> sortBasketsByDistance({
    required List<Basket> baskets,
    required LatLng userLocation,
  }) {
    final List<Basket> sortedBaskets = List.from(baskets);
    
    sortedBaskets.sort((a, b) {
      final distanceA = calculateDistance(
        userLocation,
        LatLng(a.commerce.latitude, a.commerce.longitude),
      );
      final distanceB = calculateDistance(
        userLocation,
        LatLng(b.commerce.latitude, b.commerce.longitude),
      );
      return distanceA.compareTo(distanceB);
    });
    
    return sortedBaskets;
  }

  // === CONVERSION DES DONNÉES ===

  /// Convertit une liste de paniers en marqueurs.
  Future<Set<Marker>> basketsToMarkers(
    List<Basket> baskets, {
    required Function(Basket) onMarkerTap,
    String? selectedBasketId,
  }) async {
    final Set<Marker> markers = {};
    
    for (final basket in baskets) {
      final bool isSelected = basket.id == selectedBasketId;
      final BitmapDescriptor icon = await createCommerceMarker(
        basket.commerce.type,
        isSelected: isSelected,
      );
      
      markers.add(
        Marker(
          markerId: MarkerId(basket.id),
          position: LatLng(
            basket.commerce.latitude,
            basket.commerce.longitude,
          ),
          icon: icon,
          infoWindow: InfoWindow(
            title: basket.commerce.name,
            snippet: '${basket.discountedPrice.toStringAsFixed(2)}€ • ${basket.title}',
          ),
          onTap: () => onMarkerTap(basket),
        ),
      );
    }
    
    return markers;
  }

  // === GESTION DES MARQUEURS ===

  /// Ajoute plusieurs marqueurs à la carte.
  void addMarkers(List<MapMarker> markers) {
    _markers.clear();
    _markers.addAll(markers);
    _notifyListeners();
  }

  /// Ajoute un seul marqueur.
  void addMarker(MapMarker marker) {
    final existingIndex = _markers.indexWhere((m) => m.id == marker.id);
    if (existingIndex != -1) {
      _markers[existingIndex] = marker;
    } else {
      _markers.add(marker);
    }
    _notifyListeners();
  }

  /// Supprime un marqueur.
  void removeMarker(String markerId) {
    _markers.removeWhere((marker) => marker.id == markerId);
    if (_selectedMarker?.id == markerId) {
      _selectedMarker = null;
    }
    _notifyListeners();
  }

  /// Sélectionne un marqueur.
  void selectMarker(MapMarker marker) {
    _selectedMarker = marker;
    _notifyListeners();
  }

  /// Désélectionne le marqueur actuel.
  void clearSelection() {
    _selectedMarker = null;
    _notifyListeners();
  }

  // === GESTION DES FILTRES ===

  /// Active/désactive un filtre.
  void toggleFilter(MarkerType filter) {
    if (_activeFilters.contains(filter)) {
      _activeFilters.remove(filter);
    } else {
      _activeFilters.add(filter);
    }
    _notifyListeners();
  }

  /// Active tous les filtres.
  void enableAllFilters() {
    _activeFilters.addAll(MarkerType.values);
    _notifyListeners();
  }

  /// Désactive tous les filtres.
  void disableAllFilters() {
    _activeFilters.clear();
    _notifyListeners();
  }

  // === CONVERSION EN MARQUEURS GOOGLE MAPS ===

  /// Convertit les marqueurs filtrés en objets Google Maps.
  Set<Marker> getFilteredGoogleMarkers() {
    final filteredMarkers = _activeFilters.isEmpty
        ? _markers
        : _markers.where((marker) => _activeFilters.contains(marker.type)).toList();

    return filteredMarkers.map((mapMarker) {
      return Marker(
        markerId: MarkerId(mapMarker.id),
        position: mapMarker.position,
        icon: mapMarker.type.markerColor,
        infoWindow: InfoWindow(
          title: mapMarker.title,
          snippet: mapMarker.description,
        ),
        onTap: () => selectMarker(mapMarker),
      );
    }).toSet();
  }

  /// Ajuste la caméra pour afficher tous les marqueurs filtrés.
  Future<void> fitAllMarkers() async {
    final filteredMarkers = _activeFilters.isEmpty
        ? _markers
        : _markers.where((marker) => _activeFilters.contains(marker.type)).toList();

    if (filteredMarkers.isEmpty) return;

    final positions = filteredMarkers.map((marker) => marker.position).toList();
    await fitBounds(positions);
  }

  /// Méthode utilitaire pour notifier les listeners.
  void _notifyListeners() {
    notifyListeners();
  }

  // === NETTOYAGE ===

  /// Nettoie les ressources utilisées par le service.
  @override
  void dispose() {
    stopLocationUpdates();
    _mapController?.dispose();
    _mapController = null;
    _currentPosition = null;
    _markers.clear();
    _selectedMarker = null;
    _activeFilters.clear();
    super.dispose();
  }

  // === GETTERS ===

  /// Position actuelle de l'utilisateur.
  LatLng? get currentPosition => _currentPosition;

  /// Indique si le service de géolocalisation est actif.
  bool get isLocationUpdateActive => _positionStream != null;

  /// Position par défaut de la carte.
  LatLng get defaultPosition => const LatLng(
    MapsConfig.defaultLatitude,
    MapsConfig.defaultLongitude,
  );

  /// Liste des marqueurs affichés.
  List<MapMarker> get markers => List.unmodifiable(_markers);

  /// Marqueur actuellement sélectionné.
  MapMarker? get selectedMarker => _selectedMarker;

  /// Filtres actifs.
  Set<MarkerType> get activeFilters => Set.unmodifiable(_activeFilters);

  /// Position actuelle comme LatLng (alias pour compatibilité).
  LatLng get currentLatLng => _currentPosition ?? defaultPosition;

  /// Indique si le suivi de localisation est actif.
  bool get isTrackingLocation => isLocationUpdateActive;

  /// Démarre le suivi de localisation.
  Future<void> startLocationTracking() async {
    final hasPermission = await requestLocationPermission();
    if (hasPermission) {
      final position = await getCurrentPosition();
      if (position != null) {
        await moveCamera(position);
      }
    }
  }

  /// Arrête le suivi de localisation.
  Future<void> stopLocationTracking() async {
    stopLocationUpdates();
  }

  /// Centre la caméra sur la position actuelle.
  Future<void> centerOnCurrentLocation() async {
    final position = await getCurrentPosition();
    if (position != null) {
      await moveCamera(position);
    }
  }
}