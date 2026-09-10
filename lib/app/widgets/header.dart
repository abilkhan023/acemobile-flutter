import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/l10n.dart';
import '../../shared/theme/ace_theme.dart';
import '../../shared/widgets/ace_icon.dart';
import '../route_meta.dart';

class AceHeader extends StatelessWidget {
  const AceHeader({super.key, required this.meta, required this.path, required this.canPop});

  final RouteMeta meta;
  final String path;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    if (meta.hideHeader) return const SizedBox.shrink();
    final isGoBack = canPop && path != '/' && !meta.hideBack;
    final showBack = isGoBack || !meta.hideBack;
    final title = meta.title?.call(context.l10n) ?? '';
    final bigTitle = Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AceText.style(size: 24, weight: FontWeight.w700));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 50,
        child: Stack(
          children: [
            if (title.isNotEmpty && isGoBack)
              Positioned.fill(
                child: Center(child: Text(title, style: AceText.style(size: 16, weight: FontWeight.w400))),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 16, 0),
              child: Row(
                children: [
                  if (showBack)
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => canPop ? context.pop() : context.go('/'),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: AceIcon('chevron-left', size: 24),
                      ),
                    ),
                  if (title.isNotEmpty && !isGoBack)
                    Padding(padding: EdgeInsets.only(left: showBack ? 6 : 6), child: bigTitle),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: meta.headerActions?.call(context) ?? const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
