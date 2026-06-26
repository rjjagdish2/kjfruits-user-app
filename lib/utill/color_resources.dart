import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class ColorResources {
  static Color getGreyColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF475569) : const Color(0xFFE2E8F0);
  }


  static Color getDarkColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF1E293B) : const Color(0xFF0F172A);
  }


  static Color getFooterTextColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFFF8FAFC) : const Color(0xFF334155);
  }


  static Color getGreyLightColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  }


  static Color getCategoryBgColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9);
  }



  static Color getAppBarHeaderColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF01937C) : const Color(0xFFE6F7F4);
  }

  static Color getChatAdminColor(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ?  const Color(0xFFa1916c) : const Color(0xFFFFDDD9);
  }
  static Color getSearchBg(BuildContext context) {
    return Provider.of<ThemeProvider>(context).darkTheme ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
  }
  static const Color cartShadowColor = Color(0xFFCBD5E1);
  static const Color ratingColor = Color(0xFFFFB000);
  static const Color colorGreen = Color(0xFF01937C);
  static const Color colorBlue = Color(0xFF0EA5E9);
  static const Color redColor = Color(0xFFEF4444);

}
