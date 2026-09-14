import 'package:flutter/material.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../../shared/widgets/list_item.dart';
import '../providers/balance_providers.dart';

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({super.key, required this.value, this.onChanged, this.blockSelect = false, this.preview = false});

  final PaymentMethod? value;
  final ValueChanged<PaymentMethod?>? onChanged;
  final bool blockSelect;
  final bool preview;

  void _open(BuildContext context) {
    final l = context.l10n;
    FocusManager.instance.primaryFocus?.unfocus();
    showAceSheet(
      context,
      title: l.replenishmentMethods,
      builder: (ctx) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(l.myCards, style: AceText.title),
          ),
          AceListItem(
            title: kaspiMethod.name,
            image: kaspiMethod.img,
            active: value?.id == kaspiMethod.id,
            onTap: () {
              onChanged?.call(value?.id == kaspiMethod.id ? null : kaspiMethod);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final v = value;
    return GestureDetector(
      onTap: blockSelect ? null : () => _open(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.input)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (v == null)
              Text(l.selectPaymentMethod, style: AceText.style(size: 15, weight: FontWeight.w500, color: AceColors.muted))
            else
              Row(
                spacing: 10,
                children: [
                  Image.asset(v.img, width: 25, height: 25),
                  Text(v.name, style: AceText.style(size: 15, weight: FontWeight.w600)),
                ],
              ),
            if (!preview) const AceIcon('chevron-right', size: 20, color: AceColors.dim),
          ],
        ),
      ),
    );
  }
}
