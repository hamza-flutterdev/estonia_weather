import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/weather_utils.dart';
import '../../../extensions/device_size/device_size.dart';
import '../../../presentation/home/view/weather_detail_item.dart';

class WeatherDetailsCard extends StatelessWidget {
  final DeviceSize deviceSize;

  const WeatherDetailsCard({super.key, required this.deviceSize});

  @override
  Widget build(BuildContext context) {
    final condition = Get.find<ConditionController>();

    return Obx(() {
      final weatherData = condition.mainCityWeather.value;
      final String humidity = '${weatherData!.humidity}%';
      final String windSpeed =
          '${weatherData.windSpeed.toStringAsFixed(1)}km/h';
      final String precipitation = '${weatherData.chanceOfRain}%';

      return Container(
        height: deviceSize.height * 0.11,
        decoration: roundedDecorationWithShadow(context).copyWith(
          color:
              isDarkMode(context) ? kWhite.withValues(alpha: 0.1) : kLightWhite,
        ),
        padding: kContentPaddingSmall,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: WeatherDetailItem(
                icon: WeatherUtils.getHomeIcon('precipitation'),
                value: precipitation,
                label: 'Precipitation',
              ),
            ),
            Expanded(
              child: WeatherDetailItem(
                icon: WeatherUtils.getHomeIcon('humidity'),
                value: humidity,
                label: 'Humidity',
              ),
            ),
            Expanded(
              child: WeatherDetailItem(
                icon: WeatherUtils.getHomeIcon('wind'),
                value: windSpeed,
                label: 'Wind',
              ),
            ),
          ],
        ),
      );
    });
  }
}
