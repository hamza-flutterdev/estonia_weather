import 'package:estonia_weather/core/common_widgets/custom_appbar.dart';
import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/common_widgets/weather_info_card.dart';
import '../../../core/constants/constant.dart';
import '../../cities/cities_view/cities_view.dart';
import '../../reusable/controllers/condition_controller.dart';
import '../controller/hourly_forecast_controller.dart';

class HourlyForecastView extends StatelessWidget {
  const HourlyForecastView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final DateTime selectedDate = args['date'];
    final String minTemp = args['minTemp'];
    final ConditionController conditionController = Get.find();
    final HourlyForecastController controller = Get.put(
      HourlyForecastController(),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: bgColor,
      drawer: const Drawer(),
      appBar: CustomAppBar(
        subtitle: '',
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
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipPath(
            clipper: BottomArcClipper(),
            child: Container(
              decoration: BoxDecoration(gradient: kGradient),
              child: Image.asset('assets/images/hourly_img/bg_container.png'),
            ),
          ),
          Positioned(
            top: mobileHeight(context) * 0.11,
            left: mobileWidth(context) * 0.05,
            right: mobileWidth(context) * 0.05,
            child: WeatherInfoCard(
              weatherData: conditionController.mainCityWeather.value,
              date: selectedDate,
              temperature: conditionController.temperature,
              condition: conditionController.condition,
              minTemp: minTemp,
              iconUrl: conditionController.weatherIconUrl,
            ),
          ),

          // Date Header
          // Container(
          //   margin: const EdgeInsets.all(kBodyHp),
          //   padding: const EdgeInsets.all(kBodyHp),
          //   decoration: BoxDecoration(
          //     color: kWhite,
          //     borderRadius: BorderRadius.circular(12),
          //     boxShadow: [
          //       BoxShadow(
          //         color: Colors.grey.withOpacity(0.1),
          //         blurRadius: 10,
          //         spreadRadius: 1,
          //       ),
          //     ],
          //   ),
          //   child: Row(
          //     children: [
          //       Icon(
          //         Icons.calendar_today,
          //         color: primaryColor,
          //         size: secondaryIcon(context),
          //       ),
          //       const SizedBox(width: kElementWidthGap),
          //       Obx(
          //         () => Text(
          //           controller.formattedDate,
          //           style: titleBoldMediumStyle.copyWith(color: primaryColor),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Hourly Forecast List
          // Expanded(
          //   child: Container(
          //     margin: const EdgeInsets.symmetric(horizontal: kBodyHp),
          //     decoration: BoxDecoration(
          //       color: kWhite,
          //       borderRadius: BorderRadius.circular(16),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.grey.withOpacity(0.1),
          //           blurRadius: 10,
          //           spreadRadius: 1,
          //         ),
          //       ],
          //     ),
          //     child: Obx(
          //       () => ListView.builder(
          //         padding: const EdgeInsets.all(kBodyHp),
          //         itemCount: controller.hourlyData.length,
          //         itemBuilder: (context, index) {
          //           final hourData = controller.hourlyData[index];
          //           final isCurrentHour =
          //               DateTime.now().hour == hourData['hour'];
          //
          //           return Container(
          //             margin: const EdgeInsets.only(bottom: kElementGap),
          //             padding: const EdgeInsets.all(kBodyHp),
          //             decoration: BoxDecoration(
          //               gradient:
          //                   isCurrentHour
          //                       ? LinearGradient(
          //                         begin: Alignment.topLeft,
          //                         end: Alignment.bottomRight,
          //                         colors: [
          //                           primaryColor.withOpacity(0.1),
          //                           secondaryColor.withOpacity(0.1),
          //                         ],
          //                       )
          //                       : null,
          //               borderRadius: BorderRadius.circular(12),
          //               border: Border.all(
          //                 color:
          //                     isCurrentHour ? primaryColor : Colors.transparent,
          //                 width: 1,
          //               ),
          //             ),
          //             child: Row(
          //               children: [
          //                 // Time
          //                 SizedBox(
          //                   width: 60,
          //                   child: Text(
          //                     hourData['time'],
          //                     style: titleBoldMediumStyle.copyWith(
          //                       color:
          //                           isCurrentHour ? primaryColor : Colors.black,
          //                     ),
          //                   ),
          //                 ),
          //                 // Weather Icon
          //                 Image.asset(
          //                   controller.getWeatherIcon(hourData['condition']),
          //                   width: primaryIcon(context),
          //                   errorBuilder: (context, error, stackTrace) {
          //                     return Icon(
          //                       Icons.cloud,
          //                       color: isCurrentHour ? primaryColor : greyColor,
          //                       size: primaryIcon(context),
          //                     );
          //                   },
          //                 ),
          //                 const SizedBox(width: kBodyHp),
          //                 // Temperature
          //                 SizedBox(
          //                   width: 50,
          //                   child: Text(
          //                     '${hourData['temp']}°',
          //                     style: titleBoldMediumStyle.copyWith(
          //                       color:
          //                           isCurrentHour ? primaryColor : Colors.black,
          //                     ),
          //                   ),
          //                 ),
          //                 // Precipitation
          //                 Expanded(
          //                   child: Row(
          //                     children: [
          //                       Icon(
          //                         Icons.water_drop,
          //                         color:
          //                             isCurrentHour ? primaryColor : greyColor,
          //                         size: secondaryIcon(context),
          //                       ),
          //                       const SizedBox(width: kElementWidthGap),
          //                       Text(
          //                         hourData['precipitationPercentage'],
          //                         style: bodyMediumStyle.copyWith(
          //                           color:
          //                               isCurrentHour
          //                                   ? primaryColor
          //                                   : Colors.black,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //                 // Wind Speed
          //                 Row(
          //                   children: [
          //                     Icon(
          //                       Icons.air,
          //                       color: isCurrentHour ? primaryColor : greyColor,
          //                       size: secondaryIcon(context),
          //                     ),
          //                     const SizedBox(width: kElementWidthGap),
          //                     Text(
          //                       '${hourData['windSpeed'].toStringAsFixed(1)}km/h',
          //                       style: bodyMediumStyle.copyWith(
          //                         color:
          //                             isCurrentHour
          //                                 ? primaryColor
          //                                 : Colors.black,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           );
          //         },
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(height: kBodyHp),
        ],
      ),
    );
  }
}

class BottomArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);

    path.quadraticBezierTo(
      size.width / 2,
      size.height + 40,
      size.width,
      size.height - 40,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
