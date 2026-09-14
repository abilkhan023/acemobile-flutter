import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/api/api_client.dart';
import '../../../core/utils/l10n.dart';
import '../../../core/utils/money.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../clubs/data/booking_api.dart';
import '../../clubs/data/booking_models.dart';

class ReservationDetails {
  const ReservationDetails(this.raw, this.tariff);

  final Map<String, dynamic> raw;
  final Tariff? tariff;

  Map<String, dynamic> _map(String key) {
    final v = raw[key];
    return v is Map ? Map<String, dynamic>.from(v) : const {};
  }

  String? get logo => _map('game_center')['logo']?.toString();
  String? get centerName => _map('game_center')['name']?.toString();
  String? get address => _map('branch')['address']?.toString();
  String? get computerName => _map('computer')['name']?.toString();
  String? get dateTime => _map('reservation')['date_time']?.toString();
  num? get durationSec => _map('user_tariff')['duration'] as num?;
}

final reservationDetailsProvider = FutureProvider.family<ReservationDetails, String>((ref, id) async {
  final raw = await apiCall(() => ref.watch(coreDioProvider).get('/reservations/$id'), (d) => Map<String, dynamic>.from(d as Map));
  final userTariff = raw['user_tariff'];
  final tariffId = userTariff is Map ? userTariff['tariff_id']?.toString() : null;
  Tariff? tariff;
  if (tariffId != null && tariffId.isNotEmpty) {
    try {
      tariff = await ref.watch(bookingApiProvider).tariff(tariffId);
    } catch (_) {}
  }
  return ReservationDetails(raw, tariff);
});

class ActivityDetailScreen extends ConsumerWidget {
  const ActivityDetailScreen({super.key, required this.id});

  final String id;

  String _date(BuildContext context, String? raw) {
    if (raw == null) return '';
    var dt = DateTime.tryParse(raw);
    if (dt == null) return raw;
    if (!raw.endsWith('Z') && !RegExp(r'[+-]\d\d:?\d\d$').hasMatch(raw)) {
      dt = DateTime.utc(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);
    }
    final local = dt.toLocal();
    return context.l10n.dateAtTime(DateFormat('dd.MM.yyyy').format(local), DateFormat('HH:mm').format(local));
  }

  Widget _box({required String icon, required String title, required String text}) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.row), boxShadow: AceShadows.card),
        child: Row(
          spacing: 14,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(color: AceColors.cardAlt, shape: BoxShape.circle),
              child: Center(child: AceIcon(icon, size: 22, color: AceColors.accent)),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AceText.style(size: 16, weight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(text, style: AceText.text),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(reservationDetailsProvider(id));
    final details = async.value;
    if (async.hasError && details == null) {
      return Center(child: Padding(padding: const EdgeInsets.all(32), child: Text(l.loadFailed, textAlign: TextAlign.center, style: AceText.text)));
    }
    if (async.isLoading && details == null) return const Center(child: AceSpinner(color: AceColors.accent));
    final minutes = ((details?.durationSec ?? 0) / 60).round();
    return AcePage(
      gap: 16,
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 110),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.card), boxShadow: AceShadows.card),
          child: Column(
            spacing: 8,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: details?.logo?.isNotEmpty == true
                    ? CachedNetworkImage(imageUrl: details!.logo!, fit: BoxFit.contain, errorWidget: (_, _, _) => Image.asset('assets/images/just_icon.png'))
                    : Image.asset('assets/images/just_icon.png'),
              ),
              Text(details?.centerName ?? '', textAlign: TextAlign.center, style: AceText.title),
              Text(details?.address ?? '', textAlign: TextAlign.center, style: AceText.text),
            ],
          ),
        ),
        _box(icon: 'comp', title: l.pcNumber(details?.computerName ?? ''), text: _date(context, details?.dateTime)),
        _box(icon: 'coin-vertical', title: formatMoney(details?.tariff?.basePrice), text: l.priceByTariff(details?.tariff?.name ?? '')),
        _box(icon: 'refresh-ccw-clock', title: l.minutes(minutes), text: l.tariffDuration),
      ],
    );
  }
}
