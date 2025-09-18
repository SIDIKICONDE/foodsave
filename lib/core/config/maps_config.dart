import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Configuration des cartes Google Maps pour l'application FoodSave.
///
/// Contient les clés API et les configurations spécifiques aux cartes.
class MapsConfig {
  /// Constructeur privé pour empêcher l'instanciation.
  const MapsConfig._();

  // === CLÉS API ===
  
  /// Clé API Google Maps pour Android.
  static const String androidApiKey = 'AIzaSyDdBh-f7YHdRhYDCk17WSuKlLXXqlJVn4c';
  
  /// Clé API Google Maps pour iOS.
  static const String iosApiKey = 'AIzaSyDdBh-f7YHdRhYDCk17WSuKlLXXqlJVn4c';
  
  /// Clé API Google Maps pour Web.
  static const String webApiKey = 'AIzaSyDdBh-f7YHdRhYDCk17WSuKlLXXqlJVn4c';

  // === CONFIGURATION DE LA CARTE ===
  
  /// Position par défaut (Paris, France) pour centrer la carte.
  static const double defaultLatitude = 48.8566;
  static const double defaultLongitude = 2.3522;
  
  /// Niveau de zoom par défaut.
  static const double defaultZoom = 14.0;

  /// Position par défaut sous forme de LatLng.
  static const LatLng defaultPosition = LatLng(defaultLatitude, defaultLongitude);

  /// Clé API Google Maps principale.
  static const String googleMapsApiKey = androidApiKey;

  /// Style de carte par défaut (optionnel).
  static const String? mapStyle = null;
  
  /// Niveau de zoom minimum.
  static const double minZoom = 10.0;
  
  /// Niveau de zoom maximum.
  static const double maxZoom = 20.0;
  
  /// Rayon de recherche par défaut (en kilomètres).
  static const double defaultSearchRadius = 5.0;

  // === STYLES DE CARTE ===
  
  /// Style de carte sombre (optionnel).
  static const String darkMapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [{"color": "#1d2c4d"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#8ec3b9"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#1a3646"}]
    }
  ]
  ''';

  // === MARQUEURS PERSONNALISÉS ===
  
  /// Couleur des marqueurs pour les boulangeries.
  static const String bakeryMarkerColor = '#FF6B35';
  
  /// Couleur des marqueurs pour les restaurants.
  static const String restaurantMarkerColor = '#F7931E';
  
  /// Couleur des marqueurs pour les fruits & légumes.
  static const String groceryMarkerColor = '#4CAF50';
  
  /// Couleur des marqueurs pour les supermarchés.
  static const String supermarketMarkerColor = '#2196F3';
  
  /// Couleur des marqueurs par défaut.
  static const String defaultMarkerColor = '#9C27B0';

  // === URLS ET ENDPOINTS ===
  
  /// URL de base pour les services Google Maps.
  static const String mapsBaseUrl = 'https://maps.googleapis.com/maps/api';
  
  /// URL pour le géocodage.
  static const String geocodingUrl = '$mapsBaseUrl/geocode/json';
  
  /// URL pour les directions.
  static const String directionsUrl = '$mapsBaseUrl/directions/json';
  
  /// URL pour les places nearby.
  static const String placesNearbyUrl = '$mapsBaseUrl/place/nearbysearch/json';

  // === INSTRUCTIONS DE CONFIGURATION ===
  
  /// Instructions pour obtenir les clés API.
  static const String setupInstructions = '''
  🔑 Configuration des clés API Google Maps :
  
  1. Allez sur Google Cloud Console (console.cloud.google.com)
  2. Créez ou sélectionnez un projet
  3. Activez l'API Google Maps SDK
  4. Créez des clés API pour chaque plateforme :
     - Android : Clé avec restriction par nom de package
     - iOS : Clé avec restriction par bundle identifier  
     - Web : Clé avec restriction par domaine
  5. Remplacez les clés dans ce fichier
  6. Configurez la facturation (requis même pour l'usage gratuit)
  
  📱 Configuration Android (android/app/src/main/AndroidManifest.xml) :
  <meta-data
      android:name="com.google.android.geo.API_KEY"
      android:value="YOUR_ANDROID_API_KEY_HERE"/>
      
  🍎 Configuration iOS (ios/Runner/AppDelegate.swift) :
  GMSServices.provideAPIKey("YOUR_IOS_API_KEY_HERE")
  
  🌐 Configuration Web (web/index.html) :
  <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_WEB_API_KEY_HERE"></script>
  ''';
}