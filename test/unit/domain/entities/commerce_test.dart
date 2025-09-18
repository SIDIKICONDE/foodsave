import 'package:flutter_test/flutter_test.dart';
import 'package:foodsave_app/domain/entities/commerce.dart';

/// Tests unitaires pour la classe [Commerce].
/// 
/// Ces tests vérifient le comportement de la classe Commerce,
/// incluant les calculs de distance et la gestion des horaires.
void main() {
  group('Commerce', () {
    late Commerce testCommerce;
    late DateTime now;

    setUp(() {
      now = DateTime.now();
      testCommerce = Commerce(
        id: 'commerce_1',
        name: 'Test Boulangerie',
        type: CommerceType.bakery,
        address: '123 Test Street, Paris',
        latitude: 48.8566,
        longitude: 2.3522,
        phone: '0123456789',
        email: 'test@boulangerie.com',
        createdAt: now,
        isActive: true,
        description: 'Une boulangerie de test',
        website: 'https://test-boulangerie.com',
        imageUrl: 'https://example.com/image.jpg',
        coverImageUrl: 'https://example.com/cover.jpg',
        openingHours: const {
          1: '08:00-20:00', // Lundi
          2: '08:00-20:00', // Mardi
          3: '08:00-20:00', // Mercredi
          4: '08:00-20:00', // Jeudi
          5: '08:00-20:00', // Vendredi
          6: '08:00-18:00', // Samedi
          7: null, // Dimanche fermé
        },
        specialDays: const ['2024-01-01', '2024-12-25'],
        averageRating: 4.5,
        totalReviews: 150,
        ecoEngagement: EcoEngagementLevel.gold,
        certifications: const ['Bio', 'Label Rouge'],
        totalBasketsSold: 500,
        totalKgSaved: 1250.5,
        totalCo2Saved: 75.2,
        pickupInstructions: 'Récupération à l\'arrière du magasin',
        specialOffers: const ['Réduction 10%', 'Panier gratuit'],
        tags: const ['bio', 'local', 'artisanal'],
        isVerified: true,
        joinedAt: now.subtract(const Duration(days: 30)),
      );
    });

    group('Constructeur', () {
      test('devrait créer un commerce avec tous les paramètres requis', () {
        expect(testCommerce.id, equals('commerce_1'));
        expect(testCommerce.name, equals('Test Boulangerie'));
        expect(testCommerce.type, equals(CommerceType.bakery));
        expect(testCommerce.address, equals('123 Test Street, Paris'));
        expect(testCommerce.latitude, equals(48.8566));
        expect(testCommerce.longitude, equals(2.3522));
        expect(testCommerce.phone, equals('0123456789'));
        expect(testCommerce.email, equals('test@boulangerie.com'));
        expect(testCommerce.createdAt, equals(now));
        expect(testCommerce.isActive, equals(true));
      });

      test('devrait créer un commerce avec des paramètres optionnels par défaut', () {
        final Commerce minimalCommerce = Commerce(
          id: 'minimal_commerce',
          name: 'Minimal Commerce',
          type: CommerceType.other,
          address: '456 Minimal Street',
          latitude: 48.8566,
          longitude: 2.3522,
          phone: '0987654321',
          email: 'minimal@commerce.com',
          createdAt: DateTime.now(),
          isActive: true,
        );

        expect(minimalCommerce.description, isNull);
        expect(minimalCommerce.website, isNull);
        expect(minimalCommerce.imageUrl, isNull);
        expect(minimalCommerce.coverImageUrl, isNull);
        expect(minimalCommerce.openingHours, isEmpty);
        expect(minimalCommerce.specialDays, isEmpty);
        expect(minimalCommerce.averageRating, equals(0.0));
        expect(minimalCommerce.totalReviews, equals(0));
        expect(minimalCommerce.ecoEngagement, equals(EcoEngagementLevel.bronze));
        expect(minimalCommerce.certifications, isEmpty);
        expect(minimalCommerce.totalBasketsSold, equals(0));
        expect(minimalCommerce.totalKgSaved, equals(0.0));
        expect(minimalCommerce.totalCo2Saved, equals(0.0));
        expect(minimalCommerce.pickupInstructions, isNull);
        expect(minimalCommerce.specialOffers, isEmpty);
        expect(minimalCommerce.tags, isEmpty);
        expect(minimalCommerce.isVerified, equals(false));
        expect(minimalCommerce.joinedAt, isNull);
      });
    });

    group('Calcul de distance', () {
      test('devrait calculer correctement la distance entre deux points', () {
        // Distance approximative entre Paris et Lyon (environ 460 km)
        const double lyonLatitude = 45.7640;
        const double lyonLongitude = 4.8357;
        
        final double distance = testCommerce.calculateDistance(lyonLatitude, lyonLongitude);
        
        // Tolérance plus souple selon la formule simplifiée
        expect(distance, greaterThan(350));
        expect(distance, lessThan(500));
      });

      test('devrait retourner 0 pour la même position', () {
        final double distance = testCommerce.calculateDistance(
          testCommerce.latitude,
          testCommerce.longitude,
        );
        
        expect(distance, equals(0.0));
      });

      test('devrait calculer correctement une distance courte', () {
        // Position très proche (environ 1 km)
        const double nearbyLatitude = 48.8566 + 0.01;
        const double nearbyLongitude = 2.3522 + 0.01;
        
        final double distance = testCommerce.calculateDistance(nearbyLatitude, nearbyLongitude);
        
        expect(distance, greaterThan(0));
        expect(distance, lessThan(10)); // Moins de 10 km
      });
    });

    group('Horaires d\'ouverture', () {
      test('devrait être ouvert pendant les heures d\'ouverture', () {
        // Lundi à 10h00
        final DateTime monday10am = DateTime(2024, 1, 1, 10, 0); // Lundi
        
        expect(testCommerce.isOpenAt(monday10am), isTrue);
      });

      test('ne devrait pas être ouvert avant l\'heure d\'ouverture', () {
        // Lundi à 7h00 (avant ouverture)
        final DateTime monday7am = DateTime(2024, 1, 1, 7, 0); // Lundi
        
        expect(testCommerce.isOpenAt(monday7am), isFalse);
      });

      test('ne devrait pas être ouvert après l\'heure de fermeture', () {
        // Lundi à 21h00 (après fermeture)
        final DateTime monday9pm = DateTime(2024, 1, 1, 21, 0); // Lundi
        
        expect(testCommerce.isOpenAt(monday9pm), isFalse);
      });

      test('ne devrait pas être ouvert le dimanche', () {
        // Dimanche à 10h00
        final DateTime sunday10am = DateTime(2024, 1, 7, 10, 0); // Dimanche
        
        expect(testCommerce.isOpenAt(sunday10am), isFalse);
      });

      test('devrait gérer les horaires du samedi', () {
        // Samedi à 10h00 (ouvert)
        final DateTime saturday10am = DateTime(2024, 1, 6, 10, 0); // Samedi
        
        expect(testCommerce.isOpenAt(saturday10am), isTrue);
        
        // Samedi à 19h00 (fermé)
        final DateTime saturday7pm = DateTime(2024, 1, 6, 19, 0); // Samedi
        
        expect(testCommerce.isOpenAt(saturday7pm), isFalse);
      });

      test('devrait gérer les horaires mal formatés', () {
        final Commerce badHoursCommerce = testCommerce.copyWith(
          openingHours: const {
            1: 'invalid-hours',
            2: '08:00', // Manque l'heure de fermeture
            3: '08:00-20:00-22:00', // Trop d'heures
          },
        );
        
        // Lundi avec horaires invalides
        final DateTime monday10am = DateTime(2024, 1, 1, 10, 0);
        expect(badHoursCommerce.isOpenAt(monday10am), isFalse);
      });
    });

    group('copyWith', () {
      test('devrait créer une copie avec des valeurs modifiées', () {
        final Commerce updatedCommerce = testCommerce.copyWith(
          name: 'Updated Boulangerie',
          averageRating: 4.8,
          isActive: false,
        );

        expect(updatedCommerce.id, equals(testCommerce.id));
        expect(updatedCommerce.name, equals('Updated Boulangerie'));
        expect(updatedCommerce.averageRating, equals(4.8));
        expect(updatedCommerce.isActive, equals(false));
        expect(updatedCommerce.type, equals(testCommerce.type));
        expect(updatedCommerce.address, equals(testCommerce.address));
      });

      test('devrait conserver les valeurs originales si aucun paramètre n\'est fourni', () {
        final Commerce copiedCommerce = testCommerce.copyWith();

        expect(copiedCommerce.id, equals(testCommerce.id));
        expect(copiedCommerce.name, equals(testCommerce.name));
        expect(copiedCommerce.type, equals(testCommerce.type));
        expect(copiedCommerce.address, equals(testCommerce.address));
        expect(copiedCommerce.latitude, equals(testCommerce.latitude));
        expect(copiedCommerce.longitude, equals(testCommerce.longitude));
      });
    });

    group('Égalité', () {
      test('devrait être égal à un autre commerce avec les mêmes propriétés', () {
        final Commerce identicalCommerce = Commerce(
          id: 'commerce_1',
          name: 'Test Boulangerie',
          type: CommerceType.bakery,
          address: '123 Test Street, Paris',
          latitude: 48.8566,
          longitude: 2.3522,
          phone: '0123456789',
          email: 'test@boulangerie.com',
          createdAt: now,
          isActive: true,
          description: 'Une boulangerie de test',
          website: 'https://test-boulangerie.com',
          imageUrl: 'https://example.com/image.jpg',
          coverImageUrl: 'https://example.com/cover.jpg',
          openingHours: const {
            1: '08:00-20:00',
            2: '08:00-20:00',
            3: '08:00-20:00',
            4: '08:00-20:00',
            5: '08:00-20:00',
            6: '08:00-18:00',
            7: null,
          },
          specialDays: const ['2024-01-01', '2024-12-25'],
          averageRating: 4.5,
          totalReviews: 150,
          ecoEngagement: EcoEngagementLevel.gold,
          certifications: const ['Bio', 'Label Rouge'],
          totalBasketsSold: 500,
          totalKgSaved: 1250.5,
          totalCo2Saved: 75.2,
          pickupInstructions: 'Récupération à l\'arrière du magasin',
          specialOffers: const ['Réduction 10%', 'Panier gratuit'],
          tags: const ['bio', 'local', 'artisanal'],
          isVerified: true,
          joinedAt: now.subtract(const Duration(days: 30)),
        );

        expect(testCommerce, equals(identicalCommerce));
      });

      test('ne devrait pas être égal à un commerce avec des propriétés différentes', () {
        final Commerce differentCommerce = testCommerce.copyWith(id: 'different_id');

        expect(testCommerce, isNot(equals(differentCommerce)));
      });
    });

    group('toString', () {
      test('devrait retourner une représentation string appropriée', () {
        final String commerceString = testCommerce.toString();

        expect(commerceString, contains('Commerce'));
        expect(commerceString, contains('commerce_1'));
        expect(commerceString, contains('Test Boulangerie'));
        expect(commerceString, contains('bakery'));
        expect(commerceString, contains('true'));
      });
    });
  });

  group('CommerceType', () {
    test('devrait avoir tous les types de commerce attendus', () {
      expect(CommerceType.values, contains(CommerceType.bakery));
      expect(CommerceType.values, contains(CommerceType.restaurant));
      expect(CommerceType.values, contains(CommerceType.supermarket));
      expect(CommerceType.values, contains(CommerceType.greengrocer));
      expect(CommerceType.values, contains(CommerceType.butcher));
      expect(CommerceType.values, contains(CommerceType.fishmonger));
      expect(CommerceType.values, contains(CommerceType.grocery));
      expect(CommerceType.values, contains(CommerceType.cafe));
      expect(CommerceType.values, contains(CommerceType.other));
    });
  });

  group('EcoEngagementLevel', () {
    test('devrait avoir tous les niveaux d\'engagement attendus', () {
      expect(EcoEngagementLevel.values, contains(EcoEngagementLevel.bronze));
      expect(EcoEngagementLevel.values, contains(EcoEngagementLevel.silver));
      expect(EcoEngagementLevel.values, contains(EcoEngagementLevel.gold));
      expect(EcoEngagementLevel.values, contains(EcoEngagementLevel.champion));
    });
  });
}
