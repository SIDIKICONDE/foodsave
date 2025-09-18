import 'package:dartz/dartz.dart';
import 'package:foodsave_app/core/error/failures.dart';

/// Type de données pour les résultats d'opérations asynchrones.
/// 
/// Retourne soit un [Failure] en cas d'erreur, soit un résultat de type [T].
typedef ResultFuture<T> = Future<Either<Failure, T>>;

/// Type de données pour les résultats d'opérations synchrones.
/// 
/// Retourne soit un [Failure] en cas d'erreur, soit un résultat de type [T].
typedef ResultVoid = Either<Failure, void>;

/// Type de données pour les map de données JSON.
typedef DataMap = Map<String, dynamic>;