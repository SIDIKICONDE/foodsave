// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Order _$OrderFromJson(Map<String, dynamic> json) {
  return _Order.fromJson(json);
}

/// @nodoc
mixin _$Order {
  /// Identifiant unique de la commande
  String get id => throw _privateConstructorUsedError;

  /// Identifiant de l'étudiant
  String get studentId => throw _privateConstructorUsedError;

  /// Identifiant du commerçant
  String get merchantId => throw _privateConstructorUsedError;

  /// Identifiant du repas
  String get mealId => throw _privateConstructorUsedError;

  /// Quantité commandée
  int get quantity => throw _privateConstructorUsedError;

  /// Prix total de la commande
  double get totalPrice => throw _privateConstructorUsedError;

  /// Prix unitaire au moment de la commande
  double get unitPrice => throw _privateConstructorUsedError;

  /// Statut de la commande
  OrderStatus get status => throw _privateConstructorUsedError;

  /// Mode de paiement
  PaymentMethod? get paymentMethod => throw _privateConstructorUsedError;

  /// Statut du paiement
  PaymentStatus get paymentStatus => throw _privateConstructorUsedError;

  /// ID de transaction de paiement
  String? get paymentTransactionId => throw _privateConstructorUsedError;

  /// Code de récupération (QR Code)
  String? get pickupCode => throw _privateConstructorUsedError;

  /// Instructions spéciales
  String? get specialInstructions => throw _privateConstructorUsedError;

  /// Note de l'étudiant (1-5)
  int? get studentRating => throw _privateConstructorUsedError;

  /// Commentaire de l'étudiant
  String? get studentComment => throw _privateConstructorUsedError;

  /// Date de création de la commande
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Date de confirmation
  DateTime? get confirmedAt => throw _privateConstructorUsedError;

  /// Date de paiement
  DateTime? get paidAt => throw _privateConstructorUsedError;

  /// Date de préparation
  DateTime? get preparedAt => throw _privateConstructorUsedError;

  /// Date de récupération
  DateTime? get pickedUpAt => throw _privateConstructorUsedError;

  /// Date d'annulation
  DateTime? get cancelledAt => throw _privateConstructorUsedError;

  /// Raison d'annulation
  String? get cancellationReason => throw _privateConstructorUsedError;

  /// Date de dernière mise à jour
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Order to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderCopyWith<Order> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderCopyWith<$Res> {
  factory $OrderCopyWith(Order value, $Res Function(Order) then) =
      _$OrderCopyWithImpl<$Res, Order>;
  @useResult
  $Res call(
      {String id,
      String studentId,
      String merchantId,
      String mealId,
      int quantity,
      double totalPrice,
      double unitPrice,
      OrderStatus status,
      PaymentMethod? paymentMethod,
      PaymentStatus paymentStatus,
      String? paymentTransactionId,
      String? pickupCode,
      String? specialInstructions,
      int? studentRating,
      String? studentComment,
      DateTime createdAt,
      DateTime? confirmedAt,
      DateTime? paidAt,
      DateTime? preparedAt,
      DateTime? pickedUpAt,
      DateTime? cancelledAt,
      String? cancellationReason,
      DateTime? updatedAt});
}

/// @nodoc
class _$OrderCopyWithImpl<$Res, $Val extends Order>
    implements $OrderCopyWith<$Res> {
  _$OrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? merchantId = null,
    Object? mealId = null,
    Object? quantity = null,
    Object? totalPrice = null,
    Object? unitPrice = null,
    Object? status = null,
    Object? paymentMethod = freezed,
    Object? paymentStatus = null,
    Object? paymentTransactionId = freezed,
    Object? pickupCode = freezed,
    Object? specialInstructions = freezed,
    Object? studentRating = freezed,
    Object? studentComment = freezed,
    Object? createdAt = null,
    Object? confirmedAt = freezed,
    Object? paidAt = freezed,
    Object? preparedAt = freezed,
    Object? pickedUpAt = freezed,
    Object? cancelledAt = freezed,
    Object? cancellationReason = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      mealId: null == mealId
          ? _value.mealId
          : mealId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod?,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      paymentTransactionId: freezed == paymentTransactionId
          ? _value.paymentTransactionId
          : paymentTransactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      pickupCode: freezed == pickupCode
          ? _value.pickupCode
          : pickupCode // ignore: cast_nullable_to_non_nullable
              as String?,
      specialInstructions: freezed == specialInstructions
          ? _value.specialInstructions
          : specialInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      studentRating: freezed == studentRating
          ? _value.studentRating
          : studentRating // ignore: cast_nullable_to_non_nullable
              as int?,
      studentComment: freezed == studentComment
          ? _value.studentComment
          : studentComment // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      preparedAt: freezed == preparedAt
          ? _value.preparedAt
          : preparedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickedUpAt: freezed == pickedUpAt
          ? _value.pickedUpAt
          : pickedUpAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderImplCopyWith<$Res> implements $OrderCopyWith<$Res> {
  factory _$$OrderImplCopyWith(
          _$OrderImpl value, $Res Function(_$OrderImpl) then) =
      __$$OrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String studentId,
      String merchantId,
      String mealId,
      int quantity,
      double totalPrice,
      double unitPrice,
      OrderStatus status,
      PaymentMethod? paymentMethod,
      PaymentStatus paymentStatus,
      String? paymentTransactionId,
      String? pickupCode,
      String? specialInstructions,
      int? studentRating,
      String? studentComment,
      DateTime createdAt,
      DateTime? confirmedAt,
      DateTime? paidAt,
      DateTime? preparedAt,
      DateTime? pickedUpAt,
      DateTime? cancelledAt,
      String? cancellationReason,
      DateTime? updatedAt});
}

/// @nodoc
class __$$OrderImplCopyWithImpl<$Res>
    extends _$OrderCopyWithImpl<$Res, _$OrderImpl>
    implements _$$OrderImplCopyWith<$Res> {
  __$$OrderImplCopyWithImpl(
      _$OrderImpl _value, $Res Function(_$OrderImpl) _then)
      : super(_value, _then);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? studentId = null,
    Object? merchantId = null,
    Object? mealId = null,
    Object? quantity = null,
    Object? totalPrice = null,
    Object? unitPrice = null,
    Object? status = null,
    Object? paymentMethod = freezed,
    Object? paymentStatus = null,
    Object? paymentTransactionId = freezed,
    Object? pickupCode = freezed,
    Object? specialInstructions = freezed,
    Object? studentRating = freezed,
    Object? studentComment = freezed,
    Object? createdAt = null,
    Object? confirmedAt = freezed,
    Object? paidAt = freezed,
    Object? preparedAt = freezed,
    Object? pickedUpAt = freezed,
    Object? cancelledAt = freezed,
    Object? cancellationReason = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$OrderImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      studentId: null == studentId
          ? _value.studentId
          : studentId // ignore: cast_nullable_to_non_nullable
              as String,
      merchantId: null == merchantId
          ? _value.merchantId
          : merchantId // ignore: cast_nullable_to_non_nullable
              as String,
      mealId: null == mealId
          ? _value.mealId
          : mealId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      unitPrice: null == unitPrice
          ? _value.unitPrice
          : unitPrice // ignore: cast_nullable_to_non_nullable
              as double,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as OrderStatus,
      paymentMethod: freezed == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as PaymentMethod?,
      paymentStatus: null == paymentStatus
          ? _value.paymentStatus
          : paymentStatus // ignore: cast_nullable_to_non_nullable
              as PaymentStatus,
      paymentTransactionId: freezed == paymentTransactionId
          ? _value.paymentTransactionId
          : paymentTransactionId // ignore: cast_nullable_to_non_nullable
              as String?,
      pickupCode: freezed == pickupCode
          ? _value.pickupCode
          : pickupCode // ignore: cast_nullable_to_non_nullable
              as String?,
      specialInstructions: freezed == specialInstructions
          ? _value.specialInstructions
          : specialInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      studentRating: freezed == studentRating
          ? _value.studentRating
          : studentRating // ignore: cast_nullable_to_non_nullable
              as int?,
      studentComment: freezed == studentComment
          ? _value.studentComment
          : studentComment // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confirmedAt: freezed == confirmedAt
          ? _value.confirmedAt
          : confirmedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      paidAt: freezed == paidAt
          ? _value.paidAt
          : paidAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      preparedAt: freezed == preparedAt
          ? _value.preparedAt
          : preparedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      pickedUpAt: freezed == pickedUpAt
          ? _value.pickedUpAt
          : pickedUpAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancelledAt: freezed == cancelledAt
          ? _value.cancelledAt
          : cancelledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cancellationReason: freezed == cancellationReason
          ? _value.cancellationReason
          : cancellationReason // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderImpl implements _Order {
  const _$OrderImpl(
      {required this.id,
      required this.studentId,
      required this.merchantId,
      required this.mealId,
      required this.quantity,
      required this.totalPrice,
      required this.unitPrice,
      this.status = OrderStatus.pending,
      this.paymentMethod,
      this.paymentStatus = PaymentStatus.pending,
      this.paymentTransactionId,
      this.pickupCode,
      this.specialInstructions,
      this.studentRating,
      this.studentComment,
      required this.createdAt,
      this.confirmedAt,
      this.paidAt,
      this.preparedAt,
      this.pickedUpAt,
      this.cancelledAt,
      this.cancellationReason,
      this.updatedAt});

  factory _$OrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderImplFromJson(json);

  /// Identifiant unique de la commande
  @override
  final String id;

  /// Identifiant de l'étudiant
  @override
  final String studentId;

  /// Identifiant du commerçant
  @override
  final String merchantId;

  /// Identifiant du repas
  @override
  final String mealId;

  /// Quantité commandée
  @override
  final int quantity;

  /// Prix total de la commande
  @override
  final double totalPrice;

  /// Prix unitaire au moment de la commande
  @override
  final double unitPrice;

  /// Statut de la commande
  @override
  @JsonKey()
  final OrderStatus status;

  /// Mode de paiement
  @override
  final PaymentMethod? paymentMethod;

  /// Statut du paiement
  @override
  @JsonKey()
  final PaymentStatus paymentStatus;

  /// ID de transaction de paiement
  @override
  final String? paymentTransactionId;

  /// Code de récupération (QR Code)
  @override
  final String? pickupCode;

  /// Instructions spéciales
  @override
  final String? specialInstructions;

  /// Note de l'étudiant (1-5)
  @override
  final int? studentRating;

  /// Commentaire de l'étudiant
  @override
  final String? studentComment;

  /// Date de création de la commande
  @override
  final DateTime createdAt;

  /// Date de confirmation
  @override
  final DateTime? confirmedAt;

  /// Date de paiement
  @override
  final DateTime? paidAt;

  /// Date de préparation
  @override
  final DateTime? preparedAt;

  /// Date de récupération
  @override
  final DateTime? pickedUpAt;

  /// Date d'annulation
  @override
  final DateTime? cancelledAt;

  /// Raison d'annulation
  @override
  final String? cancellationReason;

  /// Date de dernière mise à jour
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Order(id: $id, studentId: $studentId, merchantId: $merchantId, mealId: $mealId, quantity: $quantity, totalPrice: $totalPrice, unitPrice: $unitPrice, status: $status, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, paymentTransactionId: $paymentTransactionId, pickupCode: $pickupCode, specialInstructions: $specialInstructions, studentRating: $studentRating, studentComment: $studentComment, createdAt: $createdAt, confirmedAt: $confirmedAt, paidAt: $paidAt, preparedAt: $preparedAt, pickedUpAt: $pickedUpAt, cancelledAt: $cancelledAt, cancellationReason: $cancellationReason, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.merchantId, merchantId) ||
                other.merchantId == merchantId) &&
            (identical(other.mealId, mealId) || other.mealId == mealId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.paymentTransactionId, paymentTransactionId) ||
                other.paymentTransactionId == paymentTransactionId) &&
            (identical(other.pickupCode, pickupCode) ||
                other.pickupCode == pickupCode) &&
            (identical(other.specialInstructions, specialInstructions) ||
                other.specialInstructions == specialInstructions) &&
            (identical(other.studentRating, studentRating) ||
                other.studentRating == studentRating) &&
            (identical(other.studentComment, studentComment) ||
                other.studentComment == studentComment) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.confirmedAt, confirmedAt) ||
                other.confirmedAt == confirmedAt) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt) &&
            (identical(other.preparedAt, preparedAt) ||
                other.preparedAt == preparedAt) &&
            (identical(other.pickedUpAt, pickedUpAt) ||
                other.pickedUpAt == pickedUpAt) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.cancellationReason, cancellationReason) ||
                other.cancellationReason == cancellationReason) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        studentId,
        merchantId,
        mealId,
        quantity,
        totalPrice,
        unitPrice,
        status,
        paymentMethod,
        paymentStatus,
        paymentTransactionId,
        pickupCode,
        specialInstructions,
        studentRating,
        studentComment,
        createdAt,
        confirmedAt,
        paidAt,
        preparedAt,
        pickedUpAt,
        cancelledAt,
        cancellationReason,
        updatedAt
      ]);

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      __$$OrderImplCopyWithImpl<_$OrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderImplToJson(
      this,
    );
  }
}

abstract class _Order implements Order {
  const factory _Order(
      {required final String id,
      required final String studentId,
      required final String merchantId,
      required final String mealId,
      required final int quantity,
      required final double totalPrice,
      required final double unitPrice,
      final OrderStatus status,
      final PaymentMethod? paymentMethod,
      final PaymentStatus paymentStatus,
      final String? paymentTransactionId,
      final String? pickupCode,
      final String? specialInstructions,
      final int? studentRating,
      final String? studentComment,
      required final DateTime createdAt,
      final DateTime? confirmedAt,
      final DateTime? paidAt,
      final DateTime? preparedAt,
      final DateTime? pickedUpAt,
      final DateTime? cancelledAt,
      final String? cancellationReason,
      final DateTime? updatedAt}) = _$OrderImpl;

  factory _Order.fromJson(Map<String, dynamic> json) = _$OrderImpl.fromJson;

  /// Identifiant unique de la commande
  @override
  String get id;

  /// Identifiant de l'étudiant
  @override
  String get studentId;

  /// Identifiant du commerçant
  @override
  String get merchantId;

  /// Identifiant du repas
  @override
  String get mealId;

  /// Quantité commandée
  @override
  int get quantity;

  /// Prix total de la commande
  @override
  double get totalPrice;

  /// Prix unitaire au moment de la commande
  @override
  double get unitPrice;

  /// Statut de la commande
  @override
  OrderStatus get status;

  /// Mode de paiement
  @override
  PaymentMethod? get paymentMethod;

  /// Statut du paiement
  @override
  PaymentStatus get paymentStatus;

  /// ID de transaction de paiement
  @override
  String? get paymentTransactionId;

  /// Code de récupération (QR Code)
  @override
  String? get pickupCode;

  /// Instructions spéciales
  @override
  String? get specialInstructions;

  /// Note de l'étudiant (1-5)
  @override
  int? get studentRating;

  /// Commentaire de l'étudiant
  @override
  String? get studentComment;

  /// Date de création de la commande
  @override
  DateTime get createdAt;

  /// Date de confirmation
  @override
  DateTime? get confirmedAt;

  /// Date de paiement
  @override
  DateTime? get paidAt;

  /// Date de préparation
  @override
  DateTime? get preparedAt;

  /// Date de récupération
  @override
  DateTime? get pickedUpAt;

  /// Date d'annulation
  @override
  DateTime? get cancelledAt;

  /// Raison d'annulation
  @override
  String? get cancellationReason;

  /// Date de dernière mise à jour
  @override
  DateTime? get updatedAt;

  /// Create a copy of Order
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderImplCopyWith<_$OrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
