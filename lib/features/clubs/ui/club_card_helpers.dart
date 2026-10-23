import 'package:flutter/material.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../providers/club_live.dart';

Widget livePill(BuildContext context, ClubLive? live) {
  final l = context.l10n;
  final free = live?.free ?? 0;
  final busy = live != null && free == 0;
  return Container(
    height: 28,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: busy ? const Color(0x2EF93829) : const Color(0x2434C77B),
      borderRadius: BorderRadius.circular(AceRadius.pill),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: busy ? AceColors.accent : AceColors.success, shape: BoxShape.circle)),
        Text(
          live == null ? '…' : l.freeOf('${live.free}', '${live.total}'),
          style: AceText.style(size: 12, weight: FontWeight.w600, color: busy ? AceColors.accent : AceColors.success),
        ),
      ],
    ),
  );
}
