import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/widgets/ace_sheet.dart';
import '../../../shared/widgets/link_menu.dart';

void showBalanceSheet(BuildContext context) {
  final l = context.l10n;
  showAceSheet(
    context,
    title: l.balance,
    builder: (ctx) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        LinkMenu(
          title: l.currentBalance,
          onTap: () {
            Navigator.of(ctx).pop();
            context.push('/current_balance');
          },
        ),
        LinkMenu(
          title: l.balanceReplenishment,
          onTap: () {
            Navigator.of(ctx).pop();
            context.push('/balance_replenishment');
          },
        ),
      ],
    ),
  );
}
