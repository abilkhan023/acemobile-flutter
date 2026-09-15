import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/l10n.dart';
import '../../shared/theme/ace_colors.dart';
import '../../shared/widgets/ace_icon.dart';

const footerOverlayHeight = 100.0;

class AceFooter extends StatelessWidget {
  const AceFooter({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final items = [
      (icon: 'ace', to: '/', label: l.clubs),
      (icon: 'refresh-ccw-clock', to: '/activity', label: l.activity),
      (icon: 'coin-vertical', to: '/balance', label: l.wallet),
      (icon: 'user-square', to: '/profile', label: l.profile),
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
                child: SizedBox(
                  width: 72,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 3,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: path == item.to ? AceColors.accent : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(child: AceIcon(item.icon, size: 20, color: path == item.to ? AceColors.white : AceColors.dim)),
                      ),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: path == item.to ? AceColors.accent : AceColors.dim, height: 1),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
