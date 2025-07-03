import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

/// ========== Fonts ==========
const fontPrimary = 'Montserrat';
const fontSecondary = 'Poppins';
// final String urduFontFamily = GoogleFonts.notoNastaliqUrdu().fontFamily!;

/// ========== Padding ==========
const double kBodyHp = 16.0;
const double kElementGap = 12.0;
const double kElementInnerGap = 8.0;
const double kElementWidthGap = 8.0;
const kContentPaddingSmall = EdgeInsets.symmetric(horizontal: 12, vertical: 4);
const kContentPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

/// ========== Margins ==========
const kVerticalMargin = EdgeInsets.symmetric(vertical: 8);
const kHorizontalMargin = EdgeInsets.symmetric(horizontal: 8);

/// ========== Elevation ==========8
const double kCardElevation = 2.0;

/// ========== Border ==========
const double kBorderRadius = 8.0;
const double kCircularBorderRadius = 50.0;

/// ========== Icon Sizes ==========
double largeIcon(BuildContext context) => mobileWidth(context) * 0.15;
double primaryIcon(BuildContext context) => mobileWidth(context) * 0.1;
double secondaryIcon(BuildContext context) => mobileWidth(context) * 0.07;

/// ========== MediaQuery Helpers ==========
double mobileWidth(BuildContext context) => MediaQuery.of(context).size.width;
double mobileHeight(BuildContext context) => MediaQuery.of(context).size.height;
