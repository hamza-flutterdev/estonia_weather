import 'package:flutter/material.dart';
import '../../core/constants/constant.dart';

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
}
