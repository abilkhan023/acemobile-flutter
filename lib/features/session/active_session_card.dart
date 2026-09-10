import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/l10n.dart';
import '../../core/utils/money.dart';
import '../../shared/theme/ace_colors.dart';
import '../../shared/theme/ace_theme.dart';
import '../../shared/widgets/ace_button.dart';
import '../../shared/widgets/ace_modal.dart';
import 'mobile_socket.dart';

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

  Future<void> _confirmStop() async {
    final l = context.l10n;
    final ok = await showAceModal(
      context,
      title: l.attention,
      body: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 8),
        child: Text(l.stopSessionConfirm, style: AceText.style(size: 16, weight: FontWeight.w500, color: AceColors.muted, height: 1.4)),
      ),
      actions: [l.yesStop, l.cancel],
      submit: l.yesStop,
    );
    if (!ok) return;
    setState(() => _stopping = true);
    try {
      await ref.read(mobileSocketProvider.notifier).stopSession();
    } catch (e) {
      debugPrint('[ActiveSession] stop failed: $e');
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

    Widget cell(String label, String value, {bool danger = false}) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AceText.style(size: 12, color: AceColors.muted)),
            const SizedBox(height: 4),
            Text(value, style: AceText.style(size: 18, weight: FontWeight.w600, color: danger ? AceColors.accent : AceColors.white)),
          ],
        );

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AceColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AceColors.accent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          Row(
            spacing: 8,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF3DDC84),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Color(0x333DDC84), spreadRadius: 4)],
                ),
              ),
              Text(l.activeSession, style: AceText.style(size: 16, weight: FontWeight.w600)),
              const Spacer(),
              Text(l.pcNumber(s.context?.computerName ?? '—'), style: AceText.style(size: 14, color: AceColors.muted)),
            ],
          ),
          Row(
            children: [
              Expanded(child: cell(l.timeLeft, _format(remaining), danger: remaining <= 300)),
              const SizedBox(width: 12),
              Expanded(child: cell(l.tariff, _tariffLabel(s.session, l))),
            ],
          ),
          Row(
            children: [
              Expanded(child: cell(l.balance, balance == null ? '—' : formatMoney(balance.balance))),
              const SizedBox(width: 12),
              Expanded(child: cell(l.bonuses, balance == null ? '—' : formatMoney(balance.bonuses))),
            ],
          ),
          AceButton(style: AceButtonStyle.red, label: l.stopSession, loading: _stopping, onPressed: _confirmStop),
        ],
      ),
    );
  }
}
