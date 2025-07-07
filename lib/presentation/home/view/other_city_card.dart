import 'package:flutter/material.dart';
import '../../../core/constants/constant.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import 'weather_icon.dart';

import 'package:get/get.dart';
import '../../../core/common_widgets/common_shimmer.dart';

import '../../reusable/controllers/condition_controller.dart';
import '../controller/home_controller.dart';

class OtherCitiesSection extends StatelessWidget {
  const OtherCitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final ConditionController conditionController = Get.find();

    return Obx(
      () => Stack(
        children: [
          Positioned(
            top: mobileHeight(context) * 0.65,
            left: mobileWidth(context) * 0.05,
            right: mobileWidth(context) * 0.05,
            child: Text(
              'Other Cities',
              style: titleBoldMediumStyle.copyWith(color: primaryColor),
            ),
          ),
          Positioned(
            top: mobileHeight(context) * 0.685,
            child: SizedBox(
              height: mobileHeight(context) * 0.1,
              width: mobileWidth(context),
              child:
                  homeController.isLoading.value
                      ? ShimmerListView(
                        itemCount: 2,
                        itemWidth: mobileWidth(context) * 0.7,
                        itemHeight: mobileHeight(context) * 0.1,
                        itemMargin:
                            (index) => EdgeInsets.only(
                              left: index == 0 ? kBodyHp * 2 : kElementGap,
                              right: index == 2 ? kBodyHp : kElementGap,
                            ),
                        itemDecoration: roundedDecorationWithShadow,
                      )
                      : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount:
                            conditionController.otherCitiesWeather.length,
                        itemBuilder: (context, index) {
                          final weather =
                              conditionController.otherCitiesWeather[index];
                          final isFirst = index == 0;
                          final isLast =
                              index ==
                              conditionController.otherCitiesWeather.length - 1;
                          return Container(
                            width: mobileWidth(context) * 0.7,
                            margin: EdgeInsets.only(
                              left: isFirst ? kBodyHp * 2 : kElementGap,
                              right: isLast ? kBodyHp : kElementGap,
                            ),
                            decoration: roundedDecorationWithShadow.copyWith(
                              color: primaryColor,
                            ),
                            child: OtherCityCard(
                              cityName: weather.cityName,
                              condition: weather.condition,
                              temperature: '${weather.temperature.round()}°',
                              iconUrl: weather.iconUrl,
                            ),
                          );
                        },
                      ),
            ),
          ),
          Positioned(
            top: mobileHeight(context) * 0.82,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                conditionController.otherCitiesWeather.length.clamp(0, 10),
                (index) => Container(
                  margin: kPaginationMargin,
                  width: mobileWidth(context) * 0.015,
                  height: mobileWidth(context) * 0.015,
                  decoration: BoxDecoration(
                    color: index == 0 ? primaryColor : greyColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OtherCityCard extends StatelessWidget {
  final String cityName;
  final String condition;
  final String temperature;
  final String iconUrl;

  const OtherCityCard({
    super.key,
    required this.cityName,
    required this.condition,
    required this.temperature,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -mobileHeight(context) * 0.01,
          left: -mobileWidth(context) * 0.08,
          child: WeatherIcon(
            weatherData: true,
            iconUrl: iconUrl,
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
