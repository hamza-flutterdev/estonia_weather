import 'package:flutter/material.dart';
import '../../../core/constants/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import 'package:get/get.dart';

import '../../../core/utils/weather_utils.dart';
import '../../reusable/controllers/condition_controller.dart';

class WeatherDetailsCard extends StatelessWidget {
  const WeatherDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ConditionController conditionController = Get.find();

    return Obx(
      () => Positioned(
        top: mobileHeight(context) * 0.31,
        left: mobileWidth(context) * 0.05,
        right: mobileWidth(context) * 0.05,
        child: Container(
          height: mobileHeight(context) * 0.15,
          decoration: roundedDecorationWithShadow,
          child: Padding(
            padding: kContentPaddingSmall,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WeatherDetailItem(
                  icon: WeatherUtils.getHomeIcon('precipitation'),
                  value: conditionController.chanceOfRain,
                  label: 'Precipitation',
                ),
                WeatherDetailItem(
                  icon: WeatherUtils.getHomeIcon('humidity'),
                  value: conditionController.humidity,
                  label: 'Humidity',
                ),
                WeatherDetailItem(
                  icon: WeatherUtils.getHomeIcon('wind'),
                  value: conditionController.windSpeed,
                  label: 'Wind',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
