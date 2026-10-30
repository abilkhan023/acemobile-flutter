import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/env.dart';
import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../core/utils/money.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../auth/providers/auth_provider.dart';
import '../data/banking_api.dart';
import '../providers/balance_providers.dart';

class BalanceIdScreen extends ConsumerStatefulWidget {
  const BalanceIdScreen({super.key, required this.walletId});

  final String walletId;

  @override
  ConsumerState<BalanceIdScreen> createState() => _BalanceIdScreenState();
}

class _BalanceIdScreenState extends ConsumerState<BalanceIdScreen> {
  bool _loading = false;

  Future<void> _kaspi(WalletClub? w) async {
    final l = context.l10n;
    final toast = ref.read(toastProvider.notifier);
    final user = ref.read(authProvider).user;
    setState(() => _loading = true);
    try {
      final url = await ref.read(bankingApiProvider).kaspiPay(sum: 100, username: user?.username ?? '', clubSlug: w?.club?.slug ?? '');
      if (url == null) throw StateError('no redirect url');
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      toast.danger(l.tryAgainLater);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final wallets = ref.watch(walletClubsProvider);
    final w = (wallets.value ?? const <WalletClub>[]).where((e) => e.key == widget.walletId).firstOrNull;
    final width = MediaQuery.sizeOf(context).width;
    Widget row(String icon, String text) => Row(
          spacing: 4,
          children: [
            AceIcon(icon),
            Expanded(child: Text(text, style: AceText.style(size: 14))),
          ],
        );
    return AcePage(
      gap: 0,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 46),
      children: [
        Center(
          child: QrImageView(
            data: 'https://${Env.deepLinkHost}/balance/${widget.walletId}',
            size: (width - 32) * 0.8,
            padding: const EdgeInsets.all(12),
            backgroundColor: AceColors.card,
            eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AceColors.white),
            dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: AceColors.white),
          ),
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(w?.displayName ?? '', style: AceText.style(size: 18)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(formatMoney(w?.ownBalance ?? 0), style: AceText.style(size: 18)),
                      if (w != null && w.hasHold) Text(l.availableSum(formatMoney(w.wallet.spendable)), style: AceText.caption),
                    ],
                  ),
                ],
              ),
            ),
            row('location-arrow', w?.club?.address ?? w?.club?.description ?? ''),
            row('star', '9.7'),
            row('timer', l.aroundTheClock),
          ],
        ),
        const SizedBox(height: 36),
        AceButton(label: l.topUp100Kaspi, style: AceButtonStyle.red, loading: _loading, onPressed: () => _kaspi(w)),
      ],
    );
  }
}
