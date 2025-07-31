import 'dart:io';

import 'package:estonia_weather/core/local_storage/local_storage.dart';
import 'package:estonia_weather/core/utils/drawer_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../gen/assets.gen.dart';
import '../../presentation/premium_screen/premium_screen.dart';
import '../constants/constant.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        color: getBgColor(Get.context!),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(gradient: kGradient(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: kElementGap),
                      child: Image.asset(
                        Assets.images.icon.path,
                        height: largeIcon(context),
                      ),
                    ),
                  ),
                  SizedBox(height: kElementInnerGap),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Estonia Weather',
                      style: headlineSmallStyle(context),
                    ),
                  ),
                ],
              ),
            ),
            DrawerTile(
              icon: Icons.more,
              title: 'More Apps',
              onTap: () {
                DrawerActions.moreApp();
              },
            ),
            Divider(color: primaryColor.withValues(alpha: 0.1)),
            DrawerTile(
              icon: Icons.privacy_tip_rounded,
              title: 'Privacy Policy',
              onTap: () {
                DrawerActions.privacy();
              },
            ),
            Divider(color: primaryColor.withValues(alpha: 0.1)),
            DrawerTile(
              icon: Icons.star_rounded,
              title: 'Rate Us',
              onTap: () {
                DrawerActions.rateUs();
              },
            ),
            Divider(color: primaryColor.withValues(alpha: 0.1)),
            if (Platform.isIOS) ...[
              DrawerTile(
                icon: Icons.workspace_premium,
                title: 'Ads free',
                onTap: () {
                  Get.to(PremiumScreen());
                },
              ),
              Divider(color: primaryColor.withValues(alpha: 0.1)),
            ],
            // PremiumScreen
            ListTile(
              leading: Icon(
                Icons.dark_mode_rounded,
                size: 24,
                color: getTextColor(Get.context!),
              ),
              title: Text(
                Get.theme.brightness == Brightness.dark
                    ? 'Dark Mode'
                    : 'Light Mode',
                style: titleSmallStyle(context),
              ),
              trailing: Switch(
                value: Get.isDarkMode,
                onChanged: (value) async {
                  Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                  await LocalStorage().setBool('isDarkMode', value);
                },
                thumbColor: WidgetStatePropertyAll(
                  greyColor.withValues(alpha: 0.7),
                ),
                trackColor: WidgetStatePropertyAll(
                  greyColor.withValues(alpha: 0.2),
                ),
                trackOutlineColor: WidgetStatePropertyAll(
                  greyColor.withValues(alpha: 0.5),
                ),
                trackOutlineWidth: WidgetStatePropertyAll(1),

                activeThumbImage: AssetImage(Assets.images.icon.path),
              ),
            ),
            Divider(color: primaryColor.withValues(alpha: 0.1)),
          ],
        ),
      ),
    );
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
      leading: Icon(icon, size: 24, color: getTextColor(Get.context!)),
      title: Text(title, style: titleSmallStyle(context)),
      onTap: onTap,
    );
  }
}
