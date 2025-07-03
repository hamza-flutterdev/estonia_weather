// import 'package:flutter/material.dart';
// import '../theme/app_styles.dart';
//
// class CarouselBottomIcon extends StatelessWidget {
//   final List<String> items;
//   final List<String>? urduTitles, imgPath;
//   final CarouselSliderController carouselController;
//   final Function(int) onIndexChanged;
//   final Function(int)? onItemTap;
//   final List<Color>? containerColors,
//       iconColors,
//       titleTextColors,
//       urduTextColors;
//   final List<TextStyle>? titleTextStyles, urduTextStyles;
//   final int currentIndex;
//   final bool autoPlay, enlargeCenterPage, enableInfiniteScroll, smallerIcons;
//   final double? height;
//   final double viewportFraction;
//   final EdgeInsets? itemMargin;
//   final int? selectedIndex;
//   final TextStyle? titleTextStyle, urduTextStyle;
//
//   const CarouselBottomIcon({
//     super.key,
//     required this.items,
//     this.urduTitles,
//     required this.carouselController,
//     required this.onIndexChanged,
//     this.onItemTap,
//     required this.currentIndex,
//     this.autoPlay = false,
//     this.height,
//     this.viewportFraction = 0.65,
//     this.enlargeCenterPage = true,
//     this.itemMargin,
//     this.enableInfiniteScroll = true,
//     this.selectedIndex,
//     this.imgPath,
//     this.containerColors,
//     this.iconColors,
//     this.smallerIcons = false,
//     this.titleTextStyle,
//     this.urduTextStyle,
//     this.titleTextStyles,
//     this.urduTextStyles,
//     this.titleTextColors,
//     this.urduTextColors,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider.builder(
//       carouselController: carouselController,
//       itemCount: items.length,
//       options: CarouselOptions(
//         height: height,
//         autoPlay: autoPlay,
//         autoPlayInterval: const Duration(seconds: 3),
//         aspectRatio: 16 / 9,
//         enlargeCenterPage: enlargeCenterPage,
//         viewportFraction: viewportFraction,
//         enableInfiniteScroll: enableInfiniteScroll,
//         scrollPhysics: const BouncingScrollPhysics(),
//         onPageChanged: (index, reason) => onIndexChanged(index),
//       ),
//       itemBuilder:
//           (context, index, _) => GestureDetector(
//             onTap: onItemTap != null ? () => onItemTap!(index) : null,
//             child: Container(
//               margin: kHorizontalMargin,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(26),
//                 border: Border.all(
//                   color:
//                       containerColors?.elementAt(index) ??
//                       primaryColor.withValues(alpha: 0.7),
//                   width: 0.5,
//                 ),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(4),
//                 child: Container(
//                   decoration: roundedDecoration.copyWith(
//                     color:
//                         containerColors?.elementAt(index) ??
//                         primaryColor.withValues(alpha: 0.7),
//                     borderRadius: BorderRadius.circular(24),
//                     border: Border.all(
//                       color:
//                           selectedIndex == index ? primaryColor : transparent,
//                       width: selectedIndex == index ? 1.0 : 0.0,
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(kElementInnerGap),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: kElementInnerGap),
//                         Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Center(
//                               child: Text(
//                                 items[index],
//                                 textAlign: TextAlign.center,
//                                 style: () {
//                                   if (titleTextStyles != null &&
//                                       titleTextStyles!.length > index) {
//                                     return titleTextStyles![index];
//                                   }
//                                   if (titleTextColors != null &&
//                                       titleTextColors!.length > index) {
//                                     return (titleTextStyle ??
//                                             titleBoldMediumStyle)
//                                         .copyWith(
//                                           color: titleTextColors![index],
//                                         );
//                                   }
//                                   return titleTextStyle ??
//                                       titleBoldMediumStyle.copyWith(
//                                         color: kWhite,
//                                       );
//                                 }(),
//                               ),
//                             ),
//                             if (urduTitles != null &&
//                                 urduTitles!.length > index) ...[
//                               const SizedBox(height: kElementInnerGap),
//                               Text(
//                                 urduTitles![index],
//                                 textAlign: TextAlign.center,
//                                 style: () {
//                                   if (urduTextStyles != null &&
//                                       urduTextStyles!.length > index) {
//                                     return urduTextStyles![index];
//                                   }
//                                   if (urduTextColors != null &&
//                                       urduTextColors!.length > index) {
//                                     return (urduTextStyle ??
//                                             titleBoldMediumStyle)
//                                         .copyWith(
//                                           color: urduTextColors![index],
//                                         );
//                                   }
//                                   return urduTextStyle ??
//                                       urduBodyLargeStyle.copyWith(
//                                         color: kWhite,
//                                       );
//                                 }(),
//                               ),
//                             ],
//                           ],
//                         ),
//                         if (imgPath != null && imgPath!.length > index) ...[
//                           const SizedBox(height: kElementInnerGap),
//                           () {
//                             final image = Image.asset(
//                               imgPath![index],
//                               height: primaryIcon(context),
//                               fit: BoxFit.fitHeight,
//                             );
//                             final filtered =
//                                 iconColors != null && iconColors!.length > index
//                                     ? ColorFiltered(
//                                       colorFilter: ColorFilter.mode(
//                                         iconColors![index],
//                                         BlendMode.srcIn,
//                                       ),
//                                       child: image,
//                                     )
//                                     : image;
//                             return smallerIcons
//                                 ? Center(child: filtered)
//                                 : Expanded(child: filtered);
//                           }(),
//                         ],
//                         const SizedBox(height: kElementInnerGap),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//     );
//   }
// }
