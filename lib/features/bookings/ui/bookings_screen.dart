import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_modal.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../../shared/widgets/link_menu.dart';
import '../../session/mobile_socket.dart';
import '../../session/socket_errors.dart';
import '../data/bookings_api.dart';
import '../widgets/booking_sheet.dart';
import '../widgets/booking_view.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final async = ref.watch(myBookingsProvider);
    final items = async.value ?? const <Booking>[];
    if (async.isLoading && items.isEmpty) return const Center(child: AceSpinner(color: AceColors.accent));
    return RefreshIndicator(
      color: AceColors.accent,
      onRefresh: () => ref.refresh(myBookingsProvider.future),
      child: AcePage(
        gap: 14,
        children: [
          if (async.hasError && items.isEmpty)
            _Empty(text: l.loadFailed)
          else if (items.isEmpty)
            _Empty(text: l.noBookings)
          else
            for (final b in items) _BookingCard(booking: b),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.row)),
        child: Text(text, style: AceText.text),
      );
}

class _BookingCard extends ConsumerStatefulWidget {
  const _BookingCard({required this.booking});

  final Booking booking;

  @override
  ConsumerState<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends ConsumerState<_BookingCard> {
  bool _busy = false;

  Booking get b => widget.booking;

  Future<void> _run(Future<void> Function() action, {String? success, String Function(Object e)? errorText}) async {
    final l = context.l10n;
    final toast = ref.read(toastProvider.notifier);
    setState(() => _busy = true);
    try {
      await action();
      if (success != null) toast.success(success);
      ref.invalidate(myBookingsProvider);
    } catch (e) {
      toast.danger(errorText?.call(e) ?? bookingErrorText(e, l, room: b.isRoom));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _cancel() async {
    final l = context.l10n;
    final ok = await showAceModal(
      context,
      title: l.cancelBooking,
      body: Text(l.cancelBookingConfirm, style: AceText.style(size: 15, color: AceColors.muted, height: 1.4)),
      actions: [l.cancelBooking, l.back],
      submit: l.cancelBooking,
    );
    if (!ok || b.places.isEmpty) return;
    await _run(() => ref.read(bookingsApiProvider).cancel(b.places.first.id), success: l.bookingCancelled);
  }

  Future<void> _openDoor() async {
    final l = context.l10n;
    final toast = ref.read(toastProvider.notifier);
    final zoneId = b.zoneId;
    if (zoneId == null) return;
    setState(() => _busy = true);
    try {
      final res = await ref.read(mobileSocketProvider.notifier).openDoor(zoneId);
      res['sent'] == false ? toast.warning(l.doorNoLock) : toast.success(l.doorOpened);
    } catch (e) {
      toast.danger(socketErrorText(e, l));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _placeActions(BookingPlace p) {
    final l = context.l10n;
    final api = ref.read(bookingsApiProvider);
    final friends = ref.read(friendsProvider).value ?? const <UserRef>[];
    showAceSheet(
      context,
      title: l.pcNumber(p.computer ?? ''),
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Text(l.assignFriend, style: AceText.title),
          if (friends.isEmpty)
            Text(l.noFriends, style: AceText.caption)
          else
            for (final f in friends)
              LinkMenu(
                title: f.username,
                icon: p.assignedToId == f.id ? 'check-circle' : 'user',
                color: AceColors.cardAlt,
                onTap: () {
                  Navigator.of(ctx).pop();
                  _run(() => api.assignFriend(p.id, f.id));
                },
              ),
          if (p.assignedToId != null)
            AceButton(
              label: l.removeFriend,
              style: AceButtonStyle.gray,
              onPressed: () {
                Navigator.of(ctx).pop();
                _run(() => api.assignFriend(p.id, null));
              },
            ),
          AceButton(
            label: l.startOnFriendPc,
            style: AceButtonStyle.red,
            onPressed: () async {
              Navigator.of(ctx).pop();
              var name = '';
              await _run(() async => name = await api.startOnFriendPc(p.id), errorText: (e) => _startErrorText(e, l));
              if (name.isNotEmpty) ref.read(toastProvider.notifier).success(l.sessionStartedFor(name));
            },
          ),
        ],
      ),
    );
  }

  void _editMembers() {
    final l = context.l10n;
    final friends = ref.read(friendsProvider).value ?? const <UserRef>[];
    final selected = {for (final m in b.members) m.id};
    showAceSheet(
      context,
      title: l.roomMembers,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 14,
          children: [
            Text(l.roomMembersHint, style: AceText.text),
            if (friends.isEmpty)
              Text(l.noFriends, style: AceText.caption)
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final f in friends)
                    AcePill(
                      height: 34,
                      color: selected.contains(f.id) ? AceColors.accent : AceColors.cardAlt,
                      onTap: () => setSheet(() => selected.contains(f.id) ? selected.remove(f.id) : selected.add(f.id)),
                      child: Text(f.username, style: AceText.style(size: 13, weight: FontWeight.w600)),
                    ),
                ],
              ),
            AceButton(
              label: l.save,
              style: AceButtonStyle.red,
              onPressed: () {
                Navigator.of(ctx).pop();
                _run(() => ref.read(bookingsApiProvider).setMembers(b.id, selected.toList()), success: l.membersSaved);
              },
            ),
          ],
        ),
      ),
    );
  }

  String _startErrorText(Object e, AppLocalizations l) {
    if (e is ApiException && e.status == 400) return l.pcOffline;
    if (e is ApiException && e.status == 409) return l.pcInUse;
    return bookingErrorText(e, l);
  }

  String _placeStatus(Booking b, BookingPlace p, AppLocalizations l) {
    if (p.claimedBy != null) return l.placeClaimed(p.claimedBy!.username);
    if (p.status == 'burned') return l.placeBurned;
    if (p.status == 'cancelled' || p.status == 'released') return l.placeCancelled;
    if (p.assigned != null) return p.assigned!.username;
    if (b.isOwner && !b.isRoom && p.status == 'waiting') return l.youOrByCode;
    return p.mine ? l.you : l.unassignedSeat;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final now = DateTime.now().toUtc();
    final live = b.startsAt != null && b.endsAt != null && !now.isBefore(b.startsAt!) && now.isBefore(b.endsAt!);
    final title = [b.gameCenterName, b.zoneName].whereType<String>().where((s) => s.isNotEmpty).join(' · ');
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.card), boxShadow: AceShadows.card),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Row(
            children: [
              if (b.isRoom) const Padding(padding: EdgeInsets.only(right: 8), child: Icon(Icons.meeting_room_outlined, size: 18, color: AceColors.accent)),
              Expanded(child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: AceText.title)),
              if (live)
                AcePill(
                  height: 26,
                  color: const Color(0x2434C77B),
                  child: Text(l.bookingLive, style: AceText.style(size: 11, weight: FontWeight.w600, color: AceColors.success)),
                ),
            ],
          ),
          Text(
            [bookingWindow(context, b), b.tariffName, if ((b.branchAddress ?? '').isNotEmpty) b.branchAddress].whereType<String>().where((s) => s.isNotEmpty).join(' · '),
            style: AceText.text,
          ),
          if (!b.isOwner && b.owner != null) Text(l.friendsBooking(b.owner!.username), style: AceText.style(size: 13, weight: FontWeight.w600, color: AceColors.accent)),
          if (b.isRoom && b.members.isNotEmpty)
            Text('${l.roomMembers}: ${b.members.map((m) => m.username).join(', ')}', style: AceText.text),
          if (!b.isRoom && b.places.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(color: AceColors.cardAlt, borderRadius: BorderRadius.circular(AceRadius.input)),
              child: Column(
                children: [
                  for (final p in b.places)
                    InkWell(
                      onTap: b.isOwner && p.waiting && !_busy ? () => _placeActions(p) : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(child: Text(l.pcNumber(p.computer ?? ''), style: AceText.style(size: 14, weight: FontWeight.w500))),
                            Text(_placeStatus(b, p, l), style: AceText.style(size: 13, color: p.mine || p.assigned != null ? AceColors.text : AceColors.muted)),
                            if (b.isOwner && p.waiting) const Padding(padding: EdgeInsets.only(left: 6), child: AceIcon('chevron-right', size: 16, color: AceColors.dim)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (b.isOwner && (b.accessCode ?? '').isNotEmpty) AccessCodeCard(code: b.accessCode!),
          if (b.doorAvailable(now))
            AceButton(label: l.openDoor, icon: 'lock', style: AceButtonStyle.red, loading: _busy, onPressed: _openDoor),
          if (b.isOwner && b.isRoom && b.endsAt != null && now.isBefore(b.endsAt!))
            AceButton(label: l.editMembers, style: AceButtonStyle.gray, disabled: _busy, onPressed: _editMembers),
          if (b.canCancel(now)) AceButton(label: l.cancelBooking, style: AceButtonStyle.gray, disabled: _busy, onPressed: _cancel),
        ],
      ),
    );
  }
}
