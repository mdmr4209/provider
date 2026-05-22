import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomTextField extends StatefulWidget {
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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;
  late FocusNode _focusNode;
  bool _isFocused = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.isPassword;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _toggleObscure() {
    if (mounted) {
      setState(() => _isObscured = !_isObscured);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle && widget.title != null) _buildTitle(theme),
        _buildInputField(theme),
        if (_errorText != null) _buildErrorText(theme),
      ],
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.titlePaddingBottom.h),
      child: Text(
        widget.title!,
        style: widget.titleStyle ??
            theme.textTheme.labelLarge?.copyWith(
              color: widget.titleColor ?? theme.textTheme.labelLarge?.color,
              fontSize: (widget.titleFontSize ?? 14).sp,
              fontWeight: widget.titleFontWeight ?? FontWeight.w600,
              fontFamily: widget.titleFontFamily,
            ),
      ),
    );
  }

  Widget _buildErrorText(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h, left: 4.w),
      child: Text(
        _errorText!,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInputField(ThemeData theme) {
    final hasError = _errorText != null;
    final isEnabled = widget.enabled;
    
    final inputTheme = theme.inputDecorationTheme;
    final colorScheme = theme.colorScheme;

    final bg = widget.backgroundColor ?? 
               (isEnabled ? (inputTheme.fillColor ?? theme.cardColor) 
                          : (theme.disabledColor.withValues(alpha: 0.05)));
    
    final borderCol = hasError 
        ? (widget.errorBorderColor ?? colorScheme.error)
        : (!isEnabled 
            ? (widget.disabledBorderColor ?? theme.disabledColor.withValues(alpha: 0.2))
            : (_isFocused 
                ? (widget.focusedBorderColor ?? colorScheme.primary) 
                : (widget.borderColor ?? theme.dividerColor)));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: widget.width.w,
      height: widget.height?.h,
      decoration: BoxDecoration(
        color: bg,
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        border: Border.all(
          color: borderCol,
          width: (hasError || _isFocused) ? (widget.borderWidth + 0.5).w : widget.borderWidth.w,
        ),
        boxShadow: widget.shadow
            ? [
                BoxShadow(
                  color: widget.shadowColor ?? theme.shadowColor.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        obscureText: _isObscured,
        readOnly: widget.readOnly,
        enabled: isEnabled,
        autofocus: widget.autofocus,
        maxLines: widget.isPassword ? 1 : widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textAlign: widget.textAlign,
        textCapitalization: widget.textCapitalization,
        inputFormatters: widget.inputFormatters,
        onSaved: widget.onSaved,
        onFieldSubmitted: widget.onFieldSubmitted,
        onEditingComplete: widget.onEditingComplete,
        autovalidateMode: widget.autovalidateMode,
        onChanged: (val) {
          if (hasError) {
            setState(() => _errorText = null);
          }
          widget.onChanged?.call(val);
        },
        onTap: widget.onTap,
        validator: (val) {
          if (widget.validator != null) {
            final result = widget.validator!(val);
            if (mounted) {
              setState(() => _errorText = result);
            }
            return null; // Handle error UI externally
          }
          return null;
        },
        style: widget.textStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              color: isEnabled 
                  ? (widget.textColor ?? theme.textTheme.bodyMedium?.color)
                  : theme.disabledColor,
              fontSize: (widget.fontSize ?? 14).sp,
              fontWeight: widget.fontWeight ?? FontWeight.w400,
              fontFamily: widget.fontFamily,
            ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          hintStyle: widget.hintStyle ??
              inputTheme.hintStyle ??
              theme.textTheme.bodyMedium?.copyWith(
                color: widget.hintColor ?? theme.hintColor.withValues(alpha: 0.5),
                fontSize: (widget.hintFontSize ?? 14).sp,
                fontWeight: widget.hintFontWeight ?? FontWeight.w400,
                fontFamily: widget.hintFontFamily,
              ),
          labelStyle: widget.hintStyle ?? inputTheme.labelStyle,
          isDense: true,
          contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          prefixIcon: _buildPrefix(theme, hasError),
          suffixIcon: _buildSuffix(theme, hasError),
          counterText: '',
        ),
      ),
    );
  }

  Widget? _buildPrefix(ThemeData theme, bool hasError) {
    if (widget.prefix == null) return null;
    final color = hasError ? theme.colorScheme.error : (widget.prefixColor ?? theme.hintColor);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: widget.prefixPadding,
          child: _resolveAssetOrWidget(widget.prefix, widget.prefixSize, widget.usePrefixColor, color),
        ),
      ],
    );
  }

  Widget? _buildSuffix(ThemeData theme, bool hasError) {
    final List<Widget> children = [];
    final color = hasError ? theme.colorScheme.error : (widget.suffixColor ?? theme.hintColor);

    if (widget.isPassword && widget.showObscureToggle) {
      children.add(
        GestureDetector(
          onTap: _toggleObscure, 
          child: _buildObscureIcon(theme, hasError)
        ),
      );
    }

    if (widget.suffix != null) {
      children.add(
        Padding(
          padding: widget.suffixPadding,
          child: _resolveAssetOrWidget(widget.suffix, widget.suffixSize, widget.useSuffixColor, color),
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

  Widget _buildObscureIcon(ThemeData theme, bool hasError) {
    final color = hasError ? theme.colorScheme.error : theme.hintColor;
    final icon = _isObscured ? (widget.hiddenIcon ?? Icons.visibility_off_outlined) 
                             : (widget.visibleIcon ?? Icons.visibility_outlined);
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: _resolveAssetOrWidget(icon, widget.obscureIconSize, true, color),
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
