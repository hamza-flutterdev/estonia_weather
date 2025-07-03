import 'package:flutter/material.dart';
import '../../core/theme/app_styles.dart'; // Update path as needed
import '../constants/constant.dart';
import '../theme/app_colors.dart'; // Update path as needed

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: mobileHeight(context) * 0.055,
      margin: kVerticalMargin,
      decoration: roundedPrimaryBorderDecoration.copyWith(color: primaryColor),
      child: Center(
        child: Text(title, style: titleSmallBoldStyle.copyWith(color: kWhite)),
      ),
    );
  }
}
