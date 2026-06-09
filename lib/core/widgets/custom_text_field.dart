import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class _InputState {
  bool isObscured;
  bool isFocused;
  String? errorText;

  _InputState({
    required this.isObscured,
    required this.isFocused,
  });
}

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? title;
  final bool isPassword;
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
  final double borderWidth;
  final double borderRadius;
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

  // Leading (Prefix) - Supports Widget OR Asset Path
  final dynamic prefix; // Widget or String (path)
  final double prefixSize;
  final EdgeInsetsGeometry prefixPadding;
  final bool usePrefixColor;
  final Color? prefixColor;

  // Trailing (Suffix) - Supports Widget OR Asset Path
  final dynamic suffix; // Widget or String (path)
  final double suffixSize;
  final EdgeInsetsGeometry suffixPadding;
  final bool useSuffixColor;
  final Color? suffixColor;

  // Obscure Toggle Icons
  final dynamic visibleIcon; // Widget or String (path)
  final dynamic hiddenIcon; // Widget or String (path)
  final double obscureIconSize;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.title,
    this.isPassword = false,
    this.showObscureToggle = true,
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
    this.titlePaddingBottom = 8,

    // Container
    this.height,
    this.width = double.infinity,
    this.backgroundColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.disabledBorderColor,
    this.borderWidth = 1,
    this.borderRadius = 12,
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

    // Prefix
    this.prefix,
    this.prefixSize = 20,
    this.prefixPadding = const EdgeInsets.only(right: 12),
    this.usePrefixColor = true,
    this.prefixColor,

    // Suffix
    this.suffix,
    this.suffixSize = 20,
    this.suffixPadding = const EdgeInsets.only(left: 12),
    this.useSuffixColor = true,
    this.suffixColor,

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
        isObscured: isPassword,
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
      padding: EdgeInsets.only(top: 6.h, left: 4.w),
      child: Text(
        error,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInputField(ThemeData theme, FormFieldState<_InputState> fieldState, _InputState state) {
    final hasError = state.errorText != null;
    final isEnabled = enabled;
    
    final inputTheme = theme.inputDecorationTheme;
    final colorScheme = theme.colorScheme;

    final bg = backgroundColor ?? 
               (isEnabled ? (inputTheme.fillColor ?? theme.cardColor) 
                          : (theme.disabledColor.withValues(alpha: 0.05)));
    
    final borderCol = hasError 
        ? (errorBorderColor ?? colorScheme.error)
        : (!isEnabled 
            ? (disabledBorderColor ?? theme.disabledColor.withValues(alpha: 0.2))
            : (state.isFocused 
                ? (focusedBorderColor ?? colorScheme.primary) 
                : (borderColor ?? theme.dividerColor)));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width.w,
      height: height?.h,
      decoration: BoxDecoration(
        color: bg,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: Border.all(
          color: borderCol,
          width: (hasError || state.isFocused) ? (borderWidth + 0.5).w : borderWidth.w,
        ),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color: shadowColor ?? theme.shadowColor.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
          maxLines: isPassword ? 1 : maxLines,
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
              return null; // Handle error UI externally
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
            hintStyle: hintStyle ??
                inputTheme.hintStyle ??
                theme.textTheme.bodyMedium?.copyWith(
                  color: hintColor ?? theme.hintColor.withValues(alpha: 0.5),
                  fontSize: (hintFontSize ?? 14).sp,
                  fontWeight: hintFontWeight ?? FontWeight.w400,
                  fontFamily: hintFontFamily,
                ),
            labelStyle: hintStyle ?? inputTheme.labelStyle,
            isDense: true,
            contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            prefixIcon: _buildPrefix(theme, hasError),
            suffixIcon: _buildSuffix(theme, hasError, fieldState, state),
            counterText: '',
          ),
        ),
      ),
    );
  }

  Widget? _buildPrefix(ThemeData theme, bool hasError) {
    if (prefix == null) return null;
    final color = hasError ? theme.colorScheme.error : (prefixColor ?? theme.hintColor);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: prefixPadding,
          child: _resolveAssetOrWidget(prefix, prefixSize, usePrefixColor, color),
        ),
      ],
    );
  }

  Widget? _buildSuffix(ThemeData theme, bool hasError, FormFieldState<_InputState> fieldState, _InputState state) {
    final List<Widget> children = [];
    final color = hasError ? theme.colorScheme.error : (suffixColor ?? theme.hintColor);

    if (isPassword && showObscureToggle) {
      children.add(
        GestureDetector(
          onTap: () {
            state.isObscured = !state.isObscured;
            fieldState.didChange(state);
          }, 
          child: _buildObscureIcon(theme, hasError, state)
        ),
      );
    }

    if (suffix != null) {
      children.add(
        Padding(
          padding: suffixPadding,
          child: _resolveAssetOrWidget(suffix, suffixSize, useSuffixColor, color),
        ),
      );
    }

    if (children.isEmpty) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildObscureIcon(ThemeData theme, bool hasError, _InputState state) {
    final color = hasError ? theme.colorScheme.error : theme.hintColor;
    final icon = state.isObscured ? (hiddenIcon ?? Icons.visibility_off_outlined) 
                             : (visibleIcon ?? Icons.visibility_outlined);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: _resolveAssetOrWidget(icon, obscureIconSize, true, color),
    );
  }

  Widget _resolveAssetOrWidget(dynamic input, double size, bool useColor, Color color) {
    if (input is String) {
      if (input.toLowerCase().endsWith('.svg')) {
        return SvgPicture.asset(
          input,
          width: size.w,
          height: size.h,
          colorFilter: useColor ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        );
      }
      return Image.asset(
        input,
        width: size.w,
        height: size.h,
        color: useColor ? color : null,
        fit: BoxFit.contain,
      );
    } else if (input is IconData) {
      return Icon(input, size: size.sp, color: color);
    } else if (input is Widget) {
      return SizedBox(width: size.w, height: size.h, child: input);
    }
    return const SizedBox.shrink();
  }
}
