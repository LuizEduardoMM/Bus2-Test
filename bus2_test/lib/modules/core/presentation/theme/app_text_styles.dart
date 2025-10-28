import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const _baseHeadline = TextStyle(fontSize: 28);
  static const _baseTitleMedium = TextStyle(fontSize: 16);
  static const _baseTitleSmall = TextStyle(fontSize: 14);
  static const _baseBodyMedium = TextStyle(fontSize: 14);

  static TextStyle getHeadlineDetails(TextTheme textTheme) {
    return (textTheme.headlineMedium ?? _baseHeadline).copyWith(
      fontWeight: FontWeight.w900,
      color: AppColors.textHeadline,
      letterSpacing: -0.5,
    );
  }

  static TextStyle getBadgeText(TextTheme textTheme) {
    return (textTheme.titleSmall ?? _baseTitleSmall).copyWith(
      color: AppColors.textBadge,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.5,
    );
  }

  static TextStyle getInfoLabelStyle(TextTheme textTheme) {
    return (textTheme.bodyMedium ?? _baseBodyMedium).copyWith(fontWeight: FontWeight.bold, color: AppColors.textLabel);
  }

  static TextStyle getInfoValueStyle(TextTheme textTheme) {
    return (textTheme.bodyMedium ?? _baseBodyMedium).copyWith(color: AppColors.textValue);
  }

  static TextStyle getSectionTitle(TextTheme textTheme) {
    return (textTheme.titleMedium ?? _baseTitleMedium).copyWith(
      fontWeight: FontWeight.bold,
      color: AppColors.textSectionTitle,
    );
  }
}
