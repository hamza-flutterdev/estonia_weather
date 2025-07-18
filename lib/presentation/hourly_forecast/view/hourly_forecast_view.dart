import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:estonia_weather/presentation/hourly_forecast/view/bottom_arc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../ads_manager/banner_ads.dart';
import '../../../ads_manager/interstitial_ads.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/weather_info_card.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../gen/assets.gen.dart';
import '../../cities/cities_view/cities_view.dart';
import '../../../core/common_widgets/weather_icon.dart';
import '../controller/hourly_forecast_controller.dart';

class HourlyForecastView extends StatelessWidget {
  const HourlyForecastView({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = Get.arguments;
    final controller = Get.find<HourlyForecastController>();
    final conditionController = Get.find<ConditionController>();
    controller.setSelectedDate(selectedDate);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: bgColor,
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
          const CustomAppBar(
            actions: [
              IconActionButton(
                onTap: CitiesView.new,
                icon: Icons.add,
                color: primaryColor,
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: mobileWidth(context) * 0.05,
                    ),
                    child:
                        selectedDayData == null
                            ? const SizedBox()
                            : WeatherInfoCard(
                              weatherData:
                                  conditionController.mainCityWeather.value,
                              forecastData: selectedDayData,
                              date: selectedDate,
                              temperature:
                                  selectedDayData.maxTemp.round().toString(),
                              condition: selectedDayData.condition,
                              minTemp:
                                  selectedDayData.minTemp.round().toString(),
                              maxTemp:
                                  selectedDayData.maxTemp.round().toString(),
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

                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: kElementInnerGap,
                          ),
                          child: Container(
                            height: mobileWidth(context) * 0.18,
                            decoration: roundedDecorationWithShadow.copyWith(
                              color: isCurrentHour ? null : bgColor,
                              gradient:
                                  isCurrentHour ? kContainerGradient : null,
                              border:
                                  isCurrentHour
                                      ? Border.all(
                                        color: primaryColor,
                                        width: 2,
                                      )
                                      : null,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: kContentPaddingSmall,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: mobileWidth(context) * 0.15,
                                  child: Text(
                                    time,
                                    style: bodyMediumStyle.copyWith(
                                      color:
                                          isCurrentHour ? kWhite : primaryColor,
                                      fontWeight:
                                          isCurrentHour
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                WeatherIcon(
                                  iconUrl: hourData['iconUrl'],
                                  size: primaryIcon(context) * 1.25,
                                  weatherData: hourData['condition'],
                                ),
                                Text(
                                  '${hourData['temp_c'].round()}°',
                                  style: headlineSmallStyle.copyWith(
                                    color:
                                        isCurrentHour ? kWhite : primaryColor,
                                  ),
                                ),
                              ],
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
      bottomNavigationBar:
          Get.find<InterstitialAdController>().isAdReady
              ? const SizedBox()
              : Obx(
                () => Get.find<BannerAdController>().getBannerAdWidget('ad4'),
              ),
    );
  }
}
