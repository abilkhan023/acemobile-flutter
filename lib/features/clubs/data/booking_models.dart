import 'package:freezed_annotation/freezed_annotation.dart';

import 'models.dart';

part 'booking_models.freezed.dart';
part 'booking_models.g.dart';

@freezed
abstract class Zone with _$Zone {
  const factory Zone({
    required String id,
    String? name,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(fromJson: numFromJson) num? x,
    @JsonKey(fromJson: numFromJson) num? y,
    @JsonKey(name: 'x_len', fromJson: numFromJson) num? xLen,
    @JsonKey(name: 'y_len', fromJson: numFromJson) num? yLen,
    String? mode,
    @JsonKey(name: 'door_type') String? doorType,
  }) = _Zone;

  factory Zone.fromJson(Map<String, dynamic> json) => _$ZoneFromJson(json);
}

extension ZoneX on Zone {
  bool get isRoom => mode == 'room';
  bool get hasDoor => doorType != null && doorType!.isNotEmpty;
}

@freezed
abstract class Computer with _$Computer {
  const factory Computer({
    required String id,
    String? name,
    String? state,
    @JsonKey(fromJson: numFromJson) num? x,
    @JsonKey(fromJson: numFromJson) num? y,
    @JsonKey(name: 'zone_id') String? zoneId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'mac_address') String? macAddress,
    @JsonKey(name: 'staff_hold') bool? staffHold,
  }) = _Computer;

  factory Computer.fromJson(Map<String, dynamic> json) => _$ComputerFromJson(json);
}

@freezed
abstract class TariffAvailability with _$TariffAvailability {
  const factory TariffAvailability({
    @JsonKey(name: 'weekday_from', fromJson: numFromJson) num? weekdayFrom,
    @JsonKey(name: 'weekday_to', fromJson: numFromJson) num? weekdayTo,
    @JsonKey(name: 'available_from') String? availableFrom,
    @JsonKey(name: 'available_to') String? availableTo,
  }) = _TariffAvailability;

  factory TariffAvailability.fromJson(Map<String, dynamic> json) => _$TariffAvailabilityFromJson(json);
}

@freezed
abstract class TariffAvailabilities with _$TariffAvailabilities {
  const factory TariffAvailabilities({
    @JsonKey(name: 'to_buy') @Default([]) List<TariffAvailability> toBuy,
    @JsonKey(name: 'to_use') @Default([]) List<TariffAvailability> toUse,
  }) = _TariffAvailabilities;

  factory TariffAvailabilities.fromJson(Map<String, dynamic> json) => _$TariffAvailabilitiesFromJson(json);
}

@freezed
abstract class TariffProperty with _$TariffProperty {
  const factory TariffProperty({
    @JsonKey(name: 'tariff_id') String? tariffId,
    TariffAvailabilities? availabilities,
  }) = _TariffProperty;

  factory TariffProperty.fromJson(Map<String, dynamic> json) => _$TariffPropertyFromJson(json);
}

@freezed
abstract class Tariff with _$Tariff {
  const factory Tariff({
    required String id,
    String? name,
    @JsonKey(name: 'base_price') Object? basePrice,
    @JsonKey(fromJson: numFromJson) num? duration,
    String? type,
    @JsonKey(name: 'zone_id') String? zoneId,
    TariffProperty? property,
    @JsonKey(name: 'dynamic_price') Map<String, dynamic>? dynamicPrice,
  }) = _Tariff;

  factory Tariff.fromJson(Map<String, dynamic> json) => _$TariffFromJson(json);
}

extension TariffX on Tariff {
  bool get isDynamic => dynamicPrice != null && dynamicPrice!['price'] != null;
  Object? get price => isDynamic ? dynamicPrice!['price'] : basePrice;
  num get priceNum => num.tryParse(price?.toString() ?? '') ?? 0;
}

@freezed
abstract class Wallet with _$Wallet {
  const factory Wallet({
    String? id,
    Object? balance,
    Object? bonuses,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'game_center_id') String? gameCenterId,
    @JsonKey(name: 'game_center') Object? gameCenter,
    String? username,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}
