import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../data/bookings_api.dart';

String bookingWindow(BuildContext context, Booking b) {
  final s = b.startsAt?.toLocal();
  final e = b.endsAt?.toLocal();
  if (s == null) return '';
  final locale = Localizations.localeOf(context).toString();
  final day = DateFormat('d MMM', locale).format(s);
  final from = DateFormat('HH:mm').format(s);
  if (e == null) return '$day, $from';
  final sameDay = e.year == s.year && e.month == s.month && e.day == s.day;
  final to = sameDay ? DateFormat('HH:mm').format(e) : '${DateFormat('d MMM', locale).format(e)} ${DateFormat('HH:mm').format(e)}';
  return '$day, $from – $to';
}

String placeLabel(BookingPlace p, Map<String, String> computerNames) => p.computer ?? computerNames[p.computerId] ?? p.computerId ?? '';

class AccessCodeCard extends ConsumerWidget {
  const AccessCodeCard({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return GestureDetector(
      onTap: () {
        Clipboard.setData(ClipboardData(text: code));
        ref.read(toastProvider.notifier).success(l.codeCopied);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AceColors.cardAlt, borderRadius: BorderRadius.circular(AceRadius.input)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: [
            Row(
              children: [
                Expanded(child: Text(l.accessCode, style: AceText.caption)),
                const Icon(Icons.copy_rounded, size: 16, color: AceColors.dim),
              ],
            ),
            Text(code, style: AceText.style(size: 28, weight: FontWeight.w700).copyWith(letterSpacing: 4)),
            Text(l.accessCodeHint, style: AceText.caption),
          ],
        ),
      ),
    );
  }
}

Future<void> showBookingSuccess(BuildContext context, Booking b, {required Map<String, String> computerNames, required Map<String, String> friendNames, String? zoneName}) {
  final l = context.l10n;
  final names = [for (final p in b.places) placeLabel(p, computerNames)].where((n) => n.isNotEmpty).join(', ');
  return showAceSheet(
    context,
    builder: (ctx) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        SvgPicture.asset('assets/images/CheckCircle-true.svg', width: 40, height: 40, alignment: Alignment.centerLeft),
        Text(l.bookingSuccess, style: AceText.title),
        Text(b.isRoom ? l.roomBooked(zoneName ?? b.zoneName ?? '') : l.pcsBooked(names), style: AceText.titleMini),
        Text(l.bookingDetails(bookingWindow(context, b)), style: AceText.text),
        if (b.places.isNotEmpty && !b.isRoom)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AceColors.cardAlt, borderRadius: BorderRadius.circular(AceRadius.input)),
            child: Column(
              children: [
                for (final p in b.places)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Expanded(child: Text(l.pcNumber(placeLabel(p, computerNames)), style: AceText.style(size: 13, color: AceColors.muted))),
                        Text(
                          p.assigned?.username ?? friendNames[p.assignedToId] ?? l.youOrByCode,
                          style: AceText.style(size: 13, weight: p.assignedToId != null ? FontWeight.w600 : FontWeight.w400, color: p.assignedToId != null ? AceColors.text : AceColors.muted),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        if ((b.accessCode ?? '').isNotEmpty) AccessCodeCard(code: b.accessCode!),
        Text(l.burnHint, style: AceText.caption),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            AceButton(
              label: l.myBookings,
              style: AceButtonStyle.white,
              onPressed: () {
                Navigator.of(ctx).pop();
                context.push('/bookings');
              },
            ),
            AceButton(label: l.ready, style: AceButtonStyle.gray, onPressed: () => Navigator.of(ctx).pop()),
          ],
        ),
      ],
    ),
  );
}
