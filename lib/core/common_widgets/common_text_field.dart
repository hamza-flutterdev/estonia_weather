import 'package:flutter/material.dart';
import '../constants/constant.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final int maxLines;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final InputBorder? border;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Color? cursorColor;
  final Color? backgroundColor;

  const CommonTextField({
    super.key,
    required this.controller,
    this.hintText = 'Enter text...',
    this.minLines = 1,
    this.maxLines = 1,
    this.contentPadding = const EdgeInsets.all(kBodyHp),
    this.hintStyle,
    this.textStyle,
    this.border,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.onSubmitted,
    this.cursorColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      cursorColor: cursorColor,
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor ?? kWhite.withValues(alpha: 0.2),
        hintText: hintText,
        hintStyle:
            hintStyle ??
            bodyBoldSmallStyle(context).copyWith(color: primaryColor),
        contentPadding: contentPadding,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(kCircularBorderRadius),
              borderSide: BorderSide(color: primaryColor),
            ),
        enabledBorder:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(kCircularBorderRadius),
              borderSide: BorderSide(color: primaryColor),
            ),
        focusedBorder:
            border ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(kCircularBorderRadius),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
      ),
      style:
          textStyle ??
          bodyBoldSmallStyle(context).copyWith(color: primaryColor),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
