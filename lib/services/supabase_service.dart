import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:foodsave_app/config/supabase_config.dart';

/// Classe d'erreur personnalisée pour Supabase
class SupabaseError {
  final String message;
  final String? code;
  final dynamic details;

  const SupabaseError({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'SupabaseError: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Service principal pour gérer les interactions avec Supabase
/// 
/// Ce service encapsule toutes les opérations Supabase et fournit
/// une interface cohérente avec gestion d'erreurs appropriée.
class SupabaseService {
  /// Client Supabase utilisé pour toutes les opérations
  static final SupabaseClient _client = SupabaseConfig.client;

  /// Référence rapide au client pour les opérations directes
  static SupabaseClient get client => _client;

  /// Utilisateur actuellement connecté
  static User? get currentUser => _client.auth.currentUser;

  /// Stream des changements d'état d'authentification
  static Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Vérifie si l'utilisateur est connecté
  static bool get isAuthenticated => currentUser != null;

  // OPÉRATIONS D'AUTHENTIFICATION

  /// Inscription avec email et mot de passe
  /// 
  /// [email] - Adresse email de l'utilisateur
  /// [password] - Mot de passe de l'utilisateur
  /// [metadata] - Métadonnées supplémentaires (optionnel)
  /// 
  /// Retourne [Right] avec [AuthResponse] en cas de succès,
  /// [Left] avec [SupabaseError] en cas d'erreur.
  static Future<Either<SupabaseError, AuthResponse>> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signUp(
        email: email,
        password: password,
        data: metadata,
      );
      return Right(response);
    } catch (error) {
      return Left(_handleError(error));
    }
  }

  /// Connexion avec email et mot de passe
  /// 
  /// [email] - Adresse email de l'utilisateur
  /// [password] - Mot de passe de l'utilisateur
  /// 
  /// Retourne [Right] avec [AuthResponse] en cas de succès,
  /// [Left] avec [SupabaseError] en cas d'erreur.
  static Future<Either<SupabaseError, AuthResponse>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return Right(response);
    } catch (error) {
      return Left(_handleError(error));
    }
  }

  /// Déconnexion de l'utilisateur actuel
  /// 
  /// Retourne [Right] avec [void] en cas de succès,
  /// [Left] avec [SupabaseError] en cas d'erreur.
  static Future<Either<SupabaseError, void>> signOut() async {
    try {
      await _client.auth.signOut();
      return const Right(null);
    } catch (error) {
      return Left(_handleError(error));
    }
  }

  /// Réinitialisation du mot de passe
  /// 
  /// [email] - Adresse email pour la réinitialisation
  /// 
  /// Retourne [Right] avec [void] en cas de succès,
  /// [Left] avec [SupabaseError] en cas d'erreur.
  static Future<Either<SupabaseError, void>> resetPassword({
    required String email,
  }) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      return const Right(null);
    } catch (error) {
      return Left(_handleError(error));
    }
  }

  // OPÉRATIONS DE BASE DE DONNÉES

  /// Récupère des données d'une table avec filtres optionnels
  /// 
  /// [tableName] - Nom de la table
  /// [columns] - Colonnes à sélectionner (défaut: toutes)
  /// [filters] - Filtres à appliquer
  /// [orderBy] - Colonne pour le tri
  /// [ascending] - Ordre croissant (défaut: true)
  /// [limit] - Limite du nombre de résultats
  /// 
  /// Retourne [Right] avec [List<Map<String, dynamic>>] en cas de succès,
  /// [Left] avec [SupabaseError] en cas d'erreur.
  static Future<Either<SupabaseError, List<Map<String, dynamic>>>> select({
    required String tableName,
    String columns = '*',
    Map<String, dynamic>? filters,
    String? orderBy,
    bool ascending = true,
    int? limit,
  }) async {
    try {
      dynamic query = _client.from(tableName).select(columns);

      // Appliquer les filtres
      if (filters != null) {
        for (final MapEntry<String, dynamic> filter in filters.entries) {
          query = query.eq(filter.key, filter.value);
        }
      }

      // Appliquer le tri
      if (orderBy != null) {
        query = query.order(orderBy, ascending: ascending);
      }

      // Appliquer la limite
      if (limit != null) {
        query = query.limit(limit);
      }

      final List<Map<String, dynamic>> data = await query;
      return Right(data);
    } catch (error) {
      return Left(_handleError(error));
    }
  }

  /// Insère des données dans une table
  /// 
  /// [tableName] - Nom de la table
  /// [data] - Données à insérer
  /// 
  /// Retourne [Right] avec [List<Map<String, dynamic>>] en cas de succès,
  /// [Left] avec [SupabaseError] en cas d'erreur.
  static Future<Either<SupabaseError, List<Map<String, dynamic>>>> insert({
    required String tableName,
    required Map<String, dynamic> data,
  }) async {
    try {
      final List<Map<String, dynamic>> response = await _client
          .from(tableName)
          .insert(data)
          .select();
      return Right(response);
    } catch (error) {
      return Left(_handleError(error));
    }
  }

  /// Met à jour des données dans une table
  /// 
  /// [tableName] - Nom de la table
  /// [data] - Données à mettre à jour
  /// [filters] - Filtres pour identifier les lignes à modifier
  /// 
  /// Retourne [Right] avec [List<Map<String, dynamic>>] en cas de succès,
  /// [Left] avec [SupabaseError] en cas d'erreur.
  static Future<Either<SupabaseError, List<Map<String, dynamic>>>> update({
    required String tableName,
    required Map<String, dynamic> data,
    required Map<String, dynamic> filters,
  }) async {
    try {
      dynamic query = _client.from(tableName).update(data);

      // Appliquer les filtres
      for (final MapEntry<String, dynamic> filter in filters.entries) {
        query = query.eq(filter.key, filter.value);
      }

      final List<Map<String, dynamic>> response = await query.select();
      return Right(response);
    } catch (error) {
      return Left(_handleError(error));
    }
  }

  /// Supprime des données d'une table
  /// 
  /// [tableName] - Nom de la table
  /// [filters] - Filtres pour identifier les lignes à supprimer
  /// 
  /// Retourne [Right] avec [void] en cas de succès,
  /// [Left] avec [SupabaseError] en cas d'erreur.
  static Future<Either<SupabaseError, void>> delete({
    required String tableName,
    required Map<String, dynamic> filters,
  }) async {
    try {
      dynamic query = _client.from(tableName).delete();

      // Appliquer les filtres
      for (final MapEntry<String, dynamic> filter in filters.entries) {
        query = query.eq(filter.key, filter.value);
      }

      await query;
      return const Right(null);
    } catch (error) {
      return Left(_handleError(error));
    }
  }

  /// S'abonne aux changements en temps réel d'une table
  /// 
  /// [tableName] - Nom de la table
  /// [filter] - Filtre optionnel
  /// 
  /// Retourne un [Stream] des changements
  static RealtimeChannel subscribeToTable({
    required String tableName,
    String? filter,
    required void Function(PostgresChangePayload) callback,
  }) {
    final RealtimeChannel channel = _client.channel('public:$tableName');
    
    if (filter != null) {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: tableName,
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'id',
          value: filter,
        ),
        callback: callback,
      );
    } else {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: tableName,
        callback: callback,
      );
    }

    channel.subscribe();
    return channel;
  }

  // UTILITAIRES PRIVÉS

  /// Gère et normalise les erreurs Supabase
  /// 
  /// [error] - Erreur à traiter
  /// 
  /// Retourne une [SupabaseError] formatée
  static SupabaseError _handleError(dynamic error) {
    if (error is AuthException) {
      return SupabaseError(
        message: error.message,
        code: error.statusCode,
        details: error,
      );
    } else if (error is PostgrestException) {
      return SupabaseError(
        message: error.message,
        code: error.code,
        details: error.details,
      );
    } else {
      return SupabaseError(
        message: error.toString(),
        details: error,
      );
    }
  }
}