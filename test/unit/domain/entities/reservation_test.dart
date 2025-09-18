import 'package:flutter_test/flutter_test.dart';
import 'package:foodsave_app/domain/entities/reservation.dart';
import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/domain/entities/commerce.dart';
import 'package:foodsave_app/domain/entities/user.dart';

/// Tests unitaires pour la classe [Reservation].
/// 
/// Ces tests vérifient le comportement de la classe Reservation,
/// incluant les statuts, les calculs et les propriétés dérivées.
void main() {
  group('Reservation', () {
    late Reservation testReservation;
    late User testUser;
    late Commerce testCommerce;
    late Basket testBasket;
    late DateTime now;

    setUp(() {
      now = DateTime.now();
      
      testUser = User(
        id: 'user_1',
        name: 'Test User',
        email: 'test@example.com',
        userType: UserType.consumer,
        createdAt: now,
      );

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
        description: 'Description du panier',
        originalPrice: 10.0,
        discountedPrice: 5.0,
        availableFrom: now.subtract(const Duration(hours: 1)),
        availableUntil: now.add(const Duration(hours: 2)),
        pickupTimeStart: now.add(const Duration(minutes: 30)),
        pickupTimeEnd: now.add(const Duration(hours: 3)),
        quantity: 1,
        createdAt: now,
        status: BasketStatus.available,
      );

      testReservation = Reservation(
        id: 'reservation_1',
        userId: 'user_1',
        basketId: 'basket_1',
        commerceId: 'commerce_1',
        reservedAt: now,
        pickupTimeStart: now.add(const Duration(minutes: 30)),
        pickupTimeEnd: now.add(const Duration(hours: 3)),
        status: ReservationStatus.confirmed,
        totalAmount: 5.0,
        paymentMethod: PaymentMethod.creditCard,
        user: testUser,
        basket: testBasket,
        commerce: testCommerce,
        confirmationCode: 'ABC123',
        specialInstructions: 'Instructions spéciales',
        confirmedAt: now.add(const Duration(minutes: 5)),
        readyAt: now.add(const Duration(minutes: 15)),
        collectedAt: null,
        cancelledAt: null,
        cancellationReason: null,
        refundedAt: null,
        refundAmount: null,
        actualItems: null,
        actualWeight: null,
        rating: null,
        review: null,
        reviewedAt: null,
        promoCode: 'SAVE10',
        discountAmount: 0.5,
        loyaltyPointsEarned: 10,
        co2Saved: 1.2,
        notificationsSent: const ['confirmation', 'ready'],
      );
    });

    group('Constructeur', () {
      test('devrait créer une réservation avec tous les paramètres requis', () {
        expect(testReservation.id, equals('reservation_1'));
        expect(testReservation.userId, equals('user_1'));
        expect(testReservation.basketId, equals('basket_1'));
        expect(testReservation.commerceId, equals('commerce_1'));
        expect(testReservation.reservedAt, equals(now));
        expect(testReservation.status, equals(ReservationStatus.confirmed));
        expect(testReservation.totalAmount, equals(5.0));
        expect(testReservation.paymentMethod, equals(PaymentMethod.creditCard));
        expect(testReservation.confirmationCode, equals('ABC123'));
        expect(testReservation.specialInstructions, equals('Instructions spéciales'));
        expect(testReservation.promoCode, equals('SAVE10'));
        expect(testReservation.discountAmount, equals(0.5));
        expect(testReservation.loyaltyPointsEarned, equals(10));
        expect(testReservation.co2Saved, equals(1.2));
        expect(testReservation.notificationsSent, equals(['confirmation', 'ready']));
      });

      test('devrait créer une réservation avec des paramètres optionnels par défaut', () {
        final Reservation minimalReservation = Reservation(
          id: 'minimal_reservation',
          userId: 'user_1',
          basketId: 'basket_1',
          commerceId: 'commerce_1',
          reservedAt: DateTime.now(),
          pickupTimeStart: DateTime.now(),
          pickupTimeEnd: DateTime.now().add(const Duration(hours: 1)),
          status: ReservationStatus.pending,
          totalAmount: 10.0,
          paymentMethod: PaymentMethod.cashOnPickup,
        );

        expect(minimalReservation.user, isNull);
        expect(minimalReservation.basket, isNull);
        expect(minimalReservation.commerce, isNull);
        expect(minimalReservation.confirmationCode, isNull);
        expect(minimalReservation.specialInstructions, isNull);
        expect(minimalReservation.confirmedAt, isNull);
        expect(minimalReservation.readyAt, isNull);
        expect(minimalReservation.collectedAt, isNull);
        expect(minimalReservation.cancelledAt, isNull);
        expect(minimalReservation.cancellationReason, isNull);
        expect(minimalReservation.refundedAt, isNull);
        expect(minimalReservation.refundAmount, isNull);
        expect(minimalReservation.actualItems, isNull);
        expect(minimalReservation.actualWeight, isNull);
        expect(minimalReservation.rating, isNull);
        expect(minimalReservation.review, isNull);
        expect(minimalReservation.reviewedAt, isNull);
        expect(minimalReservation.promoCode, isNull);
        expect(minimalReservation.discountAmount, isNull);
        expect(minimalReservation.loyaltyPointsEarned, isNull);
        expect(minimalReservation.co2Saved, isNull);
        expect(minimalReservation.notificationsSent, isEmpty);
      });
    });

    group('Calculs', () {
      test('devrait calculer correctement le montant net payé', () {
        expect(testReservation.netAmountPaid, equals(5.0));

        final Reservation refundedReservation = testReservation.copyWith(
          refundAmount: 2.0,
        );

        expect(refundedReservation.netAmountPaid, equals(3.0));
      });

      test('devrait gérer le cas où aucun remboursement n\'a été effectué', () {
        final Reservation noRefundReservation = testReservation.copyWith(
          refundAmount: null,
        );

        expect(noRefundReservation.netAmountPaid, equals(5.0));
      });
    });

    group('Statuts et permissions', () {
      test('devrait pouvoir être annulée quand le statut est pending', () {
        final Reservation pendingReservation = testReservation.copyWith(
          status: ReservationStatus.pending,
        );

        expect(pendingReservation.canBeCancelled, isTrue);
      });

      test('devrait pouvoir être annulée quand le statut est confirmed', () {
        expect(testReservation.canBeCancelled, isTrue);
      });

      test('ne devrait pas pouvoir être annulée quand le statut est collected', () {
        final Reservation collectedReservation = testReservation.copyWith(
          status: ReservationStatus.collected,
        );

        expect(collectedReservation.canBeCancelled, isFalse);
      });

      test('ne devrait pas pouvoir être annulée quand le statut est cancelled', () {
        final Reservation cancelledReservation = testReservation.copyWith(
          status: ReservationStatus.cancelledByUser,
        );

        expect(cancelledReservation.canBeCancelled, isFalse);
      });

      test('devrait pouvoir être récupérée pendant la période de pickup', () {
        final Reservation inWindow = testReservation.copyWith(
          status: ReservationStatus.confirmed,
          pickupTimeStart: DateTime.now().subtract(const Duration(minutes: 1)),
          pickupTimeEnd: DateTime.now().add(const Duration(minutes: 1)),
        );
        expect(inWindow.canBePickedUpNow, isTrue);
      });

      test('ne devrait pas pouvoir être récupérée avant la période de pickup', () {
        final Reservation futureReservation = testReservation.copyWith(
          pickupTimeStart: now.add(const Duration(hours: 1)),
          pickupTimeEnd: now.add(const Duration(hours: 2)),
        );

        expect(futureReservation.canBePickedUpNow, isFalse);
      });

      test('ne devrait pas pouvoir être récupérée après la période de pickup', () {
        final Reservation pastReservation = testReservation.copyWith(
          pickupTimeStart: now.subtract(const Duration(hours: 2)),
          pickupTimeEnd: now.subtract(const Duration(hours: 1)),
        );

        expect(pastReservation.canBePickedUpNow, isFalse);
      });

      test('devrait détecter quand la récupération est bientôt expirée', () {
        final Reservation soonExpiringReservation = testReservation.copyWith(
          pickupTimeEnd: now.add(const Duration(minutes: 30)),
        );

        expect(soonExpiringReservation.isPickupSoon, isTrue);
      });

      test('ne devrait pas être considérée comme expirée si elle est collectée', () {
        final Reservation collectedReservation = testReservation.copyWith(
          status: ReservationStatus.collected,
          pickupTimeEnd: now.subtract(const Duration(hours: 1)),
        );

        expect(collectedReservation.isExpired, isFalse);
      });

      test('devrait être considérée comme expirée si elle dépasse la période de pickup', () {
        final Reservation expiredReservation = testReservation.copyWith(
          status: ReservationStatus.confirmed,
          pickupTimeEnd: now.subtract(const Duration(hours: 1)),
        );

        expect(expiredReservation.isExpired, isTrue);
      });

      test('devrait pouvoir être évaluée si elle est collectée et non évaluée', () {
        final Reservation collectableReservation = testReservation.copyWith(
          status: ReservationStatus.collected,
          rating: null,
          review: null,
        );

        expect(collectableReservation.canBeReviewed, isTrue);
      });

      test('ne devrait pas pouvoir être évaluée si elle a déjà été évaluée', () {
        final Reservation reviewedReservation = testReservation.copyWith(
          status: ReservationStatus.collected,
          rating: 4.5,
          review: 'Très bon panier',
        );

        expect(reviewedReservation.canBeReviewed, isFalse);
      });
    });

    group('Calculs de temps', () {
      test('devrait calculer correctement les minutes restantes avant expiration', () {
        final Reservation futureReservation = testReservation.copyWith(
          pickupTimeEnd: DateTime.now().add(const Duration(minutes: 45)),
        );
        final int minutes = futureReservation.minutesUntilExpiry;
        expect(minutes, inInclusiveRange(44, 45));
      });

      test('devrait retourner 0 si la réservation est expirée', () {
        final Reservation expiredReservation = testReservation.copyWith(
          status: ReservationStatus.expired,
        );

        expect(expiredReservation.minutesUntilExpiry, equals(0));
      });

      test('devrait retourner 0 si la période de pickup est passée', () {
        final Reservation pastReservation = testReservation.copyWith(
          pickupTimeEnd: now.subtract(const Duration(hours: 1)),
        );

        expect(pastReservation.minutesUntilExpiry, equals(0));
      });
    });

    group('Couleurs et textes de statut', () {
      test('devrait retourner la bonne couleur pour chaque statut', () {
        expect(testReservation.statusColor, equals('#74C0FC')); // confirmed

        final Reservation pendingReservation = testReservation.copyWith(
          status: ReservationStatus.pending,
        );
        expect(pendingReservation.statusColor, equals('#FFD93D')); // pending

        final Reservation readyReservation = testReservation.copyWith(
          status: ReservationStatus.ready,
        );
        expect(readyReservation.statusColor, equals('#51CF66')); // ready

        final Reservation collectedReservation = testReservation.copyWith(
          status: ReservationStatus.collected,
        );
        expect(collectedReservation.statusColor, equals('#51CF66')); // collected

        final Reservation cancelledReservation = testReservation.copyWith(
          status: ReservationStatus.cancelledByUser,
        );
        expect(cancelledReservation.statusColor, equals('#FF8787')); // cancelled

        final Reservation expiredReservation = testReservation.copyWith(
          status: ReservationStatus.expired,
        );
        expect(expiredReservation.statusColor, equals('#ADB5BD')); // expired

        final Reservation refundedReservation = testReservation.copyWith(
          status: ReservationStatus.refunded,
        );
        expect(refundedReservation.statusColor, equals('#94D82D')); // refunded
      });

      test('devrait retourner le bon texte pour chaque statut', () {
        expect(testReservation.statusText, equals('Confirmé'));

        final Reservation pendingReservation = testReservation.copyWith(
          status: ReservationStatus.pending,
        );
        expect(pendingReservation.statusText, equals('En attente'));

        final Reservation readyReservation = testReservation.copyWith(
          status: ReservationStatus.ready,
        );
        expect(readyReservation.statusText, equals('Prêt'));

        final Reservation collectedReservation = testReservation.copyWith(
          status: ReservationStatus.collected,
        );
        expect(collectedReservation.statusText, equals('Récupéré'));

        final Reservation cancelledByUserReservation = testReservation.copyWith(
          status: ReservationStatus.cancelledByUser,
        );
        expect(cancelledByUserReservation.statusText, equals('Annulé par vous'));

        final Reservation cancelledByCommerceReservation = testReservation.copyWith(
          status: ReservationStatus.cancelledByCommerce,
        );
        expect(cancelledByCommerceReservation.statusText, equals('Annulé par le commerce'));

        final Reservation expiredReservation = testReservation.copyWith(
          status: ReservationStatus.expired,
        );
        expect(expiredReservation.statusText, equals('Expiré'));

        final Reservation refundedReservation = testReservation.copyWith(
          status: ReservationStatus.refunded,
        );
        expect(refundedReservation.statusText, equals('Remboursé'));
      });
    });

    group('Méthodes de paiement', () {
      test('devrait retourner le bon texte pour chaque méthode de paiement', () {
        expect(testReservation.paymentMethodText, equals('Carte bancaire'));

        final Reservation paypalReservation = testReservation.copyWith(
          paymentMethod: PaymentMethod.paypal,
        );
        expect(paypalReservation.paymentMethodText, equals('PayPal'));

        final Reservation applePayReservation = testReservation.copyWith(
          paymentMethod: PaymentMethod.applePay,
        );
        expect(applePayReservation.paymentMethodText, equals('Apple Pay'));

        final Reservation googlePayReservation = testReservation.copyWith(
          paymentMethod: PaymentMethod.googlePay,
        );
        expect(googlePayReservation.paymentMethodText, equals('Google Pay'));

        final Reservation foodsaveWalletReservation = testReservation.copyWith(
          paymentMethod: PaymentMethod.foodsaveWallet,
        );
        expect(foodsaveWalletReservation.paymentMethodText, equals('Portefeuille FoodSave'));

        final Reservation cashReservation = testReservation.copyWith(
          paymentMethod: PaymentMethod.cashOnPickup,
        );
        expect(cashReservation.paymentMethodText, equals('Paiement à la récupération'));
      });
    });

    group('copyWith', () {
      test('devrait créer une copie avec des valeurs modifiées', () {
        final Reservation updatedReservation = testReservation.copyWith(
          status: ReservationStatus.ready,
          totalAmount: 7.5,
          confirmationCode: 'XYZ789',
        );

        expect(updatedReservation.id, equals(testReservation.id));
        expect(updatedReservation.status, equals(ReservationStatus.ready));
        expect(updatedReservation.totalAmount, equals(7.5));
        expect(updatedReservation.confirmationCode, equals('XYZ789'));
        expect(updatedReservation.userId, equals(testReservation.userId));
        expect(updatedReservation.basketId, equals(testReservation.basketId));
      });

      test('devrait conserver les valeurs originales si aucun paramètre n\'est fourni', () {
        final Reservation copiedReservation = testReservation.copyWith();

        expect(copiedReservation.id, equals(testReservation.id));
        expect(copiedReservation.userId, equals(testReservation.userId));
        expect(copiedReservation.basketId, equals(testReservation.basketId));
        expect(copiedReservation.commerceId, equals(testReservation.commerceId));
        expect(copiedReservation.status, equals(testReservation.status));
        expect(copiedReservation.totalAmount, equals(testReservation.totalAmount));
        expect(copiedReservation.paymentMethod, equals(testReservation.paymentMethod));
      });
    });

    group('Égalité', () {
      test('devrait être égal à une autre réservation avec les mêmes propriétés', () {
        final Reservation identicalReservation = Reservation(
          id: 'reservation_1',
          userId: 'user_1',
          basketId: 'basket_1',
          commerceId: 'commerce_1',
          reservedAt: now,
          pickupTimeStart: now.add(const Duration(minutes: 30)),
          pickupTimeEnd: now.add(const Duration(hours: 3)),
          status: ReservationStatus.confirmed,
          totalAmount: 5.0,
          paymentMethod: PaymentMethod.creditCard,
          user: testUser,
          basket: testBasket,
          commerce: testCommerce,
          confirmationCode: 'ABC123',
          specialInstructions: 'Instructions spéciales',
          confirmedAt: now.add(const Duration(minutes: 5)),
          readyAt: now.add(const Duration(minutes: 15)),
          collectedAt: null,
          cancelledAt: null,
          cancellationReason: null,
          refundedAt: null,
          refundAmount: null,
          actualItems: null,
          actualWeight: null,
          rating: null,
          review: null,
          reviewedAt: null,
          promoCode: 'SAVE10',
          discountAmount: 0.5,
          loyaltyPointsEarned: 10,
          co2Saved: 1.2,
          notificationsSent: const ['confirmation', 'ready'],
        );

        expect(testReservation, equals(identicalReservation));
      });

      test('ne devrait pas être égal à une réservation avec des propriétés différentes', () {
        final Reservation differentReservation = testReservation.copyWith(id: 'different_id');

        expect(testReservation, isNot(equals(differentReservation)));
      });
    });

    group('toString', () {
      test('devrait retourner une représentation string appropriée', () {
        final String reservationString = testReservation.toString();

        expect(reservationString, contains('Reservation'));
        expect(reservationString, contains('reservation_1'));
        expect(reservationString, contains('confirmed'));
        expect(reservationString, contains('5.0€'));
      });
    });
  });

  group('ReservationStatus', () {
    test('devrait avoir tous les statuts attendus', () {
      expect(ReservationStatus.values, contains(ReservationStatus.pending));
      expect(ReservationStatus.values, contains(ReservationStatus.confirmed));
      expect(ReservationStatus.values, contains(ReservationStatus.ready));
      expect(ReservationStatus.values, contains(ReservationStatus.collected));
      expect(ReservationStatus.values, contains(ReservationStatus.cancelledByUser));
      expect(ReservationStatus.values, contains(ReservationStatus.cancelledByCommerce));
      expect(ReservationStatus.values, contains(ReservationStatus.expired));
      expect(ReservationStatus.values, contains(ReservationStatus.refunded));
    });
  });

  group('PaymentMethod', () {
    test('devrait avoir toutes les méthodes de paiement attendues', () {
      expect(PaymentMethod.values, contains(PaymentMethod.creditCard));
      expect(PaymentMethod.values, contains(PaymentMethod.paypal));
      expect(PaymentMethod.values, contains(PaymentMethod.applePay));
      expect(PaymentMethod.values, contains(PaymentMethod.googlePay));
      expect(PaymentMethod.values, contains(PaymentMethod.foodsaveWallet));
      expect(PaymentMethod.values, contains(PaymentMethod.cashOnPickup));
    });
  });
}
