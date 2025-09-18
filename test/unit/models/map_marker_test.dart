import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:foodsave_app/models/map_marker.dart';

/// Tests unitaires pour la classe [MapMarker].
/// 
/// Ces tests vérifient le comportement de la classe MapMarker,
/// incluant la création, la copie, et les propriétés des marqueurs.
void main() {
  group('MapMarker', () {
    late MapMarker testMarker;
    late LatLng testPosition;

    setUp(() {
      testPosition = const LatLng(48.8566, 2.3522);
      testMarker = MapMarker(
        id: 'test_id',
        position: testPosition,
        type: MarkerType.boulangerie,
        title: 'Test Boulangerie',
        description: 'Description de test',
        price: 5.99,
        imageUrl: 'https://example.com/image.jpg',
        isFavorite: false,
        availableUntil: DateTime.now().add(const Duration(hours: 2)),
        quantity: 3,
        rating: 4.5,
        shopName: 'Test Shop',
        address: '123 Test Street',
      );
    });

    group('Constructeur', () {
      test('devrait créer un marqueur avec tous les paramètres requis', () {
        expect(testMarker.id, equals('test_id'));
        expect(testMarker.position, equals(testPosition));
        expect(testMarker.type, equals(MarkerType.boulangerie));
        expect(testMarker.title, equals('Test Boulangerie'));
        expect(testMarker.description, equals('Description de test'));
        expect(testMarker.price, equals(5.99));
        expect(testMarker.imageUrl, equals('https://example.com/image.jpg'));
        expect(testMarker.isFavorite, equals(false));
        expect(testMarker.quantity, equals(3));
        expect(testMarker.rating, equals(4.5));
        expect(testMarker.shopName, equals('Test Shop'));
        expect(testMarker.address, equals('123 Test Street'));
      });

      test('devrait créer un marqueur avec des paramètres optionnels par défaut', () {
        const MapMarker minimalMarker = MapMarker(
          id: 'minimal_id',
          position: LatLng(48.8566, 2.3522),
          type: MarkerType.restaurant,
          title: 'Minimal Title',
          description: 'Minimal Description',
        );

        expect(minimalMarker.isFavorite, equals(false));
        expect(minimalMarker.price, isNull);
        expect(minimalMarker.imageUrl, isNull);
        expect(minimalMarker.availableUntil, isNull);
        expect(minimalMarker.quantity, isNull);
        expect(minimalMarker.rating, isNull);
        expect(minimalMarker.shopName, isNull);
        expect(minimalMarker.address, isNull);
      });
    });

    group('copyWith', () {
      test('devrait créer une copie avec des valeurs modifiées', () {
        final MapMarker updatedMarker = testMarker.copyWith(
          title: 'Updated Title',
          price: 7.99,
          isFavorite: true,
        );

        expect(updatedMarker.id, equals(testMarker.id));
        expect(updatedMarker.position, equals(testMarker.position));
        expect(updatedMarker.type, equals(testMarker.type));
        expect(updatedMarker.title, equals('Updated Title'));
        expect(updatedMarker.price, equals(7.99));
        expect(updatedMarker.isFavorite, equals(true));
        expect(updatedMarker.description, equals(testMarker.description));
      });

      test('devrait conserver les valeurs originales si aucun paramètre n\'est fourni', () {
        final MapMarker copiedMarker = testMarker.copyWith();

        expect(copiedMarker.id, equals(testMarker.id));
        expect(copiedMarker.position, equals(testMarker.position));
        expect(copiedMarker.type, equals(testMarker.type));
        expect(copiedMarker.title, equals(testMarker.title));
        expect(copiedMarker.description, equals(testMarker.description));
        expect(copiedMarker.price, equals(testMarker.price));
        expect(copiedMarker.isFavorite, equals(testMarker.isFavorite));
      });
    });

    group('Égalité', () {
      test('devrait avoir les mêmes propriétés qu\'un autre marqueur identique', () {
        final MapMarker identicalMarker = MapMarker(
          id: 'test_id',
          position: testPosition,
          type: MarkerType.boulangerie,
          title: 'Test Boulangerie',
          description: 'Description de test',
          price: 5.99,
          imageUrl: 'https://example.com/image.jpg',
          isFavorite: false,
          availableUntil: testMarker.availableUntil,
          quantity: 3,
          rating: 4.5,
          shopName: 'Test Shop',
          address: '123 Test Street',
        );
        expect(identicalMarker.id, equals(testMarker.id));
        expect(identicalMarker.position, equals(testMarker.position));
        expect(identicalMarker.type, equals(testMarker.type));
        expect(identicalMarker.title, equals(testMarker.title));
        expect(identicalMarker.description, equals(testMarker.description));
      });

      test('ne devrait pas être égal à un marqueur avec des propriétés différentes', () {
        final MapMarker differentMarker = testMarker.copyWith(id: 'different_id');

        expect(testMarker, isNot(equals(differentMarker)));
      });
    });
  });

  group('MarkerType', () {
    group('label', () {
      test('devrait retourner le bon label pour chaque type', () {
        expect(MarkerType.boulangerie.label, equals('Boulangerie'));
        expect(MarkerType.restaurant.label, equals('Restaurant'));
        expect(MarkerType.supermarche.label, equals('Supermarché'));
        expect(MarkerType.primeur.label, equals('Primeur'));
        expect(MarkerType.autre.label, equals('Autre'));
        expect(MarkerType.userLocation.label, equals('Ma position'));
      });
    });

    group('iconAsset', () {
      test('devrait retourner le bon emoji pour chaque type', () {
        expect(MarkerType.boulangerie.iconAsset, equals('🥖'));
        expect(MarkerType.restaurant.iconAsset, equals('🍽️'));
        expect(MarkerType.supermarche.iconAsset, equals('🛒'));
        expect(MarkerType.primeur.iconAsset, equals('🥬'));
        expect(MarkerType.autre.iconAsset, equals('📦'));
        expect(MarkerType.userLocation.iconAsset, equals('📍'));
      });
    });

    group('markerColor', () {
      test('devrait retourner une couleur différente pour chaque type', () {
        expect(MarkerType.boulangerie.markerColor, isA<BitmapDescriptor>());
        expect(MarkerType.restaurant.markerColor, isA<BitmapDescriptor>());
        expect(MarkerType.supermarche.markerColor, isA<BitmapDescriptor>());
        expect(MarkerType.primeur.markerColor, isA<BitmapDescriptor>());
        expect(MarkerType.autre.markerColor, isA<BitmapDescriptor>());
        expect(MarkerType.userLocation.markerColor, isA<BitmapDescriptor>());
      });
    });
  });
}
