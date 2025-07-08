import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../../core/constants/constant.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_styles.dart';
import '../../core/utils/weather_utils.dart';
import '../../presentation/home/view/weather_detail_item.dart';
import 'weather_icon.dart';
import '../../data/model/weather_model.dart';
import '../../data/model/forecast_model.dart';
import '../global_service/controllers/condition_controller.dart';

class WeatherInfoCard extends StatelessWidget {
  final DateTime? date;
  final String temperature;
  final String condition;
  final String? minTemp;
  final String iconUrl;
  final WeatherModel? weatherData;
  final ForecastModel? forecastData;
  final bool useGradient;
  final bool showWeatherDetails;
  final bool showIcon;
  final double? iconSize;

  const WeatherInfoCard({
    super.key,
    this.date,
    required this.temperature,
    required this.condition,
    this.minTemp,
    required this.iconUrl,
    this.weatherData,
    this.forecastData,
    this.useGradient = false,
    this.showWeatherDetails = true,
    this.showIcon = true,
    this.iconSize,
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
      padding: const EdgeInsets.all(kBodyHp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          Row(
            children: [
              if (showIcon)
                SizedBox(
                  width: iconSize ?? largeIcon(context),
                  child: WeatherIcon(
                    iconUrl: iconUrl,
                    size: iconSize ?? largeIcon(context),
                    weatherData: weatherData,
                  ),
                ),
              if (showIcon) const SizedBox(width: kElementWidthGap),
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
            const SizedBox(height: kElementGap),
            Padding(
              padding: kContentPaddingSmall,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WeatherDetailItem(
                    icon: WeatherUtils.getHomeIcon('precipitation'),
                    value: displayChanceOfRain,
                    label: 'Precipitation',
                  ),
                  WeatherDetailItem(
                    icon: WeatherUtils.getHomeIcon('humidity'),
                    value: displayHumidity,
                    label: 'Humidity',
                  ),
                  WeatherDetailItem(
                    icon: WeatherUtils.getHomeIcon('wind'),
                    value: displayWindSpeed,
                    label: 'Wind',
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
