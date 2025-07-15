import 'package:flutter/material.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../core/common_widgets/weather_icon.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/common_shimmer.dart';
import '../../../extensions/device_size/device_size.dart';
import '../controller/home_controller.dart';

class OtherCitiesSection extends StatelessWidget {
  final DeviceSize deviceSize;

  const OtherCitiesSection({super.key, required this.deviceSize});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final ConditionController conditionController = Get.find();

    return Obx(() {
      // Don't show anything if still loading or if it's first launch and data isn't ready
      if (homeController.isLoading.value ||
          (homeController.isFirstLaunch &&
              conditionController.selectedCitiesWeather.isEmpty)) {
        return const SizedBox.shrink();
      }

      // Create a list of cities with their original indices, excluding current location
      final otherCitiesWithIndex = <Map<String, dynamic>>[];
      for (
        int i = 0;
        i < conditionController.selectedCitiesWeather.length;
        i++
      ) {
        final weather = conditionController.selectedCitiesWeather[i];
        // Skip the main city (the one currently being displayed prominently)
        if (i == homeController.mainCityIndex) {
          continue;
        }

        // Additional check: if there's a current location city, exclude it from other cities
        // only if it's not the main city
        bool shouldExclude = false;
        if (homeController.currentLocationCity != null) {
          final currentLocationName =
              homeController.currentLocationCity!.city.toLowerCase().trim();
          final weatherCityName = weather.cityName.toLowerCase().trim();
          // Only exclude if it matches current location AND it's not the main city
          shouldExclude =
              weatherCityName == currentLocationName &&
              i != homeController.mainCityIndex;
        }

        if (!shouldExclude) {
          otherCitiesWithIndex.add({'weather': weather, 'originalIndex': i});
        }
      }

      // If no other cities to show, return empty container
      if (otherCitiesWithIndex.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          SizedBox(
            height: deviceSize.height * 0.1,
            width: deviceSize.width,
            child:
                homeController.isLoading.value
                    ? ShimmerListView(
                      itemCount: 2,
                      itemWidth: deviceSize.width * 0.7,
                      itemHeight: deviceSize.height * 0.1,
                      itemMargin:
                          (index) => EdgeInsets.only(
                            left: index == 0 ? kBodyHp * 2 : kElementGap,
                            right: index == 2 ? kBodyHp : kElementGap,
                          ),
                      itemDecoration: roundedDecorationWithShadow,
                    )
                    : NotificationListener(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo is ScrollUpdateNotification) {
                          final itemWidth = deviceSize.width * 0.7 + kBodyHp;
                          final currentIndex =
                              (scrollInfo.metrics.pixels / itemWidth).round();
                          final clampedIndex = currentIndex.clamp(
                            0,
                            otherCitiesWithIndex.length - 1,
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
                        itemCount: otherCitiesWithIndex.length,
                        itemBuilder: (context, index) {
                          final cityData = otherCitiesWithIndex[index];
                          final weather = cityData['weather'];
                          final originalIndex = cityData['originalIndex'];
                          final isFirst = index == 0;
                          final isLast =
                              index == otherCitiesWithIndex.length - 1;
                          final isMainCity =
                              originalIndex == homeController.mainCityIndex;

                          return GestureDetector(
                            onTap: () {
                              debugPrint('Tapped on city: ${weather.cityName}');
                              debugPrint('Card index: $index');
                              debugPrint('Original index: $originalIndex');
                              debugPrint('Is main city: $isMainCity');
                              if (!isMainCity) {
                                homeController.swapCityWithMainByWeatherModel(
                                  weather,
                                );
                              }
                            },
                            child: Container(
                              width: deviceSize.width * 0.7,
                              margin: EdgeInsets.only(
                                left: isFirst ? kBodyHp * 2 : kElementGap,
                                right: isLast ? kBodyHp : kElementGap,
                              ),
                              decoration: roundedDecorationWithShadow.copyWith(
                                gradient:
                                    isMainCity ? kContainerGradient : null,
                                color: isMainCity ? null : secondaryColor,
                              ),
                              child: OtherCityCard(
                                cityName: weather.cityName,
                                condition: weather.condition,
                                temperature: '${weather.temperature.round()}°',
                                iconUrl: weather.iconUrl,
                                isMainCity: isMainCity,
                                deviceSize: deviceSize,
                              ),
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
                otherCitiesWithIndex.length.clamp(0, 10),
                (index) => Container(
                  margin: kPaginationMargin,
                  width: deviceSize.width * 0.015,
                  height: deviceSize.width * 0.015,
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
      );
    });
  }
}

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
