// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Meal _$MealFromJson(Map<String, dynamic> json) {
  return _Meal.fromJson(json);
}

/// @nodoc
mixin _$Meal {
  /// Identifiant unique du repas
  String get id => throw _privateConstructorUsedError;

  /// Identifiant du commerçant propriétaire
  String get merchantId => throw _privateConstructorUsedError;

  /// Nom/titre du repas
  String get title => throw _privateConstructorUsedError;

  /// Description détaillée
  String get description => throw _privateConstructorUsedError;

  /// Prix original
  double get originalPrice => throw _privateConstructorUsedError;

  /// Prix après réduction
  double get discountedPrice => throw _privateConstructorUsedError;

  /// Catégorie du repas
  MealCategory get category => throw _privateConstructorUsedError;

  /// URLs des images
  List<String> get imageUrls => throw _privateConstructorUsedError;

  /// Quantité disponible
  int get quantity => throw _privateConstructorUsedError;

  /// Quantité restante
  int get remainingQuantity => throw _privateConstructorUsedError;

  /// Liste des allergènes
  List<String> get allergens => throw _privateConstructorUsedError;

  /// Liste des ingrédients
  List<String> get ingredients => throw _privateConstructorUsedError;

  /// Informations nutritionnelles
  NutritionalInfo? get nutritionalInfo => throw _privateConstructorUsedError;

  /// Date/heure de disponibilité
  DateTime get availableFrom => throw _privateConstructorUsedError;

  /// Date/heure limite de récupération
  DateTime get availableUntil => throw _privateConstructorUsedError;

  /// Statut du repas
  MealStatus get status => throw _privateConstructorUsedError;

  /// Note moyenne
  double get averageRating => throw _privateConstructorUsedError;

  /// Nombre de votes
  int get ratingCount => throw _privateConstructorUsedError;

  /// Indique si c'est végétarien
  bool get isVegetarian => throw _privateConstructorUsedError;

  /// Indique si c'est végétalien
  bool get isVegan => throw _privateConstructorUsedError;

  /// Indique si c'est sans gluten
  bool get isGlutenFree => throw _privateConstructorUsedError;

  /// Indique si c'est halal
  bool get isHalal => throw _privateConstructorUsedError;

  /// Date de création
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Date de dernière mise à jour
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Meal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MealCopyWith<Meal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MealCopyWith<$Res> {
  factory $MealCopyWith(Meal value, $Res Function(Meal) then) =
      _$MealCopyWithImpl<$Res, Meal>;
  @useResult
  $Res call(
      {String id,
      String merchantId,
      String title,
      String description,
      double originalPrice,
      double discountedPrice,
      MealCategory category,
      List<String> imageUrls,
      int quantity,
      int remainingQuantity,
      List<String> allergens,
      List<String> ingredients,
      NutritionalInfo? nutritionalInfo,
      DateTime availableFrom,
      DateTime availableUntil,
      MealStatus status,
      double averageRating,
      int ratingCount,
      bool isVegetarian,
      bool isVegan,
      bool isGlutenFree,
      bool isHalal,
      DateTime? createdAt,
      DateTime? updatedAt});

  $NutritionalInfoCopyWith<$Res>? get nutritionalInfo;
}

/// @nodoc
class _$MealCopyWithImpl<$Res, $Val extends Meal>
    implements $MealCopyWith<$Res> {
  _$MealCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? merchantId = null,
    Object? title = null,
    Object? description = null,
    Object? originalPrice = null,
    Object? discountedPrice = null,
    Object? category = null,
    Object? imageUrls = null,
    Object? quantity = null,
    Object? remainingQuantity = null,
    Object? allergens = null,
    Object? ingredients = null,
    Object? nutritionalInfo = freezed,
    Object? availableFrom = null,
    Object? availableUntil = null,
    Object? status = null,
    Object? averageRating = null,
    Object? ratingCount = null,
    Object? isVegetarian = null,
    Object? isVegan = null,
    Object? isGlutenFree = null,
    Object? isHalal = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountedPrice: null == discountedPrice
          ? _value.discountedPrice
          : discountedPrice // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as MealCategory,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      remainingQuantity: null == remainingQuantity
          ? _value.remainingQuantity
          : remainingQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      allergens: null == allergens
          ? _value.allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionalInfo: freezed == nutritionalInfo
          ? _value.nutritionalInfo
          : nutritionalInfo // ignore: cast_nullable_to_non_nullable
              as NutritionalInfo?,
      availableFrom: null == availableFrom
          ? _value.availableFrom
          : availableFrom // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableUntil: null == availableUntil
          ? _value.availableUntil
          : availableUntil // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MealStatus,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _value.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      isVegetarian: null == isVegetarian
          ? _value.isVegetarian
          : isVegetarian // ignore: cast_nullable_to_non_nullable
              as bool,
      isVegan: null == isVegan
          ? _value.isVegan
          : isVegan // ignore: cast_nullable_to_non_nullable
              as bool,
      isGlutenFree: null == isGlutenFree
          ? _value.isGlutenFree
          : isGlutenFree // ignore: cast_nullable_to_non_nullable
              as bool,
      isHalal: null == isHalal
          ? _value.isHalal
          : isHalal // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NutritionalInfoCopyWith<$Res>? get nutritionalInfo {
    if (_value.nutritionalInfo == null) {
      return null;
    }

    return $NutritionalInfoCopyWith<$Res>(_value.nutritionalInfo!, (value) {
      return _then(_value.copyWith(nutritionalInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MealImplCopyWith<$Res> implements $MealCopyWith<$Res> {
  factory _$$MealImplCopyWith(
          _$MealImpl value, $Res Function(_$MealImpl) then) =
      __$$MealImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String merchantId,
      String title,
      String description,
      double originalPrice,
      double discountedPrice,
      MealCategory category,
      List<String> imageUrls,
      int quantity,
      int remainingQuantity,
      List<String> allergens,
      List<String> ingredients,
      NutritionalInfo? nutritionalInfo,
      DateTime availableFrom,
      DateTime availableUntil,
      MealStatus status,
      double averageRating,
      int ratingCount,
      bool isVegetarian,
      bool isVegan,
      bool isGlutenFree,
      bool isHalal,
      DateTime? createdAt,
      DateTime? updatedAt});

  @override
  $NutritionalInfoCopyWith<$Res>? get nutritionalInfo;
}

/// @nodoc
class __$$MealImplCopyWithImpl<$Res>
    extends _$MealCopyWithImpl<$Res, _$MealImpl>
    implements _$$MealImplCopyWith<$Res> {
  __$$MealImplCopyWithImpl(_$MealImpl _value, $Res Function(_$MealImpl) _then)
      : super(_value, _then);

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? merchantId = null,
    Object? title = null,
    Object? description = null,
    Object? originalPrice = null,
    Object? discountedPrice = null,
    Object? category = null,
    Object? imageUrls = null,
    Object? quantity = null,
    Object? remainingQuantity = null,
    Object? allergens = null,
    Object? ingredients = null,
    Object? nutritionalInfo = freezed,
    Object? availableFrom = null,
    Object? availableUntil = null,
    Object? status = null,
    Object? averageRating = null,
    Object? ratingCount = null,
    Object? isVegetarian = null,
    Object? isVegan = null,
    Object? isGlutenFree = null,
    Object? isHalal = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$MealImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountedPrice: null == discountedPrice
          ? _value.discountedPrice
          : discountedPrice // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as MealCategory,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      remainingQuantity: null == remainingQuantity
          ? _value.remainingQuantity
          : remainingQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      allergens: null == allergens
          ? _value._allergens
          : allergens // ignore: cast_nullable_to_non_nullable
              as List<String>,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nutritionalInfo: freezed == nutritionalInfo
          ? _value.nutritionalInfo
          : nutritionalInfo // ignore: cast_nullable_to_non_nullable
              as NutritionalInfo?,
      availableFrom: null == availableFrom
          ? _value.availableFrom
          : availableFrom // ignore: cast_nullable_to_non_nullable
              as DateTime,
      availableUntil: null == availableUntil
          ? _value.availableUntil
          : availableUntil // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as MealStatus,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _value.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      isVegetarian: null == isVegetarian
          ? _value.isVegetarian
          : isVegetarian // ignore: cast_nullable_to_non_nullable
              as bool,
      isVegan: null == isVegan
          ? _value.isVegan
          : isVegan // ignore: cast_nullable_to_non_nullable
              as bool,
      isGlutenFree: null == isGlutenFree
          ? _value.isGlutenFree
          : isGlutenFree // ignore: cast_nullable_to_non_nullable
              as bool,
      isHalal: null == isHalal
          ? _value.isHalal
          : isHalal // ignore: cast_nullable_to_non_nullable
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
class _$MealImpl implements _Meal {
  const _$MealImpl(
      {required this.id,
      required this.merchantId,
      required this.title,
      required this.description,
      required this.originalPrice,
      required this.discountedPrice,
      required this.category,
      final List<String> imageUrls = const [],
      required this.quantity,
      this.remainingQuantity = 0,
      final List<String> allergens = const [],
      final List<String> ingredients = const [],
      this.nutritionalInfo,
      required this.availableFrom,
      required this.availableUntil,
      this.status = MealStatus.available,
      this.averageRating = 0.0,
      this.ratingCount = 0,
      this.isVegetarian = false,
      this.isVegan = false,
      this.isGlutenFree = false,
      this.isHalal = false,
      this.createdAt,
      this.updatedAt})
      : _imageUrls = imageUrls,
        _allergens = allergens,
        _ingredients = ingredients;

  factory _$MealImpl.fromJson(Map<String, dynamic> json) =>
      _$$MealImplFromJson(json);

  /// Identifiant unique du repas
  @override
  final String id;

  /// Identifiant du commerçant propriétaire
  @override
  final String merchantId;

  /// Nom/titre du repas
  @override
  final String title;

  /// Description détaillée
  @override
  final String description;

  /// Prix original
  @override
  final double originalPrice;

  /// Prix après réduction
  @override
  final double discountedPrice;

  /// Catégorie du repas
  @override
  final MealCategory category;

  /// URLs des images
  final List<String> _imageUrls;

  /// URLs des images
  @override
  @JsonKey()
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  /// Quantité disponible
  @override
  final int quantity;

  /// Quantité restante
  @override
  @JsonKey()
  final int remainingQuantity;

  /// Liste des allergènes
  final List<String> _allergens;

  /// Liste des allergènes
  @override
  @JsonKey()
  List<String> get allergens {
    if (_allergens is EqualUnmodifiableListView) return _allergens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allergens);
  }

  /// Liste des ingrédients
  final List<String> _ingredients;

  /// Liste des ingrédients
  @override
  @JsonKey()
  List<String> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  /// Informations nutritionnelles
  @override
  final NutritionalInfo? nutritionalInfo;

  /// Date/heure de disponibilité
  @override
  final DateTime availableFrom;

  /// Date/heure limite de récupération
  @override
  final DateTime availableUntil;

  /// Statut du repas
  @override
  @JsonKey()
  final MealStatus status;

  /// Note moyenne
  @override
  @JsonKey()
  final double averageRating;

  /// Nombre de votes
  @override
  @JsonKey()
  final int ratingCount;

  /// Indique si c'est végétarien
  @override
  @JsonKey()
  final bool isVegetarian;

  /// Indique si c'est végétalien
  @override
  @JsonKey()
  final bool isVegan;

  /// Indique si c'est sans gluten
  @override
  @JsonKey()
  final bool isGlutenFree;

  /// Indique si c'est halal
  @override
  @JsonKey()
  final bool isHalal;

  /// Date de création
  @override
  final DateTime? createdAt;

  /// Date de dernière mise à jour
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Meal(id: $id, merchantId: $merchantId, title: $title, description: $description, originalPrice: $originalPrice, discountedPrice: $discountedPrice, category: $category, imageUrls: $imageUrls, quantity: $quantity, remainingQuantity: $remainingQuantity, allergens: $allergens, ingredients: $ingredients, nutritionalInfo: $nutritionalInfo, availableFrom: $availableFrom, availableUntil: $availableUntil, status: $status, averageRating: $averageRating, ratingCount: $ratingCount, isVegetarian: $isVegetarian, isVegan: $isVegan, isGlutenFree: $isGlutenFree, isHalal: $isHalal, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MealImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.discountedPrice, discountedPrice) ||
                other.discountedPrice == discountedPrice) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.remainingQuantity, remainingQuantity) ||
                other.remainingQuantity == remainingQuantity) &&
            const DeepCollectionEquality()
                .equals(other._allergens, _allergens) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            (identical(other.nutritionalInfo, nutritionalInfo) ||
                other.nutritionalInfo == nutritionalInfo) &&
            (identical(other.availableFrom, availableFrom) ||
                other.availableFrom == availableFrom) &&
            (identical(other.availableUntil, availableUntil) ||
                other.availableUntil == availableUntil) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            (identical(other.isVegetarian, isVegetarian) ||
                other.isVegetarian == isVegetarian) &&
            (identical(other.isVegan, isVegan) || other.isVegan == isVegan) &&
            (identical(other.isGlutenFree, isGlutenFree) ||
                other.isGlutenFree == isGlutenFree) &&
            (identical(other.isHalal, isHalal) || other.isHalal == isHalal) &&
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
        merchantId,
        title,
        description,
        originalPrice,
        discountedPrice,
        category,
        const DeepCollectionEquality().hash(_imageUrls),
        quantity,
        remainingQuantity,
        const DeepCollectionEquality().hash(_allergens),
        const DeepCollectionEquality().hash(_ingredients),
        nutritionalInfo,
        availableFrom,
        availableUntil,
        status,
        averageRating,
        ratingCount,
        isVegetarian,
        isVegan,
        isGlutenFree,
        isHalal,
        createdAt,
        updatedAt
      ]);

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MealImplCopyWith<_$MealImpl> get copyWith =>
      __$$MealImplCopyWithImpl<_$MealImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MealImplToJson(
      this,
    );
  }
}

abstract class _Meal implements Meal {
  const factory _Meal(
      {required final String id,
      required final String merchantId,
      required final String title,
      required final String description,
      required final double originalPrice,
      required final double discountedPrice,
      required final MealCategory category,
      final List<String> imageUrls,
      required final int quantity,
      final int remainingQuantity,
      final List<String> allergens,
      final List<String> ingredients,
      final NutritionalInfo? nutritionalInfo,
      required final DateTime availableFrom,
      required final DateTime availableUntil,
      final MealStatus status,
      final double averageRating,
      final int ratingCount,
      final bool isVegetarian,
      final bool isVegan,
      final bool isGlutenFree,
      final bool isHalal,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$MealImpl;

  factory _Meal.fromJson(Map<String, dynamic> json) = _$MealImpl.fromJson;

  /// Identifiant unique du repas
  @override
  String get id;

  /// Identifiant du commerçant propriétaire
  @override
  String get merchantId;

  /// Nom/titre du repas
  @override
  String get title;

  /// Description détaillée
  @override
  String get description;

  /// Prix original
  @override
  double get originalPrice;

  /// Prix après réduction
  @override
  double get discountedPrice;

  /// Catégorie du repas
  @override
  MealCategory get category;

  /// URLs des images
  @override
  List<String> get imageUrls;

  /// Quantité disponible
  @override
  int get quantity;

  /// Quantité restante
  @override
  int get remainingQuantity;

  /// Liste des allergènes
  @override
  List<String> get allergens;

  /// Liste des ingrédients
  @override
  List<String> get ingredients;

  /// Informations nutritionnelles
  @override
  NutritionalInfo? get nutritionalInfo;

  /// Date/heure de disponibilité
  @override
  DateTime get availableFrom;

  /// Date/heure limite de récupération
  @override
  DateTime get availableUntil;

  /// Statut du repas
  @override
  MealStatus get status;

  /// Note moyenne
  @override
  double get averageRating;

  /// Nombre de votes
  @override
  int get ratingCount;

  /// Indique si c'est végétarien
  @override
  bool get isVegetarian;

  /// Indique si c'est végétalien
  @override
  bool get isVegan;

  /// Indique si c'est sans gluten
  @override
  bool get isGlutenFree;

  /// Indique si c'est halal
  @override
  bool get isHalal;

  /// Date de création
  @override
  DateTime? get createdAt;

  /// Date de dernière mise à jour
  @override
  DateTime? get updatedAt;

  /// Create a copy of Meal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MealImplCopyWith<_$MealImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NutritionalInfo _$NutritionalInfoFromJson(Map<String, dynamic> json) {
  return _NutritionalInfo.fromJson(json);
}

/// @nodoc
mixin _$NutritionalInfo {
  /// Calories (kcal)
  int? get calories => throw _privateConstructorUsedError;

  /// Protéines (g)
  double? get proteins => throw _privateConstructorUsedError;

  /// Glucides (g)
  double? get carbohydrates => throw _privateConstructorUsedError;

  /// Lipides (g)
  double? get fats => throw _privateConstructorUsedError;

  /// Fibres (g)
  double? get fiber => throw _privateConstructorUsedError;

  /// Sucres (g)
  double? get sugar => throw _privateConstructorUsedError;

  /// Sodium (mg)
  double? get sodium => throw _privateConstructorUsedError;

  /// Serializes this NutritionalInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NutritionalInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NutritionalInfoCopyWith<NutritionalInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NutritionalInfoCopyWith<$Res> {
  factory $NutritionalInfoCopyWith(
          NutritionalInfo value, $Res Function(NutritionalInfo) then) =
      _$NutritionalInfoCopyWithImpl<$Res, NutritionalInfo>;
  @useResult
  $Res call(
      {int? calories,
      double? proteins,
      double? carbohydrates,
      double? fats,
      double? fiber,
      double? sugar,
      double? sodium});
}

/// @nodoc
class _$NutritionalInfoCopyWithImpl<$Res, $Val extends NutritionalInfo>
    implements $NutritionalInfoCopyWith<$Res> {
  _$NutritionalInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NutritionalInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? calories = freezed,
    Object? proteins = freezed,
    Object? carbohydrates = freezed,
    Object? fats = freezed,
    Object? fiber = freezed,
    Object? sugar = freezed,
    Object? sodium = freezed,
  }) {
    return _then(_value.copyWith(
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int?,
      proteins: freezed == proteins
          ? _value.proteins
          : proteins // ignore: cast_nullable_to_non_nullable
              as double?,
      carbohydrates: freezed == carbohydrates
          ? _value.carbohydrates
          : carbohydrates // ignore: cast_nullable_to_non_nullable
              as double?,
      fats: freezed == fats
          ? _value.fats
          : fats // ignore: cast_nullable_to_non_nullable
              as double?,
      fiber: freezed == fiber
          ? _value.fiber
          : fiber // ignore: cast_nullable_to_non_nullable
              as double?,
      sugar: freezed == sugar
          ? _value.sugar
          : sugar // ignore: cast_nullable_to_non_nullable
              as double?,
      sodium: freezed == sodium
          ? _value.sodium
          : sodium // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NutritionalInfoImplCopyWith<$Res>
    implements $NutritionalInfoCopyWith<$Res> {
  factory _$$NutritionalInfoImplCopyWith(_$NutritionalInfoImpl value,
          $Res Function(_$NutritionalInfoImpl) then) =
      __$$NutritionalInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? calories,
      double? proteins,
      double? carbohydrates,
      double? fats,
      double? fiber,
      double? sugar,
      double? sodium});
}

/// @nodoc
class __$$NutritionalInfoImplCopyWithImpl<$Res>
    extends _$NutritionalInfoCopyWithImpl<$Res, _$NutritionalInfoImpl>
    implements _$$NutritionalInfoImplCopyWith<$Res> {
  __$$NutritionalInfoImplCopyWithImpl(
      _$NutritionalInfoImpl _value, $Res Function(_$NutritionalInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of NutritionalInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? calories = freezed,
    Object? proteins = freezed,
    Object? carbohydrates = freezed,
    Object? fats = freezed,
    Object? fiber = freezed,
    Object? sugar = freezed,
    Object? sodium = freezed,
  }) {
    return _then(_$NutritionalInfoImpl(
      calories: freezed == calories
          ? _value.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int?,
      proteins: freezed == proteins
          ? _value.proteins
          : proteins // ignore: cast_nullable_to_non_nullable
              as double?,
      carbohydrates: freezed == carbohydrates
          ? _value.carbohydrates
          : carbohydrates // ignore: cast_nullable_to_non_nullable
              as double?,
      fats: freezed == fats
          ? _value.fats
          : fats // ignore: cast_nullable_to_non_nullable
              as double?,
      fiber: freezed == fiber
          ? _value.fiber
          : fiber // ignore: cast_nullable_to_non_nullable
              as double?,
      sugar: freezed == sugar
          ? _value.sugar
          : sugar // ignore: cast_nullable_to_non_nullable
              as double?,
      sodium: freezed == sodium
          ? _value.sodium
          : sodium // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NutritionalInfoImpl implements _NutritionalInfo {
  const _$NutritionalInfoImpl(
      {this.calories,
      this.proteins,
      this.carbohydrates,
      this.fats,
      this.fiber,
      this.sugar,
      this.sodium});

  factory _$NutritionalInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$NutritionalInfoImplFromJson(json);

  /// Calories (kcal)
  @override
  final int? calories;

  /// Protéines (g)
  @override
  final double? proteins;

  /// Glucides (g)
  @override
  final double? carbohydrates;

  /// Lipides (g)
  @override
  final double? fats;

  /// Fibres (g)
  @override
  final double? fiber;

  /// Sucres (g)
  @override
  final double? sugar;

  /// Sodium (mg)
  @override
  final double? sodium;

  @override
  String toString() {
    return 'NutritionalInfo(calories: $calories, proteins: $proteins, carbohydrates: $carbohydrates, fats: $fats, fiber: $fiber, sugar: $sugar, sodium: $sodium)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NutritionalInfoImpl &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.proteins, proteins) ||
                other.proteins == proteins) &&
            (identical(other.carbohydrates, carbohydrates) ||
                other.carbohydrates == carbohydrates) &&
            (identical(other.fats, fats) || other.fats == fats) &&
            (identical(other.fiber, fiber) || other.fiber == fiber) &&
            (identical(other.sugar, sugar) || other.sugar == sugar) &&
            (identical(other.sodium, sodium) || other.sodium == sodium));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, calories, proteins,
      carbohydrates, fats, fiber, sugar, sodium);

  /// Create a copy of NutritionalInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NutritionalInfoImplCopyWith<_$NutritionalInfoImpl> get copyWith =>
      __$$NutritionalInfoImplCopyWithImpl<_$NutritionalInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NutritionalInfoImplToJson(
      this,
    );
  }
}

abstract class _NutritionalInfo implements NutritionalInfo {
  const factory _NutritionalInfo(
      {final int? calories,
      final double? proteins,
      final double? carbohydrates,
      final double? fats,
      final double? fiber,
      final double? sugar,
      final double? sodium}) = _$NutritionalInfoImpl;

  factory _NutritionalInfo.fromJson(Map<String, dynamic> json) =
      _$NutritionalInfoImpl.fromJson;

  /// Calories (kcal)
  @override
  int? get calories;

  /// Protéines (g)
  @override
  double? get proteins;

  /// Glucides (g)
  @override
  double? get carbohydrates;

  /// Lipides (g)
  @override
  double? get fats;

  /// Fibres (g)
  @override
  double? get fiber;

  /// Sucres (g)
  @override
  double? get sugar;

  /// Sodium (mg)
  @override
  double? get sodium;

  /// Create a copy of NutritionalInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NutritionalInfoImplCopyWith<_$NutritionalInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
