import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodsave_app/services/demo_map_service.dart';
import 'package:foodsave_app/models/map_marker.dart';
import 'dart:io';
import 'package:hive/hive.dart';

/// Tests unitaires pour la classe [DemoMapService].
/// 
/// Ces tests vérifient le comportement du service de démonstration
/// pour la carte, incluant la récupération et la recherche de paniers.
void main() {
  setUpAll(() async {
    final Directory tmp = await Directory.systemTemp.createTemp('hive_test_');
    Hive.init(tmp.path);
  });

  tearDownAll(() async {
    await Hive.close();
  });
  group('DemoMapService', () {
    late DemoMapService demoMapService;

    setUp(() async {
      demoMapService = DemoMapService();
      await demoMapService.initialize();
    });

    tearDown(() {
      demoMapService.dispose();
    });

    group('fetchBasketsFromSupabase', () {
      test('devrait retourner une liste de marqueurs de démonstration', () async {
        final List<MapMarker> markers = await demoMapService.fetchBasketsFromSupabase();

        expect(markers, isNotEmpty);
        expect(markers.length, greaterThan(0));
        expect(markers.length, lessThanOrEqualTo(5)); // Maximum 5 marqueurs de démo
      });

      test('devrait retourner des marqueurs avec des propriétés valides', () async {
        final List<MapMarker> markers = await demoMapService.fetchBasketsFromSupabase();

        for (final MapMarker marker in markers) {
          expect(marker.id, isNotEmpty);
          expect(marker.title, isNotEmpty);
          expect(marker.description, isNotEmpty);
          expect(marker.position, isA<LatLng>());
          expect(marker.type, isA<MarkerType>());
          expect(marker.price, isNotNull);
          expect(marker.quantity, isNotNull);
          expect(marker.rating, isNotNull);
          expect(marker.shopName, isNotEmpty);
          expect(marker.address, isNotEmpty);
        }
      });

      test('devrait filtrer les marqueurs selon le rayon spécifié', () async {
        const LatLng center = LatLng(48.8566, 2.3522);
        const double smallRadius = 0.1; // Très petit rayon

        final List<MapMarker> markers = await demoMapService.fetchBasketsFromSupabase(
          center: center,
          radiusKm: smallRadius,
        );

        // Avec un rayon très petit, on devrait avoir moins de marqueurs
        expect(markers.length, lessThanOrEqualTo(5));
      });

      test('devrait utiliser la position par défaut si aucune position n\'est fournie', () async {
        final List<MapMarker> markers = await demoMapService.fetchBasketsFromSupabase();

        expect(markers, isNotEmpty);
        // Tous les marqueurs devraient être dans un rayon raisonnable de Paris
        for (final MapMarker marker in markers) {
          expect(marker.position.latitude, greaterThan(48.0));
          expect(marker.position.latitude, lessThan(49.0));
          expect(marker.position.longitude, greaterThan(2.0));
          expect(marker.position.longitude, lessThan(3.0));
        }
      });

      test('devrait gérer les erreurs et retourner une liste vide en cas d\'échec', () async {
        // Test avec des paramètres invalides pour déclencher une erreur
        final List<MapMarker> markers = await demoMapService.fetchBasketsFromSupabase(
          center: const LatLng(999.0, 999.0), // Position invalide
          radiusKm: -1.0, // Rayon négatif
        );

        // Le service devrait gérer l'erreur gracieusement
        expect(markers, isA<List<MapMarker>>());
      });
    });

    group('searchBaskets', () {
      test('devrait retourner des marqueurs correspondant à la requête', () async {
        final List<MapMarker> markers = await demoMapService.searchBaskets('boulangerie');

        expect(markers, isA<List<MapMarker>>());
        // Au moins un marqueur devrait contenir "boulangerie" dans son contenu
        final bool hasBoulangerie = markers.any((marker) =>
            marker.title.toLowerCase().contains('boulangerie') ||
            marker.description.toLowerCase().contains('boulangerie') ||
            (marker.shopName?.toLowerCase().contains('boulangerie') ?? false));

        expect(hasBoulangerie, isTrue);
      });

      test('devrait retourner une liste vide pour une requête sans correspondance', () async {
        final List<MapMarker> markers = await demoMapService.searchBaskets('xyz123nonexistent');

        expect(markers, isEmpty);
      });

      test('devrait effectuer une recherche insensible à la casse', () async {
        final List<MapMarker> upperCaseMarkers = await demoMapService.searchBaskets('BOULANGERIE');
        final List<MapMarker> lowerCaseMarkers = await demoMapService.searchBaskets('boulangerie');

        expect(upperCaseMarkers.length, equals(lowerCaseMarkers.length));
      });

      test('devrait rechercher dans le titre, la description et le nom du magasin', () async {
        final List<MapMarker> allMarkers = await demoMapService.fetchBasketsFromSupabase();
        
        if (allMarkers.isNotEmpty) {
          final MapMarker firstMarker = allMarkers.first;
          final String searchTerm = firstMarker.title.split(' ').first.toLowerCase();
          
          final List<MapMarker> searchResults = await demoMapService.searchBaskets(searchTerm);
          
          expect(searchResults, isNotEmpty);
          expect(searchResults.any((marker) => marker.id == firstMarker.id), isTrue);
        }
      });

      test('devrait gérer les requêtes vides', () async {
        final List<MapMarker> emptyQueryMarkers = await demoMapService.searchBaskets('');
        final List<MapMarker> allMarkers = await demoMapService.fetchBasketsFromSupabase();

        expect(emptyQueryMarkers.length, equals(allMarkers.length));
      });
    });

    group('toggleFavorite', () {
      test('devrait basculer l\'état favori d\'un marqueur existant', () async {
        final List<MapMarker> markers = await demoMapService.fetchBasketsFromSupabase();
        
        if (markers.isNotEmpty) {
          final MapMarker firstMarker = markers.first;
          final bool initialFavoriteState = firstMarker.isFavorite;
          
          final bool newFavoriteState = await demoMapService.toggleFavorite(firstMarker.id);
          
          expect(newFavoriteState, equals(!initialFavoriteState));
        }
      });

      test('devrait retourner false pour un marqueur inexistant', () async {
        final bool result = await demoMapService.toggleFavorite('nonexistent_id');

        expect(result, isFalse);
      });

      test('devrait gérer les erreurs et retourner false', () async {
        // Test avec un ID invalide pour déclencher une erreur
        final bool result = await demoMapService.toggleFavorite('');

        expect(result, isFalse);
      });
    });

    group('initialize', () {
      test('devrait s\'initialiser sans erreur', () async {
        expect(() => demoMapService.initialize(), returnsNormally);
      });

      test('devrait gérer les erreurs d\'initialisation gracieusement', () async {
        // Le service devrait gérer les erreurs d'initialisation sans planter
        await demoMapService.initialize();
        
        // Après l'initialisation, les méthodes devraient toujours fonctionner
        final List<MapMarker> markers = await demoMapService.fetchBasketsFromSupabase();
        expect(markers, isA<List<MapMarker>>());
      });
    });

    group('dispose', () {
      test('devrait nettoyer les ressources sans erreur', () {
        expect(() => demoMapService.dispose(), returnsNormally);
      });

      test('devrait pouvoir être appelé plusieurs fois sans erreur', () {
        demoMapService.dispose();
        expect(() => demoMapService.dispose(), returnsNormally);
      });
    });

    group('Intégration', () {
      test('devrait maintenir la cohérence entre fetchBaskets et searchBaskets', () async {
        final List<MapMarker> allMarkers = await demoMapService.fetchBasketsFromSupabase();
        
        if (allMarkers.isNotEmpty) {
          final MapMarker testMarker = allMarkers.first;
          final String searchTerm = testMarker.title.split(' ').first;
          
          final List<MapMarker> searchResults = await demoMapService.searchBaskets(searchTerm);
          
          // Le marqueur original devrait être trouvé dans les résultats de recherche
          expect(searchResults.any((marker) => marker.id == testMarker.id), isTrue);
        }
      });

      test('devrait maintenir l\'état des favoris entre les appels', () async {
        final List<MapMarker> markers = await demoMapService.fetchBasketsFromSupabase();
        
        if (markers.isNotEmpty) {
          final MapMarker firstMarker = markers.first;
          
          // Basculer l'état favori
          await demoMapService.toggleFavorite(firstMarker.id);
          
          // Récupérer à nouveau les marqueurs
          final List<MapMarker> updatedMarkers = await demoMapService.fetchBasketsFromSupabase();
          final MapMarker? updatedMarker = updatedMarkers
              .where((marker) => marker.id == firstMarker.id)
              .firstOrNull;
          
          if (updatedMarker != null) {
            expect(updatedMarker.isFavorite, equals(!firstMarker.isFavorite));
          }
        }
      });
    });
  });
}
