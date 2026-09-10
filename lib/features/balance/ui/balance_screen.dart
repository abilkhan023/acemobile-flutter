import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n.dart';
import '../../../core/utils/money.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_page.dart';
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
    final wallets = ref.watch(walletClubsProvider);
    final items = wallets.value ?? const <WalletClub>[];
    if (wallets.isLoading && items.isEmpty) return const Center(child: AceSpinner(color: AceColors.accent));
    return AcePage(
      gap: 12,
      children: [
        for (final w in items)
          GestureDetector(
            onTap: () => context.push('/balance/${w.key}'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border.all(color: AceColors.divider), borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(w.displayName, style: AceText.style(size: 16)),
                        const SizedBox(height: 6),
                        Text(w.club?.address ?? '', style: AceText.style(size: 14)),
                      ],
                    ),
                  ),
                  Text(formatMoney(w.ownBalance), style: AceText.style(size: 18)),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
