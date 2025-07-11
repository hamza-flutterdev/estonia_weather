import 'package:flutter/material.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import 'package:get/get.dart';
import '../../../core/utils/weather_utils.dart';
import '../controller/home_controller.dart';

class WeatherDetailsCard extends StatelessWidget {
  const WeatherDetailsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ConditionController conditionController = Get.find();
    final HomeController homeController = Get.find();

    return Obx(() {
      final selectedForecastIndex = homeController.selectedForecastIndex.value;
      final forecastData = conditionController.getForecastForDay(
        selectedForecastIndex,
      );

      final precipitationValue =
          forecastData != null
              ? '${forecastData['chanceOfRain']}%'
              : conditionController.chanceOfRain;

      final humidityValue =
          forecastData != null
              ? '${forecastData['humidity']}%'
              : conditionController.humidity;

      final windValue =
          forecastData != null
              ? '${forecastData['windSpeed'].toStringAsFixed(1)}km/h'
              : conditionController.windSpeed;

      return Container(
        height: mobileHeight(context) * 0.11,
        decoration: roundedDecorationWithShadow.copyWith(color: kLightWhite),
        child: Padding(
          padding: kContentPaddingSmall,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: WeatherDetailItem(
                  icon: WeatherUtils.getHomeIcon('precipitation'),
                  value: precipitationValue,
                  label: 'Precipitation',
                ),
              ),
              Expanded(
                child: WeatherDetailItem(
                  icon: WeatherUtils.getHomeIcon('humidity'),
                  value: humidityValue,
                  label: 'Humidity',
                ),
              ),
              Expanded(
                child: WeatherDetailItem(
                  icon: WeatherUtils.getHomeIcon('wind'),
                  value: windValue,
                  label: 'Wind',
                ),
              ),
            ],
          ),
        ),
      );
    });
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
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon, width: primaryIcon(context)),
          const SizedBox(height: kElementInnerGap),
          Text(
            value,
            style: titleBoldMediumStyle.copyWith(color: primaryColor),
          ),
          Text(label, style: bodyMediumStyle.copyWith(color: primaryColor)),
        ],
      ),
    );
  }
}
