import 'dart:async';
import '../../../domain/entities/user.dart';
import '../../../core/error/exceptions.dart';
import 'auth_remote_data_source.dart';

/// Implémentation mock de [AuthRemoteDataSource] pour les tests et le développement.
///
/// Simule les appels API d'authentification avec des données statiques.
/// Utilisée pendant le développement quand l'API n'est pas encore disponible.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Simuler une base de données d'utilisateurs en mémoire
  static final List<Map<String, dynamic>> _mockUsers = [
    {
      'id': '1',
      'name': 'Jean Dupont',
      'email': 'jean.dupont@email.com',
      'password': 'password123',
      'phone': '+33123456789',
      'avatar': 'https://ui-avatars.com/api/?name=Jean+Dupont&size=150',
      'address': '123 Rue de la Paix, Paris',
      'preferences': {
        'dietary': ['bio', 'local'],
        'allergens': ['gluten'],
        'notifications': true,
      },
      'statistics': {
        'basketsSaved': 12,
        'moneySaved': 89.50,
        'co2Saved': 15.2,
      },
      'token': 'mock_token_user1',
      'refreshToken': 'mock_refresh_token_user1',
      'isEmailVerified': true,
    },
    {
      'id': '2',
      'name': 'Marie Martin',
      'email': 'marie.martin@email.com',
      'password': 'password456',
      'phone': '+33987654321',
      'avatar': 'https://ui-avatars.com/api/?name=Marie+Martin&size=150',
      'address': '456 Avenue des Champs, Lyon',
      'preferences': {
        'dietary': ['vegetarian', 'bio'],
        'allergens': ['nuts'],
        'notifications': true,
      },
      'statistics': {
        'basketsSaved': 25,
        'moneySaved': 156.80,
        'co2Saved': 28.5,
      },
      'token': 'mock_token_user2',
      'refreshToken': 'mock_refresh_token_user2',
      'isEmailVerified': true,
    },
    {
      'id': '3',
      'name': 'Pierre Lemoine',
      'email': 'test@test.com',
      'password': 'test',
      'phone': '+33555666777',
      'avatar': 'https://ui-avatars.com/api/?name=Pierre+Lemoine&size=150',
      'address': '789 Boulevard du Test, Marseille',
      'preferences': {
        'dietary': ['local'],
        'allergens': [],
        'notifications': false,
      },
      'statistics': {
        'basketsSaved': 3,
        'moneySaved': 24.90,
        'co2Saved': 4.1,
      },
      'token': 'mock_token_user3',
      'refreshToken': 'mock_refresh_token_user3',
      'isEmailVerified': true,
    },
  ];

  // Stockage temporaire du token de l'utilisateur connecté
  String? _currentToken;

  /// Crée un utilisateur à partir des données mockées.
  User _createUserFromMap(Map<String, dynamic> userMap) {
    return User(
      id: userMap['id'] as String,
      name: userMap['name'] as String,
      email: userMap['email'] as String,
      userType: UserType.consumer, // Valeur par défaut
      createdAt: DateTime.now(), // Valeur par défaut pour la démo
      phone: userMap['phone'] as String,
      avatar: userMap['avatar'] as String,
      address: userMap['address'] as String,
      preferences: UserPreferences(
        dietary: List<String>.from(userMap['preferences']['dietary'] as List),
        allergens: List<String>.from(userMap['preferences']['allergens'] as List),
        notifications: userMap['preferences']['notifications'] as bool,
      ),
      statistics: UserStatistics(
        basketsSaved: userMap['statistics']['basketsSaved'] as int,
        moneySaved: userMap['statistics']['moneySaved'] as double,
        co2Saved: userMap['statistics']['co2Saved'] as double,
      ),
      token: userMap['token'] as String,
      refreshToken: userMap['refreshToken'] as String,
      isEmailVerified: userMap['isEmailVerified'] as bool,
    );
  }

  @override
  Future<User> login(String email, String password) async {
    // Simuler la latence réseau
    await Future.delayed(const Duration(milliseconds: 800));

    // Rechercher l'utilisateur par email et mot de passe
    final userMap = _mockUsers.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => throw const AuthException('Email ou mot de passe incorrect'),
    );

    _currentToken = userMap['token'] as String;

    return _createUserFromMap(userMap);
  }

  @override
  Future<User> register(String email, String password, String name) async {
    // Simuler la latence réseau
    await Future.delayed(const Duration(milliseconds: 1000));

    // Vérifier si l'email existe déjà
    final existingUser = _mockUsers.any((user) => user['email'] == email);
    if (existingUser) {
      throw const AuthException('Un compte avec cet email existe déjà');
    }

    // Créer un nouvel utilisateur
    final newUserId = (_mockUsers.length + 1).toString();
    final newUser = {
      'id': newUserId,
      'name': name,
      'email': email,
      'password': password,
      'phone': '',
      'avatar': 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&size=150',
      'address': '',
      'preferences': {
        'dietary': <String>[],
        'allergens': <String>[],
        'notifications': true,
      },
      'statistics': {
        'basketsSaved': 0,
        'moneySaved': 0.0,
        'co2Saved': 0.0,
      },
      'token': 'mock_token_user$newUserId',
      'refreshToken': 'mock_refresh_token_user$newUserId',
      'isEmailVerified': false,
    };

    _mockUsers.add(newUser);
    _currentToken = newUser['token'] as String;

    return _createUserFromMap(newUser);
  }

  @override
  Future<void> logout() async {
    // Simuler la latence réseau
    await Future.delayed(const Duration(milliseconds: 300));
    
    _currentToken = null;
  }

  @override
  Future<User> refreshToken(String refreshToken) async {
    // Simuler la latence réseau
    await Future.delayed(const Duration(milliseconds: 500));

    // Rechercher l'utilisateur par refresh token
    final userMap = _mockUsers.firstWhere(
      (user) => user['refreshToken'] == refreshToken,
      orElse: () => throw const AuthException('Token de rafraîchissement invalide'),
    );

    // Générer un nouveau token (simulation)
    final newToken = '${userMap['token']}_refreshed_${DateTime.now().millisecondsSinceEpoch}';
    userMap['token'] = newToken;
    _currentToken = newToken;

    return _createUserFromMap(userMap);
  }

  @override
  Future<void> forgotPassword(String email) async {
    // Simuler la latence réseau
    await Future.delayed(const Duration(milliseconds: 700));

    // Vérifier si l'email existe
    final userExists = _mockUsers.any((user) => user['email'] == email);
    if (!userExists) {
      throw const AuthException('Aucun compte associé à cet email');
    }

    // En mode mock, on simule juste l'envoi réussi
    // Dans une vraie implémentation, on appellerait l'API
  }

  @override
  Future<void> verifyEmail(String token) async {
    // Simuler la latence réseau
    await Future.delayed(const Duration(milliseconds: 400));

    // En mode mock, on considère que la vérification réussit toujours
    // Dans une vraie implémentation, on vérifierait le token
  }

  @override
  Future<User> getCurrentUser() async {
    // Simuler la latence réseau
    await Future.delayed(const Duration(milliseconds: 300));

    if (_currentToken == null) {
      throw const AuthException('Aucun utilisateur connecté');
    }

    // Rechercher l'utilisateur par token
    final userMap = _mockUsers.firstWhere(
      (user) => user['token'] == _currentToken,
      orElse: () => throw const AuthException('Token invalide'),
    );

    return _createUserFromMap(userMap);
  }
}