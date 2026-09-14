import 'package:flutter/material.dart';

import '../theme/ace_colors.dart';
import '../theme/ace_theme.dart';

class AceHr extends StatelessWidget {
  const AceHr({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(height: 1, color: AceColors.divider),
          if (title != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AceColors.bg, borderRadius: BorderRadius.circular(AceRadius.pill)),
              child: Text(title!, style: AceText.caption),
            ),
        ],
      ),
    );
  }
}
