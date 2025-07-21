import 'package:flutter/material.dart';
import '../../../core/constants/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/common_widgets/weather_icon.dart';
import '../../../extensions/device_size/device_size.dart';

class OtherCityCard extends StatelessWidget {
  final String cityName;
  final String condition;
  final String temperature;
  final String iconUrl;
  final bool isMainCity;
  final DeviceSize deviceSize;

  const OtherCityCard({
    super.key,
    required this.cityName,
    required this.condition,
    required this.temperature,
    required this.iconUrl,
    this.isMainCity = false,
    required this.deviceSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -deviceSize.height * 0.01,
          left: -deviceSize.width * 0.08,
          child: WeatherIcon(
            weatherData: true,
            iconUrl: iconUrl,
            size: mediumIcon(context),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            left: deviceSize.width * 0.15,
            right: kBodyHp,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: kWhite,
                          size: secondaryIcon(context),
                        ),
                        const SizedBox(width: kElementWidthGap),
                        Expanded(
                          child: Text(
                            cityName,
                            style: titleBoldMediumStyle.copyWith(color: kWhite),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      condition,
                      style: bodyMediumStyle.copyWith(color: kWhite),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: kElementWidthGap),
              Text(
                temperature,
                style: headlineMediumStyle.copyWith(color: kWhite),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
