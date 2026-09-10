import 'package:flutter/material.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_icon.dart';
import '../../../shared/widgets/ace_page.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = [
      ('plus', l.notifTopUpTitle, l.notifTopUpMeta),
      ('check', l.notifBookingTitle, l.notifMeta),
      ('coin-vertical', l.notifChargeTitle, l.notifMeta),
      ('cart-shopping', l.notifOrderTitle, l.notifMeta),
    ];
    return AcePage(
      gap: 0,
      children: [
        for (final (icon, title, meta) in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              spacing: 16,
              children: [
                AceIcon(icon, size: 24, color: AceColors.accent),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AceText.titleMini),
                      Text(meta, style: AceText.text),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
