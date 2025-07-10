import 'package:flutter/material.dart';

/// ========== Fonts ==========
const fontPrimary = 'Montserrat';
const fontSecondary = 'Poppins';

/// ========== Padding ==========
const double kBodyHp = 16.0;
const double kElementGap = 12.0;
const double kElementInnerGap = 8.0;
const double kElementWidthGap = 6.0;
const kContentPaddingSmall = EdgeInsets.symmetric(horizontal: 12, vertical: 4);
const kContentPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

/// ========== Margins ==========
const kVerticalMargin = EdgeInsets.symmetric(vertical: 8);
const kHorizontalMargin = EdgeInsets.symmetric(horizontal: 8);
const kPaginationMargin = EdgeInsets.symmetric(horizontal: 3);

/// ========== Elevation ==========8
const double kCardElevation = 2.0;

/// ========== Border ==========
const double kBorderRadius = 8.0;
const double kCircularBorderRadius = 50.0;

/// ========== Icon Sizes ==========
double largeIcon(BuildContext context) => mobileWidth(context) * 0.3;
double mediumIcon(BuildContext context) => mobileWidth(context) * 0.27;
double primaryIcon(BuildContext context) => mobileWidth(context) * 0.1;
double secondaryIcon(BuildContext context) => mobileWidth(context) * 0.075;
double smallIcon(BuildContext context) => mobileWidth(context) * 0.06;

/// ========== MediaQuery Helpers ==========
double mobileWidth(BuildContext context) => MediaQuery.of(context).size.width;
double mobileHeight(BuildContext context) => MediaQuery.of(context).size.height;
