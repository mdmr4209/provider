import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';
import '../theme/design_system.dart';
import 'custom_loader.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPress,
    required this.title,
    this.subtitle = '',
    this.buttonColor = AppColors.buttonColor,
    this.buttonColor1 = AppColors.buttonColor1,
    this.textColor = AppColors.textWhiteColor,
    this.subtextColor = AppColors.textWhiteColor,
    this.borderColor = AppColors.borderColor,
    this.borderShadowColor = AppColors.boxShadowColor,
    this.height = 50,
    this.width = double.infinity,
    this.radius = 12,
    this.fontSize = 14,
    this.subfontSize = 12,
    this.fontWeight = FontWeight.w900,
    this.subfontWeight = FontWeight.w400,
    this.fontFamily = 'Proxima Nova',
    this.subfontFamily = 'Proxima Nova',
    this.loading = false,
    this.center = true,
    this.linearGradient = false,
    this.horizontalPadding = 16,

    // Leading properties
    this.leadingIcon = '',
    this.leadingWidget,
    this.leadingIconHeight = 25,
    this.leadingIconWidth = 25,
    this.leadingPadding = const EdgeInsets.only(right: 8),
    this.useLeadingColor = false,

    // Trailing properties
    this.trailingIcon = '',
    this.trailingWidget,
    this.trailingIconHeight = 25,
    this.trailingIconWidth = 25,
    this.trailingPadding = const EdgeInsets.only(left: 8),
    this.useTrailingColor = false,

    this.iconColor,
  });

  final String title,
      subtitle,
      fontFamily,
      subfontFamily,
      leadingIcon,
      trailingIcon;
  final Widget? leadingWidget, trailingWidget;
  final double height,
      width,
      radius,
      fontSize,
      subfontSize,
      leadingIconHeight,
      leadingIconWidth,
      trailingIconHeight,
      trailingIconWidth,
      horizontalPadding;
  final EdgeInsetsGeometry leadingPadding, trailingPadding;
  final Future<void> Function()? onPress;
  final Color textColor,
      subtextColor,
      buttonColor,
      buttonColor1,
      borderColor,
      borderShadowColor;
  final Color? iconColor;
  final FontWeight fontWeight, subfontWeight;
  final bool loading, center, linearGradient, useLeadingColor, useTrailingColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final designSystem = theme.extension<AppDesignSystem>();
    final buttonStyle = theme.elevatedButtonTheme.style;

    // Resolve colors from theme if they are defaults
    final effectiveButtonColor = buttonColor == AppColors.buttonColor
        ? (buttonStyle?.backgroundColor?.resolve({}) ?? buttonColor)
        : buttonColor;
    final effectiveTextColor = textColor == AppColors.textWhiteColor
        ? (buttonStyle?.foregroundColor?.resolve({}) ?? textColor)
        : textColor;
    final effectiveIconColor = iconColor ?? effectiveTextColor;

    // Determine Gradient
    final Gradient? effectiveGradient = linearGradient
        ? (designSystem?.primaryGradient ??
            LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [buttonColor, buttonColor1, buttonColor],
            ))
        : null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (onPress != null && !loading) ? () => onPress!() : null,
        borderRadius: BorderRadius.circular(radius.r),
        child: Container(
          height: height.h,
          width: width.w,
          decoration: ShapeDecoration(
            color: effectiveGradient == null ? effectiveButtonColor : null,
            gradient: effectiveGradient,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius.r),
              side: BorderSide(color: borderColor, width: 1.w),
            ),
            shadows: [
              if (borderShadowColor != Colors.transparent)
                designSystem?.softShadow ??
                    BoxShadow(
                      color: borderShadowColor,
                      blurRadius: 12,
                      offset: const Offset(0, 12),
                      spreadRadius: 0,
                    ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
            child: loading
                ? CustomLoader(
                    size: 20,
                    color: effectiveTextColor,
                    // strokeWidth: 2,
                  )
                : _buildContent(
                    context,
                    effectiveTextColor,
                    effectiveIconColor,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color textColor, Color iconColor) {
    final theme = Theme.of(context);

    final leading =
        leadingWidget ??
        (leadingIcon.isNotEmpty
            ? _buildAsset(
                leadingIcon,
                leadingIconWidth,
                leadingIconHeight,
                useLeadingColor,
                iconColor,
              )
            : null);

    final trailing =
        trailingWidget ??
        (trailingIcon.isNotEmpty
            ? _buildAsset(
                trailingIcon,
                trailingIconWidth,
                trailingIconHeight,
                useTrailingColor,
                iconColor,
              )
            : null);

    final textColumn = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: theme.textTheme.titleSmall?.copyWith(
            color: textColor,
            fontSize: fontSize.sp,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
            shadows: [
              Shadow(
                offset: const Offset(0, 0),
                blurRadius: 5,
                color: const Color(0xFF000000).withAlpha(232),
              ),
            ],
          ),
        ),
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: theme.textTheme.bodySmall?.copyWith(
              color: subtextColor,
              fontSize: subfontSize.sp,
              fontWeight: subfontWeight,
              fontFamily: subfontFamily,
            ),
          ),
      ],
    );

    return Row(
      mainAxisAlignment: center
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        if (leading != null) Padding(padding: leadingPadding, child: leading),
        if (center) textColumn else Expanded(child: textColumn),
        if (trailing != null)
          Padding(padding: trailingPadding, child: trailing),
      ],
    );
  }

  Widget _buildAsset(
    String path,
    double width,
    double height,
    bool useColor,
    Color color,
  ) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: width.w,
        height: height.h,
        colorFilter: useColor ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      );
    }
    return Image.asset(
      path,
      width: width.w,
      height: height.h,
      color: useColor ? color : null,
      fit: BoxFit.contain,
    );
  }
}
