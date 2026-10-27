import '../../../core/utils/dates.dart';

class PcAvailability {
  const PcAvailability({
    required this.id,
    this.stateAt,
    this.staffHold = false,
    this.sessionUntil,
    this.freeFrom,
    this.freeUntil,
    this.maxDuration,
    this.reason,
    this.fits,
  });

  final String id;
  final String? stateAt;
  final bool staffHold;
  final DateTime? sessionUntil;
  final DateTime? freeFrom;
  final DateTime? freeUntil;
  final int? maxDuration;
  final String? reason;
  final bool? fits;

  factory PcAvailability.fromJson(Map<String, dynamic> j) => PcAvailability(
        id: j['id'].toString(),
        stateAt: j['state_at']?.toString(),
        staffHold: j['staff_hold'] == true,
        sessionUntil: parseUtc(j['session_until'])?.toLocal(),
        freeFrom: parseUtc(j['free_from'])?.toLocal(),
        freeUntil: parseUtc(j['free_until'])?.toLocal(),
        maxDuration: (j['max_duration'] as num?)?.toInt(),
        reason: j['reason']?.toString(),
        fits: j['fits'] as bool?,
      );
}

class RoomAvailability {
  const RoomAvailability({this.fits, this.reason});

  final bool? fits;
  final String? reason;
}

class Availability {
  const Availability({required this.computers, this.rooms = const {}, this.reason, this.horizonDays, this.unitFinal, this.discountPercent});

  final Map<String, PcAvailability> computers;
  final Map<String, RoomAvailability> rooms;
  final num? unitFinal;
  final num? discountPercent;
  final String? reason;
  final int? horizonDays;

  factory Availability.fromJson(Map<String, dynamic> j) => Availability(
        reason: j['reason']?.toString(),
        horizonDays: (j['horizon_days'] as num?)?.toInt(),
        unitFinal: num.tryParse('${(j['tariff'] as Map?)?['unit_final'] ?? ''}'),
        discountPercent: num.tryParse('${(j['tariff'] as Map?)?['discount_percent'] ?? ''}'),
        rooms: {
          for (final z in (j['zones'] as List? ?? const []))
            if ((z as Map)['room'] case final Map r) z['id'].toString(): RoomAvailability(fits: r['fits'] as bool?, reason: r['reason']?.toString()),
        },
        computers: {
          for (final z in (j['zones'] as List? ?? const []))
            for (final c in ((z as Map)['computers'] as List? ?? const []))
              (c as Map)['id'].toString(): PcAvailability.fromJson(c.cast<String, dynamic>()),
        },
      );
}
