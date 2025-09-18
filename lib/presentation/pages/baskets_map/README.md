# Intégration Google Maps - Guide Complet 🗺️

## Vue d'ensemble

L'intégration Google Maps dans FoodSave permet aux utilisateurs de visualiser les paniers anti-gaspi sur une carte interactive, offrant une expérience géographique intuitive pour trouver les commerces partenaires à proximité.

## 🚀 Fonctionnalités

### 📍 Géolocalisation
- **Permission automatique** : Demande intelligente des permissions de géolocalisation
- **Position temps réel** : Suivi continu de la position utilisateur
- **Centrage automatique** : La carte se centre sur la position de l'utilisateur

### 🗺️ Carte interactive
- **Marqueurs personnalisés** : Différentes couleurs selon le type de commerce
- **Sélection visuelle** : Marqueurs agrandis pour les éléments sélectionnés
- **Navigation fluide** : Zoom, déplacement et ajustement automatique des vues
- **Styles multiples** : Standard, satellite, terrain

### 🔍 Recherche géographique
- **Recherche contextuelle** : Recherche adaptée à la zone visible
- **Filtres géographiques** : Distance, rayon de recherche
- **Suggestions** : Propositions basées sur la localisation

### 📱 Interface utilisateur
- **Bottom sheet expansible** : Détails des paniers avec animation
- **Contrôles flottants** : Boutons pour géolocalisation et styles
- **Barre de recherche** : Interface optimisée pour la superposition

## 📋 Prérequis

### 1. Clés API Google Maps

Vous devez obtenir des clés API depuis [Google Cloud Console](https://console.cloud.google.com) :

1. **Créer un projet** ou sélectionner un projet existant
2. **Activer les APIs** :
   - Maps SDK for Android
   - Maps SDK for iOS  
   - Maps JavaScript API (pour le web)
   - Geocoding API (optionnel)
   - Directions API (optionnel)

3. **Créer les clés API** avec restrictions appropriées :
   - **Android** : Restriction par nom de package (`com.example.foodsave_app`)
   - **iOS** : Restriction par bundle identifier
   - **Web** : Restriction par domaine

4. **Configurer la facturation** (requis même pour l'usage gratuit)

### 2. Configuration par plateforme

#### Android
Ajouter dans `android/app/src/main/AndroidManifest.xml` :
```xml
<application>
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_ANDROID_API_KEY_HERE"/>
</application>
```

#### iOS
Ajouter dans `ios/Runner/AppDelegate.swift` :
```swift
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_IOS_API_KEY_HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

#### Web
Ajouter dans `web/index.html` :
```html
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_WEB_API_KEY_HERE"></script>
```

## 🏗️ Architecture

### Services
```
core/
├── config/
│   └── maps_config.dart          # Configuration des clés et paramètres
├── services/
│   └── maps_service.dart         # Service principal Google Maps
└── demo/
    └── demo_data_service.dart    # Données de démonstration
```

### Interface utilisateur
```
presentation/presentation/baskets_map/
├── baskets_map_page.dart         # Page principale de carte
└── widgets/
    ├── map_floating_search.dart  # Barre de recherche flottante
    ├── map_controls.dart         # Contrôles de carte
    └── map_bottom_sheet.dart     # Détails des paniers
```

### Configuration des routes
```
core/routes/app_routes.dart       # Système de navigation
```

## 🎯 Utilisation

### Navigation vers la carte
```dart
// Depuis n'importe quelle page
AppRoutes.navigateToBasketsMap(context);

// Ou directement
Navigator.of(context).pushNamed('/baskets-map');
```

### Utilisation du MapsService
```dart
final mapsService = MapsService();

// Demander les permissions
final hasPermission = await mapsService.requestLocationPermission();

// Obtenir la position
final position = await mapsService.getCurrentPosition();

// Créer des marqueurs
final markers = await mapsService.basketsToMarkers(
  baskets,
  onMarkerTap: (basket) => print('Basket tapped: ${basket.id}'),
);
```

## 🎨 Personnalisation

### Couleurs des marqueurs
Modifiez dans `MapsConfig` :
```dart
static const String bakeryMarkerColor = '#FF6B35';
static const String restaurantMarkerColor = '#F7931E';
static const String groceryMarkerColor = '#4CAF50';
```

### Styles de carte
Ajoutez vos styles personnalisés dans `MapsConfig.darkMapStyle` :
```dart
static const String customMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [{"color": "#your_color"}]
  }
]
''';
```

### Configuration par défaut
```dart
// Position de démarrage
static const double defaultLatitude = 48.8566;  // Paris
static const double defaultLongitude = 2.3522;

// Niveaux de zoom
static const double defaultZoom = 14.0;
static const double minZoom = 10.0;
static const double maxZoom = 20.0;
```

## 🔧 Configuration avancée

### Permissions personnalisées
```dart
// Dans MapsService, personnalisez la demande de permissions
Future<bool> requestLocationPermission() async {
  final PermissionStatus permission = await Permission.location.request();
  
  if (permission == PermissionStatus.denied) {
    // Afficher un dialogue explicatif
    return await _showPermissionDialog();
  }
  
  return permission == PermissionStatus.granted;
}
```

### Marqueurs personnalisés avancés
```dart
// Créer des marqueurs avec icônes personnalisées
Future<BitmapDescriptor> createCustomIcon(String imagePath) async {
  return await BitmapDescriptor.asset(
    const ImageConfiguration(),
    imagePath,
  );
}
```

## 📊 Performance

### Optimisations implémentées
- ✅ **Marqueurs dynamiques** : Création à la demande
- ✅ **Cache des icônes** : Réutilisation des marqueurs similaires  
- ✅ **Mise à jour intelligente** : Seuls les marqueurs modifiés sont recréés
- ✅ **Pagination géographique** : Chargement par zones
- ✅ **Debouncing** : Limitation des requêtes lors du déplacement

### Recommandations
- Limiter le nombre de marqueurs simultanés (< 100)
- Utiliser le clustering pour les zones denses
- Implémenter le cache d'images pour les marqueurs
- Optimiser les requêtes réseau selon la zone visible

## 🐛 Résolution de problèmes

### Carte blanche ou erreur de chargement
1. **Vérifier les clés API** dans `MapsConfig`
2. **Contrôler les restrictions** dans Google Cloud Console
3. **Vérifier la facturation** activée
4. **Tester les permissions** de géolocalisation

### Marqueurs qui n'apparaissent pas
```dart
// Vérifier que les coordonnées sont valides
if (basket.commerce.latitude != 0 && basket.commerce.longitude != 0) {
  // Créer le marqueur
}
```

### Erreurs de permissions
```dart
// Gérer les différents états
switch (await Permission.location.status) {
  case PermissionStatus.denied:
    // Demander à nouveau
    break;
  case PermissionStatus.permanentlyDenied:
    // Rediriger vers les paramètres
    await openAppSettings();
    break;
}
```

## 🧪 Tests

### Tests unitaires suggérés
```dart
// Test du service Maps
testWidgets('should calculate correct distance', (tester) async {
  final service = MapsService();
  final distance = service.calculateDistance(
    const LatLng(48.8566, 2.3522), // Paris
    const LatLng(48.8584, 2.2945), // Tour Eiffel
  );
  expect(distance, closeTo(4.2, 0.5)); // ~4.2 km
});

// Test des marqueurs
testWidgets('should create markers for baskets', (tester) async {
  final baskets = DemoDataService.getDemoBaskets();
  final markers = await service.basketsToMarkers(baskets);
  expect(markers.length, equals(baskets.length));
});
```

### Tests d'intégration
```dart
testWidgets('should show basket details when marker tapped', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.byType(GoogleMap));
  await tester.pump();
  expect(find.byType(MapBottomSheet), findsOneWidget);
});
```

## 📈 Métriques et analyse

### Événements à tracker
- Nombre de vues de la carte par session
- Fréquence d'utilisation de la géolocalisation
- Interactions avec les marqueurs
- Utilisation des différents styles de carte

### Analytics Google Maps (optionnel)
```dart
// Tracker les interactions
GoogleAnalytics.trackEvent(
  category: 'Maps',
  action: 'marker_tap',
  label: basket.commerce.type.toString(),
);
```

## 🔮 Évolutions futures

### Fonctionnalités prévues
- [ ] **Clustering** : Regroupement des marqueurs proches
- [ ] **Directions** : Navigation turn-by-turn
- [ ] **Géofencing** : Notifications basées sur la localisation
- [ ] **Heatmap** : Visualisation de la densité des paniers
- [ ] **Mode hors ligne** : Cartes locales pré-téléchargées

### Améliorations techniques
- [ ] **WebGL** : Rendu 3D pour les marqueurs complexes
- [ ] **ML Kit** : Reconnaissance d'images pour les commerces
- [ ] **AR** : Réalité augmentée pour la navigation
- [ ] **Optimisations** : Rendu vectoriel des marqueurs

---

*Cette documentation est mise à jour avec chaque évolution de l'intégration Google Maps.*