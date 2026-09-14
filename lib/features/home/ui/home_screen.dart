import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../core/utils/money.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../../shared/widgets/link_menu.dart';
import '../../auth/providers/auth_controller.dart';
import '../../auth/providers/auth_provider.dart';
import '../../balance/providers/balance_providers.dart';
import '../../clubs/data/models.dart';
import '../../clubs/widgets/club_card.dart';
import '../../session/active_session_card.dart';
import '../providers/home_providers.dart';
import '../widgets/balance_sheet.dart';

Widget homeHeaderActions(BuildContext context) => const _HomeHeader();

class _HomeHeader extends ConsumerWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final auth = ref.watch(authProvider);
    final wallets = auth.isAuth ? ref.watch(walletClubsProvider).value : null;
    num? total;
    if (wallets != null) {
      final own = wallets.where((w) => w.club != null).toList();
      if (own.isNotEmpty) total = own.fold<num>(0, (acc, w) => acc + (num.tryParse(w.balance.toString()) ?? 0));
    }
    final name = auth.isAuth ? (auth.user?.username?.isNotEmpty == true ? auth.user!.username! : 'User') : '';
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(color: AceColors.cardAlt, shape: BoxShape.circle),
          child: const Center(child: AceIcon('user', size: 22)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.hi, style: AceText.text),
              Text(auth.isAuth ? name : l.enter, maxLines: 1, overflow: TextOverflow.ellipsis, style: AceText.style(size: 20, weight: FontWeight.w600)),
            ],
          ),
        ),
        AcePill(
          height: 44,
          padding: const EdgeInsets.fromLTRB(16, 0, 14, 0),
          onTap: () => auth.isAuth ? showBalanceSheet(context) : context.push('/login'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Text(auth.isAuth ? (total == null ? l.balance : formatMoney(total)) : l.enter, style: AceText.style(size: 15, weight: FontWeight.w600)),
              AceIcon(auth.isAuth ? 'plus' : 'login', size: 16, color: AceColors.accent),
            ],
          ),
        ),
      ],
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, this.deepLinkUuid});

  final String? deepLinkUuid;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _branchesErrorShown = false;

  @override
  void initState() {
    super.initState();
    final uuid = widget.deepLinkUuid;
    if (uuid != null && uuid.isNotEmpty && !ref.read(authProvider).isAuth) {
      Future.microtask(() => _loginByDeepLink(uuid));
    }
  }

  Future<void> _loginByDeepLink(String uuid) async {
    final l = context.l10n;
    final toast = ref.read(toastProvider.notifier);
    try {
      await ref.read(authControllerProvider).loginByDeepLink(uuid);
      toast.success(l.welcome);
    } catch (_) {
      toast.danger(l.authFailed);
    }
  }

  void _openActivity(Reservation item) {
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
                    Expanded(child: Text(item.gameCenterName, style: AceText.style(size: 16, weight: FontWeight.w600))),
                    _ActiveDot(active: active),
                  ],
                ),
                Text(_activityText(item, l), style: AceText.text),
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
                    _cancel(item.id);
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

  Future<void> _cancel(String id) async {
    final l = context.l10n;
    final toast = ref.read(toastProvider.notifier);
    try {
      await ref.read(activityProvider.notifier).cancel(id);
      toast.success(l.bookingCancelled);
    } catch (_) {
      toast.danger(l.bookingCancelFailed);
    }
  }

  String _activityText(Reservation item, AppLocalizations l) {
    if (item.isActive == true) return l.pcActiveBooking(item.computerName);
    final dt = item.dateTimeParsed;
    final day = dt == null ? '' : DateFormat('dd.MM').format(dt);
    final time = dt == null ? '' : DateFormat('HH:mm').format(dt);
    return l.pcBookingAt(item.computerName, day, time);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final isAuth = ref.watch(isAuthProvider);
    final branches = ref.watch(homeBranchesProvider);
    final activity = ref.watch(activityProvider);

    ref.listen(homeBranchesProvider, (_, next) {
      if (next.hasError && !_branchesErrorShown) {
        _branchesErrorShown = true;
        ref.read(toastProvider.notifier).danger(l.branchesLoadFailed);
      }
    });

    final branchCards = branches.maybeWhen(
      data: (cards) => cards,
      error: (e, _) => e is BranchesLoadException ? e.cards : const <BranchCard>[],
      orElse: () => const <BranchCard>[],
    );
    final activityItems = activity.value ?? const <Reservation>[];

    return AcePage(
      gap: 18,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      children: [
        if (isAuth) const ActiveSessionCard(),
        Row(
          spacing: 12,
          children: [
            Expanded(child: _ActionCard(icon: 'comp', label: l.reservation, onTap: () => context.push('/clubs'))),
            Expanded(child: _ActionCard(icon: 'qr-code', label: l.qrLogin, onTap: () => context.push('/qr-code'))),
          ],
        ),
        _SectionHeader(title: l.clubsNearby, action: l.all, onAction: () => context.push('/clubs')),
        if (branches.isLoading && branchCards.isEmpty)
          const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Center(child: AceSpinner(color: AceColors.accent)))
        else
          for (final c in branchCards)
            ClubCard(title: c.title, subtitle: c.text, logo: c.img, onTap: () => context.push('/clubs/${c.branch.id}')),
        if (isAuth) ...[
          _SectionHeader(title: l.lastActivity),
          if (activity.isLoading && activityItems.isEmpty)
            const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Center(child: AceSpinner(color: AceColors.accent)))
          else if (activityItems.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.row)),
              child: Text(l.noActivityYet, style: AceText.text),
            )
          else
            for (final item in activityItems)
              LinkMenu(
                title: item.gameCenterName,
                subtitle: _activityText(item, l),
                icon: item.isActive == true ? 'comp' : 'arrow-counter-clockwise',
                onTap: () => _openActivity(item),
              ),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AceText.title),
          if (action != null)
            AcePill(onTap: onAction, child: Text(action!, style: AceText.style(size: 13, weight: FontWeight.w600))),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.icon, required this.label, this.onTap});

  final String icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.card), boxShadow: AceShadows.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(color: AceColors.cardAlt, shape: BoxShape.circle),
              child: Center(child: AceIcon(icon, size: 22, color: AceColors.accent)),
            ),
            Text(label, style: AceText.style(size: 16, weight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _ActiveDot extends StatelessWidget {
  const _ActiveDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? AceColors.success : Colors.transparent,
        shape: BoxShape.circle,
        border: active ? null : Border.all(color: AceColors.success),
      ),
    );
  }
}
