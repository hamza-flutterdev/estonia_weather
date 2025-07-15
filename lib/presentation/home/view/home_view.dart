import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/common_widgets/custom_drawer.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/presentation/home/view/main_card.dart';
import 'package:estonia_weather/presentation/home/view/today_forecast_card.dart';
import 'package:estonia_weather/presentation/home/view/weather_detail_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../../../core/animation/animated_weather_icon.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/section_header.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/theme/app_styles.dart';
import '../../../extensions/device_size/device_size.dart';
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

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        bool? exit = await PanaraConfirmDialog.show(
          context,
          title: "Exit App?",
          message: "Do you really want to exit the app?",
          confirmButtonText: "Exit",
          cancelButtonText: "Cancel",
          onTapCancel: () => Navigator.pop(context, false),
          onTapConfirm: () => SystemNavigator.pop(),
          panaraDialogType: PanaraDialogType.custom,
          color: primaryColor,
          barrierDismissible: false,
        );
        return exit ?? false;
      },
      child: Scaffold(
        backgroundColor: bgColor,
        drawer: CustomDrawer(),
        body: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final deviceSize = DeviceSize(constraints, context);

                  return Obx(
                    () => SizedBox(
                      height: deviceSize.height,
                      width: double.infinity,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CustomAppBar(
                            title: homeController.mainCityName,
                            subtitle: homeController.currentDate.value,
                            useBackButton: false,
                            actions: [
                              IconActionButton(
                                onTap: () => Get.to(CitiesView()),
                                icon: Icons.add,
                                color: primaryColor,
                                size: secondaryIcon(context),
                              ),
                            ],
                          ),
                          Positioned(
                            top: constraints.maxHeight * 0.115,
                            left: deviceSize.weatherCardHorizontalMargin,
                            right: deviceSize.weatherCardHorizontalMargin,
                            child: MainCard(
                              maxTemp: conditionController.maxTemp,
                              temperature: conditionController.temperature,
                              condition: conditionController.condition,
                              minTemp: conditionController.minTemp.toString(),
                            ),
                          ),
                          Positioned(
                            top: deviceSize.weatherIconTop,
                            left: deviceSize.weatherIconLeft,
                            child: AnimatedWeatherIcon(
                              imagePath: conditionController.weatherIconPath,
                              condition: conditionController.condition,
                              width: deviceSize.weatherIconSize,
                            ),
                          ),
                          Positioned(
                            top: deviceSize.detailsCardTop,
                            left: deviceSize.horizontalPadding,
                            right: deviceSize.horizontalPadding,
                            child: WeatherDetailsCard(deviceSize: deviceSize),
                          ),
                          Positioned(
                            top: deviceSize.todayHeaderTop,
                            left: deviceSize.horizontalPadding,
                            right: deviceSize.horizontalPadding,
                            child: SectionHeader(
                              actionText: '7 Day Forecasts >',
                              onTap: () {
                                final selectedDate = DateTime.now();
                                Get.to(
                                  () => DailyForecastView(),
                                  arguments: selectedDate,
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: deviceSize.todayForecastTop,
                            left: 0,
                            right: 0,
                            child: TodayForecastSection(deviceSize: deviceSize),
                          ),
                          // Other Cities Header
                          Positioned(
                            top: deviceSize.otherCitiesHeaderTop,
                            left: deviceSize.horizontalPadding,
                            right: deviceSize.horizontalPadding,
                            child: Text(
                              'Other Cities',
                              style: titleBoldMediumStyle.copyWith(
                                color: primaryColor,
                              ),
                            ),
                          ),
                          Positioned(
                            top: deviceSize.otherCitiesTop,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: OtherCitiesSection(deviceSize: deviceSize),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
