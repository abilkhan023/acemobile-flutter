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
    final fg = active ? AceColors.bg : AceColors.white;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: active ? AceColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AceColors.white),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 16,
              children: [
                Image.asset(image, width: 25, height: 25, fit: BoxFit.contain),
                Text(title, style: AceText.style(size: 16, weight: FontWeight.w500, color: fg)),
              ],
            ),
            AceIcon('chevron-right', size: 24, color: fg),
          ],
        ),
      ),
    );
  }
}
