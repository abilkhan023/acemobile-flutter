import 'package:flutter/material.dart';

import '../theme/ace_colors.dart';
import '../theme/ace_theme.dart';
import 'ace_icon.dart';

Future<T?> showAceSheet<T>(BuildContext context, {String? title, required WidgetBuilder builder, bool scrollable = true}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    backgroundColor: Colors.transparent,
    barrierColor: AceColors.sheetOverlay,
    builder: (ctx) => AceSheet(title: title, scrollable: scrollable, child: builder(ctx)),
  );
}

class AceSheet extends StatelessWidget {
  const AceSheet({super.key, this.title, required this.child, this.scrollable = true});

  final String? title;
  final Widget child;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final bottom = keyboard > 0 ? 0.0 : MediaQuery.viewPaddingOf(context).bottom;
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 20,
      children: [
        Row(
          mainAxisAlignment: title == null ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
          children: [
            if (title != null) Expanded(child: Text(title!, style: AceText.titleBig)),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(color: AceColors.cardAlt, shape: BoxShape.circle),
                child: const Center(child: AceIcon('xmark', size: 18)),
              ),
            ),
          ],
        ),
        child,
      ],
    );
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: keyboard),
      child: Container(
        constraints: BoxConstraints(minHeight: size.height * 0.3, maxHeight: size.height * 0.92),
        padding: EdgeInsets.fromLTRB(20, 12, 20, (bottom > 0 ? bottom : 16) + 12),
        decoration: const BoxDecoration(
          color: AceColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AceRadius.card)),
          boxShadow: AceShadows.bar,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(color: AceColors.cardAlt, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Flexible(child: scrollable ? SingleChildScrollView(child: body) : body),
          ],
        ),
      ),
    );
  }
}
