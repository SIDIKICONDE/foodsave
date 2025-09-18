import 'package:foodsave_app/domain/entities/user.dart';
import 'package:foodsave_app/domain/entities/commerce.dart';
import 'package:foodsave_app/domain/entities/basket.dart';
import 'package:foodsave_app/domain/entities/reservation.dart';
import 'package:foodsave_app/models/map_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Classe utilitaire pour créer des objets de test.
/// 
/// Cette classe fournit des méthodes statiques pour créer des instances
/// de test des entités principales du projet FoodSave.
class TestHelpers {
  /// Crée un utilisateur de test avec des valeurs par défaut.
  static User createTestUser({
    String? id,
    String? name,
    String? email,
    UserType? userType,
    DateTime? createdAt,
    String? phone,
    String? avatar,
    String? address,
    bool? isEmailVerified,
  }) {
    final DateTime now = DateTime.now();
    
    return User(
      id: id ?? 'test_user_id',
      name: name ?? 'Test User',
      email: email ?? 'test@example.com',
      userType: userType ?? UserType.consumer,
      createdAt: createdAt ?? now,
      phone: phone,
      avatar: avatar,
      address: address,
      isEmailVerified: isEmailVerified ?? true,
      token: 'test_token',
      refreshToken: 'test_refresh_token',
    );
  }

  /// Crée un commerce de test avec des valeurs par défaut.
  static Commerce createTestCommerce({
    String? id,
    String? name,
    CommerceType? type,
    String? address,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    DateTime? createdAt,
    bool? isActive,
  }) {
    final DateTime now = DateTime.now();
    
    return Commerce(
      id: id ?? 'test_commerce_id',
      name: name ?? 'Test Commerce',
      type: type ?? CommerceType.bakery,
      address: address ?? '123 Test Street',
      latitude: latitude ?? 48.8566,
      longitude: longitude ?? 2.3522,
      phone: phone ?? '0123456789',
      email: email ?? 'test@commerce.com',
      createdAt: createdAt ?? now,
      isActive: isActive ?? true,
    );
  }

  /// Crée un panier de test avec des valeurs par défaut.
  static Basket createTestBasket({
    String? id,
    String? commerceId,
    Commerce? commerce,
    String? title,
    String? description,
    double? originalPrice,
    double? discountedPrice,
    DateTime? availableFrom,
    DateTime? availableUntil,
    DateTime? pickupTimeStart,
    DateTime? pickupTimeEnd,
    int? quantity,
    DateTime? createdAt,
    BasketStatus? status,
  }) {
    final DateTime now = DateTime.now();
    final Commerce testCommerce = commerce ?? createTestCommerce();
    
    return Basket(
      id: id ?? 'test_basket_id',
      commerceId: commerceId ?? 'test_commerce_id',
      commerce: testCommerce,
      title: title ?? 'Test Basket',
      description: description ?? 'Description du panier de test',
      originalPrice: originalPrice ?? 10.0,
      discountedPrice: discountedPrice ?? 5.0,
      availableFrom: availableFrom ?? now.subtract(const Duration(hours: 1)),
      availableUntil: availableUntil ?? now.add(const Duration(hours: 2)),
      pickupTimeStart: pickupTimeStart ?? now.add(const Duration(minutes: 30)),
      pickupTimeEnd: pickupTimeEnd ?? now.add(const Duration(hours: 3)),
      quantity: quantity ?? 3,
      createdAt: createdAt ?? now,
      status: status ?? BasketStatus.available,
    );
  }

  /// Crée une réservation de test avec des valeurs par défaut.
  static Reservation createTestReservation({
    String? id,
    String? userId,
    String? basketId,
    String? commerceId,
    DateTime? reservedAt,
    DateTime? pickupTimeStart,
    DateTime? pickupTimeEnd,
    ReservationStatus? status,
    double? totalAmount,
    PaymentMethod? paymentMethod,
    User? user,
    Basket? basket,
    Commerce? commerce,
  }) {
    final DateTime now = DateTime.now();
    final User testUser = user ?? createTestUser();
    final Basket testBasket = basket ?? createTestBasket();
    final Commerce testCommerce = commerce ?? createTestCommerce();
    
    return Reservation(
      id: id ?? 'test_reservation_id',
      userId: userId ?? 'test_user_id',
      basketId: basketId ?? 'test_basket_id',
      commerceId: commerceId ?? 'test_commerce_id',
      reservedAt: reservedAt ?? now,
      pickupTimeStart: pickupTimeStart ?? now.add(const Duration(minutes: 30)),
      pickupTimeEnd: pickupTimeEnd ?? now.add(const Duration(hours: 3)),
      status: status ?? ReservationStatus.confirmed,
      totalAmount: totalAmount ?? 5.0,
      paymentMethod: paymentMethod ?? PaymentMethod.creditCard,
      user: testUser,
      basket: testBasket,
      commerce: testCommerce,
      confirmationCode: 'TEST123',
    );
  }

  /// Crée un marqueur de carte de test avec des valeurs par défaut.
  static MapMarker createTestMapMarker({
    String? id,
    LatLng? position,
    MarkerType? type,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavorite,
    DateTime? availableUntil,
    int? quantity,
    double? rating,
    String? shopName,
    String? address,
  }) {
    return MapMarker(
      id: id ?? 'test_marker_id',
      position: position ?? const LatLng(48.8566, 2.3522),
      type: type ?? MarkerType.boulangerie,
      title: title ?? 'Test Marker',
      description: description ?? 'Description du marqueur de test',
      price: price ?? 5.99,
      imageUrl: imageUrl,
      isFavorite: isFavorite ?? false,
      availableUntil: availableUntil ?? DateTime.now().add(const Duration(hours: 2)),
      quantity: quantity ?? 3,
      rating: rating ?? 4.5,
      shopName: shopName ?? 'Test Shop',
      address: address ?? '123 Test Street',
    );
  }

  /// Crée une liste de paniers de test.
  static List<Basket> createTestBaskets({int count = 3}) {
    return List.generate(count, (index) => createTestBasket(
      id: 'test_basket_$index',
      title: 'Test Basket $index',
      quantity: index + 1,
    ));
  }

  /// Crée une liste de marqueurs de test.
  static List<MapMarker> createTestMapMarkers({int count = 3}) {
    return List.generate(count, (index) => createTestMapMarker(
      id: 'test_marker_$index',
      title: 'Test Marker $index',
      quantity: index + 1,
    ));
  }

  /// Crée une liste de commerces de test.
  static List<Commerce> createTestCommerces({int count = 3}) {
    return List.generate(count, (index) => createTestCommerce(
      id: 'test_commerce_$index',
      name: 'Test Commerce $index',
      latitude: 48.8566 + (index * 0.01),
      longitude: 2.3522 + (index * 0.01),
    ));
  }

  /// Crée une liste d'utilisateurs de test.
  static List<User> createTestUsers({int count = 3}) {
    return List.generate(count, (index) => createTestUser(
      id: 'test_user_$index',
      name: 'Test User $index',
      email: 'test$index@example.com',
    ));
  }

  /// Crée une liste de réservations de test.
  static List<Reservation> createTestReservations({int count = 3}) {
    return List.generate(count, (index) => createTestReservation(
      id: 'test_reservation_$index',
      totalAmount: (index + 1) * 5.0,
    ));
  }
}

/// Extensions pour les tests.
extension TestExtensions on DateTime {
  /// Crée une date de test avec un décalage par rapport à maintenant.
  static DateTime testDate({Duration? offset}) {
    return DateTime.now().add(offset ?? Duration.zero);
  }

  /// Crée une date de test dans le passé.
  static DateTime testPastDate({Duration? offset}) {
    return DateTime.now().subtract(offset ?? const Duration(hours: 1));
  }

  /// Crée une date de test dans le futur.
  static DateTime testFutureDate({Duration? offset}) {
    return DateTime.now().add(offset ?? const Duration(hours: 1));
  }
}

/// Constantes pour les tests.
class TestConstants {
  static const String testEmail = 'test@example.com';
  static const String testPassword = 'password123';
  static const String testName = 'Test User';
  static const String testPhone = '+33123456789';
  static const String testAddress = '123 Test Street, Paris';
  static const String testToken = 'test_token';
  static const String testRefreshToken = 'test_refresh_token';
  
  static const double testLatitude = 48.8566;
  static const double testLongitude = 2.3522;
  static const double testRadius = 10.0;
  
  static const double testOriginalPrice = 10.0;
  static const double testDiscountedPrice = 5.0;
  static const int testQuantity = 3;
  static const double testRating = 4.5;
  
  static const Duration testDuration = Duration(hours: 2);
  static const Duration testShortDuration = Duration(minutes: 30);
  static const Duration testLongDuration = Duration(hours: 3);
}
