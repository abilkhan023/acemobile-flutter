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
    this.padding = const EdgeInsets.symmetric(vertical: 14.5, horizontal: 18),
    this.radius = 16,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w700,
    this.gap = 4,
    this.textColor,
    this.borderColor,
    this.expand = true,
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

  Color get _bg => switch (style) {
        AceButtonStyle.plain => Colors.transparent,
        AceButtonStyle.gray => AceColors.cardAlt,
        AceButtonStyle.lightBlue => AceColors.telegram,
        AceButtonStyle.blue => AceColors.blue,
        AceButtonStyle.red => AceColors.red,
        AceButtonStyle.white => AceColors.white,
        AceButtonStyle.black => AceColors.black,
      };

  Color get _fg => textColor ?? (style == AceButtonStyle.white ? AceColors.cardAlt : AceColors.white);

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
      if (label != null) Flexible(child: Text(label!, textAlign: TextAlign.center, style: AceText.style(size: fontSize, weight: fontWeight, color: fg))),
      if (label == null && child != null) Flexible(child: child!),
      if (iconRight != null) AceIcon(iconRight!, color: fg),
    ];
    return Opacity(
      opacity: isDisabled ? 0.7 : 1,
      child: Material(
        color: _bg,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          splashColor: const Color(0x66FFFFFF),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: borderColor ?? Colors.transparent),
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
    );
  }
}
