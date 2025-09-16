// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'restaurant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) {
  return _Restaurant.fromJson(json);
}

/// @nodoc
mixin _$Restaurant {
  /// Identifiant unique du restaurant
  String get id => throw _privateConstructorUsedError;

  /// Identifiant du propriétaire/commerçant
  String get ownerId => throw _privateConstructorUsedError;

  /// Nom du restaurant
  String get name => throw _privateConstructorUsedError;

  /// Description du restaurant
  String get description => throw _privateConstructorUsedError;

  /// Type de cuisine/restaurant
  RestaurantType get type => throw _privateConstructorUsedError;

  /// URL de la photo de couverture
  String? get coverImageUrl => throw _privateConstructorUsedError;

  /// URL du logo
  String? get logoUrl => throw _privateConstructorUsedError;

  /// Galerie d'images
  List<String> get imageUrls => throw _privateConstructorUsedError;

  /// Adresse complète
  String get address => throw _privateConstructorUsedError;

  /// Ville
  String get city => throw _privateConstructorUsedError;

  /// Code postal
  String get postalCode => throw _privateConstructorUsedError;

  /// Coordonnées géographiques
  LocationCoordinates get coordinates => throw _privateConstructorUsedError;

  /// Numéro de téléphone
  String? get phoneNumber => throw _privateConstructorUsedError;

  /// Email de contact
  String? get email => throw _privateConstructorUsedError;

  /// Site web
  String? get website => throw _privateConstructorUsedError;

  /// Horaires d'ouverture
  Map<String, OpeningHours> get openingHours =>
      throw _privateConstructorUsedError;

  /// Note moyenne
  double get averageRating => throw _privateConstructorUsedError;

  /// Nombre total d'avis
  int get totalReviews => throw _privateConstructorUsedError;

  /// Nombre total de repas vendus
  int get totalMealsSold => throw _privateConstructorUsedError;

  /// Nombre total d'économies générées (en euros)
  double get totalSavingsGenerated => throw _privateConstructorUsedError;

  /// Spécialités culinaires
  List<String> get specialties => throw _privateConstructorUsedError;

  /// Certifications (bio, halal, etc.)
  List<RestaurantCertification> get certifications =>
      throw _privateConstructorUsedError;

  /// Rayon de livraison en km
  double get deliveryRadius => throw _privateConstructorUsedError;

  /// Temps de préparation moyen en minutes
  int get averagePreparationTime => throw _privateConstructorUsedError;

  /// Indique si le restaurant est ouvert
  bool get isOpen => throw _privateConstructorUsedError;

  /// Indique si le restaurant est actif
  bool get isActive => throw _privateConstructorUsedError;

  /// Indique si le restaurant est vérifié
  bool get isVerified => throw _privateConstructorUsedError;

  /// Indique si le restaurant propose de la livraison
  bool get offersDelivery => throw _privateConstructorUsedError;

  /// Date de création
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Date de dernière mise à jour
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Restaurant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RestaurantCopyWith<Restaurant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestaurantCopyWith<$Res> {
  factory $RestaurantCopyWith(
          Restaurant value, $Res Function(Restaurant) then) =
      _$RestaurantCopyWithImpl<$Res, Restaurant>;
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String name,
      String description,
      RestaurantType type,
      String? coverImageUrl,
      String? logoUrl,
      List<String> imageUrls,
      String address,
      String city,
      String postalCode,
      LocationCoordinates coordinates,
      String? phoneNumber,
      String? email,
      String? website,
      Map<String, OpeningHours> openingHours,
      double averageRating,
      int totalReviews,
      int totalMealsSold,
      double totalSavingsGenerated,
      List<String> specialties,
      List<RestaurantCertification> certifications,
      double deliveryRadius,
      int averagePreparationTime,
      bool isOpen,
      bool isActive,
      bool isVerified,
      bool offersDelivery,
      DateTime? createdAt,
      DateTime? updatedAt});

  $LocationCoordinatesCopyWith<$Res> get coordinates;
}

/// @nodoc
class _$RestaurantCopyWithImpl<$Res, $Val extends Restaurant>
    implements $RestaurantCopyWith<$Res> {
  _$RestaurantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? coverImageUrl = freezed,
    Object? logoUrl = freezed,
    Object? imageUrls = null,
    Object? address = null,
    Object? city = null,
    Object? postalCode = null,
    Object? coordinates = null,
    Object? phoneNumber = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? openingHours = null,
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? totalMealsSold = null,
    Object? totalSavingsGenerated = null,
    Object? specialties = null,
    Object? certifications = null,
    Object? deliveryRadius = null,
    Object? averagePreparationTime = null,
    Object? isOpen = null,
    Object? isActive = null,
    Object? isVerified = null,
    Object? offersDelivery = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RestaurantType,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      coordinates: null == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as LocationCoordinates,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      openingHours: null == openingHours
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, OpeningHours>,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      totalMealsSold: null == totalMealsSold
          ? _value.totalMealsSold
          : totalMealsSold // ignore: cast_nullable_to_non_nullable
              as int,
      totalSavingsGenerated: null == totalSavingsGenerated
          ? _value.totalSavingsGenerated
          : totalSavingsGenerated // ignore: cast_nullable_to_non_nullable
              as double,
      specialties: null == specialties
          ? _value.specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>,
      certifications: null == certifications
          ? _value.certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<RestaurantCertification>,
      deliveryRadius: null == deliveryRadius
          ? _value.deliveryRadius
          : deliveryRadius // ignore: cast_nullable_to_non_nullable
              as double,
      averagePreparationTime: null == averagePreparationTime
          ? _value.averagePreparationTime
          : averagePreparationTime // ignore: cast_nullable_to_non_nullable
              as int,
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      offersDelivery: null == offersDelivery
          ? _value.offersDelivery
          : offersDelivery // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LocationCoordinatesCopyWith<$Res> get coordinates {
    return $LocationCoordinatesCopyWith<$Res>(_value.coordinates, (value) {
      return _then(_value.copyWith(coordinates: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RestaurantImplCopyWith<$Res>
    implements $RestaurantCopyWith<$Res> {
  factory _$$RestaurantImplCopyWith(
          _$RestaurantImpl value, $Res Function(_$RestaurantImpl) then) =
      __$$RestaurantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String ownerId,
      String name,
      String description,
      RestaurantType type,
      String? coverImageUrl,
      String? logoUrl,
      List<String> imageUrls,
      String address,
      String city,
      String postalCode,
      LocationCoordinates coordinates,
      String? phoneNumber,
      String? email,
      String? website,
      Map<String, OpeningHours> openingHours,
      double averageRating,
      int totalReviews,
      int totalMealsSold,
      double totalSavingsGenerated,
      List<String> specialties,
      List<RestaurantCertification> certifications,
      double deliveryRadius,
      int averagePreparationTime,
      bool isOpen,
      bool isActive,
      bool isVerified,
      bool offersDelivery,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $LocationCoordinatesCopyWith<$Res> get coordinates;
}

/// @nodoc
class __$$RestaurantImplCopyWithImpl<$Res>
    extends _$RestaurantCopyWithImpl<$Res, _$RestaurantImpl>
    implements _$$RestaurantImplCopyWith<$Res> {
  __$$RestaurantImplCopyWithImpl(
      _$RestaurantImpl _value, $Res Function(_$RestaurantImpl) _then)
      : super(_value, _then);

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? coverImageUrl = freezed,
    Object? logoUrl = freezed,
    Object? imageUrls = null,
    Object? address = null,
    Object? city = null,
    Object? postalCode = null,
    Object? coordinates = null,
    Object? phoneNumber = freezed,
    Object? email = freezed,
    Object? website = freezed,
    Object? openingHours = null,
    Object? averageRating = null,
    Object? totalReviews = null,
    Object? totalMealsSold = null,
    Object? totalSavingsGenerated = null,
    Object? specialties = null,
    Object? certifications = null,
    Object? deliveryRadius = null,
    Object? averagePreparationTime = null,
    Object? isOpen = null,
    Object? isActive = null,
    Object? isVerified = null,
    Object? offersDelivery = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$RestaurantImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RestaurantType,
      coverImageUrl: freezed == coverImageUrl
          ? _value.coverImageUrl
          : coverImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      postalCode: null == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String,
      coordinates: null == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as LocationCoordinates,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      openingHours: null == openingHours
          ? _value._openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as Map<String, OpeningHours>,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      totalMealsSold: null == totalMealsSold
          ? _value.totalMealsSold
          : totalMealsSold // ignore: cast_nullable_to_non_nullable
              as int,
      totalSavingsGenerated: null == totalSavingsGenerated
          ? _value.totalSavingsGenerated
          : totalSavingsGenerated // ignore: cast_nullable_to_non_nullable
              as double,
      specialties: null == specialties
          ? _value._specialties
          : specialties // ignore: cast_nullable_to_non_nullable
              as List<String>,
      certifications: null == certifications
          ? _value._certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<RestaurantCertification>,
      deliveryRadius: null == deliveryRadius
          ? _value.deliveryRadius
          : deliveryRadius // ignore: cast_nullable_to_non_nullable
              as double,
      averagePreparationTime: null == averagePreparationTime
          ? _value.averagePreparationTime
          : averagePreparationTime // ignore: cast_nullable_to_non_nullable
              as int,
      isOpen: null == isOpen
          ? _value.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isVerified: null == isVerified
          ? _value.isVerified
          : isVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      offersDelivery: null == offersDelivery
          ? _value.offersDelivery
          : offersDelivery // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RestaurantImpl implements _Restaurant {
  const _$RestaurantImpl(
      {required this.id,
      required this.ownerId,
      required this.name,
      required this.description,
      required this.type,
      this.coverImageUrl,
      this.logoUrl,
      final List<String> imageUrls = const [],
      required this.address,
      required this.city,
      required this.postalCode,
      required this.coordinates,
      this.phoneNumber,
      this.email,
      this.website,
      final Map<String, OpeningHours> openingHours = const {},
      this.averageRating = 0.0,
      this.totalReviews = 0,
      this.totalMealsSold = 0,
      this.totalSavingsGenerated = 0.0,
      final List<String> specialties = const [],
      final List<RestaurantCertification> certifications = const [],
      this.deliveryRadius = 5.0,
      this.averagePreparationTime = 15,
      this.isOpen = true,
      this.isActive = true,
      this.isVerified = false,
      this.offersDelivery = false,
      this.createdAt,
      this.updatedAt})
      : _imageUrls = imageUrls,
        _openingHours = openingHours,
        _specialties = specialties,
        _certifications = certifications;

  factory _$RestaurantImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestaurantImplFromJson(json);

  /// Identifiant unique du restaurant
  @override
  final String id;

  /// Identifiant du propriétaire/commerçant
  @override
  final String ownerId;

  /// Nom du restaurant
  @override
  final String name;

  /// Description du restaurant
  @override
  final String description;

  /// Type de cuisine/restaurant
  @override
  final RestaurantType type;

  /// URL de la photo de couverture
  @override
  final String? coverImageUrl;

  /// URL du logo
  @override
  final String? logoUrl;

  /// Galerie d'images
  final List<String> _imageUrls;

  /// Galerie d'images
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  /// Adresse complète
  @override
  final String address;

  /// Ville
  @override
  final String city;

  /// Code postal
  @override
  final String postalCode;

  /// Coordonnées géographiques
  @override
  final LocationCoordinates coordinates;

  /// Numéro de téléphone
  @override
  final String? phoneNumber;

  /// Email de contact
  @override
  final String? email;

  /// Site web
  @override
  final String? website;

  /// Horaires d'ouverture
  final Map<String, OpeningHours> _openingHours;

  /// Horaires d'ouverture
  @override
  @JsonKey()
  Map<String, OpeningHours> get openingHours {
    if (_openingHours is EqualUnmodifiableMapView) return _openingHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_openingHours);
  }

  /// Note moyenne
  @override
  @JsonKey()
  final double averageRating;

  /// Nombre total d'avis
  @override
  @JsonKey()
  final int totalReviews;

  /// Nombre total de repas vendus
  @override
  @JsonKey()
  final int totalMealsSold;

  /// Nombre total d'économies générées (en euros)
  @override
  @JsonKey()
  final double totalSavingsGenerated;

  /// Spécialités culinaires
  final List<String> _specialties;

  /// Spécialités culinaires
  @override
  @JsonKey()
  List<String> get specialties {
    if (_specialties is EqualUnmodifiableListView) return _specialties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_specialties);
  }

  /// Certifications (bio, halal, etc.)
  final List<RestaurantCertification> _certifications;

  /// Certifications (bio, halal, etc.)
  @override
  @JsonKey()
  List<RestaurantCertification> get certifications {
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certifications);
  }

  /// Rayon de livraison en km
  @override
  @JsonKey()
  final double deliveryRadius;

  /// Temps de préparation moyen en minutes
  @override
  @JsonKey()
  final int averagePreparationTime;

  /// Indique si le restaurant est ouvert
  @override
  @JsonKey()
  final bool isOpen;

  /// Indique si le restaurant est actif
  @override
  @JsonKey()
  final bool isActive;

  /// Indique si le restaurant est vérifié
  @override
  @JsonKey()
  final bool isVerified;

  /// Indique si le restaurant propose de la livraison
  @override
  @JsonKey()
  final bool offersDelivery;

  /// Date de création
  @override
  final DateTime? createdAt;

  /// Date de dernière mise à jour
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Restaurant(id: $id, ownerId: $ownerId, name: $name, description: $description, type: $type, coverImageUrl: $coverImageUrl, logoUrl: $logoUrl, imageUrls: $imageUrls, address: $address, city: $city, postalCode: $postalCode, coordinates: $coordinates, phoneNumber: $phoneNumber, email: $email, website: $website, openingHours: $openingHours, averageRating: $averageRating, totalReviews: $totalReviews, totalMealsSold: $totalMealsSold, totalSavingsGenerated: $totalSavingsGenerated, specialties: $specialties, certifications: $certifications, deliveryRadius: $deliveryRadius, averagePreparationTime: $averagePreparationTime, isOpen: $isOpen, isActive: $isActive, isVerified: $isVerified, offersDelivery: $offersDelivery, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestaurantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.coverImageUrl, coverImageUrl) ||
                other.coverImageUrl == coverImageUrl) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.coordinates, coordinates) ||
                other.coordinates == coordinates) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.website, website) || other.website == website) &&
            const DeepCollectionEquality()
                .equals(other._openingHours, _openingHours) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.totalMealsSold, totalMealsSold) ||
                other.totalMealsSold == totalMealsSold) &&
            (identical(other.totalSavingsGenerated, totalSavingsGenerated) ||
                other.totalSavingsGenerated == totalSavingsGenerated) &&
            const DeepCollectionEquality()
                .equals(other._specialties, _specialties) &&
            const DeepCollectionEquality()
                .equals(other._certifications, _certifications) &&
            (identical(other.deliveryRadius, deliveryRadius) ||
                other.deliveryRadius == deliveryRadius) &&
            (identical(other.averagePreparationTime, averagePreparationTime) ||
                other.averagePreparationTime == averagePreparationTime) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isVerified, isVerified) ||
                other.isVerified == isVerified) &&
            (identical(other.offersDelivery, offersDelivery) ||
                other.offersDelivery == offersDelivery) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        ownerId,
        name,
        description,
        type,
        coverImageUrl,
        logoUrl,
        const DeepCollectionEquality().hash(_imageUrls),
        address,
        city,
        postalCode,
        coordinates,
        phoneNumber,
        email,
        website,
        const DeepCollectionEquality().hash(_openingHours),
        averageRating,
        totalReviews,
        totalMealsSold,
        totalSavingsGenerated,
        const DeepCollectionEquality().hash(_specialties),
        const DeepCollectionEquality().hash(_certifications),
        deliveryRadius,
        averagePreparationTime,
        isOpen,
        isActive,
        isVerified,
        offersDelivery,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RestaurantImplCopyWith<_$RestaurantImpl> get copyWith =>
      __$$RestaurantImplCopyWithImpl<_$RestaurantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RestaurantImplToJson(
      this,
    );
  }
}

abstract class _Restaurant implements Restaurant {
  const factory _Restaurant(
      {required final String id,
      required final String ownerId,
      required final String name,
      required final String description,
      required final RestaurantType type,
      final String? coverImageUrl,
      final String? logoUrl,
      final List<String> imageUrls,
      required final String address,
      required final String city,
      required final String postalCode,
      required final LocationCoordinates coordinates,
      final String? phoneNumber,
      final String? email,
      final String? website,
      final Map<String, OpeningHours> openingHours,
      final double averageRating,
      final int totalReviews,
      final int totalMealsSold,
      final double totalSavingsGenerated,
      final List<String> specialties,
      final List<RestaurantCertification> certifications,
      final double deliveryRadius,
      final int averagePreparationTime,
      final bool isOpen,
      final bool isActive,
      final bool isVerified,
      final bool offersDelivery,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$RestaurantImpl;

  factory _Restaurant.fromJson(Map<String, dynamic> json) =
      _$RestaurantImpl.fromJson;

  /// Identifiant unique du restaurant
  @override
  String get id;

  /// Identifiant du propriétaire/commerçant
  @override
  String get ownerId;

  /// Nom du restaurant
  @override
  String get name;

  /// Description du restaurant
  @override
  String get description;

  /// Type de cuisine/restaurant
  @override
  RestaurantType get type;

  /// URL de la photo de couverture
  @override
  String? get coverImageUrl;

  /// URL du logo
  @override
  String? get logoUrl;

  /// Galerie d'images
  @override
  List<String> get imageUrls;

  /// Adresse complète
  @override
  String get address;

  /// Ville
  @override
  String get city;

  /// Code postal
  @override
  String get postalCode;

  /// Coordonnées géographiques
  @override
  LocationCoordinates get coordinates;

  /// Numéro de téléphone
  @override
  String? get phoneNumber;

  /// Email de contact
  @override
  String? get email;

  /// Site web
  @override
  String? get website;

  /// Horaires d'ouverture
  @override
  Map<String, OpeningHours> get openingHours;

  /// Note moyenne
  @override
  double get averageRating;

  /// Nombre total d'avis
  @override
  int get totalReviews;

  /// Nombre total de repas vendus
  @override
  int get totalMealsSold;

  /// Nombre total d'économies générées (en euros)
  @override
  double get totalSavingsGenerated;

  /// Spécialités culinaires
  @override
  List<String> get specialties;

  /// Certifications (bio, halal, etc.)
  @override
  List<RestaurantCertification> get certifications;

  /// Rayon de livraison en km
  @override
  double get deliveryRadius;

  /// Temps de préparation moyen en minutes
  @override
  int get averagePreparationTime;

  /// Indique si le restaurant est ouvert
  @override
  bool get isOpen;

  /// Indique si le restaurant est actif
  @override
  bool get isActive;

  /// Indique si le restaurant est vérifié
  @override
  bool get isVerified;

  /// Indique si le restaurant propose de la livraison
  @override
  bool get offersDelivery;

  /// Date de création
  @override
  DateTime? get createdAt;

  /// Date de dernière mise à jour
  @override
  DateTime? get updatedAt;

  /// Create a copy of Restaurant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RestaurantImplCopyWith<_$RestaurantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LocationCoordinates _$LocationCoordinatesFromJson(Map<String, dynamic> json) {
  return _LocationCoordinates.fromJson(json);
}

/// @nodoc
mixin _$LocationCoordinates {
  /// Latitude
  double get latitude => throw _privateConstructorUsedError;

  /// Longitude
  double get longitude => throw _privateConstructorUsedError;

  /// Serializes this LocationCoordinates to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LocationCoordinates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LocationCoordinatesCopyWith<LocationCoordinates> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LocationCoordinatesCopyWith<$Res> {
  factory $LocationCoordinatesCopyWith(
          LocationCoordinates value, $Res Function(LocationCoordinates) then) =
      _$LocationCoordinatesCopyWithImpl<$Res, LocationCoordinates>;
  @useResult
  $Res call({double latitude, double longitude});
}

/// @nodoc
class _$LocationCoordinatesCopyWithImpl<$Res, $Val extends LocationCoordinates>
    implements $LocationCoordinatesCopyWith<$Res> {
  _$LocationCoordinatesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LocationCoordinates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_value.copyWith(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LocationCoordinatesImplCopyWith<$Res>
    implements $LocationCoordinatesCopyWith<$Res> {
  factory _$$LocationCoordinatesImplCopyWith(_$LocationCoordinatesImpl value,
          $Res Function(_$LocationCoordinatesImpl) then) =
      __$$LocationCoordinatesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double latitude, double longitude});
}

/// @nodoc
class __$$LocationCoordinatesImplCopyWithImpl<$Res>
    extends _$LocationCoordinatesCopyWithImpl<$Res, _$LocationCoordinatesImpl>
    implements _$$LocationCoordinatesImplCopyWith<$Res> {
  __$$LocationCoordinatesImplCopyWithImpl(_$LocationCoordinatesImpl _value,
      $Res Function(_$LocationCoordinatesImpl) _then)
      : super(_value, _then);

  /// Create a copy of LocationCoordinates
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? latitude = null,
    Object? longitude = null,
  }) {
    return _then(_$LocationCoordinatesImpl(
      latitude: null == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LocationCoordinatesImpl implements _LocationCoordinates {
  const _$LocationCoordinatesImpl(
      {required this.latitude, required this.longitude});

  factory _$LocationCoordinatesImpl.fromJson(Map<String, dynamic> json) =>
      _$$LocationCoordinatesImplFromJson(json);

  /// Latitude
  @override
  final double latitude;

  /// Longitude
  @override
  final double longitude;

  @override
  String toString() {
    return 'LocationCoordinates(latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LocationCoordinatesImpl &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, latitude, longitude);

  /// Create a copy of LocationCoordinates
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LocationCoordinatesImplCopyWith<_$LocationCoordinatesImpl> get copyWith =>
      __$$LocationCoordinatesImplCopyWithImpl<_$LocationCoordinatesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LocationCoordinatesImplToJson(
      this,
    );
  }
}

abstract class _LocationCoordinates implements LocationCoordinates {
  const factory _LocationCoordinates(
      {required final double latitude,
      required final double longitude}) = _$LocationCoordinatesImpl;

  factory _LocationCoordinates.fromJson(Map<String, dynamic> json) =
      _$LocationCoordinatesImpl.fromJson;

  /// Latitude
  @override
  double get latitude;

  /// Longitude
  @override
  double get longitude;

  /// Create a copy of LocationCoordinates
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LocationCoordinatesImplCopyWith<_$LocationCoordinatesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) {
  return _OpeningHours.fromJson(json);
}

/// @nodoc
mixin _$OpeningHours {
  /// Heure d'ouverture
  String get openTime => throw _privateConstructorUsedError;

  /// Heure de fermeture
  String get closeTime => throw _privateConstructorUsedError;

  /// Indique si c'est fermé ce jour
  bool get isClosed => throw _privateConstructorUsedError;

  /// Pause déjeuner (optionnelle)
  TimeSlot? get lunchBreak => throw _privateConstructorUsedError;

  /// Serializes this OpeningHours to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OpeningHours
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OpeningHoursCopyWith<OpeningHours> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpeningHoursCopyWith<$Res> {
  factory $OpeningHoursCopyWith(
          OpeningHours value, $Res Function(OpeningHours) then) =
      _$OpeningHoursCopyWithImpl<$Res, OpeningHours>;
  @useResult
  $Res call(
      {String openTime, String closeTime, bool isClosed, TimeSlot? lunchBreak});

  $TimeSlotCopyWith<$Res>? get lunchBreak;
}

/// @nodoc
class _$OpeningHoursCopyWithImpl<$Res, $Val extends OpeningHours>
    implements $OpeningHoursCopyWith<$Res> {
  _$OpeningHoursCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OpeningHours
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? openTime = null,
    Object? closeTime = null,
    Object? isClosed = null,
    Object? lunchBreak = freezed,
  }) {
    return _then(_value.copyWith(
      openTime: null == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as String,
      closeTime: null == closeTime
          ? _value.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as String,
      isClosed: null == isClosed
          ? _value.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      lunchBreak: freezed == lunchBreak
          ? _value.lunchBreak
          : lunchBreak // ignore: cast_nullable_to_non_nullable
              as TimeSlot?,
    ) as $Val);
  }

  /// Create a copy of OpeningHours
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TimeSlotCopyWith<$Res>? get lunchBreak {
    if (_value.lunchBreak == null) {
      return null;
    }

    return $TimeSlotCopyWith<$Res>(_value.lunchBreak!, (value) {
      return _then(_value.copyWith(lunchBreak: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OpeningHoursImplCopyWith<$Res>
    implements $OpeningHoursCopyWith<$Res> {
  factory _$$OpeningHoursImplCopyWith(
          _$OpeningHoursImpl value, $Res Function(_$OpeningHoursImpl) then) =
      __$$OpeningHoursImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String openTime, String closeTime, bool isClosed, TimeSlot? lunchBreak});

  @override
  $TimeSlotCopyWith<$Res>? get lunchBreak;
}

/// @nodoc
class __$$OpeningHoursImplCopyWithImpl<$Res>
    extends _$OpeningHoursCopyWithImpl<$Res, _$OpeningHoursImpl>
    implements _$$OpeningHoursImplCopyWith<$Res> {
  __$$OpeningHoursImplCopyWithImpl(
      _$OpeningHoursImpl _value, $Res Function(_$OpeningHoursImpl) _then)
      : super(_value, _then);

  /// Create a copy of OpeningHours
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? openTime = null,
    Object? closeTime = null,
    Object? isClosed = null,
    Object? lunchBreak = freezed,
  }) {
    return _then(_$OpeningHoursImpl(
      openTime: null == openTime
          ? _value.openTime
          : openTime // ignore: cast_nullable_to_non_nullable
              as String,
      closeTime: null == closeTime
          ? _value.closeTime
          : closeTime // ignore: cast_nullable_to_non_nullable
              as String,
      isClosed: null == isClosed
          ? _value.isClosed
          : isClosed // ignore: cast_nullable_to_non_nullable
              as bool,
      lunchBreak: freezed == lunchBreak
          ? _value.lunchBreak
          : lunchBreak // ignore: cast_nullable_to_non_nullable
              as TimeSlot?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpeningHoursImpl implements _OpeningHours {
  const _$OpeningHoursImpl(
      {required this.openTime,
      required this.closeTime,
      this.isClosed = false,
      this.lunchBreak});

  factory _$OpeningHoursImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpeningHoursImplFromJson(json);

  /// Heure d'ouverture
  @override
  final String openTime;

  /// Heure de fermeture
  @override
  final String closeTime;

  /// Indique si c'est fermé ce jour
  @override
  @JsonKey()
  final bool isClosed;

  /// Pause déjeuner (optionnelle)
  @override
  final TimeSlot? lunchBreak;

  @override
  String toString() {
    return 'OpeningHours(openTime: $openTime, closeTime: $closeTime, isClosed: $isClosed, lunchBreak: $lunchBreak)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpeningHoursImpl &&
            (identical(other.openTime, openTime) ||
                other.openTime == openTime) &&
            (identical(other.closeTime, closeTime) ||
                other.closeTime == closeTime) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed) &&
            (identical(other.lunchBreak, lunchBreak) ||
                other.lunchBreak == lunchBreak));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, openTime, closeTime, isClosed, lunchBreak);

  /// Create a copy of OpeningHours
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OpeningHoursImplCopyWith<_$OpeningHoursImpl> get copyWith =>
      __$$OpeningHoursImplCopyWithImpl<_$OpeningHoursImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpeningHoursImplToJson(
      this,
    );
  }
}

abstract class _OpeningHours implements OpeningHours {
  const factory _OpeningHours(
      {required final String openTime,
      required final String closeTime,
      final bool isClosed,
      final TimeSlot? lunchBreak}) = _$OpeningHoursImpl;

  factory _OpeningHours.fromJson(Map<String, dynamic> json) =
      _$OpeningHoursImpl.fromJson;

  /// Heure d'ouverture
  @override
  String get openTime;

  /// Heure de fermeture
  @override
  String get closeTime;

  /// Indique si c'est fermé ce jour
  @override
  bool get isClosed;

  /// Pause déjeuner (optionnelle)
  @override
  TimeSlot? get lunchBreak;

  /// Create a copy of OpeningHours
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OpeningHoursImplCopyWith<_$OpeningHoursImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) {
  return _TimeSlot.fromJson(json);
}

/// @nodoc
mixin _$TimeSlot {
  /// Heure de début
  String get startTime => throw _privateConstructorUsedError;

  /// Heure de fin
  String get endTime => throw _privateConstructorUsedError;

  /// Serializes this TimeSlot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeSlotCopyWith<TimeSlot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeSlotCopyWith<$Res> {
  factory $TimeSlotCopyWith(TimeSlot value, $Res Function(TimeSlot) then) =
      _$TimeSlotCopyWithImpl<$Res, TimeSlot>;
  @useResult
  $Res call({String startTime, String endTime});
}

/// @nodoc
class _$TimeSlotCopyWithImpl<$Res, $Val extends TimeSlot>
    implements $TimeSlotCopyWith<$Res> {
  _$TimeSlotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_value.copyWith(
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimeSlotImplCopyWith<$Res>
    implements $TimeSlotCopyWith<$Res> {
  factory _$$TimeSlotImplCopyWith(
          _$TimeSlotImpl value, $Res Function(_$TimeSlotImpl) then) =
      __$$TimeSlotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String startTime, String endTime});
}

/// @nodoc
class __$$TimeSlotImplCopyWithImpl<$Res>
    extends _$TimeSlotCopyWithImpl<$Res, _$TimeSlotImpl>
    implements _$$TimeSlotImplCopyWith<$Res> {
  __$$TimeSlotImplCopyWithImpl(
      _$TimeSlotImpl _value, $Res Function(_$TimeSlotImpl) _then)
      : super(_value, _then);

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startTime = null,
    Object? endTime = null,
  }) {
    return _then(_$TimeSlotImpl(
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeSlotImpl implements _TimeSlot {
  const _$TimeSlotImpl({required this.startTime, required this.endTime});

  factory _$TimeSlotImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeSlotImplFromJson(json);

  /// Heure de début
  @override
  final String startTime;

  /// Heure de fin
  @override
  final String endTime;

  @override
  String toString() {
    return 'TimeSlot(startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeSlotImpl &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, startTime, endTime);

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeSlotImplCopyWith<_$TimeSlotImpl> get copyWith =>
      __$$TimeSlotImplCopyWithImpl<_$TimeSlotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeSlotImplToJson(
      this,
    );
  }
}

abstract class _TimeSlot implements TimeSlot {
  const factory _TimeSlot(
      {required final String startTime,
      required final String endTime}) = _$TimeSlotImpl;

  factory _TimeSlot.fromJson(Map<String, dynamic> json) =
      _$TimeSlotImpl.fromJson;

  /// Heure de début
  @override
  String get startTime;

  /// Heure de fin
  @override
  String get endTime;

  /// Create a copy of TimeSlot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeSlotImplCopyWith<_$TimeSlotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
