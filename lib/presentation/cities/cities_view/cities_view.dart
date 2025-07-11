import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/constants/constant.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import '../../../core/common_widgets/custom_toast.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/search_bar.dart';
import '../controller/cities_controller.dart';

class CitiesView extends StatelessWidget {
  const CitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final CitiesController controller = Get.find<CitiesController>();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(useBackButton: true, subtitle: 'Manage Cities'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
              child: SearchBarField(
                controller: controller.searchController,
                onSearch: (value) => controller.searchCities(value),
                backgroundColor: secondaryColor,
                borderColor: primaryColor,
                iconColor: primaryColor,
                textColor: textGreyColor,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: kBodyHp),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    );
                  }

                  final citiesToShow =
                      controller.filteredCities.isEmpty
                          ? controller.allCities
                          : controller.filteredCities;

                  final weatherToShow =
                      controller.allCitiesWeather.where((weather) {
                        return citiesToShow.any(
                          (city) => city.cityAscii == weather.cityName,
                        );
                      }).toList();

                  // Show "No cities found" message if search returns empty results
                  if (controller.searchController.text.isNotEmpty &&
                      weatherToShow.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: textGreyColor,
                          ),
                          const SizedBox(height: kElementGap),
                          Text(
                            'No cities found',
                            style: titleBoldMediumStyle.copyWith(
                              color: textGreyColor,
                            ),
                          ),
                          const SizedBox(height: kElementInnerGap),
                          Text(
                            'Try searching with different keywords',
                            style: bodyMediumStyle.copyWith(
                              color: textGreyColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      kBodyHp,
                      kBodyHp,
                      kBodyHp,
                      0,
                    ),
                    itemCount: weatherToShow.length,
                    itemBuilder: (context, index) {
                      final weather = weatherToShow[index];
                      final city = citiesToShow.firstWhere(
                        (city) => city.cityAscii == weather.cityName,
                      );

                      final isSelected = controller.isCitySelected(city);
                      final canRemove = controller.canRemoveCity();
                      final canAdd = controller.canAddCity();

                      return Container(
                        margin: const EdgeInsets.only(bottom: kBodyHp * 1.5),
                        decoration: roundedDecorationWithShadow.copyWith(
                          gradient: kContainerGradient,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(kBodyHp),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          weather.cityName,
                                          style: titleSmallBoldStyle.copyWith(
                                            color: kWhite,
                                          ),
                                        ),
                                        Icon(
                                          Icons.location_on,
                                          color: kWhite,
                                          size: smallIcon(context),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: kElementInnerGap),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            controller.getAqiText(
                                              weather.airQuality,
                                            ),
                                            style: bodyMediumStyle.copyWith(
                                              color: kWhite,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${weather.temperature.round()}°',
                                    style: headlineMediumStyle.copyWith(
                                      color: kWhite,
                                    ),
                                  ),
                                  Text(
                                    weather.condition,
                                    style: bodyMediumStyle.copyWith(
                                      color: kWhite,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: kElementGap,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    IconActionButton(
                                      backgroundColor: kWhite,
                                      isCircular: true,
                                      icon:
                                          isSelected ? Icons.remove : Icons.add,
                                      color: primaryColor,
                                      size: smallIcon(context) * 0.6,
                                      onTap: () async {
                                        if (isSelected) {
                                          // Remove city
                                          if (canRemove) {
                                            SimpleToast.showCustomToast(
                                              context: context,
                                              message:
                                                  '${city.city} has been removed',
                                              type: ToastificationType.warning,
                                              primaryColor: kOrange,
                                              icon: Icons.remove_circle_outline,
                                            );
                                            await controller
                                                .removeCityFromSelected(city);
                                          } else {
                                            SimpleToast.showCustomToast(
                                              context: context,
                                              message:
                                                  'A minimum of 3 cities are required',
                                              type: ToastificationType.warning,
                                              primaryColor: kOrange,
                                              icon: Icons.remove_circle_outline,
                                            );
                                          }
                                        } else {
                                          // Add city
                                          if (canAdd) {
                                            SimpleToast.showCustomToast(
                                              context: context,
                                              message:
                                                  '${city.city} has been added',
                                              type: ToastificationType.info,
                                              primaryColor: primaryColor,
                                              icon: Icons.add_circle_outline,
                                            );
                                            await controller.addCityToSelected(
                                              city,
                                            );
                                          } else {
                                            SimpleToast.showCustomToast(
                                              context: context,
                                              message:
                                                  'Maximum number of cities reached',
                                              type: ToastificationType.error,
                                              primaryColor: kRed,
                                              icon: Icons.error,
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
