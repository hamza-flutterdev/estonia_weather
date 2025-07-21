import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/utils/weather_utils.dart';
import '../../../extensions/device_size/device_size.dart';
import '../../../presentation/home/view/weather_detail_item.dart';
import '../controller/home_controller.dart';

class WeatherDetailsCard extends StatelessWidget {
  final DeviceSize deviceSize;

  const WeatherDetailsCard({super.key, required this.deviceSize});

  @override
  Widget build(BuildContext context) {
    final condition = Get.find<ConditionController>();
    final home = Get.find<HomeController>();

    return Obx(() {
      final forecast = condition.getForecastForDay(
        home.selectedForecastIndex.value,
      );

      final precipitation =
          forecast?['chanceOfRain'] != null
              ? '${forecast!['chanceOfRain']}%'
              : condition.chanceOfRain;

      final humidity =
          forecast?['humidity'] != null
              ? '${forecast!['humidity']}%'
              : condition.humidity;

      final wind =
          forecast?['windSpeed'] != null
              ? '${forecast!['windSpeed'].toStringAsFixed(1)}km/h'
              : condition.windSpeed;

      return Container(
        height: deviceSize.height * 0.11,
        decoration: roundedDecorationWithShadow.copyWith(color: kLightWhite),
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
                value: wind,
                label: 'Wind',
              ),
            ),
          ],
        ),
      );
    });
  }
}
