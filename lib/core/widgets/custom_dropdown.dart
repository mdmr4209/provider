import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';

class CustomDropdown extends StatefulWidget {
  // controller must be ValueNotifier<String> (single) or ValueNotifier<List<String>> (multi)
  final ValueNotifier<dynamic> controller;
  final List<String> items;
  final String title;
  final void Function(dynamic value)? onChanged;
  final bool enabled;

  // Title Text
  final bool showTitle;
  final double titlePaddingBottom;
  final TextStyle? titleStyle;
  final Color titleColor;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final String titleFontFamily;
  final double? titleLetterSpacing;
  final EdgeInsets? titlePadding;

  // Container
  final double? height;
  final double width;
  final double containerPaddingHorizontal;
  final double containerPaddingVertical;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final bool shadow;
  final Color? shadowColor;
  final double shadowBlur;
  final Offset shadowOffset;
  final Gradient? gradient;

  // Leading & Trailing Assets (Support SVG/Image/Widget)
  final String leadingIcon;
  final Widget? leadingWidget;
  final double leadingIconHeight;
  final double leadingIconWidth;
  final EdgeInsetsGeometry leadingPadding;
  final bool useLeadingColor;
  final Color? leadingColor;

  final String trailingIcon;
  final Widget? trailingWidget;
  final double trailingIconHeight;
  final double trailingIconWidth;
  final EdgeInsetsGeometry trailingPadding;
  final bool useTrailingColor;
  final Color? trailingColor;

  // Hint
  final String hintText;
  final TextStyle? hintStyle;
  final Color hintColor;
  final double hintFontSize;
  final FontWeight hintFontWeight;
  final String hintFontFamily;

  // Selected text
  final TextStyle? selectedTextStyle;
  final Color selectedTextColor;
  final double selectedTextFontSize;
  final FontWeight selectedTextFontWeight;
  final String selectedTextFontFamily;

  // Menu popup (Single Select)
  final Color menuBackgroundColor;
  final double menuElevation;
  final double? menuMaxHeight;

  // Menu item text
  final TextStyle? menuItemStyle;
  final Color menuItemColor;
  final double menuItemFontSize;
  final FontWeight menuItemFontWeight;
  final String menuItemFontFamily;

  // Multi-select specific
  final bool multiSelect;
  final Color? dialogBackgroundColor;
  final String dialogTitle;
  final TextStyle? dialogTitleStyle;
  final Color dialogTitleColor;
  final double dialogTitleFontSize;
  final FontWeight dialogTitleFontWeight;
  final String dialogTitleFontFamily;
  final TextStyle? dialogItemStyle;
  final Color dialogItemColor;
  final double dialogItemFontSize;
  final FontWeight dialogItemFontWeight;
  final String dialogItemFontFamily;
  final Color checkboxActiveColor;
  final double dialogRadius;

  // Initial values
  final String? initialSingleValue;
  final List<String>? initialMultiValues;

  const CustomDropdown({
    super.key,
    required this.controller,
    required this.items,
    this.title = '',
    this.onChanged,
    this.enabled = true,

    // Title
    this.showTitle = true,
    this.titlePaddingBottom = 6,
    this.titleStyle,
    this.titleColor = AppColors.textColor,
    this.titleFontSize = 14,
    this.titleFontWeight = FontWeight.w600,
    this.titleFontFamily = 'Proxima Nova',
    this.titleLetterSpacing,
    this.titlePadding,

    // Container
    this.height,
    this.width = double.infinity,
    this.containerPaddingHorizontal = 12,
    this.containerPaddingVertical = 0,
    this.backgroundColor = AppColors.whiteColor,
    this.borderColor = AppColors.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 12,
    this.shadow = false,
    this.shadowColor,
    this.shadowBlur = 4,
    this.shadowOffset = const Offset(0, 2),
    this.gradient,

    // Leading
    this.leadingIcon = '',
    this.leadingWidget,
    this.leadingIconHeight = 20,
    this.leadingIconWidth = 20,
    this.leadingPadding = const EdgeInsets.only(right: 10),
    this.useLeadingColor = true,
    this.leadingColor,

    // Trailing
    this.trailingIcon = '',
    this.trailingWidget,
    this.trailingIconHeight = 20,
    this.trailingIconWidth = 20,
    this.trailingPadding = const EdgeInsets.only(left: 10),
    this.useTrailingColor = true,
    this.trailingColor,

    // Hint
    this.hintText = 'Select Option',
    this.hintStyle,
    this.hintColor = AppColors.hintTextColor,
    this.hintFontSize = 14,
    this.hintFontWeight = FontWeight.w400,
    this.hintFontFamily = 'Proxima Nova',

    // Selected
    this.selectedTextStyle,
    this.selectedTextColor = AppColors.textColor,
    this.selectedTextFontSize = 14,
    this.selectedTextFontWeight = FontWeight.w500,
    this.selectedTextFontFamily = 'Proxima Nova',

    // Menu
    this.menuBackgroundColor = AppColors.whiteColor,
    this.menuElevation = 8,
    this.menuMaxHeight,
    this.menuItemStyle,
    this.menuItemColor = AppColors.textColor,
    this.menuItemFontSize = 14,
    this.menuItemFontWeight = FontWeight.w400,
    this.menuItemFontFamily = 'Proxima Nova',

    // Multi
    this.multiSelect = false,
    this.dialogTitle = 'Select Items',
    this.dialogBackgroundColor,
    this.dialogTitleStyle,
    this.dialogTitleColor = AppColors.textColor,
    this.dialogTitleFontSize = 18,
    this.dialogTitleFontWeight = FontWeight.bold,
    this.dialogTitleFontFamily = 'Proxima Nova',
    this.dialogItemStyle,
    this.dialogItemColor = AppColors.textColor,
    this.dialogItemFontSize = 15,
    this.dialogItemFontWeight = FontWeight.w400,
    this.dialogItemFontFamily = 'Proxima Nova',
    this.checkboxActiveColor = AppColors.primaryColor,
    this.dialogRadius = 16,

    // Initial
    this.initialSingleValue,
    this.initialMultiValues,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initValues());
  }

  void _initValues() {
    if (!widget.multiSelect && widget.initialSingleValue != null) {
      if (widget.controller.value == null ||
          widget.controller.value.toString().isEmpty) {
        widget.controller.value = widget.initialSingleValue;
      }
    }
    if (widget.multiSelect && widget.initialMultiValues != null) {
      if (widget.controller.value == null ||
          (widget.controller.value as List).isEmpty) {
        widget.controller.value = List<String>.from(widget.initialMultiValues!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.enabled ? 1.0 : 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showTitle && widget.title.isNotEmpty) _buildTitle(),
          ValueListenableBuilder(
            valueListenable: widget.controller,
            builder: (context, value, child) {
              return _buildContainer(context, value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding:
          widget.titlePadding ??
          EdgeInsets.only(bottom: widget.titlePaddingBottom.h),
      child: Text(
        widget.title,
        style:
            widget.titleStyle ??
            TextStyle(
              color: widget.titleColor,
              fontSize: widget.titleFontSize.sp,
              fontWeight: widget.titleFontWeight,
              fontFamily: widget.titleFontFamily,
              letterSpacing: widget.titleLetterSpacing,
            ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context, dynamic currentValue) {
    return Container(
      width: widget.width.w,
      height: widget.height?.h ?? 50.h,
      padding: EdgeInsets.symmetric(
        horizontal: widget.containerPaddingHorizontal.w,
        vertical: widget.containerPaddingVertical.h,
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        border: Border.all(
          color: widget.borderColor,
          width: widget.borderWidth.w,
        ),
        boxShadow: widget.shadow
            ? [
                BoxShadow(
                  color:
                      widget.shadowColor ??
                      AppColors.boxShadowColor.withValues(alpha: 0.1),
                  blurRadius: widget.shadowBlur,
                  offset: widget.shadowOffset,
                ),
              ]
            : null,
      ),
      child: widget.multiSelect
          ? _buildMultiSelectTrigger(context, currentValue)
          : _buildSingleSelect(currentValue),
    );
  }

  Widget _buildSingleSelect(dynamic currentValue) {
    final effectiveLeading = _getLeading(widget.selectedTextColor);

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: (currentValue == null || currentValue.toString().isEmpty)
            ? null
            : currentValue.toString(),
        icon: _getTrailing(widget.selectedTextColor),
        dropdownColor: widget.menuBackgroundColor,
        elevation: widget.menuElevation.toInt(),
        menuMaxHeight: widget.menuMaxHeight?.h,
        borderRadius: BorderRadius.circular(widget.borderRadius.r),
        style:
            widget.selectedTextStyle ??
            TextStyle(
              fontSize: widget.selectedTextFontSize.sp,
              color: widget.selectedTextColor,
              fontWeight: widget.selectedTextFontWeight,
              fontFamily: widget.selectedTextFontFamily,
            ),
        hint: Row(
          children: [
            if (effectiveLeading != null)
              Padding(padding: widget.leadingPadding, child: effectiveLeading),
            Expanded(
              child: Text(
                widget.hintText,
                style:
                    widget.hintStyle ??
                    TextStyle(
                      fontSize: widget.hintFontSize.sp,
                      color: widget.hintColor,
                      fontWeight: widget.hintFontWeight,
                      fontFamily: widget.hintFontFamily,
                    ),
              ),
            ),
          ],
        ),
        selectedItemBuilder: (context) {
          return widget.items.map((String item) {
            return Row(
              children: [
                if (effectiveLeading != null)
                  Padding(
                    padding: widget.leadingPadding,
                    child: effectiveLeading,
                  ),
                Expanded(
                  child: Text(
                    item,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        widget.selectedTextStyle ??
                        TextStyle(
                          fontSize: widget.selectedTextFontSize.sp,
                          color: widget.selectedTextColor,
                          fontWeight: widget.selectedTextFontWeight,
                          fontFamily: widget.selectedTextFontFamily,
                        ),
                  ),
                ),
              ],
            );
          }).toList();
        },
        onChanged: widget.enabled
            ? (value) {
                widget.controller.value = value;
                if (widget.onChanged != null) widget.onChanged!(value);
              }
            : null,
        items: widget.items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style:
                  widget.menuItemStyle ??
                  TextStyle(
                    fontSize: widget.menuItemFontSize.sp,
                    color: widget.menuItemColor,
                    fontWeight: widget.menuItemFontWeight,
                    fontFamily: widget.menuItemFontFamily,
                  ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMultiSelectTrigger(BuildContext context, dynamic currentValue) {
    final List<String> selected = List<String>.from(currentValue ?? []);
    final effectiveLeading = _getLeading(widget.selectedTextColor);

    return InkWell(
      onTap: widget.enabled ? () => _showMultiSelectDialog(context) : null,
      child: Row(
        children: [
          if (effectiveLeading != null)
            Padding(padding: widget.leadingPadding, child: effectiveLeading),
          Expanded(
            child: Text(
              selected.isEmpty ? widget.hintText : selected.join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: selected.isEmpty
                  ? (widget.hintStyle ??
                        TextStyle(
                          fontSize: widget.hintFontSize.sp,
                          color: widget.hintColor,
                          fontWeight: widget.hintFontWeight,
                          fontFamily: widget.hintFontFamily,
                        ))
                  : (widget.selectedTextStyle ??
                        TextStyle(
                          fontSize: widget.selectedTextFontSize.sp,
                          color: widget.selectedTextColor,
                          fontWeight: widget.selectedTextFontWeight,
                          fontFamily: widget.selectedTextFontFamily,
                        )),
            ),
          ),
          Padding(
            padding: widget.trailingPadding,
            child: _getTrailing(
              selected.isEmpty ? widget.hintColor : widget.selectedTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMultiSelectDialog(BuildContext context) async {
    final List<String> current = List<String>.from(
      widget.controller.value ?? [],
    );
    final temp = ValueNotifier<List<String>>(List.from(current));

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: widget.dialogBackgroundColor ?? widget.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.dialogRadius.r),
        ),
        title: Text(
          widget.dialogTitle,
          style:
              widget.dialogTitleStyle ??
              TextStyle(
                color: widget.dialogTitleColor,
                fontSize: widget.dialogTitleFontSize.sp,
                fontWeight: widget.dialogTitleFontWeight,
                fontFamily: widget.dialogTitleFontFamily,
              ),
        ),
        content: ValueListenableBuilder<List<String>>(
          valueListenable: temp,
          builder: (_, selected, __) => SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = selected.contains(item);
                return CheckboxListTile(
                  value: isSelected,
                  activeColor: widget.checkboxActiveColor,
                  checkColor: AppColors.whiteColor,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    item,
                    style:
                        widget.dialogItemStyle ??
                        TextStyle(
                          fontSize: widget.dialogItemFontSize.sp,
                          color: widget.dialogItemColor,
                          fontWeight: widget.dialogItemFontWeight,
                          fontFamily: widget.dialogItemFontFamily,
                        ),
                  ),
                  onChanged: (checked) {
                    final updated = List<String>.from(temp.value);
                    if (checked == true) {
                      updated.add(item);
                    } else {
                      updated.remove(item);
                    }
                    temp.value = updated;
                  },
                );
              },
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textColor3, fontSize: 14.sp),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.checkboxActiveColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () {
              widget.controller.value = List<String>.from(temp.value);
              if (widget.onChanged != null)
                widget.onChanged!(widget.controller.value);
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: TextStyle(color: AppColors.whiteColor, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _getLeading(Color color) {
    return widget.leadingWidget ??
        (widget.leadingIcon.isNotEmpty
            ? _buildAsset(
                widget.leadingIcon,
                widget.leadingIconWidth,
                widget.leadingIconHeight,
                widget.useLeadingColor,
                widget.leadingColor ?? color,
              )
            : null);
  }

  Widget _getTrailing(Color color) {
    return widget.trailingWidget ??
        (widget.trailingIcon.isNotEmpty
            ? _buildAsset(
                widget.trailingIcon,
                widget.trailingIconWidth,
                widget.trailingIconHeight,
                widget.useTrailingColor,
                widget.trailingColor ?? color,
              )
            : Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 24.sp,
                color: color,
              ));
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
