import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/common_widgets/section_header.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
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
import '../controller/daily_forecast_controller.dart';

class DailyForecastView extends StatelessWidget {
  const DailyForecastView({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = Get.arguments;
    final controller = Get.find<DailyForecastController>();
    final conditionController = Get.find<ConditionController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: getBgColor(context),
      body: Stack(
        children: [
          SizedBox(
            height: mobileHeight(context) * 0.4,
            width: double.infinity,
            child: Image.asset(
              Assets.images.dailyForecastBgContainer.path,
              fit: BoxFit.cover,
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
            child: Column(
              children: [
                const SizedBox(height: kToolbarHeight),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mobileWidth(context) * 0.05,
                  ),
                  child: WeatherInfoCard(
                    weatherData: conditionController.mainCityWeather.value,
                    date: selectedDate,
                    temperature: conditionController.temperature,
                    maxTemp: conditionController.maxTemp,
                    condition: conditionController.condition,
                    minTemp:
                        controller.selectedDayData?.minTemp
                            .round()
                            .toString() ??
                        '--',
                    imagePath: conditionController.weatherIconPath,
                  ),
                ),
                const SizedBox(height: kElementGap),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mobileHeight(context) * 0.026,
                  ),
                  child: SectionHeader(
                    actionIcon: Icons.location_on,
                    title: '7 Day Forecasts',
                    actionText: controller.mainCityName.toString(),
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: kElementGap),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: mobileWidth(context) * 0.05,
                    ),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      final dayData = conditionController.getForecastForDay(
                        index,
                      );
                      if (dayData == null) return const SizedBox();

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: kElementInnerGap,
                        ),
                        child: Container(
                          height: mobileHeight(context) * 0.09,
                          decoration: roundedDecorationWithShadow(
                            context,
                          ).copyWith(
                            gradient: index == 0 ? kContainerGradient : null,
                            color: index == 0 ? null : getBgColor(context),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: kContentPaddingSmall,
                          child: Row(
                            children: [
                              SizedBox(
                                width: mobileWidth(context) * 0.15,
                                child: Text(
                                  dayData['day'],
                                  style: bodyLargeStyle(context).copyWith(
                                    color: index == 0 ? kWhite : primaryColor,
                                  ),
                                ),
                              ),
                              WeatherIcon(
                                iconUrl: dayData['iconUrl'],
                                size: primaryIcon(context) * 1.25,
                                weatherData: dayData['condition'],
                              ),
                              const SizedBox(width: kElementWidthGap),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  dayData['condition'],
                                  style: bodyLargeStyle(context).copyWith(
                                    color: index == 0 ? kWhite : primaryColor,
                                  ),
                                ),
                              ),
                              Text(
                                '${dayData['temp'].round()}° / ${dayData['minTemp'].round()}°',
                                style: bodyLargeStyle(context).copyWith(
                                  color: index == 0 ? kWhite : primaryColor,
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
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          Get.find<InterstitialAdController>().isAdReady
              ? const SizedBox()
              : Obx(
                () => Get.find<BannerAdController>().getBannerAdWidget('ad2'),
              ),
    );
  }
}
