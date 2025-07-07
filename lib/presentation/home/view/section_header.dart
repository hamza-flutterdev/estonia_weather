import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onTap;

  const SectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: titleBoldMediumStyle.copyWith(color: primaryColor)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: bodyLargeStyle.copyWith(color: primaryColor),
          ),
        ),
      ],
    );
  }
}
