import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';

class _InputState {
  bool isObscured;
  bool isFocused;
  String? errorText;

  _InputState({
    required this.isObscured,
    required this.isFocused,
  });
}

class InputTextWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? title;
  final bool obscureText;
  final bool showObscureToggle;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final AutovalidateMode? autovalidateMode;

  // Title Style
  final bool showTitle;
  final TextStyle? titleStyle;
  final Color? titleColor;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final String? titleFontFamily;
  final double titlePaddingBottom;

  // Container & Decoration
  final double? height;
  final double width;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? disabledBorderColor;
  final double? borderWidth;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final bool shadow;
  final Color? shadowColor;
  final Gradient? gradient;

  // Text Styles
  final TextStyle? textStyle;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;

  final TextStyle? hintStyle;
  final Color? hintColor;
  final double? hintFontSize;
  final FontWeight? hintFontWeight;
  final String? hintFontFamily;

  // Leading (Prefix)
  final String leadingIcon;
  final Widget? leadingWidget;
  final double leadingIconHeight;
  final double leadingIconWidth;
  final EdgeInsetsGeometry leadingPadding;
  final bool useLeadingColor;
  final Color? leadingColor;

  // Trailing (Suffix)
  final String trailingIcon;
  final Widget? trailingWidget;
  final double trailingIconHeight;
  final double trailingIconWidth;
  final EdgeInsetsGeometry trailingPadding;
  final bool useTrailingColor;
  final Color? trailingColor;

  // Obscure Toggle Icons
  final String? visibleIcon;
  final String? hiddenIcon;
  final double obscureIconSize;

  const InputTextWidget({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.title,
    this.obscureText = false,
    this.showObscureToggle = false,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.focusNode,
    this.onChanged,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.validator,
    this.onSaved,
    this.autovalidateMode,

    // Title
    this.showTitle = false,
    this.titleStyle,
    this.titleColor,
    this.titleFontSize,
    this.titleFontWeight,
    this.titleFontFamily,
    this.titlePaddingBottom = 6,

    // Container
    this.height,
    this.width = double.infinity,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.disabledBorderColor,
    this.borderWidth,
    this.borderRadius,
    this.contentPadding,
    this.shadow = false,
    this.shadowColor,
    this.gradient,

    // Text
    this.textStyle,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,

    // Hint
    this.hintStyle,
    this.hintColor,
    this.hintFontSize,
    this.hintFontWeight,
    this.hintFontFamily,

    // Leading
    this.leadingIcon = '',
    this.leadingWidget,
    this.leadingIconHeight = 20,
    this.leadingIconWidth = 20,
    this.leadingPadding = const EdgeInsets.only(right: 12),
    this.useLeadingColor = true,
    this.leadingColor,

    // Trailing
    this.trailingIcon = '',
    this.trailingWidget,
    this.trailingIconHeight = 20,
    this.trailingIconWidth = 20,
    this.trailingPadding = const EdgeInsets.only(left: 12),
    this.useTrailingColor = true,
    this.trailingColor,

    // Obscure
    this.visibleIcon,
    this.hiddenIcon,
    this.obscureIconSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<_InputState>(
      initialValue: _InputState(
        isObscured: obscureText,
        isFocused: false,
      ),
      builder: (FormFieldState<_InputState> fieldState) {
        final state = fieldState.value!;
        final hasError = state.errorText != null;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showTitle && title != null) _buildTitle(theme),
            _buildInputField(theme, fieldState, state),
            if (hasError) _buildErrorText(theme, state.errorText!),
          ],
        );
      },
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: titlePaddingBottom.h),
      child: Text(
        title!,
        style: titleStyle ??
            theme.textTheme.labelLarge?.copyWith(
              color: titleColor ?? theme.textTheme.labelLarge?.color,
              fontSize: (titleFontSize ?? 14).sp,
              fontWeight: titleFontWeight ?? FontWeight.w600,
              fontFamily: titleFontFamily,
            ),
      ),
    );
  }

  Widget _buildErrorText(ThemeData theme, String error) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h, left: 4.w),
      child: Text(
        error,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  Widget _buildInputField(ThemeData theme, FormFieldState<_InputState> fieldState, _InputState state) {
    final hasError = state.errorText != null;
    final isEnabled = enabled;
    
    // Theme-based resolution
    final inputTheme = theme.inputDecorationTheme;
    final colorScheme = theme.colorScheme;

    // Helper to get properties from theme's InputBorder
    Color getBorderColor(InputBorder? border, Color fallback) {
      if (border is OutlineInputBorder) return border.borderSide.color;
      return fallback;
    }

    double getBorderWidth(InputBorder? border, double fallback) {
      if (border is OutlineInputBorder) return border.borderSide.width;
      return fallback;
    }

    BorderRadius getBorderRadius(InputBorder? border) {
      if (border is OutlineInputBorder) return border.borderRadius;
      return BorderRadius.circular(12.r);
    }

    final bg = backgroundColor ?? 
               (isEnabled ? (inputTheme.fillColor ?? theme.cardColor) 
                          : (theme.disabledColor.withAlpha(25)));
    
    final borderCol = hasError 
        ? (errorBorderColor ?? getBorderColor(inputTheme.errorBorder, colorScheme.error))
        : (!isEnabled 
            ? (disabledBorderColor ?? getBorderColor(inputTheme.disabledBorder, theme.disabledColor.withAlpha(75)))
            : (state.isFocused 
                ? (focusedBorderColor ?? getBorderColor(inputTheme.focusedBorder, colorScheme.primary)) 
                : (borderColor ?? getBorderColor(inputTheme.enabledBorder, AppColors.inputBorderColor))));

    final effectiveWidth = hasError || state.isFocused 
        ? getBorderWidth(hasError ? inputTheme.errorBorder : inputTheme.focusedBorder, 1.5) 
        : getBorderWidth(inputTheme.enabledBorder, 1.0);

    final effectiveRadius = borderRadius != null 
        ? BorderRadius.circular(borderRadius!.r) 
        : getBorderRadius(inputTheme.enabledBorder);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width.w,
      height: height?.h,
      decoration: BoxDecoration(
        color: bg,
        gradient: gradient,
        borderRadius: effectiveRadius,
        border: Border.all(
          color: borderCol,
          width: (borderWidth ?? effectiveWidth).w,
        ),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: shadowColor ?? theme.shadowColor.withAlpha(20),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          state.isFocused = hasFocus;
          fieldState.didChange(state);
        },
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: state.isObscured,
          readOnly: readOnly,
          enabled: isEnabled,
          autofocus: autofocus,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textAlign: textAlign,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          onSaved: onSaved,
          onFieldSubmitted: onFieldSubmitted,
          onEditingComplete: onEditingComplete,
          autovalidateMode: autovalidateMode,
          onChanged: (val) {
            if (hasError) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                state.errorText = null;
                fieldState.didChange(state);
              });
            }
            onChanged?.call(val);
          },
          onTap: onTap,
          validator: (val) {
            if (validator != null) {
              final result = validator!(val);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                state.errorText = result;
                fieldState.didChange(state);
              });
              return null; // Use custom error UI
            }
            return null;
          },
          style: textStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                color: isEnabled 
                    ? (textColor ?? theme.textTheme.bodyMedium?.color)
                    : theme.disabledColor,
                fontSize: (fontSize ?? 14).sp,
                fontWeight: fontWeight ?? FontWeight.w400,
                fontFamily: fontFamily,
              ),
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            hintStyle: hintStyle ?? inputTheme.hintStyle,
            labelStyle: hintStyle ?? inputTheme.labelStyle,
            isDense: true,
            contentPadding: contentPadding ?? inputTheme.contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            prefixIcon: _buildLeading(theme, hasError),
            suffixIcon: _buildTrailing(theme, hasError, fieldState, state),
            counterText: '',
              fillColor: backgroundColor
          ),
        ),
      ),
    );
  }

  Widget? _buildLeading(ThemeData theme, bool hasError) {
    if (leadingWidget == null && leadingIcon.isEmpty) return null;
    final color = hasError ? theme.colorScheme.error : (leadingColor ?? theme.hintColor);
    final leading = leadingWidget ??
        Padding(
          padding: leadingPadding,
          child: _buildAsset(leadingIcon, leadingIconWidth, leadingIconHeight, useLeadingColor, color),
        );
    return Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [leading]);
  }

  Widget? _buildTrailing(ThemeData theme, bool hasError, FormFieldState<_InputState> fieldState, _InputState state) {
    final List<Widget> children = [];
    final color = hasError ? theme.colorScheme.error : (trailingColor ?? theme.hintColor);
    if (showObscureToggle || obscureText) {
      children.add(GestureDetector(
        onTap: () {
          state.isObscured = !state.isObscured;
          fieldState.didChange(state);
        }, 
        child: _buildObscureIcon(theme, hasError, state)
      ));
    }
    if (trailingWidget != null || trailingIcon.isNotEmpty) {
      final trailing = trailingWidget ??
          Padding(
            padding: trailingPadding,
            child: _buildAsset(trailingIcon, trailingIconWidth, trailingIconHeight, useTrailingColor, color),
          );
      children.add(trailing);
    }
    if (children.isEmpty) return null;
    return Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: children);
  }

  Widget _buildObscureIcon(ThemeData theme, bool hasError, _InputState state) {
    final color = hasError ? theme.colorScheme.error : (trailingColor ?? theme.hintColor);
    if (state.isObscured) {
      if (hiddenIcon != null) return _buildAsset(hiddenIcon!, obscureIconSize, obscureIconSize, true, color);
      return Icon(Icons.visibility_off_outlined, size: obscureIconSize.sp, color: color);
    } else {
      if (visibleIcon != null) return _buildAsset(visibleIcon!, obscureIconSize, obscureIconSize, true, color);
      return Icon(Icons.visibility_outlined, size: obscureIconSize.sp, color: color);
    }
  }

  Widget _buildAsset(String path, double width, double height, bool useColor, Color color) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(path, width: width.w, height: height.h, colorFilter: useColor ? ColorFilter.mode(color, BlendMode.srcIn) : null);
    }
    return Image.asset(path, width: width.w, height: height.h, color: useColor ? color : null, fit: BoxFit.contain);
  }
}
