import 'package:flutter/material.dart';

import '../theme/ace_colors.dart';
import '../theme/ace_theme.dart';
import 'ace_icon.dart';

enum AceButtonStyle { plain, gray, lightBlue, blue, red, white, black }

class AceButton extends StatelessWidget {
  const AceButton({
    super.key,
    this.label,
    this.child,
    this.style = AceButtonStyle.plain,
    this.icon,
    this.iconRight,
    this.leading,
    this.loading = false,
    this.disabled = false,
    this.onPressed,
    this.padding = const EdgeInsets.symmetric(vertical: 17, horizontal: 22),
    this.radius = AceRadius.pill,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w600,
    this.gap = 8,
    this.textColor,
    this.borderColor,
    this.expand = true,
    this.shadow,
  });

  final String? label;
  final Widget? child;
  final AceButtonStyle style;
  final String? icon;
  final String? iconRight;
  final Widget? leading;
  final bool loading;
  final bool disabled;
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  final double radius;
  final double fontSize;
  final FontWeight fontWeight;
  final double gap;
  final Color? textColor;
  final Color? borderColor;
  final bool expand;
  final List<BoxShadow>? shadow;

  Color get _bg => switch (style) {
        AceButtonStyle.plain => Colors.transparent,
        AceButtonStyle.gray => AceColors.cardAlt,
        AceButtonStyle.lightBlue => AceColors.telegram,
        AceButtonStyle.blue => AceColors.blue,
        AceButtonStyle.red => AceColors.accent,
        AceButtonStyle.white => AceColors.white,
        AceButtonStyle.black => AceColors.card,
      };

  Color get _fg => textColor ?? (style == AceButtonStyle.white ? AceColors.accentDark : AceColors.white);

  @override
  Widget build(BuildContext context) {
    final isDisabled = disabled || loading;
    final fg = _fg;
    final children = <Widget>[
      if (loading)
        AceSpinner(color: fg)
      else if (leading != null)
        leading!
      else if (icon != null)
        AceIcon(icon!, color: fg),
      if (label != null) Flexible(child: Text(label!, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: AceText.style(size: fontSize, weight: fontWeight, color: fg))),
      if (label == null && child != null) Flexible(child: child!),
      if (iconRight != null) AceIcon(iconRight!, color: fg),
    ];
    final shadows = isDisabled ? null : (shadow ?? (style == AceButtonStyle.red ? AceShadows.accent : null));
    return Opacity(
      opacity: isDisabled ? 0.6 : 1,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius), boxShadow: shadows),
        child: Material(
          color: _bg,
          borderRadius: BorderRadius.circular(radius),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: isDisabled ? null : onPressed,
            splashColor: const Color(0x33FFFFFF),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: borderColor == null ? null : Border.all(color: borderColor!),
              ),
              child: IconTheme(
                data: IconThemeData(color: fg, size: 20),
                child: Row(
                  mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: gap,
                  children: children,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AceCircleButton extends StatelessWidget {
  const AceCircleButton({super.key, required this.icon, this.onTap, this.size = 44, this.iconSize = 22, this.color = AceColors.card, this.iconColor});

  final String icon;
  final VoidCallback? onTap;
  final double size;
  final double iconSize;
  final Color color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(child: AceIcon(icon, size: iconSize, color: iconColor)),
      ),
    );
  }
}

class AcePill extends StatelessWidget {
  const AcePill({super.key, required this.child, this.color = AceColors.cardAlt, this.height = 32, this.padding = const EdgeInsets.symmetric(horizontal: 14), this.onTap});

  final Widget child;
  final Color color;
  final double height;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: height,
        padding: padding,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(AceRadius.pill)),
        child: Center(widthFactor: 1, child: child),
      ),
    );
  }
}
