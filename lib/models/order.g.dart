// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      merchantId: json['merchantId'] as String,
      mealId: json['mealId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      status: $enumDecodeNullable(_$OrderStatusEnumMap, json['status']) ??
          OrderStatus.pending,
      paymentMethod:
          $enumDecodeNullable(_$PaymentMethodEnumMap, json['paymentMethod']),
      paymentStatus:
          $enumDecodeNullable(_$PaymentStatusEnumMap, json['paymentStatus']) ??
              PaymentStatus.pending,
      paymentTransactionId: json['paymentTransactionId'] as String?,
      pickupCode: json['pickupCode'] as String?,
      specialInstructions: json['specialInstructions'] as String?,
      studentRating: (json['studentRating'] as num?)?.toInt(),
      studentComment: json['studentComment'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      confirmedAt: json['confirmedAt'] == null
          ? null
          : DateTime.parse(json['confirmedAt'] as String),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      preparedAt: json['preparedAt'] == null
          ? null
          : DateTime.parse(json['preparedAt'] as String),
      pickedUpAt: json['pickedUpAt'] == null
          ? null
          : DateTime.parse(json['pickedUpAt'] as String),
      cancelledAt: json['cancelledAt'] == null
          ? null
          : DateTime.parse(json['cancelledAt'] as String),
      cancellationReason: json['cancellationReason'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'merchantId': instance.merchantId,
      'mealId': instance.mealId,
      'quantity': instance.quantity,
      'totalPrice': instance.totalPrice,
      'unitPrice': instance.unitPrice,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod],
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'paymentTransactionId': instance.paymentTransactionId,
      'pickupCode': instance.pickupCode,
      'specialInstructions': instance.specialInstructions,
      'studentRating': instance.studentRating,
      'studentComment': instance.studentComment,
      'createdAt': instance.createdAt.toIso8601String(),
      'confirmedAt': instance.confirmedAt?.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
      'preparedAt': instance.preparedAt?.toIso8601String(),
      'pickedUpAt': instance.pickedUpAt?.toIso8601String(),
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'cancellationReason': instance.cancellationReason,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.confirmed: 'confirmed',
  OrderStatus.preparing: 'preparing',
  OrderStatus.ready: 'ready',
  OrderStatus.pickedUp: 'picked_up',
  OrderStatus.cancelled: 'cancelled',
  OrderStatus.expired: 'expired',
};

const _$PaymentMethodEnumMap = {
  PaymentMethod.creditCard: 'credit_card',
  PaymentMethod.mobilePayment: 'mobile_payment',
  PaymentMethod.digitalWallet: 'digital_wallet',
  PaymentMethod.studentPoints: 'student_points',
  PaymentMethod.payOnPickup: 'pay_on_pickup',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.paid: 'paid',
  PaymentStatus.failed: 'failed',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.refunding: 'refunding',
};
