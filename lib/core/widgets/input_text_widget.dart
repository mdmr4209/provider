import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class InputTextWidget extends StatefulWidget {
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
  State<InputTextWidget> createState() => _InputTextWidgetState();
}

class _InputTextWidgetState extends State<InputTextWidget> {
  late bool _isObscured;
  late FocusNode _focusNode;
  bool _isFocused = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
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
      padding: EdgeInsets.only(top: 4.h, left: 4.w),
      child: Text(
        _errorText!,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
          fontSize: 11.sp,
        ),
      ),
    );
  }

  Widget _buildInputField(ThemeData theme) {
    final hasError = _errorText != null;
    final isEnabled = widget.enabled;
    
    // Theme-based resolution
    final inputTheme = theme.inputDecorationTheme;
    final colorScheme = theme.colorScheme;

    final bg = widget.backgroundColor ?? 
               (isEnabled ? (inputTheme.fillColor ?? theme.cardColor) 
                          : (theme.disabledColor.withValues(alpha: 0.1)));
    
    final borderCol = hasError 
        ? (widget.errorBorderColor ?? colorScheme.error)
        : (!isEnabled 
            ? (widget.disabledBorderColor ?? theme.disabledColor.withValues(alpha: 0.3))
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
                  blurRadius: 8,
                  offset: const Offset(0, 2),
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
        maxLines: widget.maxLines,
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
            return null; // Suppress standard error UI to use custom inline error
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
                color: widget.hintColor ?? theme.hintColor.withValues(alpha: 0.6),
                fontSize: (widget.hintFontSize ?? 14).sp,
                fontWeight: widget.hintFontWeight ?? FontWeight.w400,
                fontFamily: widget.hintFontFamily,
              ),
          labelStyle: widget.hintStyle ?? inputTheme.labelStyle,
          isDense: true,
          contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          prefixIcon: _buildLeading(theme, hasError),
          suffixIcon: _buildTrailing(theme, hasError),
          counterText: '',
        ),
      ),
    );
  }

  Widget? _buildLeading(ThemeData theme, bool hasError) {
    if (widget.leadingWidget == null && widget.leadingIcon.isEmpty) return null;

    final color = hasError ? theme.colorScheme.error : (widget.leadingColor ?? theme.hintColor);
    
    final leading = widget.leadingWidget ??
        Padding(
          padding: widget.leadingPadding,
          child: _buildAsset(
            widget.leadingIcon,
            widget.leadingIconWidth,
            widget.leadingIconHeight,
            widget.useLeadingColor,
            color,
          ),
        );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [leading],
    );
  }

  Widget? _buildTrailing(ThemeData theme, bool hasError) {
    final List<Widget> children = [];
    final color = hasError ? theme.colorScheme.error : (widget.trailingColor ?? theme.hintColor);

    if (widget.showObscureToggle || widget.obscureText) {
      children.add(
        GestureDetector(
          onTap: _toggleObscure, 
          child: _buildObscureIcon(theme, hasError)
        ),
      );
    }

    if (widget.trailingWidget != null || widget.trailingIcon.isNotEmpty) {
      final trailing = widget.trailingWidget ??
          Padding(
            padding: widget.trailingPadding,
            child: _buildAsset(
              widget.trailingIcon,
              widget.trailingIconWidth,
              widget.trailingIconHeight,
              widget.useTrailingColor,
              color,
            ),
          );
      children.add(trailing);
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
    
    if (_isObscured) {
      if (widget.hiddenIcon != null) {
        return _buildAsset(widget.hiddenIcon!, widget.obscureIconSize, widget.obscureIconSize, true, color);
      }
      return Icon(Icons.visibility_off_outlined, size: widget.obscureIconSize.sp, color: color);
    } else {
      if (widget.visibleIcon != null) {
        return _buildAsset(widget.visibleIcon!, widget.obscureIconSize, widget.obscureIconSize, true, color);
      }
      return Icon(Icons.visibility_outlined, size: widget.obscureIconSize.sp, color: color);
    }
  }

  Widget _buildAsset(String path, double width, double height, bool useColor, Color color) {
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
