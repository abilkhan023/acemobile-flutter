import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ace_colors.dart';

abstract final class AceText {
  static const family = 'Rubik';

  static TextStyle style({
    double size = 15,
    FontWeight weight = FontWeight.w400,
    Color color = AceColors.text,
    double? height,
  }) =>
      TextStyle(fontFamily: family, fontSize: size, fontWeight: weight, color: color, height: height);

  static TextStyle get title => style(size: 18, weight: FontWeight.w600);
  static TextStyle get titleBig => style(size: 22, weight: FontWeight.w600);
  static TextStyle get titleMini => style(size: 16, weight: FontWeight.w600);
  static TextStyle get body => style(size: 15, weight: FontWeight.w500);
  static TextStyle get text => style(size: 13, weight: FontWeight.w400, color: AceColors.muted);
  static TextStyle get label => style(size: 13, weight: FontWeight.w500, color: AceColors.muted);
  static TextStyle get caption => style(size: 12, weight: FontWeight.w400, color: AceColors.muted);
  static TextStyle get link => style(size: 14, weight: FontWeight.w500, color: AceColors.link);
}

abstract final class AceTheme {
  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: AceText.family,
      scaffoldBackgroundColor: AceColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AceColors.accent,
        secondary: AceColors.accent,
        surface: AceColors.bg,
        onSurface: AceColors.text,
        error: AceColors.accent,
      ),
      splashFactory: InkRipple.splashFactory,
      highlightColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AceColors.text, size: 20),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
      cupertinoOverrideTheme: const CupertinoThemeData(brightness: Brightness.dark),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
      dialogTheme: const DialogThemeData(backgroundColor: Colors.transparent),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(fontFamily: AceText.family, bodyColor: AceColors.text, displayColor: AceColors.text).copyWith(
        bodyMedium: AceText.style(),
      ),
      textSelectionTheme: const TextSelectionThemeData(cursorColor: AceColors.accent),
    );
  }
}
