import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../models/map_marker.dart';
import '../core/config/maps_config.dart';

/// Service pour gérer les interactions avec Google Maps
class MapsService with ChangeNotifier {
  /// Instance singleton du service
  static final MapsService _instance = MapsService._internal();
  factory MapsService() => _instance;
  MapsService._internal();

  /// Contrôleur de la carte Google Maps
  GoogleMapController? _mapController;
  
  /// Position actuelle de l'utilisateur
  Position? _currentPosition;
  
  /// Liste des marqueurs sur la carte
  final Map<String, MapMarker> _markers = {};
  
  /// Marqueur sélectionné
  MapMarker? _selectedMarker;
  
  /// Filtres actifs pour les types de marqueurs
  final Set<MarkerType> _activeFilters = MarkerType.values.toSet()..remove(MarkerType.userLocation);
  
  /// État du suivi de position
  bool _isTrackingLocation = false;
  
  /// Subscription pour le suivi de position
  StreamSubscription<Position>? _positionStreamSubscription;

  // Getters
  GoogleMapController? get mapController => _mapController;
  Position? get currentPosition => _currentPosition;
  Map<String, MapMarker> get markers => Map.unmodifiable(_markers);
  MapMarker? get selectedMarker => _selectedMarker;
  Set<MarkerType> get activeFilters => Set.unmodifiable(_activeFilters);
  bool get isTrackingLocation => _isTrackingLocation;

  /// Obtenir la position actuelle ou la position par défaut
  LatLng get currentLatLng {
    if (_currentPosition != null) {
      return LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    }
    return const LatLng(MapsConfig.defaultLatitude, MapsConfig.defaultLongitude);
  }

  /// Initialiser le contrôleur de carte
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  /// Vérifier et demander les permissions de localisation
  Future<bool> checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifier si le service de localisation est activé
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Obtenir la position actuelle de l'utilisateur
  Future<Position?> getCurrentLocation() async {
    try {
      final bool hasPermission = await checkLocationPermission();
      if (!hasPermission) return null;

      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      
      notifyListeners();
      return _currentPosition;
    } catch (e) {
      debugPrint('Erreur lors de l\'obtention de la position: $e');
      return null;
    }
  }

  /// Commencer le suivi de la position en temps réel
  Future<void> startLocationTracking() async {
    if (_isTrackingLocation) return;

    final bool hasPermission = await checkLocationPermission();
    if (!hasPermission) return;

    _isTrackingLocation = true;
    
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Mise à jour tous les 10 mètres
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _currentPosition = position;
      _updateUserLocationMarker(position);
      notifyListeners();
    });

    notifyListeners();
  }

  /// Arrêter le suivi de la position
  void stopLocationTracking() {
    _isTrackingLocation = false;
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    
    // Retirer le marqueur de position utilisateur
    _markers.removeWhere((key, marker) => marker.type == MarkerType.userLocation);
    
    notifyListeners();
  }

  /// Mettre à jour le marqueur de position utilisateur
  void _updateUserLocationMarker(Position position) {
    const String userMarkerId = 'user_location';
    
    _markers[userMarkerId] = MapMarker(
      id: userMarkerId,
      position: LatLng(position.latitude, position.longitude),
      type: MarkerType.userLocation,
      title: 'Ma position',
      description: 'Vous êtes ici',
    );
  }

  /// Centrer la carte sur la position actuelle
  Future<void> centerOnCurrentLocation() async {
    if (_currentPosition == null) {
      await getCurrentLocation();
    }
    
    if (_currentPosition != null && _mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          MapsConfig.defaultZoom,
        ),
      );
    }
  }

  /// Ajouter un marqueur sur la carte
  void addMarker(MapMarker marker) {
    _markers[marker.id] = marker;
    notifyListeners();
  }

  /// Ajouter plusieurs marqueurs
  void addMarkers(List<MapMarker> markers) {
    for (final marker in markers) {
      _markers[marker.id] = marker;
    }
    notifyListeners();
  }

  /// Retirer un marqueur de la carte
  void removeMarker(String markerId) {
    _markers.remove(markerId);
    if (_selectedMarker?.id == markerId) {
      _selectedMarker = null;
    }
    notifyListeners();
  }

  /// Effacer tous les marqueurs (sauf la position utilisateur)
  void clearMarkers() {
    MapMarker? userMarker;
    try {
      userMarker = _markers.values
          .firstWhere((m) => m.type == MarkerType.userLocation);
    } catch (e) {
      // Pas de marqueur utilisateur trouvé
      userMarker = null;
    }
    
    _markers.clear();
    
    if (userMarker != null) {
      _markers[userMarker.id] = userMarker;
    }
    
    _selectedMarker = null;
    notifyListeners();
  }

  /// Sélectionner un marqueur
  void selectMarker(String markerId) {
    _selectedMarker = _markers[markerId];
    notifyListeners();
  }

  /// Désélectionner le marqueur actuel
  void clearSelection() {
    _selectedMarker = null;
    notifyListeners();
  }

  /// Activer/désactiver un filtre de type de marqueur
  void toggleFilter(MarkerType type) {
    if (type == MarkerType.userLocation) return; // Ne pas filtrer la position utilisateur
    
    if (_activeFilters.contains(type)) {
      _activeFilters.remove(type);
    } else {
      _activeFilters.add(type);
    }
    notifyListeners();
  }

  /// Activer tous les filtres
  void enableAllFilters() {
    _activeFilters.addAll(MarkerType.values.where((t) => t != MarkerType.userLocation));
    notifyListeners();
  }

  /// Désactiver tous les filtres
  void disableAllFilters() {
    _activeFilters.clear();
    notifyListeners();
  }

  /// Obtenir les marqueurs filtrés
  Set<Marker> getFilteredGoogleMarkers() {
    return _markers.values
        .where((marker) => _activeFilters.contains(marker.type) || marker.type == MarkerType.userLocation)
        .map((marker) => Marker(
          markerId: MarkerId(marker.id),
          position: marker.position,
          icon: marker.type.markerColor,
          infoWindow: InfoWindow(
            title: marker.title,
            snippet: marker.description,
          ),
          onTap: () => selectMarker(marker.id),
        ))
        .toSet();
  }

  /// Animer la caméra vers une position spécifique
  Future<void> animateToPosition(LatLng position, {double? zoom}) async {
    if (_mapController == null) return;
    
    await _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(
        position,
        zoom ?? MapsConfig.defaultZoom,
      ),
    );
  }

  /// Ajuster la caméra pour afficher tous les marqueurs
  Future<void> fitAllMarkers({EdgeInsets padding = const EdgeInsets.all(50)}) async {
    if (_mapController == null || _markers.isEmpty) return;
    
    final List<LatLng> positions = _markers.values
        .where((marker) => _activeFilters.contains(marker.type) || marker.type == MarkerType.userLocation)
        .map((marker) => marker.position)
        .toList();
    
    if (positions.isEmpty) return;
    
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
        padding.left + padding.right,
      ),
    );
  }

  /// Nettoyer les ressources
  @override
  void dispose() {
    stopLocationTracking();
    _mapController = null;
    super.dispose();
  }
}