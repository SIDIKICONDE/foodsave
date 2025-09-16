// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RestaurantImpl _$$RestaurantImplFromJson(Map<String, dynamic> json) =>
    _$RestaurantImpl(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$RestaurantTypeEnumMap, json['type']),
      coverImageUrl: json['coverImageUrl'] as String?,
      logoUrl: json['logoUrl'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      address: json['address'] as String,
      city: json['city'] as String,
      postalCode: json['postalCode'] as String,
      coordinates: LocationCoordinates.fromJson(
          json['coordinates'] as Map<String, dynamic>),
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      openingHours: (json['openingHours'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, OpeningHours.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      totalMealsSold: (json['totalMealsSold'] as num?)?.toInt() ?? 0,
      totalSavingsGenerated:
          (json['totalSavingsGenerated'] as num?)?.toDouble() ?? 0.0,
      specialties: (json['specialties'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$RestaurantCertificationEnumMap, e))
              .toList() ??
          const [],
      deliveryRadius: (json['deliveryRadius'] as num?)?.toDouble() ?? 5.0,
      averagePreparationTime:
          (json['averagePreparationTime'] as num?)?.toInt() ?? 15,
      isOpen: json['isOpen'] as bool? ?? true,
      isActive: json['isActive'] as bool? ?? true,
      isVerified: json['isVerified'] as bool? ?? false,
      offersDelivery: json['offersDelivery'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$RestaurantImplToJson(_$RestaurantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'name': instance.name,
      'description': instance.description,
      'type': _$RestaurantTypeEnumMap[instance.type]!,
      'coverImageUrl': instance.coverImageUrl,
      'logoUrl': instance.logoUrl,
      'imageUrls': instance.imageUrls,
      'address': instance.address,
      'city': instance.city,
      'postalCode': instance.postalCode,
      'coordinates': instance.coordinates,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'website': instance.website,
      'openingHours': instance.openingHours,
      'averageRating': instance.averageRating,
      'totalReviews': instance.totalReviews,
      'totalMealsSold': instance.totalMealsSold,
      'totalSavingsGenerated': instance.totalSavingsGenerated,
      'specialties': instance.specialties,
      'certifications': instance.certifications
          .map((e) => _$RestaurantCertificationEnumMap[e]!)
          .toList(),
      'deliveryRadius': instance.deliveryRadius,
      'averagePreparationTime': instance.averagePreparationTime,
      'isOpen': instance.isOpen,
      'isActive': instance.isActive,
      'isVerified': instance.isVerified,
      'offersDelivery': instance.offersDelivery,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$RestaurantTypeEnumMap = {
  RestaurantType.restaurant: 'restaurant',
  RestaurantType.bakery: 'bakery',
  RestaurantType.cafe: 'cafe',
  RestaurantType.fastFood: 'fast_food',
  RestaurantType.caterer: 'caterer',
  RestaurantType.foodTruck: 'food_truck',
  RestaurantType.supermarket: 'supermarket',
  RestaurantType.groceryStore: 'grocery_store',
  RestaurantType.other: 'other',
};

const _$RestaurantCertificationEnumMap = {
  RestaurantCertification.organic: 'organic',
  RestaurantCertification.halal: 'halal',
  RestaurantCertification.kosher: 'kosher',
  RestaurantCertification.fairTrade: 'fair_trade',
  RestaurantCertification.sustainable: 'sustainable',
  RestaurantCertification.local: 'local',
};

_$LocationCoordinatesImpl _$$LocationCoordinatesImplFromJson(
        Map<String, dynamic> json) =>
    _$LocationCoordinatesImpl(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$LocationCoordinatesImplToJson(
        _$LocationCoordinatesImpl instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_$OpeningHoursImpl _$$OpeningHoursImplFromJson(Map<String, dynamic> json) =>
    _$OpeningHoursImpl(
      openTime: json['openTime'] as String,
      closeTime: json['closeTime'] as String,
      isClosed: json['isClosed'] as bool? ?? false,
      lunchBreak: json['lunchBreak'] == null
          ? null
          : TimeSlot.fromJson(json['lunchBreak'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OpeningHoursImplToJson(_$OpeningHoursImpl instance) =>
    <String, dynamic>{
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
      'isClosed': instance.isClosed,
      'lunchBreak': instance.lunchBreak,
    };

_$TimeSlotImpl _$$TimeSlotImplFromJson(Map<String, dynamic> json) =>
    _$TimeSlotImpl(
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );

Map<String, dynamic> _$$TimeSlotImplToJson(_$TimeSlotImpl instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
