import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_page.dart';
import '../../clubs/widgets/club_card.dart';
import '../widgets/element_row.dart';

class PaymentDetailsScreen extends StatelessWidget {
  const PaymentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AcePage(
      fillHeight: true,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(16)),
              child: Column(
                spacing: 6,
                children: [
                  SizedBox(width: 40, height: 40, child: CachedNetworkImage(imageUrl: clubLogoFallback, fit: BoxFit.contain, errorWidget: (_, _, _) => Image.asset('assets/images/just_icon.png'))),
                  Padding(padding: const EdgeInsets.only(top: 4), child: Text(l.sampleClubName, style: AceText.style(size: 20, weight: FontWeight.w600))),
                  Text(l.sampleClubAddress, style: AceText.style(size: 16, weight: FontWeight.w500, color: AceColors.muted)),
                ],
              ),
            ),
            ElementRow(icon: 'desktop', title: l.pcNumber('100'), description: l.completedAtSample),
            ElementRow(icon: 'coin-vertical', title: '2 500 ₸', description: l.chargedByTariffNight),
            ElementRow(icon: 'clock-counter-clockwise', title: l.minutes120, description: l.sessionDuration),
          ],
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 10,
          children: [
            AceButton(label: l.print, style: AceButtonStyle.white, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18)),
            AceButton(label: l.sendByEmail, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18)),
          ],
        ),
      ],
    );
  }
}
