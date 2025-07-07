import 'package:estonia_weather/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final bool enabled;

  const CustomShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return Shimmer.fromColors(
      baseColor: baseColor ?? kWhite,
      highlightColor: highlightColor ?? primaryColor.withValues(alpha: 0.01),
      child: child,
    );
  }
}

class ShimmerListItem extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsets? margin;
  final BoxDecoration? decoration;
  final BorderRadius? borderRadius;
  final Color? color;

  const ShimmerListItem({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.decoration,
    this.borderRadius,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin ?? EdgeInsets.zero,
      decoration:
          decoration ??
          BoxDecoration(
            color: color ?? kWhite,
            borderRadius: borderRadius ?? BorderRadius.circular(20),
          ),
    );
  }
}

class ShimmerListView extends StatelessWidget {
  final int itemCount;
  final double? itemWidth;
  final double? itemHeight;
  final Axis scrollDirection;
  final EdgeInsets Function(int index)? itemMargin;
  final BoxDecoration? itemDecoration;
  final BorderRadius? itemBorderRadius;
  final Color? itemColor;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerListView({
    super.key,
    this.itemCount = 5,
    this.itemWidth,
    this.itemHeight,
    this.scrollDirection = Axis.horizontal,
    this.itemMargin,
    this.itemDecoration,
    this.itemBorderRadius,
    this.itemColor,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: ListView.builder(
        scrollDirection: scrollDirection,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return ShimmerListItem(
            width: itemWidth,
            height: itemHeight,
            margin: itemMargin?.call(index),
            decoration: itemDecoration,
            borderRadius: itemBorderRadius,
            color: itemColor,
          );
        },
      ),
    );
  }
}
