import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n.dart';
import '../../../core/utils/money.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../clubs/widgets/club_card.dart';
import '../providers/balance_providers.dart';

class BalanceScreen extends ConsumerWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final wallets = ref.watch(walletClubsProvider);
    final items = (wallets.value ?? const <WalletClub>[]).where((w) => w.club != null).toList();
    if (wallets.isLoading && items.isEmpty) return const Center(child: AceSpinner(color: AceColors.accent));
    return AcePage(
      gap: 14,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.card), boxShadow: AceShadows.card),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 14,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Text(l.walletsPerClub, style: AceText.style(size: 18, weight: FontWeight.w700)),
                  Text(l.walletsPerClubHint, style: AceText.text),
                ],
              ),
              AceButton(label: l.topUp, style: AceButtonStyle.red, padding: const EdgeInsets.symmetric(vertical: 13), fontSize: 14, onPressed: () => context.push('/balance_replenishment')),
            ],
          ),
        ),
        Text(l.byClubs, style: AceText.title),
        for (final w in items)
          ClubCard(
            title: w.displayName,
            subtitle: w.club?.address ?? '',
            logo: w.club?.logo,
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatMoney(w.ownBalance), style: AceText.style(size: 16, weight: FontWeight.w700)),
                if (w.hasHold) Text(l.availableSum(formatMoney(w.wallet.spendable)), style: AceText.caption),
              ],
            ),
            onTap: () => openTopUp(ref, context, w),
          ),
      ],
    );
  }
}
