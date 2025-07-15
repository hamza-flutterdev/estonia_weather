import 'package:flutter/material.dart';

const Color transparent = Colors.transparent;
// Whites
const Color kWhite = Color(0xFFFFFFFF);
const Color kLightWhite = Color(0xFFF7FBFF);

// Blacks
const Color kBlack = Color(0xFF000000);

// Grays
const Color greyColor = Color(0xff626262);

//red
const kOrange = Color(0xffFF7600);
const kRed = Color(0xffe30000);

//Green
const kGreen = Color(0xff55ff00);

//text color
const Color blackTextColor = Color(0xFF000000);
const Color textGreyColor = Color(0xff626262);

//app primary
const secondaryColor = Color(0xDDA7CEF8);
const primaryColor = Color(0xDD4981E8);
const bgColor = Color(0xF1CEE4F6);

// Gradients
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
