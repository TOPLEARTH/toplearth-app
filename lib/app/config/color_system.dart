import 'package:flutter/material.dart';

abstract class ColorSystem {
  static const ColorScheme colorScheme = ColorScheme.light(
    primary: primary,
    onPrimary: white,
    secondary: secondary,
    onSecondary: white,
    error: red,
    onError: white,
    surface: white,
    onSurface: black,
    brightness: Brightness.light,
  );

  /// ⭐️ toplearth color
  static const Color main = Color(0xFF0F2A4F);

  static const Color sub = Color(0xFF7389A9);

  static const Color sub2 = Color(0xFF6E4EA);

  static const Color greySub = Color(0xFFD9D9D9);

  /// Transparent Color
  static const Color transparent = Colors.transparent;

  /// White Color
  static const Color white = Color(0xFFFFFFFF);

  /// Black Color
  static const Color black = Color(0xFF151515);

  static const MaterialColor mainColor = MaterialColor(
    _mainColorValue,
    <int, Color>{
      900: Color(0xFF0F2A4F),
      800: Color(0xFF1A3A5F),
      700: Color(0xFF2A4F7A),
      600: Color(0xFF3A6495),
      500: Color(0xFF4F7AAE),
      400: Color(0xFF6A94C4),
      300: Color(0xFF8AB0D9),
      200: Color(0xFFAFCCEC),
      100: Color(0xFFD9E8F6),
      50: Color(0xFFEBF3FA),
    },
  );

  static const int _mainColorValue = 0xFF0F2A4F;

  /// Primary Color
  static const MaterialColor primary = MaterialColor(
    _primaryValue,
    <int, Color>{
      900: Color(0xFF005D5E),
      800: Color(0xFF007268),
      700: Color(0xFF008D73),
      600: Color(0xFF00A978),
      500: Color(0xFF00C579),
      400: Color(0xFF37DC8C),
      300: Color(0xFF5FED9A),
      200: Color(0xFF95F9B5),
      100: Color(0xFFC9FCD4),
      50: Color(0xFFF1FFF4),
    },
  );
  static const int _primaryValue = 0xFF00C579;

  /// Secondary Color
  static const MaterialColor secondary = MaterialColor(
    _secondaryValue,
    <int, Color>{
      900: Color(0xFF225905),
      800: Color(0xFF2F6B08),
      700: Color(0xFF42850D),
      600: Color(0xFF589F13),
      500: Color(0xFF70BA1B),
      400: Color(0xFF9CD54C),
      300: Color(0xFFBDEA72),
      200: Color(0xFFDCF8A3),
      100: Color(0xFFEFFBD0),
      50: Color(0xFFF8FFE6),
    },
  );
  static const int _secondaryValue = 0xFF70BA1B;

  /// Neutral Color
  static MaterialColor neutral = const MaterialColor(
    _neutralValue,
    <int, Color>{
      900: Color(0xFF1C1C4F),
      800: Color(0xFF2E2E5F),
      700: Color(0xFF494976),
      600: Color(0xFF6A6A8D),
      500: Color(0xFF9292A5),
      400: Color(0xFFB7B7C9),
      300: Color(0xFFD4D4E3),
      200: Color(0xFFEAEAF6),
      100: Color(0xFFF5F5FF),
      50: Color(0xFFFAFAFF),
    },
  );
  static const int _neutralValue = 0xFF9292A5;

  /// Red Color
  static const MaterialColor red = MaterialColor(
    _redValue,
    <int, Color>{
      900: Color(0xFF7A082D),
      800: Color(0xFF930D2E),
      700: Color(0xFFB7152F),
      600: Color(0xFFDB1F2C),
      500: Color(0xFFFF2E2B),
      400: Color(0xFFFF6F60),
      300: Color(0xFFFF977F),
      200: Color(0xFFFFE3D4),
      100: Color(0xFFFFD5D5),
      50: Color(0xFFFFEFE6),
    },
  );
  static const int _redValue = 0xFFFF2E2B;

  /// Yellow Color
  static const MaterialColor yellow = MaterialColor(
    _yellowValue,
    <int, Color>{
      900: Color(0xFF764400),
      800: Color(0xFF8F5600),
      700: Color(0xFFB17101),
      600: Color(0xFFD48E01),
      500: Color(0xFFF7AD02),
      400: Color(0xFFFAC740),
      300: Color(0xFFFCD866),
      200: Color(0xFFFEE999),
      100: Color(0xFFFEF5CC),
      50: Color(0xFFFFFAE5),
    },
  );
  static const int _yellowValue = 0xFFF7AD02;

  /// Blue Color
  static const MaterialColor blue = MaterialColor(
    _blueValue,
    <int, Color>{
      900: Color(0xFF102670),
      800: Color(0xFF1C3988),
      700: Color(0xFF2C52A9),
      600: Color(0xFF4070CA),
      500: Color(0xFF5891EB),
      400: Color(0xFF80B1F3),
      300: Color(0xFF9BC7F9),
      200: Color(0xFFBDDDFD),
      100: Color(0xFFDEEFFE),
      50: Color(0xFFEBF4FC),
    },
  );

  static const MaterialColor grey = MaterialColor(
    _greyValue,
    <int, Color>{
      900: Color(0xFF1C1C1C),
      800: Color(0xFF2E2E2E),
      700: Color(0xFF494949),
      600: Color(0xFF6A6A6A),
      500: Color(0xFF929292),
      400: Color(0xFFB7B7B7),
      300: Color(0xFFD4D4D4),
      200: Color(0xFFEAEAEA),
      100: Color(0xFFF5F5F5),
      50: Color(0xFFFAFAFA),
    },
  );

  static const int _greyValue = 0xFF929292;

  static const int _blueValue = 0xFF5891EB;
}
