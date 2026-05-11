import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


import '../res/colors/app_color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.buttonColor = AppColor.buttonColor,
    this.buttonColor1 = AppColor.buttonColor1,
    this.textColor = AppColor.textWhiteColor,
    this.subtextColor = AppColor.textWhiteColor,
    this.borderColor = Colors.transparent,
    this.trailingColor = false,
    this.borderShadowColor = const Color(0x1E000000),
    required this.onPress,
    this.height = 50,
    this.leadingIconHeight = 25,
    this.leadingIconWeight = 25,
    this.leadingPaddingLeft = 8,
    this.leadingPaddingRight = 8,
    this.trailingIconHeight = 25,
    this.trailingIconWeight = 25,
    this.trailingPaddingLeft = 8,
    this.trailingPaddingRight = 8,
    this.width = double.infinity,
    this.loading = false,
    this.center = true,
    this.leading = false,
    this.trailing = false,
    this.linearGradient = false,
    this.leadingIcon = '',
    this.trailingIcon = '',
    required this.title,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w900,
    this.fontFamily = 'Proxima Nova',
    this.radius = 0,
    this.subtitle = '',
    this.subfontSize = 12,
    this.horizontal = 16,
    this.subfontWeight = FontWeight.w400,
    this.subfontFamily = 'Proxima Nova',
  });

  final bool loading, center, leading, linearGradient, trailing, trailingColor;
  final String title,
      subtitle,
      fontFamily,
      subfontFamily,
      leadingIcon,
      trailingIcon;
  final double height,
      fontSize,
      radius,
      subfontSize,
      width,
      leadingIconHeight,
      leadingIconWeight,
      leadingPaddingLeft,
      leadingPaddingRight,
      trailingIconHeight,
      trailingIconWeight,
      trailingPaddingLeft,
      trailingPaddingRight,
      horizontal;
  final Future<void> Function()? onPress;
  final Color textColor,
      subtextColor,
      buttonColor,
      buttonColor1,
      borderColor,
      borderShadowColor;
  final FontWeight fontWeight, subfontWeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = theme.elevatedButtonTheme.style;
    
    // Resolve colors from theme if they are defaults
    final effectiveButtonColor = buttonColor == AppColor.buttonColor ? (buttonStyle?.backgroundColor?.resolve({}) ?? buttonColor) : buttonColor;
    final effectiveTextColor = textColor == AppColor.textWhiteColor ? (buttonStyle?.foregroundColor?.resolve({}) ?? textColor) : textColor;

    return InkWell(
      onTap: (onPress != null && !loading) ? () => onPress!() : null,
      child: Container(
        height: height.h,
        width: width.w,
        decoration: linearGradient
            ? ShapeDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(1.00, -1.22),
                  end: const Alignment(-0.20, 2.10),
                  colors: [buttonColor, buttonColor1],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius == 0 ? 12.r : radius.r),
                ),
              )
            : ShapeDecoration(
                color: effectiveButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius == 0 ? 12.r : radius.r),
                  side: BorderSide(color: borderColor, width: 1.w),
                ),
              ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontal.w),
          child: loading
              ? Center(child: CircularProgressIndicator(color: effectiveTextColor))
              : center
                  ? Center(
                      child: subtitle.isEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (leading)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: leadingPaddingLeft,
                                      right: leadingPaddingRight,
                                    ),
                                    child: SvgPicture.asset(
                                      leadingIcon,
                                      width: leadingIconWeight,
                                      height: leadingIconHeight,
                                    ),
                                  ),
                                Text(
                                  title,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: effectiveTextColor,
                                    fontSize: fontSize.sp,
                                    fontWeight: fontWeight,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (leading)
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: leadingPaddingLeft,
                                      right: leadingPaddingRight,
                                    ),
                                    child: SvgPicture.asset(
                                      leadingIcon,
                                      width: leadingIconWeight,
                                      height: leadingIconHeight,
                                    ),
                                  ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      title,
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: effectiveTextColor,
                                        fontSize: fontSize.sp,
                                        fontWeight: fontWeight,
                                      ),
                                    ),
                                    Text(
                                      subtitle,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: subtextColor,
                                        fontSize: subfontSize.sp,
                                        fontWeight: subfontWeight,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (leading)
                          Padding(
                            padding: EdgeInsets.only(
                              left: leadingPaddingLeft,
                              right: leadingPaddingRight,
                            ),
                            child: SvgPicture.asset(
                              leadingIcon,
                              width: leadingIconWeight,
                              height: leadingIconHeight,
                            ),
                          ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: effectiveTextColor,
                                  fontSize: fontSize.sp,
                                  fontWeight: fontWeight,
                                ),
                              ),
                              if (subtitle.isNotEmpty)
                                Text(
                                  subtitle,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: subtextColor,
                                    fontSize: subfontSize.sp,
                                    fontWeight: subfontWeight,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (trailing)
                          Padding(
                            padding: EdgeInsets.only(
                              left: trailingPaddingLeft,
                              right: trailingPaddingRight,
                            ),
                            child: SvgPicture.asset(
                              colorFilter: trailingColor
                                  ? ColorFilter.mode(
                                      theme.iconTheme.color!,
                                      BlendMode.srcIn,
                                    )
                                  : null,
                              trailingIcon,
                              width: trailingIconWeight,
                              height: trailingIconHeight,
                            ),
                          ),
                      ],
                    ),
        ),
      ),
    );
  }
}
