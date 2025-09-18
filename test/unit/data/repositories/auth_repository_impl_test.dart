import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:foodsave_app/data/repositories/auth_repository_impl.dart';
import 'package:foodsave_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:foodsave_app/domain/entities/user.dart';
import 'package:foodsave_app/core/error/exceptions.dart';
import 'package:foodsave_app/core/error/failures.dart';

/// Mock pour [AuthRemoteDataSource]
class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

/// Tests unitaires pour [AuthRepositoryImpl].
/// 
/// Ces tests vérifient le comportement de l'implémentation du repository d'authentification,
/// incluant la gestion des exceptions et la conversion en failures.
void main() {
  group('AuthRepositoryImpl', () {
    late AuthRepositoryImpl authRepositoryImpl;
    late MockAuthRemoteDataSource mockAuthRemoteDataSource;
    late User testUser;

    setUp(() {
      mockAuthRemoteDataSource = MockAuthRemoteDataSource();
      authRepositoryImpl = AuthRepositoryImpl(
        remoteDataSource: mockAuthRemoteDataSource,
      );

      testUser = User(
        id: 'user_1',
        name: 'Test User',
        email: 'test@example.com',
        userType: UserType.consumer,
        createdAt: DateTime.now(),
        token: 'test_token',
        refreshToken: 'test_refresh_token',
        isEmailVerified: true,
      );
    });

    group('login', () {
      test('devrait retourner un utilisateur quand la connexion réussit', () async {
        // Arrange
        when(() => mockAuthRemoteDataSource.login(
          'test@example.com',
          'password123',
        )).thenAnswer((_) async => testUser);

        // Act
        final Either<Failure, User> result = await authRepositoryImpl.login(
          'test@example.com',
          'password123',
        );

        // Assert
        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Ne devrait pas retourner une erreur'),
          (user) {
            expect(user, equals(testUser));
            expect(user.id, equals('user_1'));
            expect(user.email, equals('test@example.com'));
          },
        );

        verify(() => mockAuthRemoteDataSource.login(
          'test@example.com',
          'password123',
        )).called(1);
      });

      test('devrait retourner une AuthFailure quand AuthException est levée', () async {
        // Arrange
        const AuthException authException = AuthException('Identifiants incorrects');
        when(() => mockAuthRemoteDataSource.login(
          'test@example.com',
          'wrongpassword',
        )).thenThrow(authException);

        // Act
        final Either<Failure, User> result = await authRepositoryImpl.login(
          'test@example.com',
          'wrongpassword',
        );

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, equals('Identifiants incorrects'));
          },
          (user) => fail('Ne devrait pas retourner un utilisateur'),
        );

        verify(() => mockAuthRemoteDataSource.login(
          'test@example.com',
          'wrongpassword',
        )).called(1);
      });

      test('devrait retourner une ServerFailure quand ServerException est levée', () async {
        // Arrange
        const ServerException serverException = ServerException('Erreur serveur');
        when(() => mockAuthRemoteDataSource.login(
          'test@example.com',
          'password123',
        )).thenThrow(serverException);

        // Act
        final Either<Failure, User> result = await authRepositoryImpl.login(
          'test@example.com',
          'password123',
        );

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, equals('Erreur serveur'));
          },
          (user) => fail('Ne devrait pas retourner un utilisateur'),
        );

        verify(() => mockAuthRemoteDataSource.login(
          'test@example.com',
          'password123',
        )).called(1);
      });

      test('devrait retourner une NetworkFailure quand NetworkException est levée', () async {
        // Arrange
        const NetworkException networkException = NetworkException('Pas de connexion');
        when(() => mockAuthRemoteDataSource.login(
          'test@example.com',
          'password123',
        )).thenThrow(networkException);

        // Act
        final Either<Failure, User> result = await authRepositoryImpl.login(
          'test@example.com',
          'password123',
        );

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) {
            expect(failure, isA<NetworkFailure>());
            expect(failure.message, equals('Pas de connexion'));
          },
          (user) => fail('Ne devrait pas retourner un utilisateur'),
        );

        verify(() => mockAuthRemoteDataSource.login(
          'test@example.com',
          'password123',
        )).called(1);
      });

      test('devrait retourner une UnknownFailure pour les autres exceptions', () async {
        // Arrange
        when(() => mockAuthRemoteDataSource.login(
          'test@example.com',
          'password123',
        )).thenThrow(Exception('Erreur inconnue'));

        // Act
        final Either<Failure, User> result = await authRepositoryImpl.login(
          'test@example.com',
          'password123',
        );

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, contains('Erreur inconnue lors de la connexion'));
          },
          (user) => fail('Ne devrait pas retourner un utilisateur'),
        );

        verify(() => mockAuthRemoteDataSource.login(
          'test@example.com',
          'password123',
        )).called(1);
      });
    });

    group('register', () {
      test('devrait retourner un utilisateur quand l\'inscription réussit', () async {
        // Arrange
        when(() => mockAuthRemoteDataSource.register(
          'newuser@example.com',
          'password123',
          'New User',
        )).thenAnswer((_) async => testUser);

        // Act
        final Either<Failure, User> result = await authRepositoryImpl.register(
          'newuser@example.com',
          'password123',
          'New User',
          UserType.consumer,
        );

        // Assert
        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Ne devrait pas retourner une erreur'),
          (user) {
            expect(user, equals(testUser));
            expect(user.email, equals('test@example.com'));
          },
        );

        verify(() => mockAuthRemoteDataSource.register(
          'newuser@example.com',
          'password123',
          'New User',
        )).called(1);
      });

      test('devrait retourner une AuthFailure quand AuthException est levée', () async {
        // Arrange
        const AuthException authException = AuthException('Email déjà utilisé');
        when(() => mockAuthRemoteDataSource.register(
          'existing@example.com',
          'password123',
          'Existing User',
        )).thenThrow(authException);

        // Act
        final Either<Failure, User> result = await authRepositoryImpl.register(
          'existing@example.com',
          'password123',
          'Existing User',
          UserType.consumer,
        );

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, equals('Email déjà utilisé'));
          },
          (user) => fail('Ne devrait pas retourner un utilisateur'),
        );

        verify(() => mockAuthRemoteDataSource.register(
          'existing@example.com',
          'password123',
          'Existing User',
        )).called(1);
      });

      test('devrait retourner une UnknownFailure pour les autres exceptions', () async {
        // Arrange
        when(() => mockAuthRemoteDataSource.register(
          'test@example.com',
          'password123',
          'Test User',
        )).thenThrow(Exception('Erreur inconnue'));

        // Act
        final Either<Failure, User> result = await authRepositoryImpl.register(
          'test@example.com',
          'password123',
          'Test User',
          UserType.consumer,
        );

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, contains('Erreur inconnue lors de l\'inscription'));
          },
          (user) => fail('Ne devrait pas retourner un utilisateur'),
        );

        verify(() => mockAuthRemoteDataSource.register(
          'test@example.com',
          'password123',
          'Test User',
        )).called(1);
      });
    });

    group('logout', () {
      test('devrait retourner Right(null) quand la déconnexion réussit', () async {
        // Arrange
        when(() => mockAuthRemoteDataSource.logout()).thenAnswer((_) async {});

        // Act
        final Either<Failure, void> result = await authRepositoryImpl.logout();

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Ne devrait pas retourner une erreur'),
          (_) => expect(true, isTrue),
        );

        verify(() => mockAuthRemoteDataSource.logout()).called(1);
      });

      test('devrait retourner une AuthFailure quand AuthException est levée', () async {
        // Arrange
        const AuthException authException = AuthException('Token invalide');
        when(() => mockAuthRemoteDataSource.logout()).thenThrow(authException);

        // Act
        final Either<Failure, void> result = await authRepositoryImpl.logout();

        // Assert
        expect(result, isA<Left<Failure, void>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, equals('Token invalide'));
          },
          (_) => fail('Ne devrait pas retourner un succès'),
        );

        verify(() => mockAuthRemoteDataSource.logout()).called(1);
      });

      test('devrait retourner une UnknownFailure pour les autres exceptions', () async {
        // Arrange
        when(() => mockAuthRemoteDataSource.logout()).thenThrow(Exception('Erreur inconnue'));

        // Act
        final Either<Failure, void> result = await authRepositoryImpl.logout();

        // Assert
        expect(result, isA<Left<Failure, void>>());
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, contains('Erreur inconnue lors de la déconnexion'));
          },
          (_) => fail('Ne devrait pas retourner un succès'),
        );

        verify(() => mockAuthRemoteDataSource.logout()).called(1);
      });
    });

    group('refreshToken', () {
      test('devrait retourner un utilisateur quand le rafraîchissement réussit', () async {
        // Arrange
        when(() => mockAuthRemoteDataSource.refreshToken('refresh_token'))
            .thenAnswer((_) async => testUser);

        // Act
        final Either<Failure, User> result = await authRepositoryImpl.refreshToken('refresh_token');

        // Assert
        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Ne devrait pas retourner une erreur'),
          (user) {
            expect(user, equals(testUser));
            expect(user.token, equals('test_token'));
          },
        );

        verify(() => mockAuthRemoteDataSource.refreshToken('refresh_token')).called(1);
      });

      test('devrait retourner une AuthFailure quand AuthException est levée', () async {
        // Arrange
        const AuthException authException = AuthException('Token expiré');
        when(() => mockAuthRemoteDataSource.refreshToken('invalid_token'))
            .thenThrow(authException);

        // Act
        final Either<Failure, User> result = await authRepositoryImpl.refreshToken('invalid_token');

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, equals('Token expiré'));
          },
          (user) => fail('Ne devrait pas retourner un utilisateur'),
        );

        verify(() => mockAuthRemoteDataSource.refreshToken('invalid_token')).called(1);
      });
    });

    group('forgotPassword', () {
      test('devrait retourner Right(null) quand la réinitialisation réussit', () async {
        // Arrange
        when(() => mockAuthRemoteDataSource.forgotPassword('test@example.com'))
            .thenAnswer((_) async {});

        // Act
        final Either<Failure, void> result = await authRepositoryImpl.forgotPassword('test@example.com');

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Ne devrait pas retourner une erreur'),
          (_) => expect(true, isTrue),
        );

        verify(() => mockAuthRemoteDataSource.forgotPassword('test@example.com')).called(1);
      });

      test('devrait retourner une AuthFailure quand AuthException est levée', () async {
        // Arrange
        const AuthException authException = AuthException('Email introuvable');
        when(() => mockAuthRemoteDataSource.forgotPassword('nonexistent@example.com'))
            .thenThrow(authException);

        // Act
        final Either<Failure, void> result = await authRepositoryImpl.forgotPassword('nonexistent@example.com');

        // Assert
        expect(result, isA<Left<Failure, void>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, equals('Email introuvable'));
          },
          (_) => fail('Ne devrait pas retourner un succès'),
        );

        verify(() => mockAuthRemoteDataSource.forgotPassword('nonexistent@example.com')).called(1);
      });
    });

    group('verifyEmail', () {
      test('devrait retourner Right(null) quand la vérification réussit', () async {
        // Arrange
        when(() => mockAuthRemoteDataSource.verifyEmail('verification_token'))
            .thenAnswer((_) async {});

        // Act
        final Either<Failure, void> result = await authRepositoryImpl.verifyEmail('verification_token');

        // Assert
        expect(result, isA<Right<Failure, void>>());
        result.fold(
          (failure) => fail('Ne devrait pas retourner une erreur'),
          (_) => expect(true, isTrue),
        );

        verify(() => mockAuthRemoteDataSource.verifyEmail('verification_token')).called(1);
      });

      test('devrait retourner une AuthFailure quand AuthException est levée', () async {
        // Arrange
        const AuthException authException = AuthException('Token de vérification invalide');
        when(() => mockAuthRemoteDataSource.verifyEmail('invalid_token'))
            .thenThrow(authException);

        // Act
        final Either<Failure, void> result = await authRepositoryImpl.verifyEmail('invalid_token');

        // Assert
        expect(result, isA<Left<Failure, void>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, equals('Token de vérification invalide'));
          },
          (_) => fail('Ne devrait pas retourner un succès'),
        );

        verify(() => mockAuthRemoteDataSource.verifyEmail('invalid_token')).called(1);
      });
    });

    group('getCurrentUser', () {
      test('devrait retourner un utilisateur quand la récupération réussit', () async {
        // Arrange
        when(() => mockAuthRemoteDataSource.getCurrentUser())
            .thenAnswer((_) async => testUser);

        // Act
        final Either<Failure, User> result = await authRepositoryImpl.getCurrentUser();

        // Assert
        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Ne devrait pas retourner une erreur'),
          (user) {
            expect(user, equals(testUser));
            expect(user.id, equals('user_1'));
          },
        );

        verify(() => mockAuthRemoteDataSource.getCurrentUser()).called(1);
      });

      test('devrait retourner une AuthFailure quand AuthException est levée', () async {
        // Arrange
        const AuthException authException = AuthException('Utilisateur non authentifié');
        when(() => mockAuthRemoteDataSource.getCurrentUser())
            .thenThrow(authException);

        // Act
        final Either<Failure, User> result = await authRepositoryImpl.getCurrentUser();

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, equals('Utilisateur non authentifié'));
          },
          (user) => fail('Ne devrait pas retourner un utilisateur'),
        );

        verify(() => mockAuthRemoteDataSource.getCurrentUser()).called(1);
      });

      test('devrait retourner une UnknownFailure pour les autres exceptions', () async {
        // Arrange
        when(() => mockAuthRemoteDataSource.getCurrentUser())
            .thenThrow(Exception('Erreur inconnue'));

        // Act
        final Either<Failure, User> result = await authRepositoryImpl.getCurrentUser();

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) {
            expect(failure, isA<UnknownFailure>());
            expect(failure.message, contains('Erreur inconnue lors de la récupération de l\'utilisateur'));
          },
          (user) => fail('Ne devrait pas retourner un utilisateur'),
        );

        verify(() => mockAuthRemoteDataSource.getCurrentUser()).called(1);
      });
    });

    group('Intégration', () {
      test('devrait maintenir la cohérence des données utilisateur', () async {
        // Arrange
        final User userWithCompleteData = User(
          id: 'complete_user',
          name: 'Complete User',
          email: 'complete@example.com',
          userType: UserType.merchant,
          createdAt: DateTime.now(),
          phone: '+33123456789',
          avatar: 'https://example.com/avatar.jpg',
          address: '123 Test Street',
          token: 'complete_token',
          refreshToken: 'complete_refresh_token',
          isEmailVerified: true,
        );

        when(() => mockAuthRemoteDataSource.login(
          'complete@example.com',
          'password123',
        )).thenAnswer((_) async => userWithCompleteData);

        // Act
        final Either<Failure, User> result = await authRepositoryImpl.login(
          'complete@example.com',
          'password123',
        );

        // Assert
        result.fold(
          (failure) => fail('Ne devrait pas retourner une erreur'),
          (user) {
            expect(user.id, equals('complete_user'));
            expect(user.name, equals('Complete User'));
            expect(user.email, equals('complete@example.com'));
            expect(user.userType, equals(UserType.merchant));
            expect(user.phone, equals('+33123456789'));
            expect(user.avatar, equals('https://example.com/avatar.jpg'));
            expect(user.address, equals('123 Test Street'));
            expect(user.token, equals('complete_token'));
            expect(user.refreshToken, equals('complete_refresh_token'));
            expect(user.isEmailVerified, equals(true));
          },
        );
      });
    });
  });
}
