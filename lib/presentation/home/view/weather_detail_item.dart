import 'package:flutter/material.dart';

import '../../../core/constants/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class WeatherDetailItem extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const WeatherDetailItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(icon, width: primaryIcon(context)),
        const SizedBox(height: kElementInnerGap),
        Text(value, style: titleBoldMediumStyle.copyWith(color: primaryColor)),
        Text(label, style: bodyMediumStyle.copyWith(color: primaryColor)),
      ],
    );
  }
}
