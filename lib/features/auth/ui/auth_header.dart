import 'package:flutter/material.dart';

import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(title, style: AceText.style(size: 24, weight: FontWeight.w600)),
        if (subtitle != null) Text(subtitle!, style: AceText.style(size: 15, weight: FontWeight.w500, color: AceColors.muted)),
      ],
    );
  }
}
