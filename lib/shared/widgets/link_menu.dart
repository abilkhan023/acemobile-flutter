import 'package:flutter/material.dart';

import '../theme/ace_colors.dart';
import '../theme/ace_theme.dart';
import 'ace_icon.dart';

class LinkMenu extends StatelessWidget {
  const LinkMenu({super.key, required this.title, this.subtitle, this.onTap, this.danger = false});

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    if (danger) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(22),
          alignment: Alignment.center,
          child: Text(title, style: AceText.style(size: 16, weight: FontWeight.w600, color: AceColors.muted)),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(color: AceColors.cardAlt, borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                spacing: 8,
                children: [
                  Text(title, style: AceText.style(size: 16, weight: FontWeight.w700)),
                  if (subtitle != null) Text(subtitle!, style: AceText.style(size: 12, weight: FontWeight.w500, color: AceColors.muted)),
                ],
              ),
            ),
            const AceIcon('chevron-right', size: 24),
          ],
        ),
      ),
    );
  }
}
