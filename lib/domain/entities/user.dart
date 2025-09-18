import 'package:equatable/equatable.dart';

/// Énumération des types de compte utilisateur dans FoodSave.
enum UserType {
  /// Utilisateur consommateur régulier.
  consumer,
  
  /// Commerçant proposant des paniers anti-gaspi.
  merchant,
  
  /// Utilisateur en mode invité (accès limité).
  guest,
}

/// Préférences utilisateur pour les préférences alimentaires et notifications.
class UserPreferences extends Equatable {
  /// Crée une nouvelle instance de [UserPreferences].
  const UserPreferences({
    required this.dietary,
    required this.allergens,
    required this.notifications,
  });

  /// Préférences alimentaires (ex: 'vegetarian', 'bio', 'local').
  final List<String> dietary;

  /// Allergènes à éviter (ex: 'gluten', 'nuts').
  final List<String> allergens;

  /// Active/désactive les notifications.
  final bool notifications;

  /// Crée une copie avec des valeurs modifiées.
  UserPreferences copyWith({
    List<String>? dietary,
    List<String>? allergens,
    bool? notifications,
  }) {
    return UserPreferences(
      dietary: dietary ?? this.dietary,
      allergens: allergens ?? this.allergens,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [dietary, allergens, notifications];
}

/// Statistiques de l'utilisateur sur ses actions anti-gaspillage.
class UserStatistics extends Equatable {
  /// Crée une nouvelle instance de [UserStatistics].
  const UserStatistics({
    required this.basketsSaved,
    required this.moneySaved,
    required this.co2Saved,
  });

  /// Nombre de paniers sauvés.
  final int basketsSaved;

  /// Montant d'argent économisé en euros.
  final double moneySaved;

  /// CO2 économisé en kilogrammes.
  final double co2Saved;

  /// Crée une copie avec des valeurs modifiées.
  UserStatistics copyWith({
    int? basketsSaved,
    double? moneySaved,
    double? co2Saved,
  }) {
    return UserStatistics(
      basketsSaved: basketsSaved ?? this.basketsSaved,
      moneySaved: moneySaved ?? this.moneySaved,
      co2Saved: co2Saved ?? this.co2Saved,
    );
  }

  @override
  List<Object?> get props => [basketsSaved, moneySaved, co2Saved];
}

/// Entité représentant un utilisateur de l'application FoodSave.
/// 
/// Cette entité contient toutes les informations relatives à un utilisateur,
/// incluant ses préférences alimentaires, statistiques et informations d'authentification.
class User extends Equatable {
  /// Crée une nouvelle instance d'[User].
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.createdAt,
    this.phone,
    this.avatar,
    this.address,
    this.preferences,
    this.statistics,
    this.token,
    this.refreshToken,
    this.isEmailVerified = false,
  });

  /// Identifiant unique de l'utilisateur.
  final String id;

  /// Nom complet de l'utilisateur.
  final String name;

  /// Adresse email de l'utilisateur.
  final String email;

  /// Type de compte utilisateur.
  final UserType userType;

  /// Date de création du compte.
  final DateTime createdAt;

  /// Numéro de téléphone (optionnel).
  final String? phone;

  /// URL de l'avatar/photo de profil.
  final String? avatar;

  /// Adresse de l'utilisateur.
  final String? address;

  /// Préférences utilisateur.
  final UserPreferences? preferences;

  /// Statistiques de l'utilisateur.
  final UserStatistics? statistics;

  /// Token d'authentification.
  final String? token;

  /// Token de rafraîchissement.
  final String? refreshToken;

  /// Indique si l'email est vérifié.
  final bool isEmailVerified;

  /// Crée une copie de l'utilisateur avec des valeurs modifiées.
  User copyWith({
    String? id,
    String? name,
    String? email,
    UserType? userType,
    DateTime? createdAt,
    String? phone,
    String? avatar,
    String? address,
    UserPreferences? preferences,
    UserStatistics? statistics,
    String? token,
    String? refreshToken,
    bool? isEmailVerified,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      preferences: preferences ?? this.preferences,
      statistics: statistics ?? this.statistics,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    userType,
    createdAt,
    phone,
    avatar,
    address,
    preferences,
    statistics,
    token,
    refreshToken,
    isEmailVerified,
  ];

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, userType: $userType)';
  }
}