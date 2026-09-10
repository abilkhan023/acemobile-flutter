import 'package:flutter/material.dart';

import '../theme/ace_colors.dart';
import '../theme/ace_theme.dart';
import 'ace_icon.dart';

class AceCheckbox extends StatelessWidget {
  const AceCheckbox({super.key, this.active = false, this.label, this.onTap});

  final bool active;
  final String? label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: AceColors.bg,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AceColors.white),
          ),
          child: active ? const AceIcon('check', size: 17) : null,
        ),
      );
    }
    return AceChip(label: label!, active: active, onTap: onTap);
  }
}

class AceChip extends StatelessWidget {
  const AceChip({super.key, required this.label, this.active = false, this.onTap});

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AceColors.accent : AceColors.cardAlt,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 4,
          children: [
            Text(label, style: AceText.style(size: 12)),
            if (active) const AceIcon('circle-xmark', size: 16),
          ],
        ),
      ),
    );
  }
}

class AceRadioChips extends StatelessWidget {
  const AceRadioChips({super.key, required this.options, required this.labelOf, this.value, this.onChanged});

  final List<String> options;
  final String Function(String) labelOf;
  final String? value;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final o in options)
          AceChip(label: labelOf(o), active: value == o, onTap: () => onChanged?.call(value == o ? null : o)),
      ],
    );
  }
}
