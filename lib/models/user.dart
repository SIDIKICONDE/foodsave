import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Modèle utilisateur pour FoodSave
/// Respecte les standards NYTH - Zero Compromise
@freezed
class User with _$User {
  /// Constructeur du modèle User
  const factory User({
    /// Identifiant unique de l'utilisateur
    required String id,
    
    /// Adresse email de l'utilisateur
    required String email,
    
    /// Nom d'utilisateur
    required String username,
    
    /// Type d'utilisateur (étudiant/commerçant)
    required UserType userType,
    
    /// Prénom de l'utilisateur
    String? firstName,
    
    /// Nom de famille de l'utilisateur
    String? lastName,
    
    /// Numéro de téléphone
    String? phoneNumber,
    
    /// URL de l'avatar
    String? avatarUrl,
    
    /// Adresse de l'utilisateur
    String? address,
    
    /// Ville de l'utilisateur
    String? city,
    
    /// Code postal
    String? postalCode,
    
    /// Statut de vérification
    @Default(false) bool isVerified,
    
    /// Statut actif/inactif
    @Default(true) bool isActive,
    
    /// Date de création
    DateTime? createdAt,
    
    /// Date de dernière mise à jour
    DateTime? updatedAt,
  }) = _User;

  /// Factory pour la désérialisation JSON
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// Énumération des types d'utilisateur
enum UserType {
  /// Utilisateur étudiant
  @JsonValue('student')
  student,
  
  /// Utilisateur commerçant
  @JsonValue('merchant')
  merchant,
}

/// Extension pour obtenir le nom complet
extension UserExtension on User {
  /// Nom complet de l'utilisateur
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return username;
  }
  
  /// Indique si l'utilisateur est un étudiant
  bool get isStudent => userType == UserType.student;
  
  /// Indique si l'utilisateur est un commerçant
  bool get isMerchant => userType == UserType.merchant;
}