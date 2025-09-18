import 'package:flutter_test/flutter_test.dart';
import 'package:foodsave_app/domain/entities/user.dart';

/// Tests unitaires pour la classe [User] et ses classes associées.
/// 
/// Ces tests vérifient le comportement des entités utilisateur,
/// incluant les préférences et statistiques.
void main() {
  group('User', () {
    late User testUser;
    late UserPreferences testPreferences;
    late UserStatistics testStatistics;
    late DateTime now;

    setUp(() {
      now = DateTime.now();
      testPreferences = const UserPreferences(
        dietary: ['vegetarian', 'bio'],
        allergens: ['gluten', 'nuts'],
        notifications: true,
      );
      testStatistics = const UserStatistics(
        basketsSaved: 15,
        moneySaved: 125.50,
        co2Saved: 8.75,
      );
      testUser = User(
        id: 'user_1',
        name: 'Test User',
        email: 'test@example.com',
        userType: UserType.consumer,
        createdAt: now,
        phone: '+33123456789',
        avatar: 'https://example.com/avatar.jpg',
        address: '123 Test Street, Paris',
        preferences: testPreferences,
        statistics: testStatistics,
        token: 'test_token',
        refreshToken: 'test_refresh_token',
        isEmailVerified: true,
      );
    });

    group('Constructeur', () {
      test('devrait créer un utilisateur avec tous les paramètres requis', () {
        expect(testUser.id, equals('user_1'));
        expect(testUser.name, equals('Test User'));
        expect(testUser.email, equals('test@example.com'));
        expect(testUser.userType, equals(UserType.consumer));
        expect(testUser.createdAt, equals(now));
        expect(testUser.phone, equals('+33123456789'));
        expect(testUser.avatar, equals('https://example.com/avatar.jpg'));
        expect(testUser.address, equals('123 Test Street, Paris'));
        expect(testUser.preferences, equals(testPreferences));
        expect(testUser.statistics, equals(testStatistics));
        expect(testUser.token, equals('test_token'));
        expect(testUser.refreshToken, equals('test_refresh_token'));
        expect(testUser.isEmailVerified, equals(true));
      });

      test('devrait créer un utilisateur avec des paramètres optionnels par défaut', () {
        final User minimalUser = User(
          id: 'minimal_user',
          name: 'Minimal User',
          email: 'minimal@example.com',
          userType: UserType.guest,
          createdAt: DateTime.now(),
        );

        expect(minimalUser.phone, isNull);
        expect(minimalUser.avatar, isNull);
        expect(minimalUser.address, isNull);
        expect(minimalUser.preferences, isNull);
        expect(minimalUser.statistics, isNull);
        expect(minimalUser.token, isNull);
        expect(minimalUser.refreshToken, isNull);
        expect(minimalUser.isEmailVerified, equals(false));
      });
    });

    group('copyWith', () {
      test('devrait créer une copie avec des valeurs modifiées', () {
        final User updatedUser = testUser.copyWith(
          name: 'Updated Name',
          email: 'updated@example.com',
          isEmailVerified: false,
        );

        expect(updatedUser.id, equals(testUser.id));
        expect(updatedUser.name, equals('Updated Name'));
        expect(updatedUser.email, equals('updated@example.com'));
        expect(updatedUser.isEmailVerified, equals(false));
        expect(updatedUser.userType, equals(testUser.userType));
        expect(updatedUser.phone, equals(testUser.phone));
      });

      test('devrait conserver les valeurs originales si aucun paramètre n\'est fourni', () {
        final User copiedUser = testUser.copyWith();

        expect(copiedUser.id, equals(testUser.id));
        expect(copiedUser.name, equals(testUser.name));
        expect(copiedUser.email, equals(testUser.email));
        expect(copiedUser.userType, equals(testUser.userType));
        expect(copiedUser.createdAt, equals(testUser.createdAt));
        expect(copiedUser.preferences, equals(testUser.preferences));
        expect(copiedUser.statistics, equals(testUser.statistics));
      });
    });

    group('Égalité', () {
      test('devrait être égal à un autre utilisateur avec les mêmes propriétés', () {
        final User identicalUser = User(
          id: 'user_1',
          name: 'Test User',
          email: 'test@example.com',
          userType: UserType.consumer,
          createdAt: now,
          phone: '+33123456789',
          avatar: 'https://example.com/avatar.jpg',
          address: '123 Test Street, Paris',
          preferences: testPreferences,
          statistics: testStatistics,
          token: 'test_token',
          refreshToken: 'test_refresh_token',
          isEmailVerified: true,
        );

        expect(testUser, equals(identicalUser));
      });

      test('ne devrait pas être égal à un utilisateur avec des propriétés différentes', () {
        final User differentUser = testUser.copyWith(id: 'different_id');

        expect(testUser, isNot(equals(differentUser)));
      });
    });

    group('toString', () {
      test('devrait retourner une représentation string appropriée', () {
        final String userString = testUser.toString();

        expect(userString, contains('User'));
        expect(userString, contains('user_1'));
        expect(userString, contains('Test User'));
        expect(userString, contains('test@example.com'));
        expect(userString, contains('consumer'));
      });
    });
  });

  group('UserPreferences', () {
    late UserPreferences testPreferences;

    setUp(() {
      testPreferences = const UserPreferences(
        dietary: ['vegetarian', 'bio', 'local'],
        allergens: ['gluten', 'nuts', 'dairy'],
        notifications: true,
      );
    });

    group('Constructeur', () {
      test('devrait créer des préférences avec tous les paramètres', () {
        expect(testPreferences.dietary, equals(['vegetarian', 'bio', 'local']));
        expect(testPreferences.allergens, equals(['gluten', 'nuts', 'dairy']));
        expect(testPreferences.notifications, equals(true));
      });
    });

    group('copyWith', () {
      test('devrait créer une copie avec des valeurs modifiées', () {
        final UserPreferences updatedPreferences = testPreferences.copyWith(
          dietary: ['vegan'],
          notifications: false,
        );

        expect(updatedPreferences.dietary, equals(['vegan']));
        expect(updatedPreferences.allergens, equals(testPreferences.allergens));
        expect(updatedPreferences.notifications, equals(false));
      });

      test('devrait conserver les valeurs originales si aucun paramètre n\'est fourni', () {
        final UserPreferences copiedPreferences = testPreferences.copyWith();

        expect(copiedPreferences.dietary, equals(testPreferences.dietary));
        expect(copiedPreferences.allergens, equals(testPreferences.allergens));
        expect(copiedPreferences.notifications, equals(testPreferences.notifications));
      });
    });

    group('Égalité', () {
      test('devrait être égal à des préférences identiques', () {
        const UserPreferences identicalPreferences = UserPreferences(
          dietary: ['vegetarian', 'bio', 'local'],
          allergens: ['gluten', 'nuts', 'dairy'],
          notifications: true,
        );

        expect(testPreferences, equals(identicalPreferences));
      });

      test('ne devrait pas être égal à des préférences différentes', () {
        const UserPreferences differentPreferences = UserPreferences(
          dietary: ['vegan'],
          allergens: ['gluten', 'nuts', 'dairy'],
          notifications: true,
        );

        expect(testPreferences, isNot(equals(differentPreferences)));
      });
    });
  });

  group('UserStatistics', () {
    late UserStatistics testStatistics;

    setUp(() {
      testStatistics = const UserStatistics(
        basketsSaved: 25,
        moneySaved: 250.75,
        co2Saved: 15.5,
      );
    });

    group('Constructeur', () {
      test('devrait créer des statistiques avec tous les paramètres', () {
        expect(testStatistics.basketsSaved, equals(25));
        expect(testStatistics.moneySaved, equals(250.75));
        expect(testStatistics.co2Saved, equals(15.5));
      });
    });

    group('copyWith', () {
      test('devrait créer une copie avec des valeurs modifiées', () {
        final UserStatistics updatedStatistics = testStatistics.copyWith(
          basketsSaved: 30,
          moneySaved: 300.0,
        );

        expect(updatedStatistics.basketsSaved, equals(30));
        expect(updatedStatistics.moneySaved, equals(300.0));
        expect(updatedStatistics.co2Saved, equals(testStatistics.co2Saved));
      });

      test('devrait conserver les valeurs originales si aucun paramètre n\'est fourni', () {
        final UserStatistics copiedStatistics = testStatistics.copyWith();

        expect(copiedStatistics.basketsSaved, equals(testStatistics.basketsSaved));
        expect(copiedStatistics.moneySaved, equals(testStatistics.moneySaved));
        expect(copiedStatistics.co2Saved, equals(testStatistics.co2Saved));
      });
    });

    group('Égalité', () {
      test('devrait être égal à des statistiques identiques', () {
        const UserStatistics identicalStatistics = UserStatistics(
          basketsSaved: 25,
          moneySaved: 250.75,
          co2Saved: 15.5,
        );

        expect(testStatistics, equals(identicalStatistics));
      });

      test('ne devrait pas être égal à des statistiques différentes', () {
        const UserStatistics differentStatistics = UserStatistics(
          basketsSaved: 30,
          moneySaved: 250.75,
          co2Saved: 15.5,
        );

        expect(testStatistics, isNot(equals(differentStatistics)));
      });
    });
  });

  group('UserType', () {
    test('devrait avoir tous les types d\'utilisateur attendus', () {
      expect(UserType.values, contains(UserType.consumer));
      expect(UserType.values, contains(UserType.merchant));
      expect(UserType.values, contains(UserType.guest));
    });
  });
}
