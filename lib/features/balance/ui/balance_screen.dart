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

Widget balanceHeaderActions(BuildContext context) => GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.push('/balance/story'),
      child: Text(context.l10n.story, style: AceText.style(size: 14, color: AceColors.link)),
    );

class BalanceScreen extends ConsumerWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final wallets = ref.watch(walletClubsProvider);
    final items = wallets.value ?? const <WalletClub>[];
    if (wallets.isLoading && items.isEmpty) return const Center(child: AceSpinner(color: AceColors.accent));
    final own = items.where((w) => w.club != null).toList();
    final total = own.fold<num>(0, (acc, w) => acc + (num.tryParse(w.balance.toString()) ?? 0));
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
              Text(l.totalAcrossNetwork, style: AceText.text),
              Text(formatMoney(total), style: AceText.style(size: 36, weight: FontWeight.w700, height: 1).copyWith(letterSpacing: -0.5)),
              Row(
                spacing: 10,
                children: [
                  Expanded(child: AceButton(label: l.topUp, style: AceButtonStyle.red, padding: const EdgeInsets.symmetric(vertical: 13), fontSize: 14, onPressed: () => context.push('/balance_replenishment'))),
                  Expanded(child: AceButton(label: l.currentBalance, style: AceButtonStyle.gray, padding: const EdgeInsets.symmetric(vertical: 13), fontSize: 14, onPressed: () => context.push('/current_balance'))),
                ],
              ),
            ],
          ),
        ),
        Text(l.byClubs, style: AceText.title),
        for (final w in items)
          ClubCard(
            title: w.displayName,
            subtitle: w.club?.address ?? '',
            logo: w.club?.logo,
            trailing: Text(formatMoney(w.ownBalance), style: AceText.style(size: 16, weight: FontWeight.w700)),
            onTap: () => context.push('/balance/${w.key}'),
          ),
      ],
    );
  }
}
