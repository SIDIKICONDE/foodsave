import 'package:flutter_test/flutter_test.dart';
import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/domain/entities/commerce.dart';

/// Tests unitaires pour la classe [Basket].
/// 
/// Ces tests vérifient le comportement de la classe Basket,
/// incluant les calculs, les statuts et les propriétés dérivées.
void main() {
  group('Basket', () {
    late Basket testBasket;
    late Commerce testCommerce;
    late DateTime now;

    setUp(() {
      now = DateTime.now();
      testCommerce = Commerce(
        id: 'commerce_1',
        name: 'Test Commerce',
        type: CommerceType.bakery,
        address: '123 Test Street',
        latitude: 48.8566,
        longitude: 2.3522,
        phone: '0123456789',
        email: 'test@commerce.com',
        createdAt: now,
        isActive: true,
      );

      testBasket = Basket(
        id: 'basket_1',
        commerceId: 'commerce_1',
        commerce: testCommerce,
        title: 'Test Basket',
        description: 'Description du panier de test',
        originalPrice: 10.0,
        discountedPrice: 5.0,
        availableFrom: now.subtract(const Duration(hours: 1)),
        availableUntil: now.add(const Duration(hours: 2)),
        pickupTimeStart: now.add(const Duration(minutes: 30)),
        pickupTimeEnd: now.add(const Duration(hours: 3)),
        quantity: 5,
        createdAt: now,
        status: BasketStatus.available,
        imageUrls: const ['https://example.com/image1.jpg'],
        estimatedWeight: 2.5,
        size: BasketSize.medium,
        allergens: const ['gluten', 'lactose'],
        dietaryTags: const ['bio', 'local'],
        ingredients: const ['pain', 'fromage', 'légumes'],
        specialInstructions: 'Instructions spéciales',
        isLastChance: false,
        rating: 4.5,
        co2Saved: 1.2,
        isRecurring: false,
        recurringDays: const [],
      );
    });

    group('Constructeur', () {
      test('devrait créer un panier avec tous les paramètres requis', () {
        expect(testBasket.id, equals('basket_1'));
        expect(testBasket.commerceId, equals('commerce_1'));
        expect(testBasket.commerce, equals(testCommerce));
        expect(testBasket.title, equals('Test Basket'));
        expect(testBasket.description, equals('Description du panier de test'));
        expect(testBasket.originalPrice, equals(10.0));
        expect(testBasket.discountedPrice, equals(5.0));
        expect(testBasket.quantity, equals(5));
        expect(testBasket.status, equals(BasketStatus.available));
        expect(testBasket.size, equals(BasketSize.medium));
      });

      test('devrait créer un panier avec des paramètres optionnels par défaut', () {
        final Basket minimalBasket = Basket(
          id: 'minimal_basket',
          commerceId: 'commerce_1',
          commerce: Commerce(
            id: 'commerce_1',
            name: 'Test Commerce',
            type: CommerceType.bakery,
            address: '123 Test Street',
            latitude: 48.8566,
            longitude: 2.3522,
            phone: '0123456789',
            email: 'test@commerce.com',
            createdAt: DateTime.now(),
            isActive: true,
          ),
          title: 'Minimal Basket',
          description: 'Description minimale',
          originalPrice: 10.0,
          discountedPrice: 5.0,
          availableFrom: DateTime.now(),
          availableUntil: DateTime.now().add(const Duration(hours: 1)),
          pickupTimeStart: DateTime.now(),
          pickupTimeEnd: DateTime.now().add(const Duration(hours: 2)),
          quantity: 1,
          createdAt: DateTime.now(),
          status: BasketStatus.available,
        );

        expect(minimalBasket.imageUrls, isEmpty);
        expect(minimalBasket.estimatedWeight, isNull);
        expect(minimalBasket.size, equals(BasketSize.medium));
        expect(minimalBasket.allergens, isEmpty);
        expect(minimalBasket.dietaryTags, isEmpty);
        expect(minimalBasket.ingredients, isEmpty);
        expect(minimalBasket.specialInstructions, isNull);
        expect(minimalBasket.isLastChance, equals(false));
        expect(minimalBasket.isRecurring, equals(false));
        expect(minimalBasket.recurringDays, isEmpty);
      });
    });

    group('Calculs', () {
      test('devrait calculer correctement le pourcentage de réduction', () {
        expect(testBasket.discountPercentage, equals(50.0));
      });

      test('devrait calculer correctement l\'économie réalisée', () {
        expect(testBasket.savings, equals(5.0));
      });

      test('devrait gérer le cas où le prix original est zéro', () {
        final Basket freeBasket = testBasket.copyWith(
          originalPrice: 0.0,
          discountedPrice: 0.0,
        );

        expect(freeBasket.discountPercentage, equals(0.0));
        expect(freeBasket.savings, equals(0.0));
      });
    });

    group('Statuts et disponibilité', () {
      test('devrait être disponible quand le statut est available et dans les délais', () {
        expect(testBasket.isAvailable, isTrue);
      });

      test('ne devrait pas être disponible quand le statut n\'est pas available', () {
        final Basket reservedBasket = testBasket.copyWith(
          status: BasketStatus.reserved,
        );

        expect(reservedBasket.isAvailable, isFalse);
      });

      test('ne devrait pas être disponible quand la quantité est zéro', () {
        final Basket emptyBasket = testBasket.copyWith(quantity: 0);

        expect(emptyBasket.isAvailable, isFalse);
      });

      test('ne devrait pas être disponible avant la date de disponibilité', () {
        final Basket futureBasket = testBasket.copyWith(
          availableFrom: now.add(const Duration(hours: 1)),
        );

        expect(futureBasket.isAvailable, isFalse);
      });

      test('ne devrait pas être disponible après la date d\'expiration', () {
        final Basket expiredBasket = testBasket.copyWith(
          availableUntil: now.subtract(const Duration(hours: 1)),
        );

        expect(expiredBasket.isAvailable, isFalse);
      });

      test('devrait pouvoir être récupéré pendant la période de pickup', () {
        final Basket readyBasket = testBasket.copyWith(
          status: BasketStatus.reserved,
          pickupTimeStart: now.subtract(const Duration(minutes: 30)),
          pickupTimeEnd: now.add(const Duration(hours: 1)),
        );

        expect(readyBasket.canBePickedUp, isTrue);
      });

      test('ne devrait pas pouvoir être récupéré avant la période de pickup', () {
        final Basket notReadyBasket = testBasket.copyWith(
          status: BasketStatus.reserved,
          pickupTimeStart: now.add(const Duration(hours: 1)),
          pickupTimeEnd: now.add(const Duration(hours: 2)),
        );

        expect(notReadyBasket.canBePickedUp, isFalse);
      });

      test('devrait détecter quand la récupération est bientôt expirée', () {
        final Basket soonExpiringBasket = testBasket.copyWith(
          status: BasketStatus.reserved,
          pickupTimeEnd: now.add(const Duration(minutes: 30)),
        );

        expect(soonExpiringBasket.isPickupSoon, isTrue);
      });
    });

    group('Couleurs et textes de statut', () {
      test('devrait retourner la bonne couleur pour chaque statut', () {
        expect(testBasket.statusColor, equals('#51CF66')); // available

        final Basket lastChanceBasket = testBasket.copyWith(isLastChance: true);
        expect(lastChanceBasket.statusColor, equals('#FF6B6B')); // last chance

        final Basket reservedBasket = testBasket.copyWith(status: BasketStatus.reserved);
        expect(reservedBasket.statusColor, equals('#74C0FC')); // reserved

        final Basket collectedBasket = testBasket.copyWith(status: BasketStatus.collected);
        expect(collectedBasket.statusColor, equals('#51CF66')); // collected

        final Basket expiredBasket = testBasket.copyWith(status: BasketStatus.expired);
        expect(expiredBasket.statusColor, equals('#ADB5BD')); // expired

        final Basket cancelledBasket = testBasket.copyWith(status: BasketStatus.cancelled);
        expect(cancelledBasket.statusColor, equals('#FF8787')); // cancelled
      });

      test('devrait retourner le bon texte pour chaque statut', () {
        expect(testBasket.statusText, equals('Disponible'));

        final Basket lastChanceBasket = testBasket.copyWith(isLastChance: true);
        expect(lastChanceBasket.statusText, equals('Dernière chance'));

        final Basket reservedBasket = testBasket.copyWith(status: BasketStatus.reserved);
        expect(reservedBasket.statusText, equals('Réservé'));

        final Basket collectedBasket = testBasket.copyWith(status: BasketStatus.collected);
        expect(collectedBasket.statusText, equals('Récupéré'));

        final Basket expiredBasket = testBasket.copyWith(status: BasketStatus.expired);
        expect(expiredBasket.statusText, equals('Expiré'));

        final Basket cancelledBasket = testBasket.copyWith(status: BasketStatus.cancelled);
        expect(cancelledBasket.statusText, equals('Annulé'));
      });
    });

    group('copyWith', () {
      test('devrait créer une copie avec des valeurs modifiées', () {
        final Basket updatedBasket = testBasket.copyWith(
          title: 'Updated Title',
          discountedPrice: 7.99,
          status: BasketStatus.reserved,
        );

        expect(updatedBasket.id, equals(testBasket.id));
        expect(updatedBasket.title, equals('Updated Title'));
        expect(updatedBasket.discountedPrice, equals(7.99));
        expect(updatedBasket.status, equals(BasketStatus.reserved));
        expect(updatedBasket.description, equals(testBasket.description));
      });

      test('devrait conserver les valeurs originales si aucun paramètre n\'est fourni', () {
        final Basket copiedBasket = testBasket.copyWith();

        expect(copiedBasket.id, equals(testBasket.id));
        expect(copiedBasket.title, equals(testBasket.title));
        expect(copiedBasket.description, equals(testBasket.description));
        expect(copiedBasket.originalPrice, equals(testBasket.originalPrice));
        expect(copiedBasket.discountedPrice, equals(testBasket.discountedPrice));
        expect(copiedBasket.status, equals(testBasket.status));
      });
    });

    group('Égalité', () {
      test('devrait être égal à un autre panier avec les mêmes propriétés', () {
        final Basket identicalBasket = Basket(
          id: 'basket_1',
          commerceId: 'commerce_1',
          commerce: testCommerce,
          title: 'Test Basket',
          description: 'Description du panier de test',
          originalPrice: 10.0,
          discountedPrice: 5.0,
          availableFrom: testBasket.availableFrom,
          availableUntil: testBasket.availableUntil,
          pickupTimeStart: testBasket.pickupTimeStart,
          pickupTimeEnd: testBasket.pickupTimeEnd,
          quantity: 5,
          createdAt: testBasket.createdAt,
          status: BasketStatus.available,
          imageUrls: const ['https://example.com/image1.jpg'],
          estimatedWeight: 2.5,
          size: BasketSize.medium,
          allergens: const ['gluten', 'lactose'],
          dietaryTags: const ['bio', 'local'],
          ingredients: const ['pain', 'fromage', 'légumes'],
          specialInstructions: 'Instructions spéciales',
          isLastChance: false,
          rating: 4.5,
          co2Saved: 1.2,
          isRecurring: false,
          recurringDays: const [],
        );

        expect(testBasket, equals(identicalBasket));
      });

      test('ne devrait pas être égal à un panier avec des propriétés différentes', () {
        final Basket differentBasket = testBasket.copyWith(id: 'different_id');

        expect(testBasket, isNot(equals(differentBasket)));
      });
    });

    group('toString', () {
      test('devrait retourner une représentation string appropriée', () {
        final String basketString = testBasket.toString();

        expect(basketString, contains('Basket'));
        expect(basketString, contains('basket_1'));
        expect(basketString, contains('Test Basket'));
        expect(basketString, contains('available'));
        expect(basketString, contains('5.0€'));
      });
    });
  });

  group('BasketStatus', () {
    test('devrait avoir tous les statuts attendus', () {
      expect(BasketStatus.values, contains(BasketStatus.available));
      expect(BasketStatus.values, contains(BasketStatus.reserved));
      expect(BasketStatus.values, contains(BasketStatus.collected));
      expect(BasketStatus.values, contains(BasketStatus.expired));
      expect(BasketStatus.values, contains(BasketStatus.cancelled));
    });
  });

  group('BasketSize', () {
    test('devrait avoir toutes les tailles attendues', () {
      expect(BasketSize.values, contains(BasketSize.small));
      expect(BasketSize.values, contains(BasketSize.medium));
      expect(BasketSize.values, contains(BasketSize.large));
    });
  });
}
