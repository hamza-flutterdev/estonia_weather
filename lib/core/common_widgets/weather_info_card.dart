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
import '../animation/animated_weather_icon.dart';
import '../global_service/controllers/condition_controller.dart';

class WeatherInfoCard extends StatelessWidget {
  final DateTime? date;
  final String temperature;
  final String condition;
  final String minTemp;
  final String? maxTemp;
  final WeatherModel? weatherData;
  final ForecastModel? forecastData;
  final double? iconSize;
  final String imagePath;

  const WeatherInfoCard({
    super.key,
    this.date,
    required this.temperature,
    required this.condition,
    required this.minTemp,
    this.weatherData,
    this.forecastData,
    this.iconSize,
    required this.imagePath,
    this.maxTemp,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = primaryColor;
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
      decoration: roundedDecorationWithShadow.copyWith(color: kLightWhite),
      padding: kContentPaddingSmall,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (date != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat.EEEE().format(date!),
                  style: headlineSmallStyle.copyWith(color: textColor),
                ),
              ],
            ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                SizedBox(
                  width: iconSize ?? largeIcon(context),
                  height: iconSize ?? largeIcon(context),
                  child: AnimatedWeatherIcon(
                    imagePath: imagePath,
                    condition: condition,
                    width: iconSize ?? largeIcon(context),
                  ),
                ),
                SizedBox(width: kElementGap),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            temperature,
                            style: headlineLargeStyle.copyWith(
                              color: textColor,
                            ),
                          ),
                          Text(
                            '°',
                            style: headlineLargeStyle.copyWith(
                              color: textColor,
                              fontSize: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          condition,
                          style: titleBoldLargeStyle.copyWith(color: textColor),
                        ),
                      ),
                    ),
                     SizedBox(height:5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '$maxTemp°',
                            style: titleBoldMediumStyle.copyWith(
                              color: textColor,
                            ),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '/$minTemp°',
                            style: titleBoldMediumStyle.copyWith(
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height:5),
                  ],
                ),
              ],
            ),
          ),
          ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kElementWidthGap,),
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
