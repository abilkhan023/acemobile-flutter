import 'package:flutter/material.dart';

import '../theme/ace_colors.dart';
import '../theme/ace_theme.dart';
import 'ace_icon.dart';

class LinkMenu extends StatelessWidget {
  const LinkMenu({super.key, required this.title, this.subtitle, this.onTap, this.danger = false, this.icon, this.trailing, this.color = AceColors.card});

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool danger;
  final String? icon;
  final String? trailing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (danger) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          alignment: Alignment.center,
          child: Text(title, style: AceText.style(size: 14, weight: FontWeight.w500, color: AceColors.muted)),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AceRadius.row)),
        child: Row(
          spacing: 14,
          children: [
            if (icon != null)
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: AceColors.cardAlt, shape: BoxShape.circle),
                child: Center(child: AceIcon(icon!)),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(title, style: AceText.style(size: 15, weight: FontWeight.w600)),
                  if (subtitle != null) Text(subtitle!, style: AceText.text),
                ],
              ),
            ),
            if (trailing != null) Text(trailing!, style: AceText.text),
            const AceIcon('chevron-right', size: 20, color: AceColors.dim),
          ],
        ),
      ),
    );
  }
}
