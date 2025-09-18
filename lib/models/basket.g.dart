// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Basket _$BasketFromJson(Map<String, dynamic> json) => Basket(
      id: json['id'] as String,
      shopId: json['shop_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['original_price'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      type: json['type'] as String,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      availableFrom: json['available_from'] == null
          ? null
          : DateTime.parse(json['available_from'] as String),
      availableUntil: DateTime.parse(json['available_until'] as String),
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$BasketToJson(Basket instance) => <String, dynamic>{
      'id': instance.id,
      'shop_id': instance.shopId,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'original_price': instance.originalPrice,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'type': instance.type,
      'quantity': instance.quantity,
      'available_from': instance.availableFrom?.toIso8601String(),
      'available_until': instance.availableUntil.toIso8601String(),
      'image_url': instance.imageUrl,
      'is_active': instance.isActive,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
