import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';

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
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  // Title Style
  final bool showTitle;
  final TextStyle? titleStyle;
  final Color titleColor;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final String titleFontFamily;
  final double titlePaddingBottom;

  // Container & Decoration
  final double? height;
  final double width;
  final Color backgroundColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final bool shadow;
  final Color? shadowColor;
  final Gradient? gradient;

  // Text Styles
  final TextStyle? textStyle;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final String fontFamily;

  final TextStyle? hintStyle;
  final Color hintColor;
  final double hintFontSize;
  final FontWeight hintFontWeight;
  final String hintFontFamily;

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
    this.onTap,
    this.validator,

    // Title
    this.showTitle = false,
    this.titleStyle,
    this.titleColor = AppColors.textColor,
    this.titleFontSize = 14,
    this.titleFontWeight = FontWeight.w600,
    this.titleFontFamily = 'Proxima Nova',
    this.titlePaddingBottom = 6,

    // Container
    this.height,
    this.width = double.infinity,
    this.backgroundColor = AppColors.whiteColor,
    this.borderColor = AppColors.borderColor,
    this.focusedBorderColor = AppColors.primaryColor,
    this.errorBorderColor = AppColors.redColor,
    this.borderWidth = 1,
    this.borderRadius = 12,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    this.shadow = false,
    this.shadowColor,
    this.gradient,

    // Text
    this.textStyle,
    this.textColor = AppColors.textColor,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.fontFamily = 'Proxima Nova',

    // Hint
    this.hintStyle,
    this.hintColor = AppColors.hintTextColor,
    this.hintFontSize = 14,
    this.hintFontWeight = FontWeight.w400,
    this.hintFontFamily = 'Proxima Nova',

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

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
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

  void _toggleObscure() => setState(() => _isObscured = !_isObscured);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTitle && widget.title != null) _buildTitle(),
        _buildInputField(),
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.only(bottom: widget.titlePaddingBottom.h),
      child: Text(
        widget.title!,
        style:
            widget.titleStyle ??
            TextStyle(
              color: widget.titleColor,
              fontSize: widget.titleFontSize.sp,
              fontWeight: widget.titleFontWeight,
              fontFamily: widget.titleFontFamily,
            ),
      ),
    );
  }

  Widget _buildInputField() {
    final Color effectiveBorderColor = _isFocused
        ? widget.focusedBorderColor
        : widget.borderColor;

    return Container(
      width: widget.width.w,
      height: widget.height?.h,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        border: Border.all(
          color: effectiveBorderColor,
          width: widget.borderWidth.w,
        ),
        boxShadow: widget.shadow
            ? [
                BoxShadow(
                  color:
                      widget.shadowColor ??
                      AppColors.boxShadowColor.withValues(alpha: 0.1),
                  blurRadius: 4,
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
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        textAlign: widget.textAlign,
        textCapitalization: widget.textCapitalization,
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        onTap: widget.onTap,
        validator: widget.validator,
        style:
            widget.textStyle ??
            TextStyle(
              color: widget.textColor,
              fontSize: widget.fontSize.sp,
              fontWeight: widget.fontWeight,
              fontFamily: widget.fontFamily,
            ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          hintStyle:
              widget.hintStyle ??
              TextStyle(
                color: widget.hintColor,
                fontSize: widget.hintFontSize.sp,
                fontWeight: widget.hintFontWeight,
                fontFamily: widget.hintFontFamily,
              ),
          labelStyle: widget.hintStyle,
          isDense: true,
          contentPadding: widget.contentPadding,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          prefixIcon: _buildLeading(),
          suffixIcon: _buildTrailing(),
          counterText: '',
        ),
      ),
    );
  }

  Widget? _buildLeading() {
    final widgetLeading =
        widget.leadingWidget ??
        (widget.leadingIcon.isNotEmpty
            ? Padding(
                padding: widget.leadingPadding,
                child: _buildAsset(
                  widget.leadingIcon,
                  widget.leadingIconWidth,
                  widget.leadingIconHeight,
                  widget.useLeadingColor,
                  widget.leadingColor ?? widget.hintColor,
                ),
              )
            : null);

    if (widgetLeading == null) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [widgetLeading],
    );
  }

  Widget? _buildTrailing() {
    final List<Widget> children = [];

    // Obscure toggle logic
    if (widget.showObscureToggle || widget.obscureText) {
      children.add(
        GestureDetector(onTap: _toggleObscure, child: _buildObscureIcon()),
      );
    }

    // Trailing icon/widget
    final trailing =
        widget.trailingWidget ??
        (widget.trailingIcon.isNotEmpty
            ? Padding(
                padding: widget.trailingPadding,
                child: _buildAsset(
                  widget.trailingIcon,
                  widget.trailingIconWidth,
                  widget.trailingIconHeight,
                  widget.useTrailingColor,
                  widget.trailingColor ?? widget.hintColor,
                ),
              )
            : null);

    if (trailing != null) {
      children.add(trailing);
    }

    if (children.isEmpty) return null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  Widget _buildObscureIcon() {
    if (_isObscured) {
      if (widget.hiddenIcon != null) {
        return _buildAsset(
          widget.hiddenIcon!,
          widget.obscureIconSize,
          widget.obscureIconSize,
          true,
          widget.hintColor,
        );
      }
      return Icon(
        Icons.visibility_off_outlined,
        size: widget.obscureIconSize.sp,
        color: widget.hintColor,
      );
    } else {
      if (widget.visibleIcon != null) {
        return _buildAsset(
          widget.visibleIcon!,
          widget.obscureIconSize,
          widget.obscureIconSize,
          true,
          widget.hintColor,
        );
      }
      return Icon(
        Icons.visibility_outlined,
        size: widget.obscureIconSize.sp,
        color: widget.hintColor,
      );
    }
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
