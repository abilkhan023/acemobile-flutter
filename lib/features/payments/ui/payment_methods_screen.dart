import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../../shared/widgets/list_item.dart';
import '../../balance/providers/balance_providers.dart';
import '../../balance/widgets/choice_card.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  static const _cards = ['**** **** **** 5425', '**** **** **** 2366'];

  void _selectCard(BuildContext context, String num) {
    final l = context.l10n;
    showAceSheet(
      context,
      title: '${l.card} ${num.substring(num.length - 9)}',
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 24,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              Text(l.paymentMethod, style: AceText.style(size: 16, weight: FontWeight.w500)),
              ChoiceCard(value: PaymentMethod(id: num, name: num, img: 'assets/images/kaspi.png'), preview: true, blockSelect: true),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              AceButton(label: l.setAsDefault, style: AceButtonStyle.gray),
              AceButton(label: l.removeCard, style: AceButtonStyle.gray, textColor: AceColors.accent),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    Widget header(String text) => Padding(padding: const EdgeInsets.only(bottom: 2), child: Text(text, style: AceText.style(size: 16, weight: FontWeight.w500)));
    return AcePage(
      gap: 24,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            header(l.myCards),
            for (final c in _cards) AceListItem(title: c, onTap: () => _selectCard(context, c)),
            GestureDetector(
              onTap: () => context.push('/add-new-card'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 25),
                decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AceColors.border))),
                child: Row(
                  spacing: 12,
                  children: [
                    const AceIcon('plus', size: 24),
                    Text(l.addANewCard, style: AceText.style(size: 16, weight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            header(l.otherPaymentMethods),
            for (var i = 0; i < 3; i++) const AceListItem(title: 'Kaspi.kz'),
          ],
        ),
      ],
    );
  }
}
