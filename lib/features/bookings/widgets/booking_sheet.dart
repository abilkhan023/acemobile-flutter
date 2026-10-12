import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  });

  final Zone zone;
  final List<Computer> computers;
  final String bookDateTime;
  final String dateLabel;
  final String? gameCenterId;
  final String? centerName;
  final DateTime? serverTime;

  @override
  ConsumerState<_BookingSheetBody> createState() => _BookingSheetBodyState();
}

class _BookingSheetBodyState extends ConsumerState<_BookingSheetBody> {
  late final Future<List<Tariff>> _tariffs = ref
      .read(bookingApiProvider)
      .availableTariffs(zoneId: widget.zone.id, datetime: '${widget.bookDateTime}:00')
      .then((list) => [for (final t in list) if ((t.duration ?? 0) > 60) t]);
  String? _tariffId;
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
        final total = tariff == null ? 0 : (_room ? tariff.priceNum : tariff.priceNum * _seats);
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
              TariffsList(tariffs: tariffs, selected: _tariffId, serverTime: widget.serverTime, onSelect: (v) => setState(() => _tariffId = v)),
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
                      _room ? l.totalRoom(formatMoney(tariff.price)) : l.totalLine(formatMoney(tariff.price), '$_seats'),
                      style: AceText.text,
                    ),
                  ),
                  Text(formatMoney(total), style: AceText.style(size: 18, weight: FontWeight.w700)),
                ],
              ),
            AceButton(
              label: tariff == null ? l.reserve : l.reserveFor(formatMoney(total)),
              style: AceButtonStyle.red,
              loading: _booking,
              disabled: tariff == null,
              onPressed: _submit,
            ),
          ],
        );
      },
    );
  }
}
