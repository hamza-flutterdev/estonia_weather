import 'package:flutter/material.dart';

import '../../../core/constants/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class TodayForecastCard extends StatelessWidget {
  final String day;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;

  const TodayForecastCard({
    super.key,
    required this.day,
    required this.isSelected,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mobileWidth(context) * 0.2,
      margin: EdgeInsets.only(
        left: isFirst ? kBodyHp : 0,
        right: isLast ? kBodyHp : kElementWidthGap,
      ),
      decoration: roundedDecorationWithShadow.copyWith(
        color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day, style: titleBoldMediumStyle.copyWith(color: kWhite)),
          const SizedBox(height: kElementInnerGap),
          Icon(Icons.wb_sunny, size: secondaryIcon(context), color: kWhite),
          const SizedBox(height: kElementInnerGap),
          Text('0°/0°', style: titleBoldMediumStyle.copyWith(color: kWhite)),
        ],
      ),
    );
  }
}
