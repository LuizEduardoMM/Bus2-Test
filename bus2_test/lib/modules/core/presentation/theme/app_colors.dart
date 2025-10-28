import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0066CC);
  static const Color primaryDark = Color(0xFF0052A3);

  static const Color textHeadline = Color(0xFF001A4D);
  static const Color textSectionTitle = Color(0xFF003D99);
  static const Color textBadge = Color(0xFF003D99);
  static const Color textLabel = Colors.grey;
  static const Color textValue = Colors.black87;

  static const Color backgroundLight = Color(0xFFF5F9FE);
  static const Color backgroundDark = Color(0xFFEBF3FA);
  static const Color avatarBackground = Color(0xFFE0EDFB);
  static const Color cardGradientStart = Color(0xFFFAFCFE);

  static const Color white = Colors.white;
  static const Color favorite = Color(0xFFFF6B6B);
  static const Color badgeBorder = Color(0xFF85B3FF);
  static const Color cardBorder = Color(0xFFC5E0F5);

  static Color primaryShadow = primary.withValues(alpha: 0.3);
  static Color badgeGradientStart = primary.withValues(alpha: 0.15);
  static Color badgeGradientEnd = primary.withValues(alpha: 0.08);
  static Color badgeShadow = primary.withValues(alpha: 0.15);
  static Color badgeIconBackground = primary.withValues(alpha: 0.2);
}
