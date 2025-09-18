// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MealImpl _$$MealImplFromJson(Map<String, dynamic> json) => _$MealImpl(
      id: json['id'] as String,
      merchantId: json['merchantId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountedPrice: (json['discountedPrice'] as num).toDouble(),
      category: $enumDecode(_$MealCategoryEnumMap, json['category']),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      quantity: (json['quantity'] as num).toInt(),
      remainingQuantity: (json['remainingQuantity'] as num?)?.toInt() ?? 0,
      allergens: (json['allergens'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      nutritionalInfo: json['nutritionalInfo'] == null
          ? null
          : NutritionalInfo.fromJson(
              json['nutritionalInfo'] as Map<String, dynamic>),
      availableFrom: DateTime.parse(json['availableFrom'] as String),
      availableUntil: DateTime.parse(json['availableUntil'] as String),
      status: $enumDecodeNullable(_$MealStatusEnumMap, json['status']) ??
          MealStatus.available,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isVegan: json['isVegan'] as bool? ?? false,
      isGlutenFree: json['isGlutenFree'] as bool? ?? false,
      isHalal: json['isHalal'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MealImplToJson(_$MealImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'merchantId': instance.merchantId,
      'title': instance.title,
      'description': instance.description,
      'originalPrice': instance.originalPrice,
      'discountedPrice': instance.discountedPrice,
      'category': _$MealCategoryEnumMap[instance.category]!,
      'imageUrls': instance.imageUrls,
      'quantity': instance.quantity,
      'remainingQuantity': instance.remainingQuantity,
      'allergens': instance.allergens,
      'ingredients': instance.ingredients,
      'nutritionalInfo': instance.nutritionalInfo,
      'availableFrom': instance.availableFrom.toIso8601String(),
      'availableUntil': instance.availableUntil.toIso8601String(),
      'status': _$MealStatusEnumMap[instance.status]!,
      'averageRating': instance.averageRating,
      'ratingCount': instance.ratingCount,
      'isVegetarian': instance.isVegetarian,
      'isVegan': instance.isVegan,
      'isGlutenFree': instance.isGlutenFree,
      'isHalal': instance.isHalal,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$MealCategoryEnumMap = {
  MealCategory.mainCourse: 'main_course',
  MealCategory.appetizer: 'appetizer',
  MealCategory.dessert: 'dessert',
  MealCategory.beverage: 'beverage',
  MealCategory.snack: 'snack',
  MealCategory.bakery: 'bakery',
  MealCategory.other: 'other',
};

const _$MealStatusEnumMap = {
  MealStatus.available: 'available',
  MealStatus.soldOut: 'sold_out',
  MealStatus.expired: 'expired',
  MealStatus.suspended: 'suspended',
};

_$NutritionalInfoImpl _$$NutritionalInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$NutritionalInfoImpl(
      calories: (json['calories'] as num?)?.toInt(),
      proteins: (json['proteins'] as num?)?.toDouble(),
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble(),
      fats: (json['fats'] as num?)?.toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble(),
      sugar: (json['sugar'] as num?)?.toDouble(),
      sodium: (json['sodium'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$NutritionalInfoImplToJson(
        _$NutritionalInfoImpl instance) =>
    <String, dynamic>{
      'calories': instance.calories,
      'proteins': instance.proteins,
      'carbohydrates': instance.carbohydrates,
      'fats': instance.fats,
      'fiber': instance.fiber,
      'sugar': instance.sugar,
      'sodium': instance.sodium,
    };
