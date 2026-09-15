import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/booking_api.dart';
import '../data/booking_models.dart';
import '../widgets/computer_map.dart';

class ZoneLive {
  const ZoneLive({required this.zone, required this.free, required this.total});

  final Zone zone;
  final int free;
  final int total;
}

class ClubLive {
  const ClubLive({required this.zones, required this.tariffNow, required this.serverTime});

  final List<ZoneLive> zones;
  final Tariff? tariffNow;
  final DateTime? serverTime;

  int get free => zones.fold(0, (acc, z) => acc + z.free);
  int get total => zones.fold(0, (acc, z) => acc + z.total);
}

final clubLiveProvider = FutureProvider.family<ClubLive, String>((ref, branchId) async {
  final booking = ref.watch(bookingApiProvider);
  final zones = await booking.zones(branchId);
  final raw = await booking.serverDatetime();
  final now = (raw == null ? null : DateTime.tryParse(raw)) ?? DateTime.now();
  final stamp = DateFormat("yyyy-MM-dd'T'HH:mm:00").format(now);
  final computers = await booking.computersMap(branchId: branchId, datetime: stamp);
  final live = [
    for (final z in zones)
      ZoneLive(
        zone: z,
        total: computers.where((c) => c.zoneId == z.id).length,
        free: computers.where((c) => c.zoneId == z.id && ComputerMap.stateOf(c) == 'FREE').length,
      ),
  ];
  Tariff? tariffNow;
  if (zones.isNotEmpty) {
    try {
      final tariffs = await booking.availableTariffs(zoneId: zones.first.id, datetime: stamp);
      tariffNow = tariffs.where((t) => (t.duration ?? 0) > 60).firstOrNull ?? tariffs.firstOrNull;
    } catch (_) {}
  }
  return ClubLive(zones: live, tariffNow: tariffNow, serverTime: now);
});
