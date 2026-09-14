import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_icon.dart';

const clubLogoFallback = 'https://ostrov.press/wp-content/uploads/2020/10/lg_48148b64-77a4-43ab-9e14-16c0b5733568.jpg?w=1024';

class ClubLogo extends StatelessWidget {
  const ClubLogo({super.key, this.url, this.size = 56});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final src = url;
    if (src == null || src.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(color: AceColors.cardAlt, shape: BoxShape.circle),
        child: Center(child: AceIcon('ace', size: size * 0.4, color: AceColors.dim)),
      );
    }
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: CachedNetworkImage(
          imageUrl: src,
          fit: BoxFit.cover,
          placeholder: (_, _) => const ColoredBox(color: AceColors.cardAlt),
          errorWidget: (_, _, _) => const ColoredBox(color: AceColors.cardAlt, child: Center(child: AceIcon('ace', size: 22, color: AceColors.dim))),
        ),
      ),
    );
  }
}

class ClubCard extends StatelessWidget {
  const ClubCard({super.key, required this.title, required this.subtitle, this.logo, this.onTap, this.preview = false, this.trailing});

  final String title;
  final String subtitle;
  final String? logo;
  final VoidCallback? onTap;
  final bool preview;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: preview ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(AceRadius.row), boxShadow: AceShadows.card),
        child: Row(
          spacing: 14,
          children: [
            ClubLogo(url: logo),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AceText.style(size: 16, weight: FontWeight.w600)),
                  Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: AceText.text),
                ],
              ),
            ),
            if (trailing != null) trailing! else if (!preview) const AceIcon('chevron-right', size: 20, color: AceColors.dim),
          ],
        ),
      ),
    );
  }
}
