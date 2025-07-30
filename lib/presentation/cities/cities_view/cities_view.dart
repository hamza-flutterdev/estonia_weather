import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/constants/constant.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_widgets/search_bar.dart';
import '../controller/cities_controller.dart';
import 'city_card.dart';
import 'current_location_card.dart';

class CitiesView extends StatefulWidget {
  const CitiesView({super.key});

  @override
  State<CitiesView> createState() => _CitiesViewState();
}

class _CitiesViewState extends State<CitiesView> {
  @override
  void initState() {
    Get.find<InterstitialAdController>().checkAndShowAd();
    Get.find<BannerAdController>().loadBannerAd('ad3');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CitiesController controller = Get.find();

    return Scaffold(
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
                  child: Obx(() {
                    final dark = isDarkMode(context);
                    return SearchBarField(
                      controller: controller.searchController,
                      onSearch: (value) => controller.searchCities(value),
                      backgroundColor:
                          dark ? kWhite.withValues(alpha: 0.1) : secondaryColor,
                      borderColor:
                          controller.hasSearchError.value ? kRed : primaryColor,
                      iconColor:
                          controller.hasSearchError.value ? kRed : primaryColor,
                      textColor: getTextColor(context),
                    );
                  }),
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
                                Flexible(
                                  child: Text(
                                    controller.searchErrorMessage.value,
                                    style: bodyBoldSmallStyle(
                                      context,
                                    ).copyWith(color: kRed),
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
            Flexible(
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

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(kBodyHp, 0, kBodyHp, 0),
                  itemCount: weatherToShow.length,
                  itemBuilder: (context, index) {
                    final weather = weatherToShow[index];
                    final city = citiesToShow.firstWhere(
                      (city) => city.cityAscii == weather.cityName,
                    );

                    return CityCard(
                      controller: controller,
                      weather: weather,
                      city: city,
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        final interstitial = Get.find<InterstitialAdController>();
        final banner = Get.find<BannerAdController>();
        return interstitial.isShowingInterstitialAd.value
            ? const SizedBox()
            : banner.getBannerAdWidget('ad3');
      }),
    );
  }
}
