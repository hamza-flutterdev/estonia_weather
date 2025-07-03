import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:estonia_weather/core/theme/app_styles.dart';
import 'package:flutter/material.dart';
import '../../../core/common_widgets/icon_buttons.dart';
import '../../../core/constants/constant.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: const Drawer(),
      body: Stack(
        children: [
          Positioned(
            top: kBodyHp,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconActionButton(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      icon: Icons.menu,
                      color: primaryColor,
                      size: secondaryIcon(context),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: primaryColor,
                              size: secondaryIcon(context),
                            ),
                            const SizedBox(width: kElementWidthGap),
                            Text(
                              'Location',
                              style: titleBoldMediumStyle.copyWith(
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Monday 03 June',
                          style: bodyMediumStyle.copyWith(color: primaryColor),
                        ),
                      ],
                    ),
                    IconActionButton(
                      onTap: () {},
                      icon: Icons.add,
                      color: primaryColor,
                      size: secondaryIcon(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: mobileHeight(context) * 0.15,
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
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '22°',
                          style: headlineLargeStyle.copyWith(color: kWhite),
                        ),
                        Text(
                          'Mostly\nClear',
                          style: titleBoldLargeStyle.copyWith(color: kWhite),
                        ),
                      ],
                    ),
                    Positioned(
                      top: mobileHeight(context) * 0.18,
                      left: -mobileWidth(context) * 0.1,
                      child: Image.asset(
                        'assets/images/weather_conditions_img/cloudy.png',
                        width: largeIcon(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: mobileHeight(context) * 0.42,
            left: mobileWidth(context) * 0.08,
            right: mobileWidth(context) * 0.08,
            child: Container(
              height: mobileHeight(context) * 0.11,
              decoration: roundedDecorationWithShadow,
              child: Padding(
                padding: kContentPaddingSmall,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/home_img/umbrella.png',
                          width: primaryIcon(context),
                        ),
                        const SizedBox(height: kElementInnerGap),
                        Text(
                          '30%',
                          style: titleBoldMediumStyle.copyWith(
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          'Precipitation',
                          style: bodyMediumStyle.copyWith(color: primaryColor),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/home_img/droplet.png',
                          width: primaryIcon(context),
                        ),
                        const SizedBox(height: kElementInnerGap),
                        Text(
                          '30%',
                          style: titleBoldMediumStyle.copyWith(
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          'Humidity',
                          style: bodyMediumStyle.copyWith(color: primaryColor),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/home_img/windy.png',
                          width: primaryIcon(context),
                        ),
                        const SizedBox(height: kElementInnerGap),
                        Text(
                          '30%',
                          style: titleBoldMediumStyle.copyWith(
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          'Wind',
                          style: bodyMediumStyle.copyWith(color: primaryColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: mobileHeight(context) * 0.54,
            left: mobileWidth(context) * 0.08,
            right: mobileWidth(context) * 0.08,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today',
                      style: titleBoldMediumStyle.copyWith(color: primaryColor),
                    ),
                    Text(
                      '7 Day Forecasts >',
                      style: bodyLargeStyle.copyWith(color: primaryColor),
                    ),
                  ],
                ),
                const SizedBox(height: kElementGap),
                SizedBox(
                  height: mobileHeight(context) * 0.14,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final days = ['23', '24', '25', '26', '27'];
                      final temps = [
                        '30/18',
                        '33/22',
                        '32/21',
                        '35/23',
                        '29/19',
                      ];
                      final icons = [
                        Icons.wb_sunny,
                        Icons.wb_sunny,
                        Icons.wb_sunny,
                        Icons.cloud,
                        Icons.wb_sunny,
                      ];
                      final colors = [
                        Color(0xFFFFA726),
                        Color(0xFF4A90E2),
                        Color(0xFFFFA726),
                        Color(0xFF78909C),
                        Color(0xFFFFA726),
                      ];

                      return Container(
                        width: mobileWidth(context) * 0.2,
                        margin: const EdgeInsets.only(right: kElementWidthGap),
                        decoration: roundedDecorationWithShadow.copyWith(
                          color:
                              index == 1
                                  ? primaryColor
                                  : primaryColor.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              days[index],
                              style: titleBoldMediumStyle.copyWith(
                                color: kWhite,
                              ),
                            ),
                            const SizedBox(height: kElementInnerGap),
                            Icon(
                              icons[index],
                              size: 24,
                              color: index == 1 ? kWhite : colors[index],
                            ),
                            const SizedBox(height: kElementInnerGap),
                            Text(
                              temps[index],
                              style: titleBoldMediumStyle.copyWith(
                                color: kWhite,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: mobileHeight(context) * 0.12,
            left: mobileWidth(context) * 0.08,
            right: mobileWidth(context) * 0.08,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Other Cities',
                  style: titleBoldMediumStyle.copyWith(color: primaryColor),
                ),
                const SizedBox(height: kElementGap),
                Container(
                  height: 80,
                  decoration: roundedDecorationWithShadow.copyWith(
                    color: primaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kBodyHp),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 10,
                          left: -25,
                          child: Image.asset(
                            'assets/images/home_img/clouds.png',
                            width: largeIcon(context),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(width: mobileWidth(context) * 0.15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: kWhite,
                                        size: secondaryIcon(context),
                                      ),
                                      const SizedBox(width: kElementWidthGap),
                                      Text(
                                        'Location',
                                        style: titleBoldMediumStyle.copyWith(
                                          color: kWhite,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Mostly Cloudy',
                                    style: bodyMediumStyle.copyWith(
                                      color: kWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '22°',
                              style: headlineMediumStyle.copyWith(
                                color: kWhite,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: kElementGap),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    7,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: index == 0 ? 8 : 6,
                      height: index == 0 ? 8 : 6,
                      decoration: BoxDecoration(
                        color: index == 0 ? primaryColor : greyColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
