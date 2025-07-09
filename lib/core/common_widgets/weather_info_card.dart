import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../core/constants/constant.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../core/utils/weather_utils.dart';
import '../../presentation/home/view/weather_detail_item.dart';
import '../../data/model/weather_model.dart';
import '../../data/model/forecast_model.dart';
import '../animation/weather_animation.dart';
import '../global_service/controllers/condition_controller.dart';

class WeatherInfoCard extends StatelessWidget {
  final DateTime? date;
  final String temperature;
  final String condition;
  final String? minTemp;
  final WeatherModel? weatherData;
  final ForecastModel? forecastData;
  final bool useGradient;
  final bool showWeatherDetails;
  final bool showIcon;
  final double? iconSize;
  final String imagePath;

  const WeatherInfoCard({
    super.key,
    this.date,
    required this.temperature,
    required this.condition,
    this.minTemp,
    this.weatherData,
    this.forecastData,
    this.useGradient = false,
    this.showWeatherDetails = true,
    this.showIcon = true,
    this.iconSize,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = useGradient ? kWhite : primaryColor;
    final controller = Get.find<ConditionController>();

    final String displayHumidity;
    final String displayWindSpeed;
    final String displayChanceOfRain;

    if (forecastData != null) {
      displayHumidity = '${forecastData!.humidity}%';
      displayWindSpeed = '${forecastData!.windSpeed.toStringAsFixed(1)}km/h';
      displayChanceOfRain = '${forecastData!.chanceOfRain}%';
    } else if (weatherData != null) {
      displayHumidity = '${weatherData!.humidity}%';
      displayWindSpeed = '${weatherData!.windSpeed.toStringAsFixed(1)}km/h';
      displayChanceOfRain = '${weatherData!.chanceOfRain}%';
    } else {
      displayHumidity = controller.humidity;
      displayWindSpeed = controller.windSpeed;
      displayChanceOfRain = controller.chanceOfRain;
    }

    return Container(
      decoration: roundedDecorationWithShadow.copyWith(
        gradient: useGradient ? kGradient : null,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: kBodyHp,
        vertical: 8.0,
      ), // Reduced vertical padding even more
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (date != null)
            Padding(
              padding: const EdgeInsets.only(
                bottom: 4.0,
              ), // Smaller gap below date
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.EEEE().format(date!),
                    style: headlineSmallStyle.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showIcon)
                SizedBox(
                  width: iconSize ?? largeIcon(context),
                  height: iconSize ?? largeIcon(context),
                  child: AnimatedWeatherIcon(
                    imagePath: imagePath,
                    condition: condition,
                    width: largeIcon(context),
                  ),
                ),
              if (showIcon) const SizedBox(width: kBodyHp * 2.5),
              Expanded(
                flex: minTemp != null ? 3 : 5,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      minTemp != null
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        temperature,
                        style: headlineLargeStyle.copyWith(color: textColor),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        condition,
                        style: headlineSmallStyle.copyWith(color: textColor),
                      ),
                    ),
                  ],
                ),
              ),
              if (minTemp != null)
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '/$minTemp°',
                      style: titleBoldMediumStyle.copyWith(color: textColor),
                    ),
                  ),
                ),
            ],
          ),
          if (showWeatherDetails) ...[
            const SizedBox(height: 8.0), // Reduced gap before weather details
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ), // Applied horizontal padding directly, no vertical
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: WeatherDetailItem(
                      icon: WeatherUtils.getHomeIcon('precipitation'),
                      value: displayChanceOfRain,
                      label: 'Precipitation',
                    ),
                  ),
                  Expanded(
                    child: WeatherDetailItem(
                      icon: WeatherUtils.getHomeIcon('humidity'),
                      value: displayHumidity,
                      label: 'Humidity',
                    ),
                  ),
                  Expanded(
                    child: WeatherDetailItem(
                      icon: WeatherUtils.getHomeIcon('wind'),
                      value: displayWindSpeed,
                      label: 'Wind',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
