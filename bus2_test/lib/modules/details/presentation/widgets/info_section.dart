import 'package:flutter/material.dart';

import '../../../core/presentation/theme/app_colors.dart';
import '../../../core/presentation/theme/app_sizes.dart';
import '../../../core/presentation/theme/app_text_styles.dart';

class InfoSection extends StatelessWidget {
  final String title;
  final IconData? icon;
  final List<Widget> children;

  const InfoSection({super.key, required this.title, required this.children, this.icon});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final titleStyle = AppTextStyles.getSectionTitle(textTheme);

    return Card(
      elevation: cardElevation,
      shape: RoundedRectangleBorder(borderRadius: radCircular16),
      color: AppColors.backgroundLight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radCircular16,
          border: Border.all(color: AppColors.cardBorder, width: borderMedium),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.cardGradientStart, AppColors.backgroundLight],
          ),
        ),
        child: Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) Icon(icon, color: titleStyle.color, size: iconSizeTitle),
                  if (icon != null) gapW8,

                  Text(title, style: titleStyle),
                ],
              ),

              gapH12,
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
