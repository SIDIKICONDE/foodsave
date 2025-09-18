/// Configuration globale pour les tests unitaires du projet FoodSave.
/// 
/// Ce fichier contient les configurations et constantes utilisées
/// dans tous les tests unitaires du projet.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';

/// Configuration des tests unitaires.
class TestConfig {
  /// Désactive les tests d'intégration par défaut.
  static const bool enableIntegrationTests = false;
  
  /// Active les tests de performance.
  static const bool enablePerformanceTests = false;
  
  /// Timeout par défaut pour les tests asynchrones.
  static const Duration defaultTimeout = Duration(seconds: 30);
  
  /// Nombre maximum de tentatives pour les tests flaky.
  static const int maxRetries = 3;
  
  /// Active le mode debug pour les tests.
  static const bool debugMode = false;
  
  /// Configuration des mocks.
  static const MockConfig mockConfig = MockConfig();
  
  /// Configuration des données de test.
  static const TestDataConfig testDataConfig = TestDataConfig();
}

/// Configuration des mocks.
class MockConfig {
  const MockConfig();
  
  /// Active la vérification automatique des interactions.
  bool get verifyInteractions => true;
  
  /// Active la vérification des paramètres.
  bool get verifyParameters => true;
  
  /// Timeout pour les mocks.
  Duration get timeout => const Duration(seconds: 5);
}

/// Configuration des données de test.
class TestDataConfig {
  const TestDataConfig();
  
  /// Nombre par défaut d'éléments dans les listes de test.
  int get defaultListSize => 3;
  
  /// Nombre maximum d'éléments dans les listes de test.
  int get maxListSize => 10;
  
  /// Active la génération de données aléatoires.
  bool get useRandomData => false;
  
  /// Seed pour la génération de données aléatoires.
  int get randomSeed => 42;
}

/// Constantes pour les tests.
class TestConstants {
  // Identifiants de test
  static const String testUserId = 'test_user_id';
  static const String testCommerceId = 'test_commerce_id';
  static const String testBasketId = 'test_basket_id';
  static const String testReservationId = 'test_reservation_id';
  static const String testMarkerId = 'test_marker_id';
  
  // Données utilisateur
  static const String testEmail = 'test@example.com';
  static const String testPassword = 'password123';
  static const String testName = 'Test User';
  static const String testPhone = '+33123456789';
  static const String testAddress = '123 Test Street, Paris';
  
  // Données géographiques
  static const double testLatitude = 48.8566;
  static const double testLongitude = 2.3522;
  static const double testRadius = 10.0;
  
  // Données financières
  static const double testOriginalPrice = 10.0;
  static const double testDiscountedPrice = 5.0;
  static const double testRating = 4.5;
  static const int testQuantity = 3;
  
  // Durées
  static const Duration testDuration = Duration(hours: 2);
  static const Duration testShortDuration = Duration(minutes: 30);
  static const Duration testLongDuration = Duration(hours: 3);
  
  // Tokens
  static const String testToken = 'test_token';
  static const String testRefreshToken = 'test_refresh_token';
  static const String testConfirmationCode = 'TEST123';
  
  // URLs
  static const String testImageUrl = 'https://example.com/image.jpg';
  static const String testAvatarUrl = 'https://example.com/avatar.jpg';
  static const String testWebsiteUrl = 'https://example.com';
}

/// Utilitaires pour les tests.
class TestUtils {
  /// Crée un DateTime de test avec un décalage.
  static DateTime createTestDateTime({Duration? offset}) {
    return DateTime.now().add(offset ?? Duration.zero);
  }
  
  /// Crée un DateTime de test dans le passé.
  static DateTime createPastDateTime({Duration? offset}) {
    return DateTime.now().subtract(offset ?? const Duration(hours: 1));
  }
  
  /// Crée un DateTime de test dans le futur.
  static DateTime createFutureDateTime({Duration? offset}) {
    return DateTime.now().add(offset ?? const Duration(hours: 1));
  }
  
  /// Vérifie si deux DateTime sont égales à la seconde près.
  static bool areDateTimeEqual(DateTime date1, DateTime date2) {
    return date1.difference(date2).inSeconds.abs() < 1;
  }
  
  /// Crée une liste de test avec des éléments générés.
  static List<T> createTestList<T>(T Function(int index) generator, {int? count}) {
    final int listCount = count ?? TestConfig.testDataConfig.defaultListSize;
    return List.generate(listCount, generator);
  }
  
  /// Attend qu'une condition soit vraie.
  static Future<void> waitForCondition(
    bool Function() condition, {
    Duration? timeout,
    Duration? interval,
  }) async {
    final Duration timeoutDuration = timeout ?? TestConfig.defaultTimeout;
    final Duration intervalDuration = interval ?? const Duration(milliseconds: 100);
    
    final DateTime startTime = DateTime.now();
    
    while (!condition()) {
      if (DateTime.now().difference(startTime) > timeoutDuration) {
        throw TimeoutException('Condition non remplie dans le délai imparti', timeoutDuration);
      }
      
      await Future.delayed(intervalDuration);
    }
  }
}

/// Configuration des assertions personnalisées.
class CustomMatchers {
  /// Vérifie qu'une DateTime est dans une plage acceptable.
  static Matcher isDateTimeCloseTo(DateTime expected, {Duration? tolerance}) {
    final Duration toleranceDuration = tolerance ?? const Duration(seconds: 1);
    
    return predicate<DateTime>(
      (actual) => actual.difference(expected).abs() <= toleranceDuration,
      'est proche de $expected (tolérance: $toleranceDuration)',
    );
  }
  
  /// Vérifie qu'une liste contient des éléments uniques.
  static Matcher hasUniqueElements() {
    return predicate<List>(
      (list) {
        final Set uniqueElements = list.toSet();
        return uniqueElements.length == list.length;
      },
      'contient des éléments uniques',
    );
  }
  
  /// Vérifie qu'une chaîne est un email valide.
  static Matcher isValidEmail() {
    return predicate<String>(
      (email) {
        final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
        return emailRegex.hasMatch(email);
      },
      'est un email valide',
    );
  }
  
  /// Vérifie qu'une chaîne est un numéro de téléphone valide.
  static Matcher isValidPhoneNumber() {
    return predicate<String>(
      (phone) {
        final RegExp phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
        return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
      },
      'est un numéro de téléphone valide',
    );
  }
}

/// Extensions pour les tests.
extension TestExtensions on TestWidgetsFlutterBinding {
  /// Configure l'environnement de test.
  static void configureTestEnvironment() {
    TestWidgetsFlutterBinding.ensureInitialized();
    
    // Configuration spécifique aux tests
    if (TestConfig.debugMode) {
      debugPrint('Mode debug activé pour les tests');
    }
  }
}

/// Classe d'exception pour les timeouts de test.
class TimeoutException implements Exception {
  final String message;
  final Duration timeout;
  
  const TimeoutException(this.message, this.timeout);
  
  @override
  String toString() => 'TimeoutException: $message (timeout: $timeout)';
}
