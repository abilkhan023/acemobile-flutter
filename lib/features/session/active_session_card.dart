import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/dates.dart';
import '../../core/utils/l10n.dart';
import '../../core/utils/money.dart';
import '../../shared/theme/ace_colors.dart';
import '../../shared/theme/ace_theme.dart';
import '../../shared/widgets/ace_button.dart';
import '../../shared/widgets/ace_modal.dart';

import 'package:intl/intl.dart';

import '../../core/toast/toast.dart';
import '../../shared/widgets/ace_sheet.dart';
import '../../shared/widgets/link_menu.dart';
import 'mobile_socket.dart';
import 'socket_errors.dart';

class ActiveSessionCard extends ConsumerStatefulWidget {
  const ActiveSessionCard({super.key});

  @override
  ConsumerState<ActiveSessionCard> createState() => _ActiveSessionCardState();
}

class _ActiveSessionCardState extends ConsumerState<ActiveSessionCard> {
  Timer? _ticker;
  DateTime _now = DateTime.now();
  int _prevRemaining = -1;
  bool _stopping = false;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _now = DateTime.now()));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  int _remainingSec(SocketState s) {
    final end = s.session?.endsAtUtc;
    if (end == null) return 0;
    final nowMs = _now.toUtc().millisecondsSinceEpoch + s.timeOffset;
    return ((end.millisecondsSinceEpoch - nowMs) ~/ 1000).clamp(0, 1 << 31);
  }

  String _format(int s) {
    final h = s ~/ 3600;
    final m = (s % 3600) ~/ 60;
    final sec = s % 60;
    String pad(int n) => n.toString().padLeft(2, '0');
    return h > 0 ? '$h:${pad(m)}:${pad(sec)}' : '${pad(m)}:${pad(sec)}';
  }

  String _tariffLabel(SessionInfo? t, AppLocalizations l) {
    if (t == null) return '—';
    if (t.tariffType == 'per_minute') return l.tariffPerMinute;
    if (t.tariffType == 'free') return l.tariffFree;
    return (t.tariffName?.isNotEmpty == true) ? t.tariffName! : l.tariffDefault;
  }

  Future<void> _openDoor(String zoneId) async {
    final l = context.l10n;
    final toast = ref.read(toastProvider.notifier);
    try {
      final res = await ref.read(mobileSocketProvider.notifier).openDoor(zoneId);
      res['sent'] == false ? toast.warning(l.doorNoLock) : toast.success(l.doorOpened);
    } catch (e) {
      toast.danger(socketErrorText(e, l));
    }
  }

  Future<bool> _roomHostLeave() async {
    final l = context.l10n;
    final socket = ref.read(mobileSocketProvider.notifier);
    final toast = ref.read(toastProvider.notifier);
    Map<String, dynamic> info;
    try {
      info = await socket.roomMembers();
    } catch (_) {
      return false;
    }
    final members = [
      for (final m in (info['members'] as List? ?? const []))
        if (m is Map) Map<String, dynamic>.from(m),
    ];
    if (members.isEmpty || !mounted) return false;
    final prepaid = info['tariff_kind'] == 'prepaid';
    final ends = parseUtc(info['ends_at']);
    final endsLabel = ends == null ? '' : DateFormat('HH:mm').format(ends.toLocal());
    final choice = await showAceSheet<(String, String?)>(
      context,
      title: l.leaveRoomTitle,
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          for (final m in members)
            LinkMenu(
              title: l.transferTo('${m['username'] ?? ''}'),
              subtitle: m['computer_name']?.toString(),
              icon: 'user',
              color: AceColors.cardAlt,
              onTap: () => Navigator.of(ctx).pop(('transfer', m['user_id']?.toString())),
            ),
          if (prepaid) AceButton(label: l.leaveContinue(endsLabel), style: AceButtonStyle.gray, onPressed: () => Navigator.of(ctx).pop(('leave', null))),
          AceButton(label: l.stopForAll, style: AceButtonStyle.red, onPressed: () => Navigator.of(ctx).pop(('stop', null))),
        ],
      ),
    );
    if (choice == null) return true;
    setState(() => _stopping = true);
    try {
      await socket.leaveRoom(choice.$1, newHostUserId: choice.$2);
    } catch (e) {
      toast.danger(socketErrorText(e, l));
    } finally {
      if (mounted) setState(() => _stopping = false);
    }
    return true;
  }

  Future<void> _confirmStop() async {
    final l = context.l10n;
    if (ref.read(mobileSocketProvider).session?.roomRole == 'renter' && await _roomHostLeave()) return;
    if (!mounted) return;
    final ok = await showAceModal(
      context,
      title: l.attention,
      body: Text(
        l.stopSessionConfirm,
        style: AceText.style(size: 15, weight: FontWeight.w400, color: AceColors.muted, height: 1.4),
      ),
      actions: [l.yesStop, l.cancel],
      submit: l.yesStop,
    );
    if (!ok) return;
    setState(() => _stopping = true);
    try {
      await ref.read(mobileSocketProvider.notifier).stopSession();
    } catch (_) {
    } finally {
      if (mounted) setState(() => _stopping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(mobileSocketProvider);
    if (!s.hasActiveSession) return const SizedBox.shrink();
    final l = context.l10n;
    final remaining = _remainingSec(s);
    if (remaining == 0 && _prevRemaining > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(mobileSocketProvider.notifier).requestInfo());
    }
    _prevRemaining = remaining;
    final balance = s.balance;
    final details = [
      '${l.tariff} ${_tariffLabel(s.session, l)}',
      if (balance != null) '${l.balance} ${formatMoney(balance.balance)}',
      if (balance != null) '${l.bonuses} ${formatMoney(balance.bonuses)}',
    ].join(' · ');

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AceColors.accent, AceColors.accentDark]),
        borderRadius: BorderRadius.circular(AceRadius.card),
        boxShadow: AceShadows.accent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AcePill(
                height: 30,
                color: const Color(0x2EFFFFFF),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  l.activeSession,
                  style: AceText.style(size: 12, weight: FontWeight.w600, color: AceColors.white),
                ),
              ),
              Text(
                l.pcNumber(s.context?.computerName ?? '—'),
                style: AceText.style(size: 13, weight: FontWeight.w500, color: const Color(0xD9FFFFFF)),
              ),
            ],
          ),
          Text(
            _format(remaining),
            style: AceText.style(size: 44, weight: FontWeight.w700, color: AceColors.white, height: 1).copyWith(letterSpacing: -0.5),
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: Text(
                  details,
                  maxLines: 2,
                  style: AceText.style(size: 13, weight: FontWeight.w500, color: const Color(0xD9FFFFFF)),
                ),
              ),
              AceButton(
                label: l.stopSession,
                style: AceButtonStyle.white,
                expand: false,
                loading: _stopping,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                onPressed: _confirmStop,
              ),
            ],
          ),
          if (s.session?.roomRole != null && s.session?.zoneId != null)
            AceButton(
              label: l.openDoor,
              icon: 'lock',
              style: AceButtonStyle.white,
              padding: const EdgeInsets.symmetric(vertical: 11),
              fontSize: 13,
              onPressed: () => _openDoor(s.session!.zoneId!),
            ),
        ],
      ),
    );
  }
}
