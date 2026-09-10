import 'package:flutter/material.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_icon.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border.all(color: AceColors.cardAlt), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            children: [
              const Expanded(
                child: Row(
                  children: [
                    AceIcon('star-full', size: 24, color: AceColors.accent),
                    AceIcon('star-full', size: 24, color: AceColors.accent),
                    AceIcon('star-full', size: 24, color: AceColors.accent),
                    AceIcon('star-50', size: 24, color: AceColors.accent),
                    AceIcon('star', size: 24, color: AceColors.accent),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(l.reviewTimeAgo, style: AceText.style(size: 12, weight: FontWeight.w500, color: AceColors.muted)),
                  Text(l.reviewAuthor, style: AceText.style(size: 14, weight: FontWeight.w500, color: AceColors.muted)),
                ],
              ),
            ],
          ),
          Text(l.reviewText, style: AceText.style(size: 14, weight: FontWeight.w600)),
        ],
      ),
    );
  }
}
