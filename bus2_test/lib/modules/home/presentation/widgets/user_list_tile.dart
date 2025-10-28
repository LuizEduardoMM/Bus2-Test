import 'package:flutter/material.dart';

import '../../../core/domain/entities/user.dart';
import '../../../core/presentation/theme/app_colors.dart';
import '../../../core/presentation/theme/app_sizes.dart';
import '../../../core/presentation/theme/app_text_styles.dart';

class UserListTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const UserListTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: cardElevation,
      shape: RoundedRectangleBorder(borderRadius: radCircular16),
      clipBehavior: Clip.antiAlias,
      color: AppColors.cardGradientStart,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: pagePadding,
          child: Row(
            children: [
              Hero(
                tag: user.uuid,
                child: CircleAvatar(radius: 28, backgroundImage: NetworkImage(user.pictureLarge)),
              ),
              gapW16,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: AppTextStyles.getSectionTitle(textTheme),
                      overflow: TextOverflow.ellipsis,
                    ),
                    gapH4,
                    Text(
                      '${user.city}, ${user.state}',
                      style: AppTextStyles.getInfoLabelStyle(textTheme),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              gapW8,
              const Icon(Icons.chevron_right, color: AppColors.textLabel),
            ],
          ),
        ),
      ),
    );
  }
}
