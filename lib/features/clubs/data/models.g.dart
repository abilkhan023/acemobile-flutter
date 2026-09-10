// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Branch _$BranchFromJson(Map<String, dynamic> json) => _Branch(
  id: json['id'] as String,
  name: json['name'] as String?,
  address: json['address'] as String?,
  gameCenterId: json['game_center_id'] as String?,
  isAvailable: json['is_available'] as bool?,
  latitude: numFromJson(json['latitude']),
  longitude: numFromJson(json['longitude']),
  description: json['description'] as String?,
  phone: json['phone'] as String?,
  workTime: json['work_time'] as String?,
  rating: numFromJson(json['rating']),
);

Map<String, dynamic> _$BranchToJson(_Branch instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'game_center_id': instance.gameCenterId,
  'is_available': instance.isAvailable,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'description': instance.description,
  'phone': instance.phone,
  'work_time': instance.workTime,
  'rating': instance.rating,
};

_GameCenter _$GameCenterFromJson(Map<String, dynamic> json) => _GameCenter(
  id: json['id'] as String,
  name: json['name'] as String?,
  logo: json['logo'] as String?,
  slug: json['slug'] as String?,
  address: json['address'] as String?,
  description: json['description'] as String?,
  latitude: numFromJson(json['latitude']),
  longitude: numFromJson(json['longitude']),
  isAvailable: json['is_available'] as bool?,
);

Map<String, dynamic> _$GameCenterToJson(_GameCenter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
      'slug': instance.slug,
      'address': instance.address,
      'description': instance.description,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'is_available': instance.isAvailable,
    };

_Reservation _$ReservationFromJson(Map<String, dynamic> json) => _Reservation(
  id: json['id'] as String,
  dateTime: json['date_time'] as String?,
  isActive: json['is_active'] as bool?,
  computerId: json['computer_id'] as String?,
  userTariffId: json['user_tariff_id'] as String?,
  gameCenterId: json['game_center_id'] as String?,
  branchId: json['branch_id'] as String?,
  gameCenter: json['game_center'],
  computer: json['computer'],
  tariff: json['tariff'],
  createdAt: json['created_at'] as String?,
);

Map<String, dynamic> _$ReservationToJson(_Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date_time': instance.dateTime,
      'is_active': instance.isActive,
      'computer_id': instance.computerId,
      'user_tariff_id': instance.userTariffId,
      'game_center_id': instance.gameCenterId,
      'branch_id': instance.branchId,
      'game_center': instance.gameCenter,
      'computer': instance.computer,
      'tariff': instance.tariff,
      'created_at': instance.createdAt,
    };
