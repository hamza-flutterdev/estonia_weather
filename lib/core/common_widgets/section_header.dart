import 'package:flutter/material.dart';
import '../constants/constant.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onTap;
  final IconData? actionIcon;

  const SectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    required this.onTap,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: titleSmallBoldStyle.copyWith(color: primaryColor)),
        GestureDetector(
          onTap: onTap,
          child: Row(
            children: [
              if (actionIcon != null)
                Icon(actionIcon, size: smallIcon(context), color: primaryColor),
              const SizedBox(width: 4),
              Text(
                actionText,
                style: bodyBoldMediumStyle.copyWith(color: primaryColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
