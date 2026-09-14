import 'package:flutter/material.dart';

abstract final class AceColors {
  static const bg = Color(0xFF151316);
  static const surface = Color(0xFF1B181C);
  static const card = Color(0xFF201D22);
  static const cardAlt = Color(0xFF2B272D);
  static const black = Color(0xFF2B272D);
  static const border = Color(0xFF2B272D);
  static const text = Color(0xFFF7F5F7);
  static const muted = Color(0xFFA39DA6);
  static const dim = Color(0xFF8C8690);
  static const footer = Color(0xFF8C8690);
  static const divider = Color(0xFF2B272D);
  static const white = Color(0xFFFFFFFF);
  static const accent = Color(0xFFF93829);
  static const accentDark = Color(0xFFB8261C);
  static const success = Color(0xFF5BE0A0);
  static const successBg = Color(0x2634C77B);
  static const link = Color(0xFFF93829);
  static const telegram = Color(0xFF34AADF);
  static const blue = Color(0xFF0039D6);
  static const red = Color(0xFFF93829);
  static const gray7 = Color(0xFF7A7A7A);
  static const fillFocused = Color(0xFF2B272D);
  static const toastOrange = Color(0xFFEC4A0A);
  static const toastRed = Color(0xFFD92D20);
  static const toastGreen = Color(0xFF027A48);
  static const toastBlue = Color(0xFF3A94CF);
  static const toastGray = Color(0xFF667085);
  static const overlay = Color(0x99000000);
  static const sheetOverlay = Color(0x80000000);
}

abstract final class AceRadius {
  static const double card = 28;
  static const double row = 24;
  static const double input = 20;
  static const double tile = 14;
  static const double pill = 999;
}

abstract final class AceShadows {
  static const card = [BoxShadow(color: Color(0x59000000), offset: Offset(0, 14), blurRadius: 34)];
  static const accent = [BoxShadow(color: Color(0x59F93829), offset: Offset(0, 16), blurRadius: 36)];
  static const bar = [BoxShadow(color: Color(0x73000000), offset: Offset(0, 14), blurRadius: 34)];
}
