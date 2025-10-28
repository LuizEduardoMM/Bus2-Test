import 'package:flutter/material.dart';

import '../../../core/presentation/theme/app_colors.dart';
import '../../../core/presentation/theme/app_sizes.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchField({super.key, required this.controller, required this.onChanged, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: pagePadding.copyWith(top: 8, bottom: 12),
      color: AppColors.backgroundLight,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search, color: AppColors.textLabel),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textLabel),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.backgroundDark,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(borderRadius: br20, borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
