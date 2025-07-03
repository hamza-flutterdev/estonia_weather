import 'package:flutter/material.dart';

import '../constants/constant.dart';
import '../theme/app_colors.dart';

class BackIconButton extends StatelessWidget {
  const BackIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.arrow_back_ios_new,
        color: kWhite,
        size: secondaryIcon(context),
      ),
    );
  }
}

// class NotificationIconButton extends StatelessWidget {
//   final VoidCallback onTap;
//
//   const NotificationIconButton({super.key, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Image.asset('images/notifications.png'),
//     );
//   }
// }
//
// class MoonIconButton extends StatelessWidget {
//   final VoidCallback onTap;
//
//   const MoonIconButton({super.key, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Image.asset('images/moon_icon.png'),
//     );
//   }
// }
//
// class TrIconButton extends StatelessWidget {
//   final VoidCallback onTap;
//
//   const TrIconButton({super.key, required this.onTap});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Image.asset('images/try_icon.png'),
//     );
//   }
// }
//
// class CampaignIconButton extends StatelessWidget {
//   const CampaignIconButton({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pop(context);
//       },
//       child: Image.asset('images/Compaigns.svg'),
//     );
//   }
// }
//
// class MenuIcon extends StatelessWidget {
//   const MenuIcon({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.pop(context);
//       },
//       child: Image.asset('images/menu_icon.svg', height: 20, width: 20),
//     );
//   }
// }

class IconActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color color;
  final double? size;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final bool isCircular;

  const IconActionButton({
    super.key,
    this.onTap,
    required this.icon,
    required this.color,
    this.size,
    this.padding = const EdgeInsets.all(kElementInnerGap),
    this.backgroundColor,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedSize = size ?? secondaryIcon(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius:
              isCircular ? null : BorderRadius.circular(kBorderRadius),
        ),
        child: Icon(icon, color: color, size: resolvedSize),
      ),
    );
  }
}

// class SendButton extends StatelessWidget {
//   final VoidCallback? onTap;
//   final bool isLoading;
//
//   const SendButton({super.key, required this.onTap, this.isLoading = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: isLoading ? null : onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 4),
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: isLoading ? greyColor.withValues(alpha: 0.3) : kSkyColor,
//           shape: BoxShape.circle,
//         ),
//         child:
//             isLoading
//                 ? const SizedBox(
//                   width: 16,
//                   height: 16,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     valueColor: AlwaysStoppedAnimation<Color>(kWhite),
//                   ),
//                 )
//                 : const Icon(Icons.send, color: kWhite, size: 20),
//       ),
//     );
//   }
// }

class ImageActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String assetPath;
  final Color? color;
  final double? size;
  final double? width;
  final double? height;
  final bool isCircular;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  const ImageActionButton({
    super.key,
    this.onTap,
    required this.assetPath,
    this.color,
    this.size,
    this.width,
    this.isCircular = false,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(8),
    this.borderRadius,
    this.height,
  });
  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      assetPath,
      width: size,
      height: size,
      color: color,
      fit: BoxFit.contain,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
          borderRadius:
              isCircular ? null : borderRadius ?? BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: greyColor.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: image),
      ),
    );
  }
}
