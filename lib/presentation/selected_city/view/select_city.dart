import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/constants/constant.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:estonia_weather/presentation/home/view/home_view.dart';
import 'package:estonia_weather/presentation/selected_city/controller/select_city_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import '../../../core/common_widgets/custom_toast.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/search_bar.dart';

class SelectCity extends StatelessWidget {
  const SelectCity({super.key});

  @override
  Widget build(BuildContext context) {
    final SelectCityController controller = Get.find<SelectCityController>();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              useBackButton: true,
              actions: [
                IconActionButton(
                  onTap: () => Get.offAll(HomeView()),
                  icon: Icons.home,
                  color: primaryColor,
                  size: secondaryIcon(context),
                ),
              ],
              subtitle: 'Select Cities',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
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
              child: Padding(
                padding: const EdgeInsets.only(top: kBodyHp),
                child: Obx(() {
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

                    // Filter out selected cities
                    final unselectedCities =
                        citiesToShow
                            .where((city) => !controller.isCitySelected(city))
                            .toList();

                    final weatherToShow =
                        controller.allCitiesWeather.where((weather) {
                          return unselectedCities.any(
                            (city) => city.cityAscii == weather.cityName,
                          );
                        }).toList();

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
                        final city = unselectedCities.firstWhere(
                          (city) => city.cityAscii == weather.cityName,
                        );

                        return Container(
                          margin: const EdgeInsets.only(bottom: kBodyHp * 1.5),
                          decoration: roundedDecorationWithShadow.copyWith(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              controller.addCityToSelected(city);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(kBodyHp),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              weather.cityName,
                                              style: titleSmallBoldStyle
                                                  .copyWith(color: kWhite),
                                            ),
                                            const SizedBox(
                                              width: kElementWidthGap,
                                            ),
                                            Icon(
                                              Icons.location_on,
                                              color: kSilver,
                                              size: smallIcon(context),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: kElementInnerGap,
                                        ),
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: kElementGap,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconActionButton(
                                          backgroundColor: kWhite,
                                          isCircular: true,
                                          icon: Icons.add,
                                          color: primaryColor,
                                          size: smallIcon(context) * 0.6,
                                          onTap: () {
                                            controller.addCityToSelected(city);
                                            SimpleToast.showCustomToast(
                                              context: context,
                                              message: 'City has been added',
                                              type: ToastificationType.info,
                                              primaryColor: primaryColor,
                                              icon: Icons.info,
                                            );
                                          },
                                        ),
                                      ],
                                    ),
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
            ),
          ],
        ),
      ),
    );
  }
}
