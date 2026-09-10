import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ace_colors.dart';

abstract final class AceText {
  static const family = 'Nunito';

  static TextStyle style({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AceColors.white,
    double? height,
  }) =>
      TextStyle(fontFamily: family, fontSize: size, fontWeight: weight, color: color, height: height);

  static TextStyle get title => style(size: 20, weight: FontWeight.w600);
  static TextStyle get titleBig => style(size: 24, weight: FontWeight.w700);
  static TextStyle get titleMini => style(size: 16, weight: FontWeight.w600);
  static TextStyle get text => style(size: 14, weight: FontWeight.w500, color: AceColors.muted);
  static TextStyle get label => style(size: 14, weight: FontWeight.w600);
  static TextStyle get link => style(size: 14, color: AceColors.link);
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
        secondary: AceColors.link,
        surface: AceColors.bg,
        onSurface: AceColors.white,
        error: AceColors.accent,
      ),
      splashFactory: InkRipple.splashFactory,
      highlightColor: Colors.transparent,
      iconTheme: const IconThemeData(color: AceColors.white, size: 20),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
      cupertinoOverrideTheme: const CupertinoThemeData(brightness: Brightness.dark),
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
      dialogTheme: const DialogThemeData(backgroundColor: Colors.transparent),
    );
    return base.copyWith(
      textTheme: base.textTheme.apply(fontFamily: AceText.family, bodyColor: AceColors.white, displayColor: AceColors.white).copyWith(
        bodyMedium: AceText.style(),
      ),
      textSelectionTheme: const TextSelectionThemeData(cursorColor: AceColors.white),
    );
  }
}
