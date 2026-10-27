import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../core/utils/money.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../balance/providers/balance_providers.dart';
import '../../clubs/data/availability.dart';
import '../../clubs/data/booking_api.dart';
import '../../clubs/data/booking_models.dart';
import '../../clubs/widgets/tariffs_list.dart';
import '../data/bookings_api.dart';

String bookingErrorText(Object e, AppLocalizations l, {bool room = false}) {
  if (e is ApiException) {
    if (e.status == 409) return room ? l.roomBookedByOthers : l.pcBusyAt;
    if (e.status == 402) return l.notEnoughMoney;
    final m = e.message.replaceFirst(RegExp(r'^reservation:\s*'), '');
    if (m.isNotEmpty && !m.startsWith('DioException') && !m.startsWith('HTTP')) return m[0].toUpperCase() + m.substring(1);
  }
  return l.tryAgainLater;
}

Future<Booking?> showBookingSheet(
  BuildContext context, {
  required Zone zone,
  required List<Computer> computers,
  required String bookDateTime,
  required String dateLabel,
  required String? gameCenterId,
  required String? centerName,
  required DateTime? serverTime,
  int? maxDuration,
  String? branchId,
}) {
  return showAceSheet<Booking>(
    context,
    title: context.l10n.selectTariff,
    builder: (ctx) => _BookingSheetBody(
      zone: zone,
      computers: computers,
      bookDateTime: bookDateTime,
      dateLabel: dateLabel,
      gameCenterId: gameCenterId,
      centerName: centerName,
      serverTime: serverTime,
      maxDuration: maxDuration,
      branchId: branchId,
    ),
  );
}

class _BookingSheetBody extends ConsumerStatefulWidget {
  const _BookingSheetBody({
    required this.zone,
    required this.computers,
    required this.bookDateTime,
    required this.dateLabel,
    required this.gameCenterId,
    required this.centerName,
    required this.serverTime,
    this.maxDuration,
    this.branchId,
  });

  final Zone zone;
  final List<Computer> computers;
  final String bookDateTime;
  final String dateLabel;
  final String? gameCenterId;
  final String? centerName;
  final DateTime? serverTime;
  final int? maxDuration;
  final String? branchId;

  @override
  ConsumerState<_BookingSheetBody> createState() => _BookingSheetBodyState();
}

class _BookingSheetBodyState extends ConsumerState<_BookingSheetBody> {
  late final Future<List<Tariff>> _tariffs = ref
      .read(bookingApiProvider)
      .availableTariffs(zoneId: widget.zone.id, datetime: '${widget.bookDateTime}:00')
      .then((list) => [
            for (final t in list)
              if ((t.duration ?? 0) > 60 && (widget.maxDuration == null || (t.duration ?? 0) <= widget.maxDuration!)) t,
          ]);
  String? _tariffId;
  Availability? _quote;
  bool _quoting = false;
  final List<String> _friendIds = [];
  bool _booking = false;

  bool get _room => widget.zone.isRoom;
  int get _seats => widget.computers.length;
  int get _maxFriends => _room ? 30 : _seats;

  void _toggleFriend(String id) {
    final l = context.l10n;
    setState(() {
      if (_friendIds.remove(id)) return;
      if (_friendIds.length >= _maxFriends) {
        ref.read(toastProvider.notifier).warning(l.tooManyFriends('$_maxFriends'));
        return;
      }
      _friendIds.add(id);
    });
  }

  Future<void> _selectTariff(String? id) async {
    setState(() {
      _tariffId = id;
      _quote = null;
    });
    final branchId = widget.branchId ?? widget.zone.branchId;
    if (id == null || branchId == null) return;
    setState(() => _quoting = true);
    try {
      final quote = await ref.read(bookingApiProvider).availability(
            branchId: branchId,
            datetime: '${widget.bookDateTime}:00',
            tariffId: id,
            zoneId: widget.zone.id,
          );
      if (mounted && _tariffId == id) setState(() => _quote = quote);
    } catch (_) {}
    if (mounted && _tariffId == id) setState(() => _quoting = false);
  }

  String? _blockReason(AppLocalizations l) {
    final q = _quote;
    if (q == null) return null;
    if (q.reason != null) return l.tariffUnavailableAtTime;
    String hm(DateTime t) => DateFormat('HH:mm').format(t);
    if (_room) {
      final room = q.rooms[widget.zone.id];
      return room?.fits == false ? l.roomBookedByOthers : null;
    }
    for (final c in widget.computers) {
      final a = q.computers[c.id];
      if (a == null || a.fits != false) continue;
      final name = c.name ?? '';
      return switch (a.reason) {
        'next_booking_at' when a.freeUntil != null => '$name: ${l.freeOnlyUntil(hm(a.freeUntil!))}',
        'occupied_at_start' when a.freeFrom != null => '$name: ${l.busyUntil(hm(a.freeFrom!))}',
        'phone_hold' => '$name: ${l.staffHold}',
        'technical_work' => '$name: ${l.onMaintenance}',
        _ => '$name: ${l.pcUnavailable}',
      };
    }
    return null;
  }

  Future<void> _submit() async {
    final l = context.l10n;
    final id = _tariffId;
    if (id == null) return;
    setState(() => _booking = true);
    try {
      final booking = await ref.read(bookingsApiProvider).create(
            dateTime: '${widget.bookDateTime}:00',
            computerIds: _room ? [widget.computers.first.id] : [for (final c in widget.computers) c.id],
            tariffId: id,
            friendIds: _friendIds,
          );
      ref.invalidate(myBookingsProvider);
      ref.invalidate(walletsProvider);
      if (mounted) Navigator.of(context).pop(booking);
    } catch (e) {
      ref.read(toastProvider.notifier).danger(bookingErrorText(e, l, room: _room));
      if (mounted) setState(() => _booking = false);
    }
  }

  Widget _row(String left, String right, {bool strong = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(child: Text(left, maxLines: 1, overflow: TextOverflow.ellipsis, style: AceText.style(size: 13, color: AceColors.muted))),
            Text(right, style: AceText.style(size: 13, weight: strong ? FontWeight.w600 : FontWeight.w400, color: strong ? AceColors.text : AceColors.muted)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final friends = ref.watch(friendsProvider);
    final wallet = (ref.watch(walletsProvider).value ?? const []).where((w) => w.gameCenterId == widget.gameCenterId).firstOrNull;
    final names = widget.computers.map((c) => c.name ?? '').join(', ');
    return FutureBuilder<List<Tariff>>(
      future: _tariffs,
      builder: (context, snap) {
        final tariffs = snap.data ?? const <Tariff>[];
        final tariff = tariffs.where((t) => t.id == _tariffId).firstOrNull;
        final unit = _quote?.unitFinal ?? tariff?.priceNum ?? 0;
        final total = tariff == null ? 0 : (_room ? unit : unit * _seats);
        final block = _blockReason(l);
        final discount = _quote?.discountPercent ?? 0;
        final friendNames = {for (final f in friends.value ?? const <UserRef>[]) f.id: f.username};
        final byCode = (_seats - _friendIds.length - 1).clamp(0, _seats);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Text(
              _room ? '${l.roomSelected(widget.zone.name ?? '', '$_seats')}, ${widget.dateLabel}' : l.bookingPcAt(names, widget.dateLabel),
              style: AceText.text,
            ),
            if (snap.connectionState != ConnectionState.done)
              const Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Center(child: AceSpinner(color: AceColors.accent)))
            else if (snap.hasError)
              Text(l.tariffsLoadFailed, style: AceText.text)
            else if (tariffs.isEmpty)
              Text(l.noTariffsAvailable, style: AceText.text)
            else
              TariffsList(tariffs: tariffs, selected: _tariffId, serverTime: widget.serverTime, onSelect: _selectTariff),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Text(_room ? l.roomMembers : l.friendsInBooking, style: AceText.title),
                Text(_room ? l.roomMembersHint : l.friendsInBookingHint, style: AceText.text),
                if (friends.isLoading)
                  const Align(alignment: Alignment.centerLeft, child: AceSpinner(color: AceColors.accent))
                else if ((friends.value ?? const []).isEmpty)
                  Text(l.noFriends, style: AceText.caption)
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final f in friends.value!)
                        AcePill(
                          height: 34,
                          color: _friendIds.contains(f.id) ? AceColors.accent : AceColors.cardAlt,
                          onTap: () => _toggleFriend(f.id),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 6,
                            children: [
                              AceIcon(_friendIds.contains(f.id) ? 'check-circle' : 'user', size: 14),
                              Text(f.username, style: AceText.style(size: 13, weight: FontWeight.w600)),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AceColors.cardAlt, borderRadius: BorderRadius.circular(AceRadius.input)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_room) ...[
                    _row(l.you, l.roomSelected(widget.zone.name ?? '', '$_seats'), strong: true),
                    for (final id in _friendIds) _row(friendNames[id] ?? '', l.friendOwnPlace, strong: true),
                  ] else ...[
                    for (final id in _friendIds) _row(friendNames[id] ?? '', l.friendOwnPlace, strong: true),
                    if (_friendIds.length < _seats) _row(l.you, l.oneSeat),
                    if (byCode > 0) _row(l.byCode, l.moreN('$byCode')),
                    if (_seats > 1) Padding(padding: const EdgeInsets.only(top: 6), child: Text(l.seatSwapHint, style: AceText.caption)),
                  ],
                ],
              ),
            ),
            if (wallet != null) Text(l.chargedFromClubBalance(widget.centerName ?? '', formatMoney(wallet.balance)), style: AceText.text),
            if (tariff != null)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      [
                        _room ? l.totalRoom(formatMoney(unit)) : l.totalLine(formatMoney(unit), '$_seats'),
                        if (discount > 0) l.withDiscount('${discount % 1 == 0 ? discount.toInt() : discount}%'),
                      ].join(' · '),
                      style: AceText.text,
                    ),
                  ),
                  if (_quoting)
                    const AceSpinner(color: AceColors.accent)
                  else
                    Text(formatMoney(total), style: AceText.style(size: 18, weight: FontWeight.w700)),
                ],
              ),
            if (block != null) Text(block, style: AceText.style(size: 14, weight: FontWeight.w600, color: AceColors.accent)),
            AceButton(
              label: tariff == null ? l.reserve : l.reserveFor(formatMoney(total)),
              style: AceButtonStyle.red,
              loading: _booking,
              disabled: tariff == null || _quoting || block != null,
              onPressed: _submit,
            ),
          ],
        );
      },
    );
  }
}
