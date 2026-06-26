import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/app_constants.dart';

ThemeData light = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFF00B276),
  secondaryHeaderColor: const Color(0xFFECFDF5),
  brightness: Brightness.light,
  cardColor: Colors.white,
  scaffoldBackgroundColor: const Color(0xFFF8FAFC),
  focusColor: const Color(0xFF10B981),
  hintColor: const Color(0xFF64748B),
  canvasColor: const Color(0xFFF8FAFC),
  shadowColor: Colors.black.withValues(alpha: 0.04),

  cardTheme: CardThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
    color: Colors.white,
    shadowColor: Colors.black.withValues(alpha: 0.04),
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(color: Color(0xFF1E293B)),
    bodyMedium: TextStyle(color: Color(0xFF475569)),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.white, 
    surfaceTintColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
  ),
  dialogTheme: DialogThemeData(
    surfaceTintColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF00B276),
    onPrimary: Colors.white,
    secondary: const Color(0xFFECFDF5),
    onSecondary: const Color(0xFF0F172A),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: const Color(0xFF0F172A),
    shadow: Colors.black.withValues(alpha: 0.04),
  ),
);