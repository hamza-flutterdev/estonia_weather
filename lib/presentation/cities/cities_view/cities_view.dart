import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/constants/constant.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/search_bar.dart';
import '../controller/cities_controller.dart';
import 'city_card.dart';
import 'current_location_card.dart';

class CitiesView extends StatelessWidget {
  const CitiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final CitiesController controller = Get.find();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                CustomAppBar(useBackButton: true, subtitle: 'Manage Cities'),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    kBodyHp,
                    kBodyHp,
                    kBodyHp,
                    0,
                  ),
                  child: Obx(
                    () => SearchBarField(
                      controller: controller.searchController,
                      onSearch: (value) => controller.searchCities(value),
                      backgroundColor: secondaryColor,
                      borderColor:
                          controller.hasSearchError.value ? kRed : primaryColor,
                      iconColor:
                          controller.hasSearchError.value ? kRed : primaryColor,
                      textColor: textGreyColor,
                    ),
                  ),
                ),
                Obx(
                  () =>
                      controller.hasSearchError.value
                          ? Padding(
                            padding: const EdgeInsets.fromLTRB(
                              kBodyHp,
                              kElementInnerGap,
                              kBodyHp,
                              0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: kRed,
                                  size: smallIcon(context),
                                ),
                                const SizedBox(width: kElementWidthGap),
                                Expanded(
                                  child: Text(
                                    controller.searchErrorMessage.value,
                                    style: bodyBoldSmallStyle.copyWith(
                                      color: kRed,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    kBodyHp,
                    kBodyHp,
                    kBodyHp,
                    0,
                  ),
                  child: CurrentLocationCard(controller: controller),
                ),
              ],
            ),
            Expanded(
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

                final selectedCities = <Widget>[];
                final unselectedCities = <Widget>[];

                for (int index = 0; index < weatherToShow.length; index++) {
                  final weather = weatherToShow[index];
                  final city = citiesToShow.firstWhere(
                    (city) => city.cityAscii == weather.cityName,
                  );

                  final cityCard = CityCard(
                    controller: controller,
                    weather: weather,
                    city: city,
                  );

                  if (controller.isCitySelected(city)) {
                    selectedCities.add(cityCard);
                  } else {
                    unselectedCities.add(cityCard);
                  }
                }

                final allItems = <Widget>[];
                allItems.addAll(selectedCities);

                if (selectedCities.isNotEmpty && unselectedCities.isNotEmpty) {
                  allItems.add(
                    Padding(
                      padding: const EdgeInsets.only(bottom: kElementGap),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Divider(color: textGreyColor, thickness: 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kElementWidthGap,
                            ),
                            child: Text(
                              'Available Cities',
                              style: bodyMediumStyle.copyWith(
                                color: textGreyColor,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(color: textGreyColor, thickness: 1),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                allItems.addAll(unselectedCities);

                return ListView(
                  padding: const EdgeInsets.fromLTRB(kBodyHp, 0, kBodyHp, 0),
                  children: allItems,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
