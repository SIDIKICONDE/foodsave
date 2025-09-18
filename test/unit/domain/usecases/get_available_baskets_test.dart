import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:foodsave_app/domain/usecases/get_available_baskets.dart';
import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/domain/entities/commerce.dart';
import 'package:foodsave_app/domain/repositories/basket_repository.dart';

/// Mock pour [BasketRepository]
class MockBasketRepository extends Mock implements BasketRepository {}

/// Tests unitaires pour [GetAvailableBaskets].
/// 
/// Ces tests vérifient le comportement du cas d'usage de récupération
/// des paniers disponibles, incluant les filtres et la pagination.
void main() {
  group('GetAvailableBaskets', () {
    late GetAvailableBaskets getAvailableBaskets;
    late MockBasketRepository mockBasketRepository;
    late List<Basket> testBaskets;
    late Commerce testCommerce;

    setUp(() {
      mockBasketRepository = MockBasketRepository();
      getAvailableBaskets = GetAvailableBaskets(mockBasketRepository);

      testCommerce = Commerce(
        id: 'commerce_1',
        name: 'Test Boulangerie',
        type: CommerceType.bakery,
        address: '123 Test Street',
        latitude: 48.8566,
        longitude: 2.3522,
        phone: '0123456789',
        email: 'test@boulangerie.com',
        createdAt: DateTime.now(),
        isActive: true,
      );

      testBaskets = [
        Basket(
          id: 'basket_1',
          commerceId: 'commerce_1',
          commerce: testCommerce,
          title: 'Panier Boulangerie',
          description: 'Viennoiseries et pain',
          originalPrice: 12.0,
          discountedPrice: 6.0,
          availableFrom: DateTime.now().subtract(const Duration(hours: 1)),
          availableUntil: DateTime.now().add(const Duration(hours: 2)),
          pickupTimeStart: DateTime.now().add(const Duration(minutes: 30)),
          pickupTimeEnd: DateTime.now().add(const Duration(hours: 3)),
          quantity: 3,
          createdAt: DateTime.now(),
          status: BasketStatus.available,
        ),
        Basket(
          id: 'basket_2',
          commerceId: 'commerce_1',
          commerce: testCommerce,
          title: 'Panier Restaurant',
          description: 'Plats du jour',
          originalPrice: 15.0,
          discountedPrice: 8.0,
          availableFrom: DateTime.now().subtract(const Duration(hours: 1)),
          availableUntil: DateTime.now().add(const Duration(hours: 1)),
          pickupTimeStart: DateTime.now().add(const Duration(minutes: 15)),
          pickupTimeEnd: DateTime.now().add(const Duration(hours: 2)),
          quantity: 2,
          createdAt: DateTime.now(),
          status: BasketStatus.available,
        ),
      ];
    });

    group('call', () {
      test('devrait retourner une liste de paniers disponibles', () async {
        // Arrange
        const GetAvailableBasketsParams params = GetAvailableBasketsParams(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 10.0,
          limit: 20,
          offset: 0,
        );

        when(() => mockBasketRepository.getAvailableBaskets(
          latitude: params.latitude,
          longitude: params.longitude,
          radius: params.radius,
          limit: params.limit,
          offset: params.offset,
        )).thenAnswer((_) async => testBaskets);

        // Act
        final List<Basket> result = await getAvailableBaskets.call(params);

        // Assert
        expect(result, equals(testBaskets));
        expect(result.length, equals(2));
        expect(result.first.id, equals('basket_1'));
        expect(result.last.id, equals('basket_2'));

        verify(() => mockBasketRepository.getAvailableBaskets(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 10.0,
          limit: 20,
          offset: 0,
        )).called(1);
      });

      test('devrait retourner une liste vide quand aucun panier n\'est disponible', () async {
        // Arrange
        const GetAvailableBasketsParams params = GetAvailableBasketsParams(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 1.0, // Petit rayon
          limit: 20,
          offset: 0,
        );

        when(() => mockBasketRepository.getAvailableBaskets(
          latitude: params.latitude,
          longitude: params.longitude,
          radius: params.radius,
          limit: params.limit,
          offset: params.offset,
        )).thenAnswer((_) async => <Basket>[]);

        // Act
        final List<Basket> result = await getAvailableBaskets.call(params);

        // Assert
        expect(result, isEmpty);
        expect(result.length, equals(0));

        verify(() => mockBasketRepository.getAvailableBaskets(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 1.0,
          limit: 20,
          offset: 0,
        )).called(1);
      });

      test('devrait utiliser les paramètres par défaut quand ils ne sont pas fournis', () async {
        // Arrange
        const GetAvailableBasketsParams params = GetAvailableBasketsParams();

        when(() => mockBasketRepository.getAvailableBaskets(
          latitude: params.latitude,
          longitude: params.longitude,
          radius: params.radius,
          limit: params.limit,
          offset: params.offset,
        )).thenAnswer((_) async => testBaskets);

        // Act
        final List<Basket> result = await getAvailableBaskets.call(params);

        // Assert
        expect(result, equals(testBaskets));

        verify(() => mockBasketRepository.getAvailableBaskets(
          latitude: null,
          longitude: null,
          radius: 10.0, // Valeur par défaut
          limit: 20, // Valeur par défaut
          offset: 0, // Valeur par défaut
        )).called(1);
      });

      test('devrait gérer la pagination correctement', () async {
        // Arrange
        const GetAvailableBasketsParams params = GetAvailableBasketsParams(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 10.0,
          limit: 1, // Limite de 1
          offset: 1, // Offset de 1
        );

        when(() => mockBasketRepository.getAvailableBaskets(
          latitude: params.latitude,
          longitude: params.longitude,
          radius: params.radius,
          limit: params.limit,
          offset: params.offset,
        )).thenAnswer((_) async => [testBaskets.last]); // Retourne seulement le deuxième panier

        // Act
        final List<Basket> result = await getAvailableBaskets.call(params);

        // Assert
        expect(result.length, equals(1));
        expect(result.first.id, equals('basket_2'));

        verify(() => mockBasketRepository.getAvailableBaskets(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 10.0,
          limit: 1,
          offset: 1,
        )).called(1);
      });

      test('devrait gérer les rayons de recherche différents', () async {
        // Arrange
        const GetAvailableBasketsParams smallRadiusParams = GetAvailableBasketsParams(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 1.0, // Petit rayon
        );

        const GetAvailableBasketsParams largeRadiusParams = GetAvailableBasketsParams(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 50.0, // Grand rayon
        );

        when(() => mockBasketRepository.getAvailableBaskets(
          latitude: smallRadiusParams.latitude,
          longitude: smallRadiusParams.longitude,
          radius: smallRadiusParams.radius,
          limit: smallRadiusParams.limit,
          offset: smallRadiusParams.offset,
        )).thenAnswer((_) async => <Basket>[]);

        when(() => mockBasketRepository.getAvailableBaskets(
          latitude: largeRadiusParams.latitude,
          longitude: largeRadiusParams.longitude,
          radius: largeRadiusParams.radius,
          limit: largeRadiusParams.limit,
          offset: largeRadiusParams.offset,
        )).thenAnswer((_) async => testBaskets);

        // Act
        final List<Basket> smallRadiusResult = await getAvailableBaskets.call(smallRadiusParams);
        final List<Basket> largeRadiusResult = await getAvailableBaskets.call(largeRadiusParams);

        // Assert
        expect(smallRadiusResult, isEmpty);
        expect(largeRadiusResult, equals(testBaskets));

        verify(() => mockBasketRepository.getAvailableBaskets(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 1.0,
          limit: 20,
          offset: 0,
        )).called(1);

        verify(() => mockBasketRepository.getAvailableBaskets(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 50.0,
          limit: 20,
          offset: 0,
        )).called(1);
      });

      test('devrait gérer les erreurs du repository', () async {
        // Arrange
        const GetAvailableBasketsParams params = GetAvailableBasketsParams(
          latitude: 48.8566,
          longitude: 2.3522,
        );

        when(() => mockBasketRepository.getAvailableBaskets(
          latitude: params.latitude,
          longitude: params.longitude,
          radius: params.radius,
          limit: params.limit,
          offset: params.offset,
        )).thenThrow(Exception('Erreur du repository'));

        // Act & Assert
        expect(
          () => getAvailableBaskets.call(params),
          throwsA(isA<Exception>()),
        );

        verify(() => mockBasketRepository.getAvailableBaskets(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 10.0,
          limit: 20,
          offset: 0,
        )).called(1);
      });
    });

    group('GetAvailableBasketsParams', () {
      test('devrait créer des paramètres avec les valeurs fournies', () {
        const GetAvailableBasketsParams params = GetAvailableBasketsParams(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 15.0,
          limit: 50,
          offset: 10,
        );

        expect(params.latitude, equals(48.8566));
        expect(params.longitude, equals(2.3522));
        expect(params.radius, equals(15.0));
        expect(params.limit, equals(50));
        expect(params.offset, equals(10));
      });

      test('devrait utiliser les valeurs par défaut', () {
        const GetAvailableBasketsParams params = GetAvailableBasketsParams();

        expect(params.latitude, isNull);
        expect(params.longitude, isNull);
        expect(params.radius, equals(10.0));
        expect(params.limit, equals(20));
        expect(params.offset, equals(0));
      });

      test('devrait être égal à des paramètres identiques', () {
        const GetAvailableBasketsParams params1 = GetAvailableBasketsParams(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 10.0,
          limit: 20,
          offset: 0,
        );

        const GetAvailableBasketsParams params2 = GetAvailableBasketsParams(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 10.0,
          limit: 20,
          offset: 0,
        );

        expect(params1, equals(params2));
      });

      test('ne devrait pas être égal à des paramètres différents', () {
        const GetAvailableBasketsParams params1 = GetAvailableBasketsParams(
          latitude: 48.8566,
          longitude: 2.3522,
        );

        const GetAvailableBasketsParams params2 = GetAvailableBasketsParams(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 15.0, // Différent
        );

        expect(params1, isNot(equals(params2)));
      });

      test('devrait inclure tous les paramètres dans props', () {
        const GetAvailableBasketsParams params = GetAvailableBasketsParams(
          latitude: 48.8566,
          longitude: 2.3522,
          radius: 10.0,
          limit: 20,
          offset: 0,
        );

        expect(params.props, contains(48.8566));
        expect(params.props, contains(2.3522));
        expect(params.props, contains(10.0));
        expect(params.props, contains(20));
        expect(params.props, contains(0));
      });
    });

    group('Intégration', () {
      test('devrait maintenir la cohérence des données de paniers', () async {
        // Arrange
        final List<Basket> basketsWithCompleteData = [
          Basket(
            id: 'complete_basket',
            commerceId: 'commerce_1',
            commerce: testCommerce,
            title: 'Panier Complet',
            description: 'Description complète',
            originalPrice: 20.0,
            discountedPrice: 10.0,
            availableFrom: DateTime.now().subtract(const Duration(hours: 1)),
            availableUntil: DateTime.now().add(const Duration(hours: 2)),
            pickupTimeStart: DateTime.now().add(const Duration(minutes: 30)),
            pickupTimeEnd: DateTime.now().add(const Duration(hours: 3)),
            quantity: 5,
            createdAt: DateTime.now(),
            status: BasketStatus.available,
            imageUrls: const ['https://example.com/image1.jpg'],
            estimatedWeight: 3.5,
            size: BasketSize.large,
            allergens: const ['gluten', 'lactose'],
            dietaryTags: const ['bio', 'local'],
            ingredients: const ['pain', 'fromage', 'légumes'],
            specialInstructions: 'Instructions spéciales',
            isLastChance: true,
            rating: 4.8,
            co2Saved: 2.5,
            isRecurring: false,
            recurringDays: const [],
          ),
        ];

        const GetAvailableBasketsParams params = GetAvailableBasketsParams(
          latitude: 48.8566,
          longitude: 2.3522,
        );

        when(() => mockBasketRepository.getAvailableBaskets(
          latitude: params.latitude,
          longitude: params.longitude,
          radius: params.radius,
          limit: params.limit,
          offset: params.offset,
        )).thenAnswer((_) async => basketsWithCompleteData);

        // Act
        final List<Basket> result = await getAvailableBaskets.call(params);

        // Assert
        expect(result.length, equals(1));
        final Basket basket = result.first;
        expect(basket.id, equals('complete_basket'));
        expect(basket.title, equals('Panier Complet'));
        expect(basket.description, equals('Description complète'));
        expect(basket.originalPrice, equals(20.0));
        expect(basket.discountedPrice, equals(10.0));
        expect(basket.quantity, equals(5));
        expect(basket.status, equals(BasketStatus.available));
        expect(basket.imageUrls, equals(['https://example.com/image1.jpg']));
        expect(basket.estimatedWeight, equals(3.5));
        expect(basket.size, equals(BasketSize.large));
        expect(basket.allergens, equals(['gluten', 'lactose']));
        expect(basket.dietaryTags, equals(['bio', 'local']));
        expect(basket.ingredients, equals(['pain', 'fromage', 'légumes']));
        expect(basket.specialInstructions, equals('Instructions spéciales'));
        expect(basket.isLastChance, equals(true));
        expect(basket.rating, equals(4.8));
        expect(basket.co2Saved, equals(2.5));
        expect(basket.isRecurring, equals(false));
        expect(basket.recurringDays, isEmpty);
      });
    });
  });
}
