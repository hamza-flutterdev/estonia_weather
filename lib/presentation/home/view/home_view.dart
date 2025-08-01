import 'package:estonia_weather/ads_manager/banner_ads.dart';
import 'package:estonia_weather/ads_manager/splash_interstitial.dart';
import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/common_widgets/custom_drawer.dart';
import 'package:estonia_weather/core/global_service/global_key.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/presentation/home/view/main_card.dart';
import 'package:estonia_weather/presentation/home/view/today_forecast_card.dart';
import 'package:estonia_weather/presentation/home/view/weather_details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../../../core/animation/animated_weather_icon.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/section_header.dart';
import '../../../core/constants/constant.dart';
import '../../../core/global_service/android_widget_service.dart';
import '../../../core/global_service/controllers/condition_controller.dart';
import '../../../core/theme/app_styles.dart';
import '../../../extensions/device_size/device_size.dart';
import '../../cities/cities_view/cities_view.dart';
import '../../daily_forecast/view/daily_forecast_view.dart';
import '../controller/home_controller.dart';
import 'other_city_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final BannerAdController bannerAdController = Get.put(BannerAdController());
  final HomeController homeController = Get.find();

  @override
  void initState() {
    homeController.requestTrackingPermission();
    bannerAdController.loadBannerAd('ad1');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        key: globalKey,
        drawer: const CustomDrawer(),
        onDrawerChanged: (isOpen) {
          homeController.isDrawerOpen.value = isOpen;
        },
        body: const SafeArea(child: _HomeContent()),
        bottomNavigationBar: Obx(() {
          final interstitialReady =
              Get.find<SplashInterstitialAdController>()
                  .isShowingInterstitialAd
                  .value;
          final isDrawerOpen = homeController.isDrawerOpen.value;
          if (!interstitialReady && !isDrawerOpen) {
            return bannerAdController.getBannerAdWidget('ad1');
          } else {
            return const SizedBox();
          }
        }),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final conditionController = Get.find<ConditionController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceSize = DeviceSize(constraints, context);

        return Obx(() {
          final data = homeController.getCurrentHourData(
            homeController.mainCityName,
          );
          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CustomAppBar(
                    title: homeController.mainCityName,
                    subtitle: homeController.currentDate.value,
                    useBackButton: false,
                    actions: [
                      IconActionButton(
                        onTap: () => Get.to(const CitiesView()),
                        icon: Icons.add,
                        color: getIconColor(context),
                        size: secondaryIcon(context),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: kToolbarHeight,
                      left: mobileWidth(context) * 0.15,
                      right: mobileWidth(context) * 0.15,
                    ),
                    child: GestureDetector(
                      onLongPress: () async {
                        final isActive =
                            await WidgetUpdaterService.isWidgetActive();
                        if (!isActive) {
                          await WidgetUpdaterService.requestPinWidget();
                        } else {
                          WidgetUpdateManager.updateWeatherWidget();
                        }
                      },
                      child: MainCard(
                        maxTemp: conditionController.maxTemp,
                        temperature: data['temp_c'].round().toString(),
                        condition: conditionController.condition,
                        minTemp: conditionController.minTemp.toString(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: deviceSize.weatherIconTop,
                    left: mobileWidth(context) * 0.08,
                    child: AnimatedWeatherIcon(
                      imagePath: conditionController.weatherIconPath,
                      condition: conditionController.condition,
                      width: largeIcon(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: kElementGap),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
                  child: WeatherDetailsCard(deviceSize: deviceSize),
                ),
              ),
              const SizedBox(height: kElementGap),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
                child: SectionHeader(
                  actionText: '7 Day Forecasts >',
                  onTap: () {
                    final selectedDate = DateTime.now();
                    Get.to(
                      () => const DailyForecastView(),
                      arguments: selectedDate,
                    );
                  },
                ),
              ),
              const SizedBox(height: kElementGap),
              Flexible(
                fit: FlexFit.tight,
                child: TodayForecastSection(deviceSize: deviceSize),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Other Cities',
                          style: titleBoldMediumStyle(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: kElementGap),
              Flexible(
                fit: FlexFit.tight,
                child: OtherCitiesSection(deviceSize: deviceSize),
              ),
            ],
          );
        });
      },
    );
  }
}
