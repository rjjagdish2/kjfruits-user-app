import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/app_constants.dart';

ThemeData dark = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFF00D0AF),
  secondaryHeaderColor: const Color(0xFF01937C),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0F172A),
  cardColor: const Color(0xFF1E293B),
  hintColor: const Color(0xFF94A3B8),
  focusColor: const Color(0xFF00D0AF),
  canvasColor: const Color(0xFF1E293B),
  shadowColor: Colors.black.withValues(alpha: 0.4),

  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
    color: const Color(0xFF1E293B),
    shadowColor: Colors.black.withValues(alpha: 0.4),
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Color(0xFFF8FAFC), fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Color(0xFFF1F5F9)),
    bodyMedium: TextStyle(color: Color(0xFFCBD5E1)),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  popupMenuTheme: const PopupMenuThemeData(
    color: Color(0xFF1E293B), 
    surfaceTintColor: Color(0xFF1E293B),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
  ),
  dialogTheme: DialogThemeData(
    surfaceTintColor: const Color(0xFF1E293B),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xFF00D0AF),
    onPrimary: const Color(0xFF0F172A),
    secondary: const Color(0xFF01937C),
    onSecondary: Colors.white,
    error: Colors.redAccent,
    onError: Colors.white,
    surface: const Color(0xFF1E293B),
    onSurface: const Color(0xFFF8FAFC),
    shadow: Colors.black.withValues(alpha: 0.4),
  ),
);
