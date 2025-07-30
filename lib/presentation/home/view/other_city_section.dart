import 'package:flutter/material.dart';
import '../../../core/common_widgets/common_shimmer.dart';
import '../../../core/constants/constant.dart';
import '../../../core/utils/city_config.dart';
import '../../../extensions/device_size/device_size.dart';
import '../../../core/theme/app_styles.dart';
import 'package:get/get.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../controller/home_controller.dart';
import 'other_city_card.dart';

class OtherCitiesSection extends StatelessWidget {
  final DeviceSize deviceSize;

  const OtherCitiesSection({super.key, required this.deviceSize});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final ConditionController conditionController = Get.find();

    return Obx(() {
      if (homeController.isLoading.value ||
          (homeController.isFirstLaunch &&
              conditionController.selectedCitiesWeather.isEmpty)) {
        return const SizedBox.shrink();
      }

      final otherCitiesData = _getFixedOtherCities(
        homeController,
        conditionController,
      );

      if (otherCitiesData.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          SizedBox(
            height: deviceSize.height * CityConfig.cityCardHeightRatio,
            width: deviceSize.width,
            child:
                homeController.isLoading.value
                    ? OtherCityShimmerList(deviceSize: deviceSize)
                    : OtherCitiesListView(
                      deviceSize: deviceSize,
                      otherCitiesData: otherCitiesData,
                    ),
          ),
          const SizedBox(height: kElementGap),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                otherCitiesData.length.clamp(0, CityConfig.maxPaginationDots),
                (index) => Container(
                  margin: kPaginationMargin,
                  width: deviceSize.width * CityConfig.paginationDotSizeRatio,
                  height: deviceSize.width * CityConfig.paginationDotSizeRatio,
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

  List<Map<String, dynamic>> _getFixedOtherCities(
    HomeController homeController,
    ConditionController conditionController,
  ) {
    final otherCitiesData = <Map<String, dynamic>>[];
    final mainCityName = homeController.mainCityName;

    // Add priority cities first (in order)
    for (final priorityCity in CityConfig.priorityCities) {
      final weather = conditionController.selectedCitiesWeather
          .firstWhereOrNull(
            (w) => CityConfig.cityNamesMatch(w.cityName, priorityCity),
          );

      if (weather != null) {
        otherCitiesData.add({
          'weather': weather,
          'originalIndex': conditionController.selectedCitiesWeather.indexOf(
            weather,
          ),
        });
      }
    }

    // Add main city if it's not already included
    final mainCityWeather = conditionController.selectedCitiesWeather
        .firstWhereOrNull(
          (w) =>
              !CityConfig.isPriorityCity(w.cityName) &&
              CityConfig.cityNamesMatch(w.cityName, mainCityName),
        );

    if (mainCityWeather != null) {
      otherCitiesData.add({
        'weather': mainCityWeather,
        'originalIndex': conditionController.selectedCitiesWeather.indexOf(
          mainCityWeather,
        ),
      });
    } else if (homeController.mainCityIndex <
        conditionController.selectedCitiesWeather.length) {
      final weatherByIndex =
          conditionController.selectedCitiesWeather[homeController
              .mainCityIndex];

      if (!CityConfig.isPriorityCity(weatherByIndex.cityName)) {
        otherCitiesData.add({
          'weather': weatherByIndex,
          'originalIndex': homeController.mainCityIndex,
        });
      }
    }

    return otherCitiesData;
  }
}

class OtherCityShimmerList extends StatelessWidget {
  final DeviceSize deviceSize;

  const OtherCityShimmerList({super.key, required this.deviceSize});

  @override
  Widget build(BuildContext context) {
    return ShimmerListView(
      itemCount: CityConfig.maxPaginationDots,
      itemWidth: deviceSize.width * CityConfig.cityCardWidthRatio,
      itemHeight: deviceSize.height * CityConfig.cityCardHeightRatio,
      itemMargin:
          (index) => EdgeInsets.only(
            left: index == 0 ? kBodyHp * 2 : kElementGap,
            right: index == 2 ? kBodyHp : kElementGap,
          ),
      itemDecoration: roundedDecorationWithShadow(context),
    );
  }
}

class OtherCitiesListView extends StatelessWidget {
  final DeviceSize deviceSize;
  final List<Map<String, dynamic>> otherCitiesData;

  const OtherCitiesListView({
    super.key,
    required this.deviceSize,
    required this.otherCitiesData,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo is ScrollUpdateNotification) {
          final itemWidth =
              deviceSize.width * CityConfig.cityCardWidthRatio + kBodyHp;
          final currentIndex = (scrollInfo.metrics.pixels / itemWidth).round();
          final clampedIndex = currentIndex.clamp(
            0,
            otherCitiesData.length - 1,
          );

          if (homeController.currentOtherCityIndex.value != clampedIndex) {
            homeController.updateCityIndex(clampedIndex);
          }
        }
        return false;
      },
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: otherCitiesData.length,
        itemBuilder: (context, index) {
          final cityData = otherCitiesData[index];
          final weather = cityData['weather'];
          final isFirst = index == 0;
          final isLast = index == otherCitiesData.length - 1;
          final isMainCity = CityConfig.cityNamesMatch(
            weather.cityName,
            homeController.mainCityName,
          );

          return GestureDetector(
            onTap: () => _handleCityTap(homeController, weather, isMainCity),
            child: Container(
              width: deviceSize.width * CityConfig.cityCardWidthRatio,
              margin: EdgeInsets.only(
                left: isFirst ? kBodyHp * 2 : kElementGap,
                right: isLast ? kBodyHp : kElementGap,
              ),
              decoration: roundedDecorationWithShadow(context).copyWith(
                gradient: isMainCity ? kContainerGradient(context) : null,
                color: isMainCity ? null : kWhite.withValues(alpha: 0.2),
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
    );
  }

  Future<void> _handleCityTap(
    HomeController homeController,
    dynamic weather,
    bool isMainCity,
  ) async {
    if (isMainCity) return;

    final cityToMakeMain = homeController.allCities.firstWhereOrNull(
      (city) => CityConfig.cityNamesMatch(city.cityAscii, weather.cityName),
    );

    if (cityToMakeMain != null) {
      final existingIndex = homeController.selectedCities.indexWhere(
        (c) => CityConfig.cityNamesMatch(c.cityAscii, cityToMakeMain.cityAscii),
      );

      if (existingIndex >= 0) {
        await homeController.makeCityMainByIndex(existingIndex);
      } else {
        await homeController.makeCityMain(weather);
      }
    } else {
      await homeController.makeCityMain(weather);
    }
  }
}
