import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'icon_buttons.dart';
import '../constants/constant.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final String? title;
  final String subtitle;
  final bool useBackButton;
  final VoidCallback? onBackTap;

  const CustomAppBar({
    super.key,
    required this.subtitle,
    this.useBackButton = true,
    this.actions,
    this.onBackTap,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kContentPaddingSmall,
      child: AppBar(
        backgroundColor: transparent,
        elevation: 0,
        centerTitle: true,
        leading:
            useBackButton
                ? BackIconButton()
                : Builder(
                  builder: (context) {
                    return IconActionButton(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      icon: Icons.menu,
                      color: primaryColor,
                      size: secondaryIcon(context),
                    );
                  },
                ),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (title != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: primaryColor,
                      size: secondaryIcon(context),
                    ),
                    const SizedBox(width: kElementWidthGap),
                    Text(
                      title!,
                      style: titleBoldMediumStyle.copyWith(color: primaryColor),
                    ),
                  ],
                ),
              Text(
                subtitle,
                style: bodyMediumStyle.copyWith(color: primaryColor),
              ),
            ],
          ),
        ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
