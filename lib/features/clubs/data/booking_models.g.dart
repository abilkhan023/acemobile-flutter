// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Zone _$ZoneFromJson(Map<String, dynamic> json) => _Zone(
  id: json['id'] as String,
  name: json['name'] as String?,
  branchId: json['branch_id'] as String?,
  x: numFromJson(json['x']),
  y: numFromJson(json['y']),
  xLen: numFromJson(json['x_len']),
  yLen: numFromJson(json['y_len']),
  mode: json['mode'] as String?,
  doorType: json['door_type'] as String?,
);

Map<String, dynamic> _$ZoneToJson(_Zone instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'branch_id': instance.branchId,
  'x': instance.x,
  'y': instance.y,
  'x_len': instance.xLen,
  'y_len': instance.yLen,
  'mode': instance.mode,
  'door_type': instance.doorType,
};

_Computer _$ComputerFromJson(Map<String, dynamic> json) => _Computer(
  id: json['id'] as String,
  name: json['name'] as String?,
  state: json['state'] as String?,
  x: numFromJson(json['x']),
  y: numFromJson(json['y']),
  zoneId: json['zone_id'] as String?,
  branchId: json['branch_id'] as String?,
  macAddress: json['mac_address'] as String?,
  staffHold: json['staff_hold'] as bool?,
);

Map<String, dynamic> _$ComputerToJson(_Computer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'state': instance.state,
  'x': instance.x,
  'y': instance.y,
  'zone_id': instance.zoneId,
  'branch_id': instance.branchId,
  'mac_address': instance.macAddress,
  'staff_hold': instance.staffHold,
};

_TariffAvailability _$TariffAvailabilityFromJson(Map<String, dynamic> json) =>
    _TariffAvailability(
      weekdayFrom: numFromJson(json['weekday_from']),
      weekdayTo: numFromJson(json['weekday_to']),
      availableFrom: json['available_from'] as String?,
      availableTo: json['available_to'] as String?,
    );

Map<String, dynamic> _$TariffAvailabilityToJson(_TariffAvailability instance) =>
    <String, dynamic>{
      'weekday_from': instance.weekdayFrom,
      'weekday_to': instance.weekdayTo,
      'available_from': instance.availableFrom,
      'available_to': instance.availableTo,
    };

_TariffAvailabilities _$TariffAvailabilitiesFromJson(
  Map<String, dynamic> json,
) => _TariffAvailabilities(
  toBuy:
      (json['to_buy'] as List<dynamic>?)
          ?.map((e) => TariffAvailability.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  toUse:
      (json['to_use'] as List<dynamic>?)
          ?.map((e) => TariffAvailability.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$TariffAvailabilitiesToJson(
  _TariffAvailabilities instance,
) => <String, dynamic>{'to_buy': instance.toBuy, 'to_use': instance.toUse};

_TariffProperty _$TariffPropertyFromJson(Map<String, dynamic> json) =>
    _TariffProperty(
      tariffId: json['tariff_id'] as String?,
      availabilities: json['availabilities'] == null
          ? null
          : TariffAvailabilities.fromJson(
              json['availabilities'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$TariffPropertyToJson(_TariffProperty instance) =>
    <String, dynamic>{
      'tariff_id': instance.tariffId,
      'availabilities': instance.availabilities,
    };

_Tariff _$TariffFromJson(Map<String, dynamic> json) => _Tariff(
  id: json['id'] as String,
  name: json['name'] as String?,
  basePrice: json['base_price'],
  duration: numFromJson(json['duration']),
  type: json['type'] as String?,
  zoneId: json['zone_id'] as String?,
  property: json['property'] == null
      ? null
      : TariffProperty.fromJson(json['property'] as Map<String, dynamic>),
  dynamicPrice: json['dynamic_price'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$TariffToJson(_Tariff instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'base_price': instance.basePrice,
  'duration': instance.duration,
  'type': instance.type,
  'zone_id': instance.zoneId,
  'property': instance.property,
  'dynamic_price': instance.dynamicPrice,
};

_Wallet _$WalletFromJson(Map<String, dynamic> json) => _Wallet(
  id: json['id'] as String?,
  balance: json['balance'],
  bonuses: json['bonuses'],
  held: json['held'],
  available: json['available'],
  userId: json['user_id'] as String?,
  gameCenterId: json['game_center_id'] as String?,
  gameCenter: json['game_center'],
  username: json['username'] as String?,
);

Map<String, dynamic> _$WalletToJson(_Wallet instance) => <String, dynamic>{
  'id': instance.id,
  'balance': instance.balance,
  'bonuses': instance.bonuses,
  'held': instance.held,
  'available': instance.available,
  'user_id': instance.userId,
  'game_center_id': instance.gameCenterId,
  'game_center': instance.gameCenter,
  'username': instance.username,
};
