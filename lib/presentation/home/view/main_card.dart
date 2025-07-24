import 'package:flutter/material.dart';
import '../../../core/constants/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class MainCard extends StatelessWidget {
  final String temperature;
  final String condition;
  final String minTemp;
  final String? maxTemp;

  const MainCard({
    super.key,
    required this.temperature,
    required this.condition,
    required this.minTemp,
    this.maxTemp,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = kWhite;
    return Container(
      decoration: roundedDecorationWithShadow(
        context,
      ).copyWith(gradient: kGradient(context)),
      padding: kContentPaddingSmall,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                temperature,
                style: headlineLargeStyle(context).copyWith(color: textColor),
              ),
              Text(
                '°',
                style: headlineLargeStyle(
                  context,
                ).copyWith(color: textColor, fontSize: 75),
              ),
            ],
          ),
          const SizedBox(width: kElementWidthGap),
          Padding(
            padding: const EdgeInsets.only(bottom: kElementInnerGap),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$maxTemp°',
                  style: titleBoldMediumStyle(
                    context,
                  ).copyWith(color: textColor),
                ),
                Text(
                  '/$minTemp°',
                  style: titleBoldMediumStyle(
                    context,
                  ).copyWith(color: textColor),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              condition,
              style: titleBoldMediumStyle(context).copyWith(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
