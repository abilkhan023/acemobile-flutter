import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/l10n.dart';
import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_button.dart';
import '../../../shared/widgets/ace_icon.dart';

class LinksSection extends StatelessWidget {
  const LinksSection({super.key, required this.title, required this.children, this.onAll, this.loading = false});

  final String title;
  final List<Widget> children;
  final VoidCallback? onAll;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: AceText.title)),
            if (onAll != null)
              AceButton(
                label: context.l10n.all,
                style: AceButtonStyle.gray,
                expand: false,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                radius: 8,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                onPressed: onAll,
              ),
          ],
        ),
        const SizedBox(height: 20),
        if (loading)
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Align(alignment: Alignment.centerLeft, child: AceSpinner(color: AceColors.accent)),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(spacing: 8, children: children),
          ),
      ],
    );
  }
}

class LinkCard extends StatelessWidget {
  const LinkCard({
    super.key,
    required this.title,
    required this.text,
    this.img,
    this.icon,
    this.iconColor = AceColors.accent,
    this.row = false,
    this.mini = false,
    this.trailingTitle,
    this.onTap,
  });

  final String title;
  final String text;
  final String? img;
  final String? icon;
  final Color iconColor;
  final bool row;
  final bool mini;
  final Widget? trailingTitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Widget? leading;
    if (img != null && img!.isNotEmpty) {
      leading = SizedBox(
        width: 24,
        height: 24,
        child: img!.startsWith('http')
            ? CachedNetworkImage(imageUrl: img!, fit: BoxFit.contain, errorWidget: (_, _, _) => Image.asset('assets/images/just_icon.png'))
            : Image.asset(img!, fit: BoxFit.contain),
      );
    } else if (icon != null) {
      leading = AceIcon(icon!, size: 24, color: iconColor);
    }
    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 6,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, maxLines: 1, softWrap: false, overflow: TextOverflow.clip, style: AceText.style(size: 16, weight: FontWeight.w600))),
            ?trailingTitle,
          ],
        ),
        Text(text, maxLines: 1, softWrap: false, overflow: TextOverflow.clip, style: AceText.style(size: 13, weight: FontWeight.w500, color: AceColors.muted)),
      ],
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 255,
        constraints: BoxConstraints(minHeight: mini ? 70 : 110),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(16)),
        alignment: Alignment.bottomLeft,
        child: row
            ? Row(spacing: 10, children: [?leading, Expanded(child: info)])
            : SizedBox(
                width: 213,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 24,
                  children: [?leading, info],
                ),
              ),
      ),
    );
  }
}
