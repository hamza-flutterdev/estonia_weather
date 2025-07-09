import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';
import 'icon_buttons.dart';
import '../constants/constant.dart';

class CustomAppBar extends StatelessWidget {
  final List<Widget>? actions;
  final dynamic title;
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
    final bool hasTitle = title != null;
    final double topPadding = MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leading icon
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

          const SizedBox(width: 12),

          // Title & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (hasTitle)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: primaryColor,
                        size: secondaryIcon(context),
                      ),
                      const SizedBox(width: kElementWidthGap),
                      if (title is String)
                        Text(
                          title as String,
                          style: titleBoldMediumStyle.copyWith(
                            color: primaryColor,
                          ),
                        )
                      else if (title is Widget)
                        DefaultTextStyle(
                          style: titleBoldMediumStyle.copyWith(
                            color: primaryColor,
                          ),
                          child: title as Widget,
                        ),
                    ],
                  ),
                Text(
                  subtitle,
                  style: (hasTitle ? bodyMediumStyle : titleBoldMediumStyle)
                      .copyWith(color: primaryColor),
                ),
              ],
            ),
          ),

          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
