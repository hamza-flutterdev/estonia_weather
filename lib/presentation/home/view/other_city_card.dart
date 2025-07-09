import 'package:flutter/material.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/common_widgets/weather_icon.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/common_shimmer.dart';
import '../controller/home_controller.dart';

class OtherCitiesSection extends StatelessWidget {
  const OtherCitiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final ConditionController conditionController = Get.find();

    return Obx(
      () => Column(
        children: [
          SizedBox(
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
                    : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo is ScrollUpdateNotification) {
                          final itemWidth =
                              mobileWidth(context) * 0.7 + kBodyHp;
                          final currentIndex =
                              (scrollInfo.metrics.pixels / itemWidth).round();
                          final clampedIndex = currentIndex.clamp(
                            0,
                            conditionController.otherCitiesWeather.length - 1,
                          );
                          if (homeController.currentOtherCityIndex.value !=
                              clampedIndex) {
                            homeController.updateOtherCityIndex(clampedIndex);
                          }
                        }
                        return false;
                      },
                      child: ListView.builder(
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
          const SizedBox(height: kElementGap),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                conditionController.otherCitiesWeather.length.clamp(0, 10),
                (index) => Container(
                  margin: kPaginationMargin,
                  width: mobileWidth(context) * 0.015,
                  height: mobileWidth(context) * 0.015,
                  decoration: BoxDecoration(
                    color:
                        index == homeController.currentOtherCityIndex.value
                            ? primaryColor
                            : greyColor,
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
        Container(
          padding: EdgeInsets.only(
            left: mobileWidth(context) * 0.15,
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
