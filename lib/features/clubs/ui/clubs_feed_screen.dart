import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../core/utils/money.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../auth/providers/auth_controller.dart';
import '../../auth/providers/auth_provider.dart';
import '../../balance/providers/balance_providers.dart';
import '../../home/providers/home_providers.dart';
import '../../home/widgets/balance_sheet.dart';
import '../../session/active_session_card.dart';
import '../../session/mobile_socket.dart';
import '../providers/club_live.dart';
import '../providers/favorites.dart';
import 'club_card_helpers.dart';

enum _Filter { all, free, favorites }

class ClubsFeedScreen extends ConsumerStatefulWidget {
  const ClubsFeedScreen({super.key, this.deepLinkUuid});

  final String? deepLinkUuid;

  @override
  ConsumerState<ClubsFeedScreen> createState() => _ClubsFeedScreenState();
}

class _ClubsFeedScreenState extends ConsumerState<ClubsFeedScreen> {
  _Filter _filter = _Filter.all;
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

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

  void _openSession() {
    showAceSheet(
      context,
      title: context.l10n.activeSession,
      builder: (ctx) => const ActiveSessionCard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final auth = ref.watch(authProvider);
    final branches = ref.watch(homeBranchesProvider);
    final cards = branchCardsOf(branches);
    final favorites = ref.watch(favoritesProvider);
    final socket = auth.isAuth ? ref.watch(mobileSocketProvider) : null;
    final hasSession = socket?.hasActiveSession == true;
    final wallets = auth.isAuth ? ref.watch(walletClubsProvider).value : null;
    num? total;
    if (wallets != null) {
      final own = wallets.where((w) => w.club != null).toList();
      if (own.isNotEmpty) total = own.fold<num>(0, (acc, w) => acc + (num.tryParse(w.balance.toString()) ?? 0));
    }
    final q = _query.trim().toLowerCase();
    final visible = [
      for (final c in cards)
        if ((_filter != _Filter.favorites || favorites.contains(c.branch.id)) &&
            (q.isEmpty || c.title.toLowerCase().contains(q) || c.text.toLowerCase().contains(q)))
          c,
    ];
    return Stack(
      children: [
        AcePage(
          gap: 14,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          children: [
            Row(
              children: [
                Expanded(child: Text(l.clubs, style: AceText.titleBig)),
                if (!auth.isAuth)
                  AcePill(
                    height: 40,
                    padding: const EdgeInsets.fromLTRB(16, 0, 14, 0),
                    onTap: () => context.push('/login'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        Text(l.enter, style: AceText.style(size: 14, weight: FontWeight.w600)),
                        const AceIcon('login', size: 16, color: AceColors.accent),
                      ],
                    ),
                  )
                else
                  AcePill(
                    height: 40,
                    color: AceColors.card,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    onTap: hasSession ? _openSession : () => showBalanceSheet(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        if (hasSession) ...[
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AceColors.success, shape: BoxShape.circle)),
                          Text(l.pcNumber(socket?.context?.computerName ?? ''), style: AceText.style(size: 13, weight: FontWeight.w600)),
                          Container(width: 1, height: 16, color: AceColors.divider),
                        ] else
                          const AceIcon('coin-vertical', size: 16, color: AceColors.accent),
                        Text(total == null ? l.balance : formatMoney(total), style: AceText.style(size: 14, weight: FontWeight.w600)),
                      ],
                    ),
                  ),
              ],
            ),
            AceInput(
              controller: _search,
              placeholder: l.searchClubs,
              icon: 'search',
              onChanged: (v) => setState(() => _query = v),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                spacing: 8,
                children: [
                  _FilterChip(label: l.all, active: _filter == _Filter.all, onTap: () => setState(() => _filter = _Filter.all)),
                  _FilterChip(label: l.freeNow, active: _filter == _Filter.free, onTap: () => setState(() => _filter = _Filter.free)),
                  _FilterChip(label: l.favorites, active: _filter == _Filter.favorites, onTap: () => setState(() => _filter = _Filter.favorites)),
                ],
              ),
            ),
            if (branches.isLoading && cards.isEmpty)
              const Padding(padding: EdgeInsets.symmetric(vertical: 40), child: Center(child: AceSpinner(color: AceColors.accent)))
            else if (visible.isEmpty)
              _EmptyCard(text: q.isNotEmpty ? l.nothingFound : (_filter == _Filter.favorites ? l.noFavoritesYet : l.noFreeNow))
            else
              for (final c in visible)
                _ClubFeedCard(
                  card: c,
                  hideWhenBusy: _filter == _Filter.free,
                  onTap: () => context.push('/clubs/${c.branch.id}'),
                ),
            if (_filter == _Filter.free && visible.isNotEmpty) _FreeFilterEmpty(cards: visible),
          ],
        ),
        if (auth.isAuth)
          Positioned(
            right: 20,
            bottom: MediaQuery.paddingOf(context).bottom + 12,
            child: GestureDetector(
              onTap: () => context.push('/qr-code'),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: AceColors.accent, borderRadius: BorderRadius.circular(18), boxShadow: AceShadows.accent),
                child: const Center(child: AceIcon('qr-code', size: 24, color: AceColors.white)),
              ),
            ),
          ),
      ],
    );
  }
}

class _FreeFilterEmpty extends ConsumerWidget {
  const _FreeFilterEmpty({required this.cards});

  final List<BranchCard> cards;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var loaded = 0;
    var free = 0;
    for (final c in cards) {
      final live = ref.watch(clubLiveProvider(c.branch.id)).value;
      if (live == null) continue;
      loaded++;
      if (live.free > 0) free++;
    }
    if (loaded == cards.length && free == 0) return _EmptyCard(text: context.l10n.noFreeNow);
    return const SizedBox.shrink();
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.row)),
      child: Text(text, style: AceText.text),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AcePill(
      height: 34,
      color: active ? AceColors.accent : AceColors.cardAlt,
      onTap: onTap,
      child: Text(label, style: AceText.style(size: 13, weight: FontWeight.w600, color: active ? AceColors.white : AceColors.text)),
    );
  }
}

class _ClubFeedCard extends ConsumerWidget {
  const _ClubFeedCard({required this.card, required this.hideWhenBusy, required this.onTap});

  final BranchCard card;
  final bool hideWhenBusy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final live = ref.watch(clubLiveProvider(card.branch.id)).value;
    if (hideWhenBusy && live != null && live.free == 0) return const SizedBox.shrink();
    final logo = card.img;
    final tariff = live?.tariffNow;
    final subtitle = [
      if (card.text.isNotEmpty) card.text,
      if (tariff != null) l.tariffNow(tariff.name ?? '', formatMoney(tariff.basePrice)),
    ].join(' · ');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.card), boxShadow: AceShadows.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 120,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (logo != null && logo.isNotEmpty)
                    CachedNetworkImage(imageUrl: logo, fit: BoxFit.cover, errorWidget: (_, _, _) => const ColoredBox(color: AceColors.cardAlt))
                  else
                    const ColoredBox(color: AceColors.cardAlt),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x00201D22), Color(0xFF201D22)], stops: [0.3, 1]),
                    ),
                  ),
                  Positioned(left: 12, top: 12, child: livePill(context, live)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(card.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AceText.style(size: 17, weight: FontWeight.w600))),
                      const AceIcon('star-filled', size: 12, color: AceColors.accent),
                      const SizedBox(width: 4),
                      Text('8.8', style: AceText.text),
                    ],
                  ),
                  if (subtitle.isNotEmpty) Text(subtitle, style: AceText.text),
                  if (live != null && live.zones.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [for (final z in live.zones) zonePill(context, z)],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
