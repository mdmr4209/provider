import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../res/colors/app_color.dart';

class CustomDropdown extends StatefulWidget {
  // controller must be ValueNotifier<String> (single) or ValueNotifier<List<String>> (multi)
  final ValueNotifier<dynamic> controller;
  final List<String> items;
  final String title;

  // Title Text
  final double? titlePaddingBottom;
  final TextStyle? titleStyle;
  final Color? titleColor;
  final double? titleFontSize;
  final FontWeight? titleFontWeight;
  final String? titleFontFamily;
  final double? titleLetterSpacing;
  final EdgeInsets? titlePadding;

  // Container
  final double? height;
  final double? width;
  final double? containerPaddingHorizontal;
  final double? containerPaddingVertical;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double borderRadius;
  final bool shadow;
  final Color? shadowColor;
  final double shadowBlur;
  final Offset shadowOffset;

  // Hint
  final String? hintText;
  final TextStyle? hintStyle;
  final Color? hintColor;
  final double? hintFontSize;
  final FontWeight? hintFontWeight;
  final String? hintFontFamily;
  final double? hintLetterSpacing;

  // Selected text
  final TextStyle? selectedTextStyle;
  final Color? selectedTextColor;
  final double? selectedTextFontSize;
  final FontWeight? selectedTextFontWeight;
  final String? selectedTextFontFamily;

  // Dropdown icon
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;

  // Menu popup
  final Color? menuBackgroundColor;
  final double? menuElevation;

  // Menu item text
  final TextStyle? menuItemStyle;
  final Color? menuItemColor;
  final double? menuItemFontSize;
  final FontWeight? menuItemFontWeight;
  final String? menuItemFontFamily;

  // Multi-select
  final bool multiSelect;
  final bool useRawItems;

  // Dialog style
  final Color? dialogBackgroundColor;
  final TextStyle? dialogTitleStyle;
  final Color? dialogTitleColor;
  final double? dialogTitleFontSize;
  final FontWeight? dialogTitleFontWeight;
  final String? dialogTitleFontFamily;
  final double? dialogTitleLetterSpacing;
  final TextStyle? dialogItemStyle;
  final Color? dialogItemColor;
  final double? dialogItemFontSize;
  final FontWeight? dialogItemFontWeight;
  final String? dialogItemFontFamily;
  final Color? checkboxActiveColor;
  final double dialogRadius;

  // Initial values
  final String? initialSingleValue;
  final List<String>? initialMultiValues;

  const CustomDropdown({
    super.key,
    required this.controller,
    required this.items,
    required this.title,
    this.titlePaddingBottom = 0,
    this.titleStyle,
    this.titleColor = AppColor.defaultColor,
    this.titleFontSize = 12,
    this.titleFontWeight = FontWeight.w500,
    this.titleFontFamily = 'Inter',
    this.titleLetterSpacing,
    this.titlePadding,
    this.height,
    this.width,
    this.containerPaddingHorizontal,
    this.containerPaddingVertical,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius = 10,
    this.shadow = false,
    this.shadowColor,
    this.shadowBlur = 6,
    this.shadowOffset = const Offset(0, 3),
    this.hintText,
    this.hintStyle,
    this.hintColor,
    this.hintFontSize,
    this.hintFontWeight,
    this.hintFontFamily = 'Inter',
    this.hintLetterSpacing,
    this.selectedTextStyle,
    this.selectedTextColor,
    this.selectedTextFontSize,
    this.selectedTextFontWeight,
    this.selectedTextFontFamily = 'Inter',
    this.icon = Icons.keyboard_arrow_down_rounded,
    this.iconColor,
    this.iconSize,
    this.menuBackgroundColor,
    this.menuElevation,
    this.menuItemStyle,
    this.menuItemColor,
    this.menuItemFontSize,
    this.menuItemFontWeight,
    this.menuItemFontFamily = 'Inter',
    this.multiSelect = false,
    this.useRawItems = false,
    this.dialogBackgroundColor,
    this.dialogTitleStyle,
    this.dialogTitleColor,
    this.dialogTitleFontSize,
    this.dialogTitleFontWeight,
    this.dialogTitleFontFamily = 'Inter',
    this.dialogTitleLetterSpacing,
    this.dialogItemStyle,
    this.dialogItemColor,
    this.dialogItemFontSize,
    this.dialogItemFontWeight,
    this.dialogItemFontFamily = 'Inter',
    this.checkboxActiveColor,
    this.dialogRadius = 12,
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
    if (!widget.multiSelect &&
        widget.initialSingleValue != null &&
        widget.controller.value is String) {
      if ((widget.controller.value as String).isEmpty) {
        widget.controller.value = widget.initialSingleValue!;
      }
    }
    if (widget.multiSelect &&
        widget.initialMultiValues != null &&
        widget.controller.value is List<String>) {
      if ((widget.controller.value as List<String>).isEmpty) {
        widget.controller.value = List<String>.from(widget.initialMultiValues!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (_, __, ___) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          SizedBox(height: 6.h),
          _buildContainer(context),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: widget.titlePadding ??
          EdgeInsets.only(bottom: (widget.titlePaddingBottom ?? 0).h),
      child: Text(
        widget.title,
        style: widget.titleStyle ??
            TextStyle(
              color: widget.titleColor ?? Colors.black,
              fontSize: (widget.titleFontSize ?? 14).sp,
              fontWeight: widget.titleFontWeight ?? FontWeight.w500,
              fontFamily: widget.titleFontFamily,
              letterSpacing: widget.titleLetterSpacing,
            ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 46.h,
      padding: EdgeInsets.symmetric(
        horizontal: widget.containerPaddingHorizontal ?? 12.w,
        vertical: widget.containerPaddingVertical ?? 0,
      ),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: widget.borderColor ?? Colors.grey.shade300,
          width: widget.borderWidth ?? 1,
        ),
        boxShadow: widget.shadow
            ? [
                BoxShadow(
                  color: widget.shadowColor ?? Colors.black12,
                  blurRadius: widget.shadowBlur,
                  offset: widget.shadowOffset,
                ),
              ]
            : [
                BoxShadow(
                  color: (widget.shadowColor ?? AppColor.boxShadowColor)
                      .withAlpha(27),
                  blurRadius: 4,
                ),
              ],
      ),
      child: widget.multiSelect
          ? _buildMultiSelect(context)
          : _buildSingleSelect(),
    );
  }

  Widget _buildSingleSelect() {
    final String current = widget.controller.value as String;
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: current.isEmpty ? null : current,
        icon: Icon(widget.icon,
            color: widget.iconColor ?? Colors.black,
            size: widget.iconSize ?? 22.sp),
        dropdownColor: widget.menuBackgroundColor ?? Colors.white,
        elevation: widget.menuElevation?.toInt() ?? 4,
        style: widget.selectedTextStyle ??
            TextStyle(
              fontSize: (widget.selectedTextFontSize ?? 14).sp,
              color: widget.selectedTextColor ?? Colors.black87,
              fontWeight:
                  widget.selectedTextFontWeight ?? FontWeight.w500,
              fontFamily: widget.selectedTextFontFamily,
            ),
        hint: Text(
          widget.hintText ?? 'Select',
          style: widget.hintStyle ??
              TextStyle(
                fontSize: (widget.hintFontSize ?? 14).sp,
                color: widget.hintColor ?? Colors.grey.shade600,
                fontWeight: widget.hintFontWeight ?? FontWeight.w400,
                fontFamily: widget.hintFontFamily,
              ),
        ),
        onChanged: (value) {
          widget.controller.value = value ?? '';
        },
        items: widget.items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: widget.menuItemStyle ??
                      TextStyle(
                        fontSize: (widget.menuItemFontSize ?? 14).sp,
                        color: widget.menuItemColor ?? Colors.black87,
                        fontWeight:
                            widget.menuItemFontWeight ?? FontWeight.w400,
                        fontFamily: widget.menuItemFontFamily,
                      ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildMultiSelect(BuildContext context) {
    final List<String> selected =
        List<String>.from(widget.controller.value as List<String>);
    return InkWell(
      onTap: () => _showMultiSelectDialog(context),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                selected.isEmpty
                    ? widget.hintText ?? 'Select option'
                    : selected.join(', '),
                style: selected.isEmpty
                    ? (widget.hintStyle ??
                        TextStyle(
                          fontSize: (widget.hintFontSize ?? 14).sp,
                          color: widget.hintColor ?? Colors.grey.shade600,
                          fontWeight:
                              widget.hintFontWeight ?? FontWeight.w400,
                          fontFamily: widget.hintFontFamily,
                        ))
                    : (widget.selectedTextStyle ??
                        TextStyle(
                          fontSize: (widget.selectedTextFontSize ?? 14).sp,
                          color:
                              widget.selectedTextColor ?? Colors.black87,
                          fontWeight: widget.selectedTextFontWeight ??
                              FontWeight.w500,
                          fontFamily: widget.selectedTextFontFamily,
                        )),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Icon(widget.icon,
              color: widget.iconColor ?? Colors.black,
              size: widget.iconSize ?? 22.sp),
        ],
      ),
    );
  }

  Future<void> _showMultiSelectDialog(BuildContext context) async {
    final List<String> current =
        List<String>.from(widget.controller.value as List<String>);
    final temp = ValueNotifier<List<String>>(List.from(current));

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: widget.dialogBackgroundColor ?? Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.dialogRadius.r)),
        title: Text(
          widget.title,
          style: widget.dialogTitleStyle ??
              TextStyle(
                color: widget.dialogTitleColor ?? Colors.black,
                fontSize: (widget.dialogTitleFontSize ?? 16).sp,
                fontWeight:
                    widget.dialogTitleFontWeight ?? FontWeight.bold,
                fontFamily: widget.dialogTitleFontFamily,
              ),
        ),
        content: ValueListenableBuilder<List<String>>(
          valueListenable: temp,
          builder: (_, selected, __) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.items.map((item) {
                return CheckboxListTile(
                  value: selected.contains(item),
                  activeColor: widget.checkboxActiveColor ?? Colors.blue,
                  title: Text(
                    item,
                    style: widget.dialogItemStyle ??
                        TextStyle(
                          fontSize: (widget.dialogItemFontSize ?? 14).sp,
                          color:
                              widget.dialogItemColor ?? Colors.black87,
                          fontWeight: widget.dialogItemFontWeight ??
                              FontWeight.w400,
                          fontFamily: widget.dialogItemFontFamily,
                        ),
                  ),
                  onChanged: (checked) {
                    final updated = List<String>.from(selected);
                    checked == true
                        ? updated.add(item)
                        : updated.remove(item);
                    temp.value = updated;
                  },
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.controller.value = List<String>.from(temp.value);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
