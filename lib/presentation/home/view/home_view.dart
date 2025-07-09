import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/presentation/home/view/today_forecast_card.dart';
import 'package:estonia_weather/presentation/home/view/weather_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/animation/weather_animation.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/section_header.dart';
import '../../../core/common_widgets/weather_info_card.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/theme/app_styles.dart';
import '../../cities/cities_view/cities_view.dart';
import '../../daily_forecast/view/daily_forecast_view.dart';
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

      body: Stack(
        children: [
          CustomAppBar(
            title: Obx(() => Text(homeController.mainCityName)),
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

          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight * 1.5),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double width = constraints.maxWidth;
                final double height = constraints.maxHeight;
                final bool isSmall = height < 675;
                final bool isMedium = height >= 675 && height < 860;
                final bool isBig = height >= 875;
                final double horizontalPadding = width * 0.05;
                final double weatherCardHorizontalMargin = width * 0.15;
                final double weatherIconLeft = width * 0.08;
                final double weatherIconSize = largeIcon(context);

                final double detailsCardTop =
                    isSmall
                        ? height * 0.45
                        : isMedium
                        ? height * 0.36
                        : isBig
                        ? height * 0.32
                        : height * 0.40;

                final double todayHeaderTop =
                    isSmall
                        ? height * 0.58
                        : isMedium
                        ? height * 0.49
                        : isBig
                        ? height * 0.45
                        : height * 0.53;

                final double todayForecastTop =
                    isSmall
                        ? height * 0.625
                        : isMedium
                        ? height * 0.525
                        : isBig
                        ? height * 0.48
                        : height * 0.57;

                final double otherCitiesHeaderTop =
                    isSmall
                        ? height * 0.785
                        : isMedium
                        ? height * 0.70
                        : isBig
                        ? height * 0.64
                        : height * 0.73;

                final double otherCitiesTop =
                    isSmall
                        ? height * 0.84
                        : isMedium
                        ? height * 0.74
                        : isBig
                        ? height * 0.68
                        : height * 0.78;

                return Obx(
                  () => SizedBox(
                    height: height,
                    width: double.infinity,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: kBodyHp,
                          left: weatherCardHorizontalMargin,
                          right: weatherCardHorizontalMargin,
                          child: WeatherInfoCard(
                            temperature: conditionController.temperature,
                            condition: conditionController.condition,
                            imagePath: conditionController.weatherIconPath,
                            useGradient: true,
                            showWeatherDetails: false,
                            showIcon: false,
                          ),
                        ),
                        Positioned(
                          top: height * 0.16,
                          left: weatherIconLeft,
                          child: AnimatedWeatherIcon(
                            imagePath: conditionController.weatherIconPath,
                            condition: conditionController.condition,
                            width: weatherIconSize,
                          ),
                        ),
                        Positioned(
                          top: detailsCardTop,
                          left: horizontalPadding,
                          right: horizontalPadding,
                          child: const WeatherDetailsCard(),
                        ),
                        Positioned(
                          top: todayHeaderTop,
                          left: horizontalPadding,
                          right: horizontalPadding,
                          child: SectionHeader(
                            title: 'Today',
                            actionText: '7 Day Forecasts >',
                            onTap: () {
                              final selectedDate = DateTime.now();
                              Get.to(
                                () => ForecastScreen(),
                                arguments: selectedDate,
                              );
                            },
                          ),
                        ),
                        // Today Forecast Section
                        Positioned(
                          top: todayForecastTop,
                          left: 0,
                          right: 0,
                          child: const TodayForecastSection(),
                        ),
                        // Other Cities Header
                        Positioned(
                          top: otherCitiesHeaderTop,
                          left: horizontalPadding,
                          right: horizontalPadding,
                          child: Text(
                            'Other Cities',
                            style: titleBoldMediumStyle.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ),
                        // Other Cities Section
                        Positioned(
                          top: otherCitiesTop,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: const OtherCitiesSection(),
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
    );
  }
}
