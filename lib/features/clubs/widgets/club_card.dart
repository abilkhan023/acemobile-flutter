import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../shared/theme/ace_colors.dart';
import '../../../shared/theme/ace_theme.dart';
import '../../../shared/widgets/ace_icon.dart';

const clubLogoFallback = 'https://ostrov.press/wp-content/uploads/2020/10/lg_48148b64-77a4-43ab-9e14-16c0b5733568.jpg?w=1024';

class ClubCard extends StatelessWidget {
  const ClubCard({super.key, required this.title, required this.subtitle, this.logo, this.onTap, this.preview = false});

  final String title;
  final String subtitle;
  final String? logo;
  final VoidCallback? onTap;
  final bool preview;

  @override
  Widget build(BuildContext context) {
    final url = (logo?.isNotEmpty == true) ? logo! : clubLogoFallback;
    return GestureDetector(
      onTap: preview ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AceColors.card, borderRadius: BorderRadius.circular(16)),
        child: Row(
          spacing: 12,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CachedNetworkImage(imageUrl: url, fit: BoxFit.contain, errorWidget: (_, _, _) => Image.asset('assets/images/just_icon.png')),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AceText.style(size: 16, weight: FontWeight.w600)),
                  Text(subtitle, style: AceText.style(size: 14, weight: FontWeight.w500, color: AceColors.muted)),
                ],
              ),
            ),
            if (!preview) const AceIcon('chevron-right', size: 24),
          ],
        ),
      ),
    );
  }
}
