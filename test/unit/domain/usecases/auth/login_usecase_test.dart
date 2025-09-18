import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:foodsave_app/domain/usecases/auth/login_usecase.dart';
import 'package:foodsave_app/domain/entities/user.dart';
import 'package:foodsave_app/domain/repositories/auth_repository.dart';
import 'package:foodsave_app/core/error/failures.dart';

/// Mock pour [AuthRepository]
class MockAuthRepository extends Mock implements AuthRepository {}

/// Tests unitaires pour [LoginUseCase].
/// 
/// Ces tests vérifient le comportement du cas d'usage de connexion,
/// incluant les cas de succès et d'échec.
void main() {
  group('LoginUseCase', () {
    late LoginUseCase loginUseCase;
    late MockAuthRepository mockAuthRepository;
    late User testUser;
    late LoginParams testParams;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      loginUseCase = LoginUseCase(mockAuthRepository);
      
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

      testParams = const LoginParams(
        email: 'test@example.com',
        password: 'password123',
      );
    });

    group('call', () {
      test('devrait retourner un utilisateur quand la connexion réussit', () async {
        // Arrange
        when(() => mockAuthRepository.login(
          testParams.email,
          testParams.password,
        )).thenAnswer((_) async => Right(testUser));

        // Act
        final Either<Failure, User> result = await loginUseCase.call(testParams);

        // Assert
        expect(result, isA<Right<Failure, User>>());
        result.fold(
          (failure) => fail('Ne devrait pas retourner une erreur'),
          (user) {
            expect(user, equals(testUser));
            expect(user.id, equals('user_1'));
            expect(user.email, equals('test@example.com'));
            expect(user.token, equals('test_token'));
          },
        );

        verify(() => mockAuthRepository.login(
          testParams.email,
          testParams.password,
        )).called(1);
      });

      test('devrait retourner une AuthFailure quand les identifiants sont incorrects', () async {
        // Arrange
        const AuthFailure authFailure = AuthFailure(message: 'Identifiants incorrects');
        when(() => mockAuthRepository.login(
          testParams.email,
          testParams.password,
        )).thenAnswer((_) async => const Left(authFailure));

        // Act
        final Either<Failure, User> result = await loginUseCase.call(testParams);

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, equals('Identifiants incorrects'));
          },
          (user) => fail('Ne devrait pas retourner un utilisateur'),
        );

        verify(() => mockAuthRepository.login(
          testParams.email,
          testParams.password,
        )).called(1);
      });

      test('devrait retourner une ServerFailure quand le serveur est indisponible', () async {
        // Arrange
        const ServerFailure serverFailure = ServerFailure(message: 'Serveur indisponible');
        when(() => mockAuthRepository.login(
          testParams.email,
          testParams.password,
        )).thenAnswer((_) async => const Left(serverFailure));

        // Act
        final Either<Failure, User> result = await loginUseCase.call(testParams);

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) {
            expect(failure, isA<ServerFailure>());
            expect(failure.message, equals('Serveur indisponible'));
          },
          (user) => fail('Ne devrait pas retourner un utilisateur'),
        );

        verify(() => mockAuthRepository.login(
          testParams.email,
          testParams.password,
        )).called(1);
      });

      test('devrait retourner une NetworkFailure quand il n\'y a pas de connexion', () async {
        // Arrange
        const NetworkFailure networkFailure = NetworkFailure(message: 'Pas de connexion internet');
        when(() => mockAuthRepository.login(
          testParams.email,
          testParams.password,
        )).thenAnswer((_) async => const Left(networkFailure));

        // Act
        final Either<Failure, User> result = await loginUseCase.call(testParams);

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) {
            expect(failure, isA<NetworkFailure>());
            expect(failure.message, equals('Pas de connexion internet'));
          },
          (user) => fail('Ne devrait pas retourner un utilisateur'),
        );

        verify(() => mockAuthRepository.login(
          testParams.email,
          testParams.password,
        )).called(1);
      });

      test('devrait appeler le repository avec les bons paramètres', () async {
        // Arrange
        when(() => mockAuthRepository.login(
          testParams.email,
          testParams.password,
        )).thenAnswer((_) async => Right(testUser));

        // Act
        await loginUseCase.call(testParams);

        // Assert
        verify(() => mockAuthRepository.login(
          'test@example.com',
          'password123',
        )).called(1);
      });

      test('devrait gérer les paramètres avec des espaces', () async {
        // Arrange
        const LoginParams paramsWithSpaces = LoginParams(
          email: '  test@example.com  ',
          password: '  password123  ',
        );

        when(() => mockAuthRepository.login(
          paramsWithSpaces.email,
          paramsWithSpaces.password,
        )).thenAnswer((_) async => Right(testUser));

        // Act
        final Either<Failure, User> result = await loginUseCase.call(paramsWithSpaces);

        // Assert
        expect(result, isA<Right<Failure, User>>());
        verify(() => mockAuthRepository.login(
          '  test@example.com  ',
          '  password123  ',
        )).called(1);
      });

      test('devrait gérer les paramètres vides', () async {
        // Arrange
        const LoginParams emptyParams = LoginParams(
          email: '',
          password: '',
        );

        const AuthFailure authFailure = AuthFailure(message: 'Email et mot de passe requis');
        when(() => mockAuthRepository.login(
          emptyParams.email,
          emptyParams.password,
        )).thenAnswer((_) async => const Left(authFailure));

        // Act
        final Either<Failure, User> result = await loginUseCase.call(emptyParams);

        // Assert
        expect(result, isA<Left<Failure, User>>());
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, equals('Email et mot de passe requis'));
          },
          (user) => fail('Ne devrait pas retourner un utilisateur'),
        );
      });
    });

    group('LoginParams', () {
      test('devrait créer des paramètres avec les valeurs fournies', () {
        const LoginParams params = LoginParams(
          email: 'user@example.com',
          password: 'secretpassword',
        );

        expect(params.email, equals('user@example.com'));
        expect(params.password, equals('secretpassword'));
      });

      test('devrait être const', () {
        const LoginParams params1 = LoginParams(
          email: 'test@example.com',
          password: 'password',
        );
        const LoginParams params2 = LoginParams(
          email: 'test@example.com',
          password: 'password',
        );

        expect(params1.email, equals(params2.email));
        expect(params1.password, equals(params2.password));
      });
    });

    group('Intégration', () {
      test('devrait maintenir la cohérence des données utilisateur', () async {
        // Arrange
        final User userWithCompleteData = User(
          id: 'user_complete',
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

        when(() => mockAuthRepository.login(
          testParams.email,
          testParams.password,
        )).thenAnswer((_) async => Right(userWithCompleteData));

        // Act
        final Either<Failure, User> result = await loginUseCase.call(testParams);

        // Assert
        result.fold(
          (failure) => fail('Ne devrait pas retourner une erreur'),
          (user) {
            expect(user.id, equals('user_complete'));
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

      test('devrait gérer les erreurs de validation côté repository', () async {
        // Arrange
        const AuthFailure validationFailure = AuthFailure(
          message: 'Format d\'email invalide',
        );
        when(() => mockAuthRepository.login(
          testParams.email,
          testParams.password,
        )).thenAnswer((_) async => const Left(validationFailure));

        // Act
        final Either<Failure, User> result = await loginUseCase.call(testParams);

        // Assert
        result.fold(
          (failure) {
            expect(failure, isA<AuthFailure>());
            expect(failure.message, equals('Format d\'email invalide'));
          },
          (user) => fail('Ne devrait pas retourner un utilisateur'),
        );
      });
    });
  });
}
