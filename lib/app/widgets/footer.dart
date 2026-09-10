import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/l10n.dart';
import '../../shared/theme/ace_colors.dart';
import '../../shared/theme/ace_theme.dart';
import '../../shared/widgets/ace_icon.dart';

class AceFooter extends StatelessWidget {
  const AceFooter({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = [
      (icon: 'vuesax', label: l.home, to: '/'),
      (icon: 'qr-code', label: l.aceQr, to: '/qr-code'),
      (icon: 'ace', label: l.catalog, to: '/clubs'),
      (icon: 'user-square', label: l.profile, to: '/profile'),
    ];
    final bottom = MediaQuery.paddingOf(context).bottom;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, bottom > 16 ? bottom : 16),
          decoration: const BoxDecoration(
            color: Color(0xA62C2B2B),
            border: Border(top: BorderSide(color: AceColors.cardAlt)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final item in items)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.go(item.to),
                  child: SizedBox(
                    width: 85,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        AceIcon(item.icon, size: 24, color: path == item.to ? AceColors.white : AceColors.footer),
                        Text(item.label, style: AceText.style(size: 12, color: path == item.to ? AceColors.white : AceColors.footer)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
