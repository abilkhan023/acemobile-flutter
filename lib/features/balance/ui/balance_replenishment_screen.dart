import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../auth/providers/auth_provider.dart';
import '../../clubs/data/booking_api.dart';
import '../../clubs/widgets/club_card.dart';
import '../providers/balance_providers.dart';

class BalanceReplenishmentScreen extends ConsumerStatefulWidget {
  const BalanceReplenishmentScreen({super.key});

  @override
  ConsumerState<BalanceReplenishmentScreen> createState() => _BalanceReplenishmentScreenState();
}

class _BalanceReplenishmentScreenState extends ConsumerState<BalanceReplenishmentScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(balanceSelectionProvider.notifier).clear());
  }

  Future<void> _createWallet(String gameCenterId) async {
    final user = ref.read(authProvider).user;
    if (user == null) return;
    try {
      await ref.read(bookingApiProvider).wallets(userId: user.id, gameCenterId: gameCenterId);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final clubs = ref.watch(clubWalletsProvider);
    final selected = ref.watch(balanceSelectionProvider);
    final items = clubs.value ?? const <ClubWallet>[];
    return Stack(
      children: [
        AcePage(
          gap: 10,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          children: [
            Text(l.selectAComputerClub, style: AceText.style(size: 14, weight: FontWeight.w600)),
            if (clubs.isLoading && items.isEmpty)
              const Padding(padding: EdgeInsets.only(top: 40), child: Center(child: AceSpinner(color: AceColors.accent)))
            else
              for (final c in items)
                GestureDetector(
                  onTap: () => ref.read(balanceSelectionProvider.notifier).toggle(c),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(16)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 12,
                      children: [
                        Expanded(
                          child: Row(
                            spacing: 12,
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: CachedNetworkImage(imageUrl: clubLogoFallback, fit: BoxFit.contain, errorWidget: (_, _, _) => Image.asset('assets/images/just_icon.png')),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 6,
                                  children: [
                                    Text(c.club.name ?? '', style: AceText.style(size: 16, weight: FontWeight.w600)),
                                    Text(l.currentBalanceSum('${c.balance}'), style: AceText.style(size: 14, weight: FontWeight.w500, color: AceColors.muted)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        AceIcon(selected?.club.id == c.club.id ? 'circle-check' : 'circle', size: 24),
                      ],
                    ),
                  ),
                ),
          ],
        ),
        if (selected != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 32,
            child: AceButton(
              label: l.next,
              style: AceButtonStyle.white,
              onPressed: () {
                context.push('/balance/form');
                _createWallet(selected.club.id);
              },
            ),
          ),
      ],
    );
  }
}
