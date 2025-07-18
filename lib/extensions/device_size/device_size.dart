import 'package:flutter/material.dart';
import '../../core/constants/constant.dart';
/*
This is look very very messy
this is all you make fix size every container/
cards etc.
warning!> for time being this is fine, aware next time
*/
class DeviceSize {
  final BoxConstraints constraints;
  final BuildContext context;

  DeviceSize(this.constraints, this.context);

  double get width => mobileWidth(context);
  double get height => mobileHeight(context);

  bool get isSmall => height < 675;
  bool get isMedium => height >= 675 && height < 773;
  bool get isLarge => height >= 773 && height < 850;
  bool get isBig => height >= 890;
  bool get isTab => width >= 600;

  double get horizontalPadding => isTab ? width * 0.08 : width * 0.05;
  double get weatherCardHorizontalMargin => isTab ? width * 0.2 : width * 0.15;
  double get weatherIconLeft => isTab ? width * 0.12 : width * 0.08;

  double get weatherIconTop =>
      isTab
          ? height * 0.1
          : isSmall
          ? height * 0.27
          : isMedium
          ? height * 0.18
          : isLarge
          ? height * 0.15
          : isBig
          ? height * 0.19
          : height * 0.14;

  double get weatherIconSize => largeIcon(context);

  double get detailsCardTop =>
      isTab
          ? height * 0.34
          : isSmall
          ? height * 0.46
          : isMedium
          ? height * 0.33
          : isLarge
          ? height * 0.375
          : isBig
          ? height * 0.36
          : height * 0.30;

  double get todayHeaderTop =>
      isTab
          ? height * 0.46
          : isSmall
          ? height * 0.57
          : isMedium
          ? height * 0.453
          : isLarge
          ? height * 0.49
          : isBig
          ? height * 0.47
          : height * 0.415;

  double get todayForecastTop =>
      isTab
          ? height * 0.49
          : isSmall
          ? height * 0.61
          : isMedium
          ? height * 0.49
          : isLarge
          ? height * 0.53
          : isBig
          ? height * 0.495
          : height * 0.445;

  double get otherCitiesHeaderTop =>
      isTab
          ? height * 0.65
          : isSmall
          ? height * 0.747
          : isMedium
          ? height * 0.64
          : isLarge
          ? height * 0.67
          : isBig
          ? height * 0.635
          : height * 0.59;

  double get otherCitiesTop =>
      isTab
          ? height * 0.68
          : isSmall
          ? height * 0.795
          : isMedium
          ? height * 0.677
          : isLarge
          ? height * 0.707
          : isBig
          ? height * 0.67
          : height * 0.63;

  double get hourlyImageHeight => height * 0.4;
  double get hourlyCardTop => height * 0.11;

  double get hourlyCardHeight =>
      isTab
          ? height * 0.44
          : isBig
          ? height * 0.364
          : isLarge
          ? height * 0.50
          : isMedium
          ? height * 0.515
          : isSmall
          ? height * 0.48
          : height * 0.38;

  double get hourlyListItemHeight => isTab ? width * 0.12 : width * 0.18;
  double get hourlyCardLeftMargin => isTab ? width * 0.10 : width * 0.05;
  double get hourlyCardRightMargin => isTab ? width * 0.10 : width * 0.05;

  double get hourlyListContentTop => hourlyCardHeight + kToolbarHeight;

  double get hourlyListPaddingHorizontal => isTab ? width * 0.15 : kBodyHp;

  double get hourlyTimeWidth => isTab ? width * 0.1 : width * 0.15;
  double get hourlySpacerWidth => isTab ? width * 0.08 : width * 0.14;

  double get dailyImageHeight => height * 0.4;
  double get dailyCardTop => height * 0.11;

  double get dailyCardHeight =>
      isTab
          ? height * 0.44
          : isBig
          ? height * 0.364
          : isLarge
          ? height * 0.50
          : isMedium
          ? height * 0.515
          : isSmall
          ? height * 0.44
          : height * 0.38;

  double get dailyListItemHeight => isTab ? width * 0.15 : width * 0.22;
  double get dailyCardLeftMargin => isTab ? width * 0.10 : width * 0.05;
  double get dailyCardRightMargin => isTab ? width * 0.10 : width * 0.05;

  double get dailyListContentTop =>
      dailyCardHeight + kToolbarHeight + (isTab ? kBodyHp : kElementGap);

  double get dailyListPaddingHorizontal => isTab ? width * 0.15 : kBodyHp;

  double get dailyDayWidth => isTab ? width * 0.1 : width * 0.15;
  double get dailySpacerWidth => isTab ? width * 0.08 : width * 0.14;
  double get dailyConditionPaddingLeft => isTab ? 16.0 : 8.0;
}
