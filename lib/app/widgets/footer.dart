import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/theme/ace_colors.dart';
import '../../shared/widgets/ace_icon.dart';

const footerOverlayHeight = 100.0;

class AceFooter extends StatelessWidget {
  const AceFooter({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    const items = [
      (icon: 'vuesax', to: '/'),
      (icon: 'qr-code', to: '/qr-code'),
      (icon: 'ace', to: '/clubs'),
      (icon: 'user-square', to: '/profile'),
    ];
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottom > 0 ? bottom + 6 : 16),
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AceColors.card,
          borderRadius: BorderRadius.circular(34),
          boxShadow: AceShadows.bar,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final item in items)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => context.go(item.to),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: path == item.to ? AceColors.accent : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: AceIcon(item.icon, size: 24, color: path == item.to ? AceColors.white : AceColors.dim)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
