# 🧪 Tests Unitaires - FoodSave App

Ce répertoire contient tous les tests unitaires pour l'application FoodSave, développés en suivant les directives strictes pour le développement Dart.

## 📁 Structure des Tests

```
test/
├── unit/                           # Tests unitaires
│   ├── models/                     # Tests des modèles
│   │   └── map_marker_test.dart
│   ├── domain/
│   │   ├── entities/               # Tests des entités
│   │   │   ├── basket_test.dart
│   │   │   ├── user_test.dart
│   │   │   ├── commerce_test.dart
│   │   │   └── reservation_test.dart
│   │   └── usecases/               # Tests des cas d'usage
│   │       ├── auth/
│   │       │   └── login_usecase_test.dart
│   │       └── get_available_baskets_test.dart
│   ├── services/                   # Tests des services
│   │   └── demo_map_service_test.dart
│   └── data/
│       └── repositories/           # Tests des repositories
│           └── auth_repository_impl_test.dart
├── helpers/                        # Utilitaires de test
│   └── test_helpers.dart
├── test_runner.dart                # Script principal d'exécution
└── README.md                       # Ce fichier
```

## 🚀 Exécution des Tests

### Exécuter tous les tests
```bash
flutter test
```

### Exécuter un test spécifique
```bash
flutter test test/unit/models/map_marker_test.dart
```

### Exécuter les tests avec couverture
```bash
flutter test --coverage
```

### Exécuter les tests en mode verbose
```bash
flutter test --verbose
```

## 📊 Couverture des Tests

Les tests couvrent les composants suivants :

### ✅ Modèles et Entités (5 fichiers)
- **MapMarker** : Tests de création, copie, égalité et propriétés
- **Basket** : Tests de calculs, statuts, disponibilité et couleurs
- **User** : Tests d'utilisateur, préférences et statistiques
- **Commerce** : Tests de distance, horaires et propriétés
- **Reservation** : Tests de statuts, calculs et permissions

### ✅ Services (1 fichier)
- **DemoMapService** : Tests de récupération, recherche et gestion des favoris

### ✅ Cas d'Usage (2 fichiers)
- **LoginUseCase** : Tests de connexion avec gestion des erreurs
- **GetAvailableBaskets** : Tests de récupération avec filtres et pagination

### ✅ Repositories (1 fichier)
- **AuthRepositoryImpl** : Tests de conversion d'exceptions en failures

## 🛠️ Utilitaires de Test

### TestHelpers
La classe `TestHelpers` fournit des méthodes statiques pour créer des objets de test :

```dart
// Créer un utilisateur de test
final User testUser = TestHelpers.createTestUser();

// Créer un panier de test
final Basket testBasket = TestHelpers.createTestBasket();

// Créer une liste de paniers
final List<Basket> testBaskets = TestHelpers.createTestBaskets(count: 5);
```

### TestConstants
Constantes prédéfinies pour les tests :

```dart
// Utiliser les constantes de test
final String email = TestConstants.testEmail;
final double latitude = TestConstants.testLatitude;
final Duration duration = TestConstants.testDuration;
```

## 📋 Directives de Test

### 1. **Utilisation obligatoire des types statiques**
```dart
// ✅ Correct
final String testName = 'Test User';
final int testQuantity = 5;

// ❌ Incorrect
var testName = 'Test User';
var testQuantity = 5;
```

### 2. **Utilisation de `const` et `final`**
```dart
// ✅ Correct
const String testEmail = 'test@example.com';
final DateTime now = DateTime.now();

// ❌ Incorrect
String testEmail = 'test@example.com';
```

### 3. **Gestion stricte des erreurs avec `try-catch`**
```dart
// ✅ Correct
try {
  final result = await someAsyncOperation();
  expect(result, isNotNull);
} catch (e) {
  fail('Erreur inattendue: $e');
}
```

### 4. **Tests unitaires complets**
```dart
group('NomDeLaClasse', () {
  group('Méthode ou propriété', () {
    test('devrait faire quelque chose quand condition', () {
      // Arrange
      final testObject = TestHelpers.createTestObject();
      
      // Act
      final result = testObject.someMethod();
      
      // Assert
      expect(result, equals(expectedValue));
    });
  });
});
```

### 5. **Documentation claire**
```dart
/// Tests unitaires pour la classe [NomDeLaClasse].
/// 
/// Ces tests vérifient le comportement de la classe,
/// incluant les cas de succès et d'échec.
void main() {
  // Tests...
}
```

## 🎯 Bonnes Pratiques

### Structure des Tests
1. **Arrange** : Préparer les données de test
2. **Act** : Exécuter l'action à tester
3. **Assert** : Vérifier le résultat

### Nommage des Tests
- Utiliser des descriptions claires en français
- Commencer par "devrait" pour les comportements attendus
- Inclure le contexte et la condition

### Gestion des Mocks
```dart
// Créer un mock
class MockAuthRepository extends Mock implements AuthRepository {}

// Configurer le mock
when(() => mockRepository.login(any(), any()))
    .thenAnswer((_) async => Right(testUser));

// Vérifier les appels
verify(() => mockRepository.login('email', 'password')).called(1);
```

### Tests d'Intégration
```dart
group('Intégration', () {
  test('devrait maintenir la cohérence des données', () async {
    // Test d'intégration entre plusieurs composants
  });
});
```

## 🔧 Configuration

### Dépendances de Test
Les tests utilisent les packages suivants :
- `flutter_test` : Framework de test Flutter
- `mocktail` : Création de mocks
- `bloc_test` : Tests pour les BLoCs
- `dartz` : Gestion des Either (Left/Right)

### Fichiers de Configuration
- `pubspec.yaml` : Dépendances de test
- `analysis_options.yaml` : Règles d'analyse du code

## 📈 Métriques de Qualité

### Couverture de Code
- **Objectif** : > 80% de couverture
- **Mesure** : `flutter test --coverage`
- **Rapport** : Généré dans `coverage/lcov.info`

### Qualité des Tests
- **Tests unitaires** : Un test par méthode publique
- **Tests d'intégration** : Un test par flux principal
- **Tests d'erreur** : Un test par type d'exception

## 🚨 Résolution de Problèmes

### Erreurs Communes
1. **Import manquant** : Vérifier les imports dans les fichiers de test
2. **Mock non configuré** : S'assurer que les mocks sont correctement configurés
3. **Test asynchrone** : Utiliser `await` pour les opérations asynchrones

### Debug des Tests
```bash
# Exécuter un test spécifique avec debug
flutter test test/unit/models/map_marker_test.dart --verbose

# Exécuter avec pause sur les erreurs
flutter test --reporter=expanded
```

## 📚 Ressources

- [Documentation Flutter Testing](https://docs.flutter.dev/testing)
- [Mocktail Documentation](https://pub.dev/packages/mocktail)
- [Dartz Documentation](https://pub.dev/packages/dartz)
- [Directives Dart Strictes](https://dart.dev/guides/language/effective-dart)

---

**Note** : Ces tests suivent les directives strictes pour le développement Dart et garantissent une couverture complète des fonctionnalités principales de l'application FoodSave.
