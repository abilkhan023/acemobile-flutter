import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/l10n.dart';
import '../../../core/utils/money.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../clubs/widgets/club_card.dart';
import '../providers/balance_providers.dart';

class CurrentBalanceScreen extends ConsumerWidget {
  const CurrentBalanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final wallets = ref.watch(walletClubsProvider);
    final items = (wallets.value ?? const <WalletClub>[]).where((w) => w.club != null).toList();
    return AcePage(
      gap: 16,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Text(l.listOfComputerClubs, style: AceText.title),
            Text(l.eachClubHasItsOwnBalance, style: AceText.text),
          ],
        ),
        if (wallets.isLoading && items.isEmpty)
          const Center(child: AceSpinner(color: AceColors.accent))
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
              for (final w in items)
                ClubCard(
                  title: w.displayName,
                  subtitle: l.currentBalanceSum(formatMoney(w.ownBalance).replaceAll(' ₸', '')),
                  logo: w.club?.logo,
                  preview: true,
                ),
            ],
          ),
        if (!wallets.isLoading && items.isEmpty) Text(l.noBalancesAvailable, style: AceText.style(color: AceColors.accent)),
      ],
    );
  }
}
