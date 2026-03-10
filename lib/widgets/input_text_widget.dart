import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../res/assets/image_assets.dart';
import '../res/colors/app_color.dart';

/// Pure-Flutter replacement for InputTextWidget.
/// The obscure-text toggle is managed with local StatefulWidget state
/// instead of a GetX controller.
class InputTextWidget extends StatefulWidget {
  const InputTextWidget({
    super.key,
    this.hintText = '',
    this.backicontap2,
    this.backicontap,
    required this.onChanged,
    this.onTap,
    this.validator,
    this.obscureText = false,
    this.readOnly = false,
    this.leading = false,
    this.backIcon = false,
    this.backIcon2 = false,
    this.textAlign = false,
    this.leadingIcon = ImageAssets.home,
    this.imageIcon = '',
    this.backimage = '',
    this.keyboardType = TextInputType.text,
    this.backimagetap,
    this.backimageadd = false,
    this.contentPadding = false,
    this.clock = false,
    this.shadow = false,
    this.linearGradient = false,
    this.passwordIcon = ImageAssets.obsecure,
    this.borderRadius = 4.0,
    this.borderColor = AppColor.defaultDeepColor,
    this.hintTextColor = AppColor.hintTextColor,
    this.borderShadowColor = AppColor.boxShadowColor,
    this.textColor = AppColor.textColor,
    this.leadingHeight = 14.0,
    this.leadingWidth = 17.0,
    this.height = 46.0,
    this.width = double.infinity,
    this.hintfontFamily = 'Roboto',
    this.hintfontSize = 14.0,
    this.hintfontWeight = FontWeight.w300,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w500,
    this.fontFamily = 'Roboto',
    this.vertical = 14.0,
    this.horizontal = 15.0,
    this.leadingright = 0.0,
    this.leadingtop = 0.0,
    this.leadingleft = 10.0,
    this.backimagewidth = 24.0,
    this.backimageheight = 24.0,
    this.borderWidth = .5,
    this.backgroundColor = AppColor.textAreaColor,
    this.leadingColor = AppColor.hintTextColor,
    this.maxLines = 1,
    this.textEditingController,
    this.settingsIconWidget,
  });

  final String hintText, hintfontFamily, fontFamily;
  final double borderRadius,
      fontSize,
      hintfontSize,
      leadingHeight,
      leadingWidth,
      leadingright,
      leadingtop,
      leadingleft,
      backimagewidth,
      backimageheight;
  final Color borderColor,
      textColor,
      hintTextColor,
      backgroundColor,
      leadingColor,
      borderShadowColor;
  final double height, width, horizontal, vertical, borderWidth;
  final bool obscureText,
      readOnly,
      contentPadding,
      leading,
      clock,
      backIcon,
      backIcon2,
      backimageadd,
      linearGradient,
      shadow,
      textAlign;
  final String passwordIcon, leadingIcon, imageIcon, backimage;
  final ValueChanged<String> onChanged;
  final VoidCallback? onTap, backicontap, backicontap2, backimagetap;
  final String? Function(String?)? validator;
  final FontWeight fontWeight, hintfontWeight;
  final int maxLines;
  final TextEditingController? textEditingController;
  final Widget? settingsIconWidget;
  final TextInputType keyboardType;

  @override
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  late bool _isObscured;
  late TextEditingController _controller;
  bool _ownsController = false;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
    if (widget.textEditingController != null) {
      _controller = widget.textEditingController!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _toggleObscure() => setState(() => _isObscured = !_isObscured);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height.h,
      width: widget.width == double.infinity ? double.infinity : widget.width.w,
      decoration: widget.shadow
          ? ShapeDecoration(
              color: widget.backgroundColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: widget.borderWidth.w, color: widget.borderColor),
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
              ),
              shadows: [
                BoxShadow(
                  color: widget.borderShadowColor,
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            )
          : ShapeDecoration(
              color: widget.backgroundColor,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: widget.borderWidth.w, color: widget.borderColor),
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
              ),
            ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading icon
            if (widget.leading)
              Padding(
                padding: EdgeInsets.only(
                  right: widget.leadingright.w,
                  top: widget.leadingtop.h,
                  left: widget.leadingleft.w,
                ),
                child: SvgPicture.asset(
                  widget.leadingIcon,
                  width: widget.leadingWidth.w,
                  height: widget.leadingHeight.h,
                  colorFilter: ColorFilter.mode(
                      widget.leadingColor, BlendMode.srcIn),
                ),
              ),

            // Text field
            Expanded(
              child: TextField(
                controller: _controller,
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                readOnly: widget.readOnly,
                maxLines: widget.maxLines,
                textAlign:
                    widget.textAlign ? TextAlign.right : TextAlign.left,
                obscureText: _isObscured,
                keyboardType: widget.keyboardType,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: widget.hintTextColor,
                    fontSize: widget.hintfontSize.sp,
                    fontWeight: widget.hintfontWeight,
                    fontFamily: widget.hintfontFamily,
                  ),
                  border: InputBorder.none,
                  contentPadding: widget.contentPadding || widget.maxLines > 1
                      ? EdgeInsets.symmetric(
                          horizontal: widget.horizontal.w,
                          vertical: widget.vertical.h,
                        )
                      : EdgeInsets.symmetric(horizontal: widget.horizontal.w),
                ),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: widget.fontSize.sp,
                      fontWeight: widget.fontWeight,
                      fontFamily: widget.fontFamily,
                      color: widget.textColor,
                    ),
              ),
            ),

            // Obscure toggle
            if (widget.obscureText)
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: GestureDetector(
                  onTap: _toggleObscure,
                  child: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    size: 22.sp,
                    color: widget.hintTextColor,
                  ),
                ),
              ),

            // Back icons
            if (widget.backIcon)
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: GestureDetector(
                  onTap: widget.backicontap,
                  child: widget.settingsIconWidget ??
                      SvgPicture.asset(widget.imageIcon),
                ),
              ),
            if (widget.backIcon2)
              Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: GestureDetector(
                  onTap: widget.backicontap2,
                  child: SvgPicture.asset(widget.imageIcon),
                ),
              ),
            if (widget.backimageadd)
              GestureDetector(
                onTap: widget.backimagetap,
                child: Image.asset(
                  widget.backimage,
                  height: widget.backimageheight.h,
                  width: widget.backimagewidth.w,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
