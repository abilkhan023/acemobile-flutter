import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../../shared/widgets/link_menu.dart';
import '../../../shared/widgets/ace_modal.dart';
import '../../bookings/data/bookings_api.dart';
import '../../bookings/widgets/booking_sheet.dart';
import '../../clubs/data/models.dart';
import '../../home/providers/home_providers.dart';
import '../../session/active_session_card.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  String _text(Reservation item, AppLocalizations l) {
    if (item.isActive == true) return l.pcActiveBooking(item.computerName);
    final dt = item.dateTimeParsed;
    final day = dt == null ? '' : DateFormat('dd.MM').format(dt);
    final time = dt == null ? '' : DateFormat('HH:mm').format(dt);
    return l.pcBookingAt(item.computerName, day, time);
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref, String id) async {
    final l = context.l10n;
    final toast = ref.read(toastProvider.notifier);
    final ok = await showAceModal(
      context,
      title: l.cancelBooking,
      body: Text(l.cancelBookingConfirm, style: AceText.style(size: 15, color: AceColors.muted, height: 1.4)),
      actions: [l.cancelBooking, l.back],
      submit: l.cancelBooking,
    );
    if (!ok) return;
    try {
      await ref.read(activityProvider.notifier).cancel(id);
      ref.invalidate(myBookingsProvider);
      toast.success(l.bookingCancelled);
    } catch (e) {
      toast.danger(bookingErrorText(e, l));
    }
  }

  void _open(BuildContext context, WidgetRef ref, Reservation item) {
    final l = context.l10n;
    final active = item.isActive == true;
    showAceSheet(
      context,
      title: l.selectAction,
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: AceColors.cardAlt, borderRadius: BorderRadius.circular(AceRadius.row)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(item.gameCenterName, style: AceText.style(size: 16, weight: FontWeight.w600)),
                    ),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: active ? AceColors.success : AceColors.dim, shape: BoxShape.circle),
                    ),
                  ],
                ),
                Text(_text(item, l), style: AceText.text),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              if (active)
                LinkMenu(
                  title: l.cancelBooking,
                  icon: 'x-circle',
                  color: AceColors.cardAlt,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _cancel(context, ref, item.id);
                  },
                ),
              LinkMenu(
                title: l.viewDetails,
                icon: 'ace-logo',
                color: AceColors.cardAlt,
                onTap: () {
                  Navigator.of(ctx).pop();
                  context.push('/activity/${item.id}');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final activity = ref.watch(activityProvider);
    final items = activity.value ?? const <Reservation>[];
    return AcePage(
      gap: 12,
      children: [
        const ActiveSessionCard(),
        Builder(
          builder: (context) {
            final count = ref.watch(myBookingsProvider).value?.length ?? 0;
            return LinkMenu(
              title: l.myBookings,
              subtitle: count == 0 ? l.noBookings : null,
              icon: 'calendar-alt',
              trailing: count > 0 ? '$count' : null,
              onTap: () => context.push('/bookings'),
            );
          },
        ),
        if (activity.isLoading && items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: AceSpinner(color: AceColors.accent)),
          )
        else if (items.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.row)),
            child: Text(l.noActivityYet, style: AceText.text),
          )
        else
          for (final item in items)
            Opacity(
              opacity: item.isActive == true ? 1 : 0.55,
              child: LinkMenu(
                title: item.gameCenterName,
                subtitle: _text(item, l),
                icon: item.isActive == true ? 'comp' : 'arrow-counter-clockwise',
                onTap: () => _open(context, ref, item),
              ),
            ),
      ],
    );
  }
}
