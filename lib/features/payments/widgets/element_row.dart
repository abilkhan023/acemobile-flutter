import 'package:flutter/material.dart';

import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_icon.dart';

class ElementRow extends StatelessWidget {
  const ElementRow({super.key, required this.icon, required this.title, required this.description});

  final String icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(border: Border.all(color: AceColors.cardAlt), borderRadius: BorderRadius.circular(16)),
      child: Row(
        spacing: 10,
        children: [
          AceIcon(icon, size: 24, color: AceColors.accent),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                Text(title, style: AceText.style(size: 16, weight: FontWeight.w600)),
                Text(description, style: AceText.style(size: 14, weight: FontWeight.w500, color: AceColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
