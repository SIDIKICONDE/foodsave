import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../utils/constants.dart';

/// Service d'authentification pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
class AuthService {
  /// Instance de Dio pour les requêtes HTTP
  final Dio _dio;
  
  /// Instance SharedPreferences pour le stockage local
  final SharedPreferences _prefs;

  /// Constructeur du service d'authentification
  AuthService({
    required Dio dio,
    required SharedPreferences prefs,
  }) : _dio = dio, _prefs = prefs;

  /// Connecte un utilisateur avec email et mot de passe
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/signin',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final user = User.fromJson(data['user']);
        final token = data['token'] as String;

        await _saveToken(token);
        await _saveUser(user);

        return AuthResult.success(user: user, token: token);
      }

      return AuthResult.failure(
        error: response.data['message'] ?? 'Erreur de connexion'
      );
    } on DioException catch (e) {
      return AuthResult.failure(
        error: _handleDioError(e)
      );
    } catch (e) {
      return AuthResult.failure(
        error: AppConstants.unknownErrorMessage
      );
    }
  }

  /// Inscrit un nouvel utilisateur
  Future<AuthResult> signUp({
    required String email,
    required String password,
    required String username,
    required UserType userType,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/signup',
        data: {
          'email': email,
          'password': password,
          'username': username,
          'user_type': userType.name,
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (phoneNumber != null) 'phone_number': phoneNumber,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        final user = User.fromJson(data['user']);
        final token = data['token'] as String;

        await _saveToken(token);
        await _saveUser(user);

        return AuthResult.success(user: user, token: token);
      }

      return AuthResult.failure(
        error: response.data['message'] ?? 'Erreur lors de l\'inscription'
      );
    } on DioException catch (e) {
      return AuthResult.failure(
        error: _handleDioError(e)
      );
    } catch (e) {
      return AuthResult.failure(
        error: AppConstants.unknownErrorMessage
      );
    }
  }

  /// Vérification OTP
  Future<AuthResult> verifyOTP({
    required String email,
    required String otpCode,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/verify-otp',
        data: {
          'email': email,
          'otp_code': otpCode,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final user = User.fromJson(data['user']);
        
        // Mettre à jour l'utilisateur comme vérifié
        final updatedUser = user.copyWith(isVerified: true);
        await _saveUser(updatedUser);

        return AuthResult.success(
          user: updatedUser, 
          token: _getStoredToken() ?? ''
        );
      }

      return AuthResult.failure(
        error: response.data['message'] ?? 'Code OTP invalide'
      );
    } on DioException catch (e) {
      return AuthResult.failure(
        error: _handleDioError(e)
      );
    } catch (e) {
      return AuthResult.failure(
        error: AppConstants.unknownErrorMessage
      );
    }
  }

  /// Demande de réinitialisation de mot de passe
  Future<bool> requestPasswordReset(String email) async {
    try {
      final response = await _dio.post(
        '/auth/request-password-reset',
        data: {'email': email},
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Déconnexion de l'utilisateur
  Future<void> signOut() async {
    try {
      final token = _getStoredToken();
      if (token != null) {
        await _dio.post(
          '/auth/signout',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
        );
      }
    } catch (e) {
      // Ignorer les erreurs de déconnexion côté serveur
    } finally {
      await _clearLocalData();
    }
  }

  /// Vérifie si l'utilisateur est connecté
  bool isSignedIn() {
    return _getStoredToken() != null && _getStoredUser() != null;
  }

  /// Récupère l'utilisateur stocké localement
  User? getCurrentUser() {
    return _getStoredUser();
  }

  /// Récupère le token d'authentification
  String? getAuthToken() {
    return _getStoredToken();
  }

  /// Met à jour les informations de l'utilisateur
  Future<AuthResult> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? address,
    String? city,
    String? postalCode,
  }) async {
    try {
      final token = _getStoredToken();
      if (token == null) {
        return AuthResult.failure(error: 'Non authentifié');
      }

      final response = await _dio.put(
        '/auth/profile',
        data: {
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (phoneNumber != null) 'phone_number': phoneNumber,
          if (address != null) 'address': address,
          if (city != null) 'city': city,
          if (postalCode != null) 'postal_code': postalCode,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final user = User.fromJson(response.data['user']);
        await _saveUser(user);
        
        return AuthResult.success(user: user, token: token);
      }

      return AuthResult.failure(
        error: response.data['message'] ?? 'Erreur de mise à jour'
      );
    } on DioException catch (e) {
      return AuthResult.failure(error: _handleDioError(e));
    } catch (e) {
      return AuthResult.failure(error: AppConstants.unknownErrorMessage);
    }
  }

  /// Sauvegarde le token localement
  Future<void> _saveToken(String token) async {
    await _prefs.setString(AppConstants.userTokenKey, token);
  }

  /// Sauvegarde l'utilisateur localement
  Future<void> _saveUser(User user) async {
    await _prefs.setString(AppConstants.userDataKey, user.toJson().toString());
  }

  /// Récupère le token stocké
  String? _getStoredToken() {
    return _prefs.getString(AppConstants.userTokenKey);
  }

  /// Récupère l'utilisateur stocké
  User? _getStoredUser() {
    final userData = _prefs.getString(AppConstants.userDataKey);
    if (userData == null) return null;
    
    try {
      // Note: Ici nous devrions parser le JSON correctement
      // Pour l'instant, nous retournons null en attendant une meilleure implémentation
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Supprime toutes les données locales
  Future<void> _clearLocalData() async {
    await _prefs.remove(AppConstants.userTokenKey);
    await _prefs.remove(AppConstants.userDataKey);
  }

  /// Gère les erreurs Dio
  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Délai d\'attente dépassé';
      case DioExceptionType.badResponse:
        if (error.response?.statusCode == 401) {
          return 'Identifiants incorrects';
        } else if (error.response?.statusCode == 403) {
          return 'Accès refusé';
        } else if (error.response?.statusCode == 404) {
          return 'Service non trouvé';
        } else if (error.response?.statusCode == 422) {
          return 'Données invalides';
        }
        return 'Erreur du serveur';
      case DioExceptionType.cancel:
        return 'Requête annulée';
      case DioExceptionType.connectionError:
        return AppConstants.networkErrorMessage;
      default:
        return AppConstants.unknownErrorMessage;
    }
  }
}

/// Résultat d'une opération d'authentification
class AuthResult {
  /// Indique si l'opération a réussi
  final bool isSuccess;
  
  /// Utilisateur authentifié (si succès)
  final User? user;
  
  /// Token d'authentification (si succès)
  final String? token;
  
  /// Message d'erreur (si échec)
  final String? error;

  /// Constructeur privé
  const AuthResult._({
    required this.isSuccess,
    this.user,
    this.token,
    this.error,
  });

  /// Constructeur pour un succès
  factory AuthResult.success({
    required User user,
    required String token,
  }) => AuthResult._(
    isSuccess: true,
    user: user,
    token: token,
  );

  /// Constructeur pour un échec
  factory AuthResult.failure({
    required String error,
  }) => AuthResult._(
    isSuccess: false,
    error: error,
  );
}

/// Provider Riverpod pour le service d'authentification
final authServiceProvider = Provider<AuthService>((ref) {
  throw UnimplementedError('AuthService provider must be overridden');
});

/// Provider pour l'état d'authentification actuel
final currentUserProvider = StateProvider<User?>((ref) => null);