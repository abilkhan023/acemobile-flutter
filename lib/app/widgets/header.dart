import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/l10n.dart';
import '../../shared/theme/ace_theme.dart';
import '../../shared/widgets/ace_button.dart';
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
    final titleWidget = meta.titleWidget?.call(context, path);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: SizedBox(
        height: 52,
        child: Stack(
          children: [
            if (titleWidget != null || (title.isNotEmpty && isGoBack))
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 56),
                  child: Center(
                    child:
                        titleWidget ??
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AceText.style(size: 16, weight: FontWeight.w600),
                        ),
                  ),
                ),
              ),
            Row(
              spacing: 12,
              children: [
                if (showBack) AceCircleButton(icon: 'chevron-left', onTap: () => canPop ? context.pop() : context.go('/')),
                if (title.isNotEmpty && !isGoBack)
                  Expanded(
                    child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AceText.titleBig),
                  )
                else
                  const Spacer(),
                if (meta.headerActions != null)
                  if (title.isNotEmpty)
                    meta.headerActions!(context)
                  else
                    Expanded(
                      flex: 1000,
                      child: Align(alignment: Alignment.centerRight, child: meta.headerActions!(context)),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
