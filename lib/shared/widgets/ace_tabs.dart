import 'package:flutter/material.dart';

import '../theme/ace_colors.dart';
import '../theme/ace_theme.dart';

class AceTabs extends StatelessWidget {
  const AceTabs({super.key, required this.tabs, required this.active, required this.onActive});

  final List<String> tabs;
  final int active;
  final ValueChanged<int> onActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(8)),
      child: Row(
        spacing: 2,
        children: [
          for (final (i, t) in tabs.indexed)
            Expanded(
              child: GestureDetector(
                onTap: () => onActive(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  decoration: BoxDecoration(
                    color: active == i ? AceColors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(t, style: AceText.style(size: 16, weight: FontWeight.w600, color: active == i ? AceColors.accent : AceColors.muted)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
