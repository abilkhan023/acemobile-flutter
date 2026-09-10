import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_page.dart';

class _Payment {
  const _Payment({required this.id, required this.type, required this.company, required this.sum, required this.date});

  final int id;
  final String type;
  final String company;
  final String sum;
  final String date;
}

class PaymentHistoryScreen extends StatelessWidget {
  const PaymentHistoryScreen({super.key});

  static const _payments = [
    _Payment(id: 1, type: 'spis', company: 'Adamar Solutions', sum: '5000', date: '2025-01-28T17:57:36'),
    _Payment(id: 2, type: 'Ne spis', company: 'BRO CLUB', sum: '15000', date: '2025-01-02T15:27:58'),
  ];

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AcePage(
      gap: 0,
      padding: EdgeInsets.zero,
      children: [
        for (final p in _payments)
          GestureDetector(
            onTap: () => context.push('/payment_history/details/${p.id}'),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16,
                children: [
                  Expanded(
                    child: Row(
                      spacing: 16,
                      children: [
                        AceIcon(p.type == 'spis' ? 'coin-vertical' : 'plus', size: 24, color: AceColors.accent),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 6,
                            children: [
                              Text(NumberFormat.decimalPattern('ru').format(num.parse(p.sum)), style: AceText.style(size: 16, weight: FontWeight.w600)),
                              Text('${p.type != 'spis' ? l.replenishment : p.company} • ${p.date}', style: AceText.style(size: 14, weight: FontWeight.w500, color: AceColors.muted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const AceIcon('chevron-right'),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
