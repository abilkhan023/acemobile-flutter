import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../../shared/widgets/scroll_carousel.dart';
import '../../auth/providers/auth_controller.dart';
import '../../auth/providers/auth_provider.dart';
import '../../clubs/data/models.dart';
import '../../session/active_session_card.dart';
import '../providers/home_providers.dart';
import '../widgets/balance_sheet.dart';
import '../widgets/links_section.dart';

Widget homeHeaderActions(BuildContext context) => const _HomeHeader();

class _HomeHeader extends ConsumerWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final auth = ref.watch(authProvider);
    final name = auth.isAuth ? '${l.hi}, ${auth.user?.username?.isNotEmpty == true ? auth.user!.username : 'User'}' : l.hi;
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text('$name!', maxLines: 1, overflow: TextOverflow.ellipsis, style: AceText.titleBig)),
          AceButton(
            label: auth.isAuth ? l.balance : l.enter,
            style: AceButtonStyle.gray,
            expand: false,
            onPressed: () => auth.isAuth ? showBalanceSheet(context) : context.push('/login'),
          ),
        ],
      ),
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
  static const _images = ['assets/images/main.png', 'assets/images/main.png', 'assets/images/main.png', 'assets/images/main.png', 'assets/images/main.png'];
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
        spacing: 20,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(border: Border.all(color: AceColors.cardAlt), borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(item.gameCenterName, style: AceText.style(size: 16, weight: FontWeight.w600))),
                    _ActiveDot(active: active),
                  ],
                ),
                Text(_activityText(item, l), style: AceText.style(size: 14, weight: FontWeight.w500, color: AceColors.muted)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              if (active)
                _ActionRow(
                  icon: 'x-circle',
                  title: l.cancelBooking,
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _cancel(item.id);
                  },
                ),
              _ActionRow(
                icon: 'ace-logo',
                title: l.viewDetails,
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

    List<Widget> clubCards() => [
          for (final c in branchCards)
            LinkCard(
              title: c.title,
              text: c.text,
              img: c.img?.isNotEmpty == true ? c.img : 'assets/images/just_icon.png',
              onTap: () => context.push('/clubs/${c.branch.id}'),
            ),
        ];

    return AcePage(
      gap: 20,
      children: [
        ScrollCarousel(images: _images),
        if (isAuth) const ActiveSessionCard(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            spacing: 6,
            children: [
              Expanded(child: _MenuCard(icon: 'comp', label: l.reservation, onTap: () => context.push('/clubs'))),
              Expanded(child: _MenuCard(icon: 'shop', label: l.shop, soon: true)),
            ],
          ),
        ),
        LinksSection(
          title: l.lastActivity,
          loading: activity.isLoading && activityItems.isEmpty,
          children: [
            for (final item in activityItems)
              LinkCard(
                title: item.gameCenterName,
                text: _activityText(item, l),
                icon: item.isActive == true ? null : 'arrow-counter-clockwise',
                row: true,
                mini: true,
                trailingTitle: _ActiveDot(active: item.isActive == true),
                onTap: () => _openActivity(item),
              ),
          ],
        ),
        LinksSection(title: l.clubsNearby, loading: branches.isLoading, onAll: () => context.push('/clubs'), children: clubCards()),
        LinksSection(title: l.exclusiveInAce, loading: branches.isLoading, onAll: () => context.push('/clubs'), children: clubCards()),
      ],
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

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.icon, required this.title, required this.onTap});

  final String icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        decoration: BoxDecoration(color: AceColors.cardAlt, borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 12,
              children: [
                AceIcon(icon),
                Text(title, style: AceText.style(size: 16, weight: FontWeight.w700)),
              ],
            ),
            const AceIcon('caret-right'),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.icon, required this.label, this.soon = false, this.onTap});

  final String icon;
  final String label;
  final bool soon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = soon ? AceColors.footer : AceColors.white;
    return GestureDetector(
      onTap: soon ? null : onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              constraints: const BoxConstraints(minHeight: 110, minWidth: double.infinity),
              padding: const EdgeInsets.fromLTRB(26, 18, 26, 26),
              decoration: const BoxDecoration(color: AceColors.card),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  AceIcon(icon, size: 36, color: soon ? AceColors.footer : AceColors.accent),
                  Text(label, textAlign: TextAlign.center, style: AceText.style(size: 14, weight: FontWeight.w500, color: color)),
                ],
              ),
            ),
            if (soon)
              Positioned(
                left: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 6),
                  decoration: const BoxDecoration(
                    color: AceColors.accent,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  ),
                  child: Text(context.l10n.soonBadge, style: AceText.style(size: 12, weight: FontWeight.w500)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
