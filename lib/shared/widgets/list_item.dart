import 'package:flutter/material.dart';

import '../theme/ace_colors.dart';
import '../theme/ace_theme.dart';
import 'ace_icon.dart';

class AceListItem extends StatelessWidget {
  const AceListItem({super.key, required this.title, this.image = 'assets/images/kaspi.png', this.active = false, this.onTap});

  final String title;
  final String image;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: active ? AceColors.accent : AceColors.cardAlt,
          borderRadius: BorderRadius.circular(AceRadius.row),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 14,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: active ? const Color(0x33FFFFFF) : AceColors.card, shape: BoxShape.circle),
                  child: Image.asset(image, fit: BoxFit.contain),
                ),
                Text(title, style: AceText.style(size: 15, weight: FontWeight.w600)),
              ],
            ),
            AceIcon(active ? 'check-circle' : 'chevron-right', size: 22, color: active ? AceColors.white : AceColors.dim),
          ],
        ),
      ),
    );
  }
}
