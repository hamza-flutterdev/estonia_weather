import 'package:flutter/material.dart';
import '../../../core/common_widgets/common_shimmer.dart';
import '../../../core/constants/constant.dart';
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

      final otherCitiesWithIndex = <Map<String, dynamic>>[];
      for (
        int i = 0;
        i < conditionController.selectedCitiesWeather.length;
        i++
      ) {
        final weather = conditionController.selectedCitiesWeather[i];
        bool shouldExclude = false;

        if (homeController.currentLocationCity != null) {
          final currentLocationName =
              homeController.currentLocationCity!.city.toLowerCase().trim();
          final weatherCityName = weather.cityName.toLowerCase().trim();
          shouldExclude = weatherCityName == currentLocationName;
        }

        if (!shouldExclude) {
          otherCitiesWithIndex.add({'weather': weather, 'originalIndex': i});
        }
      }

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
                    ? OtherCityShimmerList(deviceSize: deviceSize)
                    : OtherCitiesListView(
                      deviceSize: deviceSize,
                      otherCitiesWithIndex: otherCitiesWithIndex,
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

class OtherCityShimmerList extends StatelessWidget {
  final DeviceSize deviceSize;

  const OtherCityShimmerList({super.key, required this.deviceSize});

  @override
  Widget build(BuildContext context) {
    return ShimmerListView(
      itemCount: 2,
      itemWidth: deviceSize.width * 0.7,
      itemHeight: deviceSize.height * 0.1,
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
  final List<Map<String, dynamic>> otherCitiesWithIndex;

  const OtherCitiesListView({
    super.key,
    required this.deviceSize,
    required this.otherCitiesWithIndex,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo is ScrollUpdateNotification) {
          final itemWidth = deviceSize.width * 0.7 + kBodyHp;
          final currentIndex = (scrollInfo.metrics.pixels / itemWidth).round();
          final clampedIndex = currentIndex.clamp(
            0,
            otherCitiesWithIndex.length - 1,
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
        itemCount: otherCitiesWithIndex.length,
        itemBuilder: (context, index) {
          final cityData = otherCitiesWithIndex[index];
          final weather = cityData['weather'];
          final originalIndex = cityData['originalIndex'];
          final isFirst = index == 0;
          final isLast = index == otherCitiesWithIndex.length - 1;
          final isMainCity = originalIndex == homeController.mainCityIndex;

          return GestureDetector(
            onTap: () {
              debugPrint('Tapped on city: ${weather.cityName}');
              if (!isMainCity) {
                homeController.makeCityMain(weather);
              }
            },
            child: Container(
              width: deviceSize.width * 0.7,
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
}
