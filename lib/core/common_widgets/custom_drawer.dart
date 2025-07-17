import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../gen/assets.gen.dart';
import '../constants/constant.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  get kSkyBlueColor => null;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        color: bgColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(gradient: kGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: kElementGap),
                      child: Image.asset(
                        'assets/images/appicon1.jpg',
                        height: largeIcon(context),
                      ),
                    ),
                  ),
                  SizedBox(height: kElementInnerGap),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Estonia Weather',
                      style: headlineSmallStyle.copyWith(color: kWhite),
                    ),
                  ),
                ],
              ),
            ),
            DrawerTile(
              icon: Icons.more,
              title: 'More Apps',
              onTap: () {
                moreApp();
              },
            ),
            Divider(color: primaryColor.withValues(alpha: 0.1)),
            DrawerTile(
              icon: Icons.privacy_tip_rounded,
              title: 'Privacy Policy',
              onTap: () {
                privacy();
              },
            ),
            Divider(color: primaryColor.withValues(alpha: 0.1)),
            DrawerTile(
              icon: Icons.star_rounded,
              title: 'Rate Us',
              onTap: () {
                rateUs();
              },
            ),
            Divider(color: primaryColor.withValues(alpha: 0.1)),
          ],
        ),
      ),
    );
  }
}

void privacy() async {
  const androidUrl = 'https://unisoftaps.blogspot.com/';
  const iosUrl = 'https://asadarmantech.blogspot.com';

  final url = Platform.isIOS ? iosUrl : androidUrl;

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

void rateUs() async {
  const androidUrl =
      'https://play.google.com/store/apps/details?id=com.unisoftaps.estoniaweatherforecast';
  const iosUrl = 'https://apps.apple.com/us/app/Estonia Weather Forecast/6748671693';

  final url = Platform.isIOS ? iosUrl : androidUrl;

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

void moreApp() async {
  const androidUrl =
      'https://play.google.com/store/apps/developer?id=Unisoft+Apps';
  const iosUrl =
      'https://apps.apple.com/us/developer/muhammad-asad-arman/id1487950157?see-all=i-phonei-pad-apps';

  final url = Platform.isIOS ? iosUrl : androidUrl;

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DrawerTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 24, color: textGreyColor),
      title: Text(title, style: titleSmallStyle),
      onTap: onTap,
    );
  }
}
