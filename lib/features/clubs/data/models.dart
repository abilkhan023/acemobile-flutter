import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

num? numFromJson(Object? v) => v is num ? v : num.tryParse(v?.toString() ?? '');

List<T> unwrapList<T>(dynamic data, T Function(Map<String, dynamic>) fromJson) {
  final list = data is Map ? (data['data'] ?? data['items'] ?? const []) : data;
  if (list is! List) return const [];
  return [for (final e in list) fromJson(Map<String, dynamic>.from(e as Map))];
}

@freezed
abstract class Branch with _$Branch {
  const factory Branch({
    required String id,
    String? name,
    String? address,
    @JsonKey(name: 'game_center_id') String? gameCenterId,
    @JsonKey(name: 'is_available') bool? isAvailable,
    @JsonKey(fromJson: numFromJson) num? latitude,
    @JsonKey(fromJson: numFromJson) num? longitude,
    String? description,
    String? phone,
    @JsonKey(name: 'work_time') String? workTime,
    @JsonKey(fromJson: numFromJson) num? rating,
  }) = _Branch;

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
}

@freezed
abstract class GameCenter with _$GameCenter {
  const factory GameCenter({
    required String id,
    String? name,
    String? logo,
    String? slug,
    String? address,
    String? description,
    @JsonKey(fromJson: numFromJson) num? latitude,
    @JsonKey(fromJson: numFromJson) num? longitude,
    @JsonKey(name: 'is_available') bool? isAvailable,
  }) = _GameCenter;

  factory GameCenter.fromJson(Map<String, dynamic> json) => _$GameCenterFromJson(json);
}

@freezed
abstract class Reservation with _$Reservation {
  const factory Reservation({
    required String id,
    @JsonKey(name: 'date_time') String? dateTime,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'computer_id') String? computerId,
    @JsonKey(name: 'user_tariff_id') String? userTariffId,
    @JsonKey(name: 'game_center_id') String? gameCenterId,
    @JsonKey(name: 'branch_id') String? branchId,
    @JsonKey(name: 'game_center') Object? gameCenter,
    Object? computer,
    Object? tariff,
    @JsonKey(name: 'created_at') String? createdAt,
  }) = _Reservation;

  factory Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);
}

extension ReservationX on Reservation {
  String get gameCenterName {
    final g = gameCenter;
    if (g is Map) return (g['name'] ?? '').toString();
    return g?.toString() ?? '';
  }

  String get computerName {
    final c = computer;
    if (c is Map) return (c['name'] ?? c['number'] ?? '').toString();
    return c?.toString() ?? '';
  }

  DateTime? get dateTimeParsed => dateTime == null ? null : DateTime.tryParse(dateTime!);
}
