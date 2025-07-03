// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../theme/app_colors.dart';
//
// class CommonDropDown<T> extends StatelessWidget {
//   final T? value;
//   final List<T> items;
//   final Function(T?) onChanged;
//   final String Function(T) itemBuilder;
//   final TextStyle? textStyle;
//   final Color? dropdownColor;
//   final Color? iconColor;
//   final double? maxHeight;
//   final double itemHeight;
//
//   const CommonDropDown({
//     super.key,
//     required this.value,
//     required this.items,
//     required this.onChanged,
//     required this.itemBuilder,
//     this.textStyle,
//     this.dropdownColor,
//     this.iconColor,
//     this.maxHeight = 300.0,
//     this.itemHeight = 48.0,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<T>(
//       value: value,
//       isExpanded: false,
//       borderRadius: BorderRadius.circular(12),
//       underline: const SizedBox(),
//       style: textStyle ?? context.textTheme.titleSmall,
//       dropdownColor: dropdownColor ?? kWhite,
//       menuMaxHeight: maxHeight,
//       icon: Icon(Icons.keyboard_arrow_down, color: iconColor ?? greyColor),
//       items:
//           items.map((T item) {
//             return DropdownMenuItem<T>(
//               value: item,
//               child: Container(
//                 height: itemHeight,
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   itemBuilder(item),
//                   style:
//                       textStyle ??
//                       context.textTheme.titleSmall?.copyWith(
//                         fontWeight: FontWeight.w400,
//                       ),
//                 ),
//               ),
//             );
//           }).toList(),
//       onChanged: onChanged,
//     );
//   }
// }
