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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.row), boxShadow: AceShadows.card),
      child: Row(
        spacing: 14,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: AceColors.cardAlt, shape: BoxShape.circle),
            child: Center(child: AceIcon(icon, size: 22, color: AceColors.accent)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                Text(title, style: AceText.style(size: 16, weight: FontWeight.w600)),
                Text(description, style: AceText.text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
