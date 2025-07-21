import 'package:flutter/material.dart';

const Color transparent = Colors.transparent;

// Whites
const Color kWhite = Color(0xFFFFFFFF);
const Color kLightWhite = Color(0xFFF7FBFF);

// Blacks
const Color kBlack = Color(0xFF1C1C1C);

// Grays
const Color greyColor = Color(0xff626262);

// Reds & Oranges
const Color kOrange = Color(0xffFF7600);
const Color kRed = Color(0xffe30000);

// Green
const Color kGreen = Color(0xff55ff00);

// Text colors
const Color blackTextColorLight = Color(0xFF000000);
const Color textGreyColorLight = Color(0xff626262);

// App primary
const Color secondaryColor = Color(0xDDA7CEF8);
const Color primaryColor = Color(0xDD4981E8);

// Light theme background
const Color lightBgColor = Color(0xF1CEE4F6);

Color getBgColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark ? kBlack : lightBgColor;

Color getTextColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? kWhite
        : blackTextColorLight;

Color getSubTextColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark
        ? greyColor
        : textGreyColorLight;

const kGradient = LinearGradient(
  begin: Alignment.bottomLeft,
  end: Alignment.topRight,
  colors: [primaryColor, secondaryColor],
  stops: [0.3, 0.95],
);

const kContainerGradient = LinearGradient(
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
  colors: [primaryColor, Color.fromARGB(80, 73, 129, 232)],
  stops: [0.3, 0.75],
);
