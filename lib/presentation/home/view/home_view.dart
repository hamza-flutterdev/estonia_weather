import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:estonia_weather/presentation/home/view/today_forecast_card.dart';
import 'package:estonia_weather/presentation/home/view/weather_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/constants/constant.dart';
import '../../../core/utils/weather_utils.dart';
import '../../cities/cities_view/cities_view.dart';
import '../../daily_forecast/view/daily_forecast_view.dart';
import '../../hourly_forecast/view/hourly_forecast_view.dart';
import '../../reusable/controllers/condtion_controller.dart';
import '../controller/home_controller.dart';
import 'other_city_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final ConditionController conditionController = Get.find();

    return Scaffold(
      backgroundColor: bgColor,
      drawer: const Drawer(),
      appBar: CustomAppBar(
        title: homeController.mainCityName,
        subtitle: homeController.currentDate.value,
        useBackButton: false,
        actions: [
          IconActionButton(
            onTap: () => Get.to(CitiesScreen()),
            icon: Icons.add,
            color: primaryColor,
            size: secondaryIcon(context),
          ),
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            Positioned(
              top: kBodyHp,
              left: mobileWidth(context) * 0.15,
              right: mobileWidth(context) * 0.15,
              child: Container(
                height: mobileHeight(context) * 0.25,
                decoration: roundedDecorationWithShadow.copyWith(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, secondaryColor],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(kBodyHp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        conditionController.temperature,
                        style: headlineLargeStyle.copyWith(color: kWhite),
                      ),
                      Center(
                        child: Text(
                          conditionController.condition,
                          style: headlineSmallStyle.copyWith(color: kWhite),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: mobileHeight(context) * 0.125,
              left: mobileWidth(context) * 0.05,
              child: WeatherIcon(
                weatherData: conditionController.mainCityWeather.value,
                iconPath: conditionController.weatherIcon,
                size: largeIcon(context),
              ),
            ),
            Positioned(
              top: mobileHeight(context) * 0.3,
              left: mobileWidth(context) * 0.05,
              right: mobileWidth(context) * 0.05,
              child: Container(
                height: mobileHeight(context) * 0.15,
                decoration: roundedDecorationWithShadow,
                child: Padding(
                  padding: kContentPaddingSmall,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WeatherDetailItem(
                        icon: WeatherUtils.getHomeIcon('precipitation'),
                        value: conditionController.precipitation,
                        label: 'Precipitation',
                      ),
                      WeatherDetailItem(
                        icon: WeatherUtils.getHomeIcon('humidity'),
                        value: conditionController.humidity,
                        label: 'Humidity',
                      ),
                      WeatherDetailItem(
                        icon: WeatherUtils.getHomeIcon('wind'),
                        value: conditionController.windSpeed,
                        label: 'Wind',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: mobileHeight(context) * 0.46,
              left: mobileWidth(context) * 0.05,
              right: mobileWidth(context) * 0.05,
              child: SectionHeader(
                title: 'Today',
                actionText: '7 Day Forecasts >',
                onTap: () => Get.to(ForecastScreen()),
              ),
            ),
            Positioned(
              top: mobileHeight(context) * 0.5,
              child: SizedBox(
                height: mobileHeight(context) * 0.14,
                width: mobileWidth(context),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    final now = DateTime.now();
                    final date = now.add(Duration(days: index));
                    final isSelected =
                        index == homeController.selectedForecastIndex.value;
                    return GestureDetector(
                      onTap: () {
                        homeController.selectForecastDay(index);
                        Get.to(
                          () => const HourlyForecastView(),
                          arguments: date,
                        );
                      },
                      child: TodayForecastCard(
                        day:
                            index == 0
                                ? 'Today'
                                : DateFormat('EEE').format(date),
                        isSelected: isSelected,
                        isFirst: index == 0,
                        isLast: index == 6,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: mobileHeight(context) * 0.65,
              left: mobileWidth(context) * 0.05,
              right: mobileWidth(context) * 0.05,
              child: Text(
                'Other Cities',
                style: titleBoldMediumStyle.copyWith(color: primaryColor),
              ),
            ),
            Positioned(
              top: mobileHeight(context) * 0.685,
              child: SizedBox(
                height: mobileHeight(context) * 0.1,
                width: mobileWidth(context),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: conditionController.otherCitiesWeather.length,
                  itemBuilder: (context, index) {
                    final weather =
                        conditionController.otherCitiesWeather[index];
                    final isFirst = index == 0;
                    final isLast =
                        index ==
                        conditionController.otherCitiesWeather.length - 1;

                    return Container(
                      width: mobileWidth(context) * 0.7,
                      margin: EdgeInsets.only(
                        left: isFirst ? kBodyHp * 2 : kElementGap,
                        right: isLast ? kBodyHp : kElementGap,
                      ),
                      decoration: roundedDecorationWithShadow.copyWith(
                        color: primaryColor,
                      ),
                      child: OtherCityCard(
                        cityName: weather.cityName,
                        condition: weather.condition,
                        temperature: '${weather.temperature.round()}°',
                        iconPath: WeatherUtils.getWeatherIcon(
                          weather.condition,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: mobileHeight(context) * 0.82,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  conditionController.otherCitiesWeather.length.clamp(0, 10),
                  (index) => Container(
                    margin: kPaginationMargin,
                    width: mobileWidth(context) * 0.015,
                    height: mobileWidth(context) * 0.015,
                    decoration: BoxDecoration(
                      color: index == 0 ? primaryColor : greyColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            if (homeController.isLoading.value)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

class WeatherIcon extends StatelessWidget {
  final dynamic weatherData;
  final String iconPath;
  final double size;

  const WeatherIcon({
    super.key,
    required this.weatherData,
    required this.iconPath,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (weatherData != null) {
      return Image.asset(
        iconPath,
        width: size,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(WeatherUtils.getDefaultIcon(), width: size);
        },
      );
    }
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: kWhite.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onTap;

  const SectionHeader({
    super.key,
    required this.title,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: titleBoldMediumStyle.copyWith(color: primaryColor)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: bodyLargeStyle.copyWith(color: primaryColor),
          ),
        ),
      ],
    );
  }
}
