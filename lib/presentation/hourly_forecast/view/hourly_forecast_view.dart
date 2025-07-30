import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/common_widgets/icon_buttons.dart';
import 'package:estonia_weather/core/common_widgets/weather_icon.dart';
import 'package:estonia_weather/core/common_widgets/weather_info_card.dart';
import 'package:estonia_weather/core/constants/constant.dart';
import 'package:estonia_weather/core/global_service/controllers/condition_controller.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:estonia_weather/presentation/hourly_forecast/view/bottom_arc.dart';
import 'package:estonia_weather/gen/assets.gen.dart';
import 'package:estonia_weather/ads_manager/banner_ads.dart';
import 'package:estonia_weather/ads_manager/interstitial_ads.dart';
import 'package:estonia_weather/presentation/cities/cities_view/cities_view.dart';
import '../controller/hourly_forecast_controller.dart';

class HourlyForecastView extends StatefulWidget {
  const HourlyForecastView({super.key});

  @override
  State<HourlyForecastView> createState() => _HourlyForecastViewState();
}

class _HourlyForecastViewState extends State<HourlyForecastView> {
  final InterstitialAdController interstitialAd = Get.put(
    InterstitialAdController(),
  );
  @override
  void initState() {
    Get.find<InterstitialAdController>().checkAndShowAd();
    Get.find<BannerAdController>().loadBannerAd('ad4');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = Get.arguments;
    final controller = Get.find<HourlyForecastController>();
    final conditionController = Get.find<ConditionController>();
    controller.setSelectedDate(selectedDate);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          ClipPath(
            clipper: BottomArcClipper(),
            child: SizedBox(
              height: mobileHeight(context) * 0.4,
              width: double.infinity,
              child: Image.asset(
                Assets.images.hourlyForecastBgContainer.path,
                fit: BoxFit.cover,
              ),
            ),
          ),
          CustomAppBar(
            actions: [
              IconActionButton(
                onTap: () => Get.to(() => const CitiesView()),
                icon: Icons.add,
                color: getIconColor(context),
              ),
            ],
            subtitle: '',
          ),
          SafeArea(
            child: Obx(() {
              final selectedDayData = controller.selectedDayData;
              final hourlyData = controller.hourlyData;
              final currentHourIndex = hourlyData.indexWhere(
                (hour) => controller.getCurrentHourData() == hour,
              );

              if (controller.isSameDate(
                    controller.selectedDate.value,
                    DateTime.now(),
                  ) &&
                  currentHourIndex != -1 &&
                  controller.scrollController.hasClients) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.scrollController.animateTo(
                    currentHourIndex *
                        ((mobileWidth(context) * 0.18) + kElementInnerGap),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                });
              }

              return Column(
                children: [
                  const SizedBox(height: kToolbarHeight),
                  if (selectedDayData != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: mobileWidth(context) * 0.05,
                      ),
                      child: WeatherInfoCard(
                        weatherData: conditionController.mainCityWeather.value,
                        date: selectedDate,
                        temperature: conditionController.temperature,
                        condition: conditionController.condition,
                        minTemp:
                            controller.selectedDayData?.minTemp
                                .round()
                                .toString() ??
                            '--',
                        maxTemp: selectedDayData.maxTemp.round().toString(),
                        imagePath: conditionController.weatherIconPath,
                      ),
                    ),
                  const SizedBox(height: kElementGap),
                  Expanded(
                    child: ListView.builder(
                      controller: controller.scrollController,
                      padding: EdgeInsets.symmetric(
                        horizontal: mobileWidth(context) * 0.05,
                      ),
                      itemCount: hourlyData.length,
                      itemBuilder: (context, index) {
                        final hourData = hourlyData[index];
                        final isCurrentHour =
                            controller.getCurrentHourData() == hourData;
                        final time = controller.getFormattedTime(
                          hourData['time'],
                        );
                        final temperature = '${hourData['temp_c'].round()}°';

                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: kElementInnerGap,
                          ),
                          child: Container(
                            height: mobileWidth(context) * 0.18,
                            padding: kContentPaddingSmall,
                            decoration: getDynamicBoxDecoration(
                              context: context,
                              isCurrentHour: isCurrentHour,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kElementGap,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        time,
                                        style: bodyLargeStyle(context).copyWith(
                                          color:
                                              isDarkMode(context)
                                                  ? null
                                                  : (isCurrentHour
                                                      ? kWhite
                                                      : primaryColor),
                                          fontWeight:
                                              isCurrentHour
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                  WeatherIcon(
                                    iconUrl: hourData['iconUrl'],
                                    size: primaryIcon(context) * 1.5,
                                    weatherData: hourData['condition'],
                                  ),
                                  Text(
                                    temperature,
                                    style: headlineSmallStyle(context).copyWith(
                                      color:
                                          isCurrentHour ? kWhite : primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final interstitial = Get.find<InterstitialAdController>();
        final banner = Get.find<BannerAdController>();
        return interstitial.isShowingInterstitialAd.value
            ? const SizedBox()
            : banner.getBannerAdWidget('ad4');
      }),
    );
    // );
  }
}
