import 'package:flutter/material.dart';

import '../../../core/presentation/theme/app_sizes.dart';
import '../../../core/presentation/theme/app_text_styles.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: infoRowPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.getInfoLabelStyle(textTheme)),
          gapW8,
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.getInfoValueStyle(textTheme),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
