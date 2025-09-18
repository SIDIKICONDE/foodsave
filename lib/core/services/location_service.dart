import 'package:geolocator/geolocator.dart';

/// Service pour la gestion de la géolocalisation.
/// 
/// Gère les permissions, l'obtention de la position actuelle,
/// et le suivi des changements de position.
class LocationService {
  /// Instance singleton du service.
  static final LocationService _instance = LocationService._internal();

  /// Constructeur factory pour obtenir l'instance singleton.
  factory LocationService() => _instance;

  /// Constructeur interne pour le pattern singleton.
  LocationService._internal();

  /// Position actuelle mise en cache.
  Position? _currentPosition;

  /// Dernière fois que la position a été mise à jour.
  DateTime? _lastPositionUpdate;

  /// Durée de validité du cache de position en minutes.
  static const int _cacheValidityMinutes = 5;

  /// Obtient la position actuelle de l'utilisateur.
  /// 
  /// [forceRefresh] force le rafraîchissement même si la position est en cache.
  /// Retourne null si les permissions ne sont pas accordées ou si la localisation échoue.
  Future<Position?> getCurrentPosition({bool forceRefresh = false}) async {
    try {
      // Vérifier si on a une position en cache valide
      if (!forceRefresh && _isPositionCacheValid()) {
        return _currentPosition;
      }

      // Vérifier et demander les permissions
      final bool hasPermission = await _checkAndRequestLocationPermission();
      if (!hasPermission) {
        return null;
      }

      // Vérifier si le service de localisation est activé
      final bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        throw LocationServiceException('Le service de localisation est désactivé');
      }

      // Obtenir la position actuelle
      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10, // Mise à jour seulement si le déplacement > 10m
        ),
      );

      _lastPositionUpdate = DateTime.now();
      return _currentPosition;
    } on LocationServiceDisabledException {
      throw LocationServiceException('Service de localisation désactivé');
    } on PermissionDeniedException {
      throw LocationPermissionException('Permission de localisation refusée');
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw LocationTimeoutException('Timeout lors de l\'obtention de la position');
      }
      throw GenericLocationException('Erreur de localisation: ${e.toString()}');
    }
  }

  /// Vérifie et demande les permissions de localisation.
  /// 
  /// Retourne true si les permissions sont accordées, false sinon.
  Future<bool> _checkAndRequestLocationPermission() async {
    // Vérifier d'abord avec Geolocator
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // Demander la permission
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // Permission refusée définitivement, ouvrir les paramètres
      await openAppSettings();
      return false;
    }

    return permission == LocationPermission.whileInUse || 
           permission == LocationPermission.always;
  }

  /// Vérifie si la position en cache est encore valide.
  bool _isPositionCacheValid() {
    if (_currentPosition == null || _lastPositionUpdate == null) {
      return false;
    }

    final DateTime now = DateTime.now();
    final Duration timeSinceUpdate = now.difference(_lastPositionUpdate!);
    
    return timeSinceUpdate.inMinutes < _cacheValidityMinutes;
  }

  /// Calcule la distance entre deux positions en kilomètres.
  /// 
  /// [startLatitude] latitude de départ.
  /// [startLongitude] longitude de départ.
  /// [endLatitude] latitude d'arrivée.
  /// [endLongitude] longitude d'arrivée.
  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    ) / 1000; // Convertir en kilomètres
  }

  /// Obtient un stream de positions pour le suivi en temps réel.
  /// 
  /// [accuracy] précision souhaitée.
  /// [distanceFilter] distance minimum en mètres pour déclencher une mise à jour.
  Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  /// Vérifie si les services de localisation sont activés.
  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  /// Ouvre les paramètres de localisation de l'appareil.
  Future<bool> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  /// Ouvre les paramètres de l'application.
  Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  /// Efface le cache de position.
  void clearPositionCache() {
    _currentPosition = null;
    _lastPositionUpdate = null;
  }

  /// Obtient le statut actuel des permissions de localisation.
  Future<LocationPermissionStatus> getPermissionStatus() async {
    final LocationPermission permission = await Geolocator.checkPermission();
    
    switch (permission) {
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.permanentlyDenied;
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.whileInUse;
      case LocationPermission.always:
        return LocationPermissionStatus.always;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.unknown;
    }
  }

  /// Formate une position en string lisible.
  static String formatPosition(Position position) {
    return '${position.latitude.toStringAsFixed(6)}, '
           '${position.longitude.toStringAsFixed(6)} '
           '(±${position.accuracy.toStringAsFixed(0)}m)';
  }

  /// Obtient la position par défaut (Paris centre).
  static Position getDefaultPosition() {
    return Position(
      latitude: 48.8566,
      longitude: 2.3522,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );
  }
}

/// Statut des permissions de localisation.
enum LocationPermissionStatus {
  /// Permission inconnue.
  unknown,
  /// Permission refusée.
  denied,
  /// Permission refusée définitivement.
  permanentlyDenied,
  /// Permission accordée seulement quand l'app est utilisée.
  whileInUse,
  /// Permission accordée en permanence.
  always,
}

/// Exception de base pour les erreurs de localisation.
abstract class LocationException implements Exception {
  /// Message d'erreur.
  final String message;

  /// Crée une nouvelle instance de [LocationException].
  const LocationException(this.message);

  @override
  String toString() => 'LocationException: $message';
}

/// Exception pour les services de localisation désactivés.
class LocationServiceException extends LocationException {
  /// Crée une nouvelle instance de [LocationServiceException].
  const LocationServiceException(super.message);
}

/// Exception pour les permissions refusées.
class LocationPermissionException extends LocationException {
  /// Crée une nouvelle instance de [LocationPermissionException].
  const LocationPermissionException(super.message);
}

/// Exception pour les timeouts.
class LocationTimeoutException extends LocationException {
  /// Crée une nouvelle instance de [LocationTimeoutException].
  const LocationTimeoutException(super.message);
}

/// Exception générique pour les autres erreurs.
class GenericLocationException extends LocationException {
  /// Crée une nouvelle instance de [GenericLocationException].
  const GenericLocationException(super.message);
}
