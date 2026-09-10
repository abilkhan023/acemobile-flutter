import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/toast/toast.dart';
import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_input.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../auth/providers/auth_provider.dart';
import '../../clubs/widgets/club_card.dart';
import '../data/banking_api.dart';
import '../providers/balance_providers.dart';
import '../widgets/choice_card.dart';

class BalanceFormScreen extends ConsumerStatefulWidget {
  const BalanceFormScreen({super.key});

  @override
  ConsumerState<BalanceFormScreen> createState() => _BalanceFormScreenState();
}

class _BalanceFormScreenState extends ConsumerState<BalanceFormScreen> {
  final _form = GlobalKey<FormState>();
  final _sum = TextEditingController();
  PaymentMethod? _method;

  @override
  void initState() {
    super.initState();
    _sum.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _sum.dispose();
    super.dispose();
  }

  void _openConfirmation() {
    final l = context.l10n;
    final sum = _sum.text.trim();
    var loading = false;
    showAceSheet(
      context,
      title: l.confirmation,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 24,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Text(l.paymentMethod, style: AceText.style(size: 16, weight: FontWeight.w500)),
                ChoiceCard(value: _method, blockSelect: true),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: AceColors.cardAlt), bottom: BorderSide(color: AceColors.cardAlt))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(l.topUpAmount, style: AceText.style(size: 16, weight: FontWeight.w500, color: AceColors.muted)),
                  Text('$sum ₸', style: AceText.style(size: 20, weight: FontWeight.w600)),
                ],
              ),
            ),
            AceButton(
              style: AceButtonStyle.white,
              label: '${l.pay} ($sum ₸)',
              loading: loading,
              onPressed: () async {
                setSheet(() => loading = true);
                await _pay(sum);
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pay(String sum) async {
    final l = context.l10n;
    final toast = ref.read(toastProvider.notifier);
    final club = ref.read(balanceSelectionProvider);
    final user = ref.read(authProvider).user;
    try {
      final url = await ref.read(bankingApiProvider).kaspiPay(
            sum: num.tryParse(sum.replaceAll(' ', '')) ?? 0,
            username: user?.username ?? '',
            clubSlug: club?.club.slug ?? '',
          );
      if (url == null) throw StateError('no redirect url');
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('kaspi pay failed: $e');
      toast.danger(l.tryAgainLater);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final club = ref.watch(balanceSelectionProvider);
    final canNext = _method != null && _sum.text.trim().isNotEmpty;
    return Stack(
      children: [
        Form(
          key: _form,
          child: AcePage(
            gap: 20,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            children: [
              ClubCard(
                title: club?.club.name ?? '',
                subtitle: club?.club.address ?? club?.club.description ?? l.currentBalanceSum('${club?.balance ?? 0}'),
                logo: club?.club.logo,
                preview: true,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 24,
                children: [
                  AceInput(controller: _sum, label: l.topUpAmountT, placeholder: l.enterAmount, rules: const ['required', 'number', 'min-100', 'max-50000']),
                  ChoiceCard(value: _method, onChanged: (m) => setState(() => _method = m)),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 32,
          child: AceButton(
            label: l.next,
            style: AceButtonStyle.white,
            disabled: !canNext,
            onPressed: () {
              if (_form.currentState!.validate()) _openConfirmation();
            },
          ),
        ),
      ],
    );
  }
}
