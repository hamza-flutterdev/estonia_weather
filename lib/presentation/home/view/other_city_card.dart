import 'package:flutter/material.dart';

import '../../../core/constants/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import 'home_view.dart';

class OtherCityCard extends StatelessWidget {
  final String cityName;
  final String condition;
  final String temperature;
  final String iconPath;

  const OtherCityCard({
    super.key,
    required this.cityName,
    required this.condition,
    required this.temperature,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -mobileWidth(context) * 0.05,
          child: WeatherIcon(
            weatherData: true,
            iconPath: iconPath,
            size: mediumIcon(context),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: mobileWidth(context) * 0.25,
            right: kBodyHp,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: kWhite,
                        size: secondaryIcon(context),
                      ),
                      const SizedBox(width: kElementWidthGap),
                      Text(
                        cityName,
                        style: titleBoldMediumStyle.copyWith(color: kWhite),
                      ),
                    ],
                  ),
                  Text(
                    condition,
                    style: bodyMediumStyle.copyWith(color: kWhite),
                  ),
                ],
              ),
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
