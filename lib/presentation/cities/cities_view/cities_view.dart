import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/constants/constant.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/search_bar.dart';
import '../controller/cities_controller.dart';

class CitiesScreen extends StatelessWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CitiesController controller = Get.find<CitiesController>();
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          CustomAppBar(
            useBackButton: true,
            actions: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.add, color: primaryColor),
              ),
            ],
            subtitle: 'Manage Cities',
          ),
          Padding(
            padding: const EdgeInsets.all(kBodyHp),
            child: SearchBarField(
              controller: controller.searchController,
              onSearch: (value) => controller.searchCities(value),
              backgroundColor: greyColor.withValues(alpha: 0.25),
              borderColor: transparent,
              iconColor: greyColor.withValues(alpha: 0.5),
              textColor: textGreyColor,
            ),
          ),
          Expanded(
            child: Obx(() {
              print('All cities count: ${controller.allCities.length}');
              print(
                'All cities weather count: ${controller.allCitiesWeather.length}',
              );
              print(
                'Selected cities count: ${controller.selectedCities.length}',
              );
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
              }
              return Obx(() {
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
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: weatherToShow.length,
                  itemBuilder: (context, index) {
                    final weather = weatherToShow[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: kElementGap),
                      decoration: roundedDecorationWithShadow.copyWith(
                        color: primaryColor,
                      ),
                      child: GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(kBodyHp),
                          child: Row(
                            children: [
                              // City info
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
                                        const SizedBox(width: kElementWidthGap),
                                        Icon(
                                          Icons.location_on,
                                          color: kSilver,
                                          size: smallIcon(context),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: kElementInnerGap),
                                    Row(
                                      children: [
                                        Text(
                                          controller.getAirQualityText(
                                            weather.airQuality,
                                          ),
                                          style: bodyMediumStyle.copyWith(
                                            color: kWhite,
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
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              });
            }),
          ),
        ],
      ),
    );
  }
}
