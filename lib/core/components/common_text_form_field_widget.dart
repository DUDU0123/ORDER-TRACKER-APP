import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order_tracker_app/core/colors/app_colors.dart';

class CommonTextFormFieldWidget extends StatelessWidget {
  const CommonTextFormFieldWidget({
    super.key,
    this.controller,
    this.hintText,
    this.cursorColor,
    this.onTap,
    this.maxLines,
    this.obscureText,
    this.showCursor,
    this.enabled,
    this.focusNode,
    this.validator,
    this.border,
    this.errorBorder,
    this.focusedBorder,
    this.disabledBorder,
    this.enabledBorder,
    this.prefixWidget,
    this.suffixWidget,
    this.filled,
    this.labelText,
    this.labelStyle,
    this.fillColor,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.hintStyle,
    this.onChanged,
    this.inputFormatters,
    this.onTapOutsideInnerFunction,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final String? hintText;
  final Color? cursorColor;
  final void Function()? onTap;
  final int? maxLines;
  final bool? obscureText;
  final bool? showCursor;
  final bool? enabled;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final InputBorder? border;
  final InputBorder? errorBorder;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;
  final InputBorder? enabledBorder;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool? filled;
  final String? labelText;
  final TextStyle? labelStyle;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final bool readOnly;
  final TextStyle? hintStyle;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTapOutsideInnerFunction;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
        if (onTapOutsideInnerFunction != null) {
          onTapOutsideInnerFunction!();
        }
      },
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      keyboardType: keyboardType,
      controller: controller,
      cursorColor: cursorColor ?? Theme.of(context).primaryColorDark,
      cursorWidth: 1.6,
      maxLines: maxLines ?? 1,
      onTap: onTap,
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      validator: validator,
      obscureText: obscureText ?? false,
      showCursor: showCursor ?? true,
      decoration: InputDecoration(
        prefixIcon: prefixWidget,
        hintText: hintText,
        border: border,
        focusedBorder: focusedBorder ?? border,
        errorBorder: errorBorder ?? border,
        disabledBorder: disabledBorder ?? border,
        suffix: suffixWidget,
        filled: filled,
        labelText: labelText,
        floatingLabelStyle: TextStyle(
          color: AppColors.kBlack,
          fontSize: 14.sp,
        ),
        labelStyle: labelStyle,
        fillColor: fillColor,
        hintStyle: hintStyle,
        enabledBorder: enabledBorder ?? border,
        suffixIcon: suffixIcon,
        suffixIconConstraints: BoxConstraints(
          minWidth: 10.w, minHeight: 10.h,
        )
      ),
    );
  }
}
