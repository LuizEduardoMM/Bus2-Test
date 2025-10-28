import 'package:flutter/material.dart';

import '../../../core/domain/entities/user.dart';
import '../../../core/presentation/theme/app_colors.dart';
import '../../../core/presentation/theme/app_sizes.dart';
import '../../../core/presentation/theme/app_text_styles.dart';

class FavoriteProfileTile extends StatelessWidget {
  const FavoriteProfileTile({
    super.key,
    required this.user,
    required this.heroTag,
    required this.onTap,
    required this.onRemove,
  });

  final User user;
  final String heroTag;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: cardElevation,
      shape: RoundedRectangleBorder(borderRadius: radCircular16),
      clipBehavior: Clip.antiAlias,
      color: AppColors.cardGradientStart,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: pagePadding,
          child: Row(
            children: [
              Hero(
                tag: heroTag,
                child: CircleAvatar(radius: avatarFavoriteRadius, backgroundImage: NetworkImage(user.pictureLarge)),
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
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: iconSizeSmall, color: AppColors.primary),
                        gapW4,
                        Flexible(
                          child: Text(
                            '${user.city}, ${user.state}',
                            style: AppTextStyles.getInfoLabelStyle(textTheme),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    gapH6,
                    Text(
                      '${user.gender.toUpperCase()} • ${user.age} anos',
                      style: textTheme.bodySmall?.copyWith(color: AppColors.textLabel),
                    ),
                  ],
                ),
              ),
              gapW8,
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
                color: AppColors.textLabel,
                tooltip: 'Remover dos favoritos',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
