import 'package:flutter/material.dart';

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
        color: secondaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Image.asset('assets/images/icon.png', height: 80),
                  ),
                  Text(
                    'Learn English',
                    style: headlineMediumStyle.copyWith(color: kWhite),
                  ),
                ],
              ),
            ),
            DrawerTile(
              icon: Icons.more,
              title: 'More Apps',
              onTap: () {
                //moreApp();
              },
            ),
            Divider(color: primaryColor.withValues(alpha: 0.1)),
            DrawerTile(
              icon: Icons.privacy_tip_rounded,
              title: 'Privacy Policy',
              onTap: () {
                //privacy();
              },
            ),
            Divider(color: primaryColor.withValues(alpha: 0.1)),
            DrawerTile(
              icon: Icons.star_rounded,
              title: 'Rate Us',
              onTap: () {
                //  rateUs();
              },
            ),
            Divider(color: primaryColor.withValues(alpha: 0.1)),
            DrawerTile(
              icon: Icons.restart_alt,
              title: 'Reset App',
              onTap: () {},
              //_showResetConfirmation(context),
            ),
            Divider(color: primaryColor.withValues(alpha: 0.1)),
          ],
        ),
      ),
    );
  }

  //   void _showResetConfirmation(BuildContext context) {
  //     PanaraConfirmDialog.show(
  //       context,
  //       title: "Reset App",
  //       message:
  //           "Are you sure you want to reset the app? This will clear all your progress and data.",
  //       confirmButtonText: "Reset",
  //       cancelButtonText: "Cancel",
  //       onTapCancel: () {
  //         Navigator.pop(context);
  //       },
  //       onTapConfirm: () async {
  //         Navigator.pop(context);
  //         await _resetApp(context);
  //       },
  //       panaraDialogType: PanaraDialogType.custom,
  //       color: primaryColor,
  //       barrierDismissible: false,
  //     );
  //   }
  //
  //   Future<void> _resetApp(BuildContext context) async {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.clear();
  //
  //     ToastHelper.showCustomToast(
  //       context: context,
  //       message: "App is being reset.",
  //       type: ToastificationType.success,
  //       primaryColor: primaryColor,
  //       icon: Icons.restart_alt,
  //     );
  //   }
  // }
  //
  // void privacy() async {
  //   const androidUrl = 'https://privacypolicymuslimapplications.blogspot.com/';
  //   const iosUrl = 'https://asadarmantech.blogspot.com';
  //
  //   final url = Platform.isIOS ? iosUrl : androidUrl;
  //
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  //
  // void rateUs() async {
  //   const androidUrl =
  //       'https://play.google.com/store/apps/details?id=com.ma.gkquiz.generalknowledge';
  //   const iosUrl = 'https://apps.apple.com/us/app/GK Quiz/6747742199';
  //
  //   final url = Platform.isIOS ? iosUrl : androidUrl;
  //
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  //
  // void moreApp() async {
  //   const androidUrl =
  //       'https://play.google.com/store/apps/developer?id=Muslim+Applications';
  //   const iosUrl =
  //       'https://apps.apple.com/us/developer/muhammad-asad-arman/id1487950157?see-all=i-phonei-pad-apps';
  //
  //   final url = Platform.isIOS ? iosUrl : androidUrl;
  //
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
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
