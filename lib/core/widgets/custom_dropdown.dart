import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';

class CustomDropdown extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (!multiSelect && initialSingleValue != null) {
      if (controller.value == null || controller.value.toString().isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller.value == null || controller.value.toString().isEmpty) {
            controller.value = initialSingleValue;
          }
        });
      }
    }
    if (multiSelect && initialMultiValues != null) {
      if (controller.value == null || (controller.value as List).isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (controller.value == null || (controller.value as List).isEmpty) {
            controller.value = List<String>.from(initialMultiValues!);
          }
        });
      }
    }

    return Opacity(
      opacity: enabled ? 1.0 : 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle && title.isNotEmpty) _buildTitle(),
          ValueListenableBuilder(
            valueListenable: controller,
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
          titlePadding ??
          EdgeInsets.only(bottom: titlePaddingBottom.h),
      child: Text(
        title,
        style:
            titleStyle ??
            TextStyle(
              color: titleColor,
              fontSize: titleFontSize.sp,
              fontWeight: titleFontWeight,
              fontFamily: titleFontFamily,
              letterSpacing: titleLetterSpacing,
            ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context, dynamic currentValue) {
    return Container(
      width: width.w,
      height: height?.h ?? 50.h,
      padding: EdgeInsets.symmetric(
        horizontal: containerPaddingHorizontal.w,
        vertical: containerPaddingVertical.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: Border.all(
          color: borderColor,
          width: borderWidth.w,
        ),
        boxShadow: shadow
            ? [
                BoxShadow(
                  color:
                      shadowColor ??
                      AppColors.boxShadowColor,
                  blurRadius: shadowBlur,
                  offset: shadowOffset,
                ),
              ]
            : null,
      ),
      child: multiSelect
          ? _buildMultiSelectTrigger(context, currentValue)
          : _buildSingleSelect(currentValue),
    );
  }

  Widget _buildSingleSelect(dynamic currentValue) {
    final effectiveLeading = _getLeading(selectedTextColor);

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: (currentValue == null || currentValue.toString().isEmpty)
            ? null
            : currentValue.toString(),
        icon: _getTrailing(selectedTextColor),
        dropdownColor: menuBackgroundColor,
        elevation: menuElevation.toInt(),
        menuMaxHeight: menuMaxHeight?.h,
        borderRadius: BorderRadius.circular(borderRadius.r),
        style:
            selectedTextStyle ??
            TextStyle(
              fontSize: selectedTextFontSize.sp,
              color: selectedTextColor,
              fontWeight: selectedTextFontWeight,
              fontFamily: selectedTextFontFamily,
            ),
        hint: Row(
          children: [
            if (effectiveLeading != null)
              Padding(padding: leadingPadding, child: effectiveLeading),
            Expanded(
              child: Text(
                hintText,
                style:
                    hintStyle ??
                    TextStyle(
                      fontSize: hintFontSize.sp,
                      color: hintColor,
                      fontWeight: hintFontWeight,
                      fontFamily: hintFontFamily,
                    ),
              ),
            ),
          ],
        ),
        selectedItemBuilder: (context) {
          return items.map((String item) {
            return Row(
              children: [
                if (effectiveLeading != null)
                  Padding(
                    padding: leadingPadding,
                    child: effectiveLeading,
                  ),
                Expanded(
                  child: Text(
                    item,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        selectedTextStyle ??
                        TextStyle(
                          fontSize: selectedTextFontSize.sp,
                          color: selectedTextColor,
                          fontWeight: selectedTextFontWeight,
                          fontFamily: selectedTextFontFamily,
                        ),
                  ),
                ),
              ],
            );
          }).toList();
        },
        onChanged: enabled
            ? (value) {
                controller.value = value;
                if (onChanged != null) onChanged!(value);
              }
            : null,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style:
                  menuItemStyle ??
                  TextStyle(
                    fontSize: menuItemFontSize.sp,
                    color: menuItemColor,
                    fontWeight: menuItemFontWeight,
                    fontFamily: menuItemFontFamily,
                  ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMultiSelectTrigger(BuildContext context, dynamic currentValue) {
    final List<String> selected = List<String>.from(currentValue ?? []);
    final effectiveLeading = _getLeading(selectedTextColor);

    return InkWell(
      onTap: enabled ? () => _showMultiSelectDialog(context) : null,
      child: Row(
        children: [
          if (effectiveLeading != null)
            Padding(padding: leadingPadding, child: effectiveLeading),
          Expanded(
            child: Text(
              selected.isEmpty ? hintText : selected.join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: selected.isEmpty
                  ? (hintStyle ??
                        TextStyle(
                          fontSize: hintFontSize.sp,
                          color: hintColor,
                          fontWeight: hintFontWeight,
                          fontFamily: hintFontFamily,
                        ))
                  : (selectedTextStyle ??
                        TextStyle(
                          fontSize: selectedTextFontSize.sp,
                          color: selectedTextColor,
                          fontWeight: selectedTextFontWeight,
                          fontFamily: selectedTextFontFamily,
                        )),
            ),
          ),
          Padding(
            padding: trailingPadding,
            child: _getTrailing(
              selected.isEmpty ? hintColor : selectedTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMultiSelectDialog(BuildContext context) async {
    final List<String> current = List<String>.from(
      controller.value ?? [],
    );
    final temp = ValueNotifier<List<String>>(List.from(current));

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: dialogBackgroundColor ?? backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dialogRadius.r),
        ),
        title: Text(
          dialogTitle,
          style:
              dialogTitleStyle ??
              TextStyle(
                color: dialogTitleColor,
                fontSize: dialogTitleFontSize.sp,
                fontWeight: dialogTitleFontWeight,
                fontFamily: dialogTitleFontFamily,
              ),
        ),
        content: ValueListenableBuilder<List<String>>(
          valueListenable: temp,
          builder: (_, selected, __) => SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = selected.contains(item);
                return CheckboxListTile(
                  value: isSelected,
                  activeColor: checkboxActiveColor,
                  checkColor: AppColors.whiteColor,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    item,
                    style:
                        dialogItemStyle ??
                        TextStyle(
                          fontSize: dialogItemFontSize.sp,
                          color: dialogItemColor,
                          fontWeight: dialogItemFontWeight,
                          fontFamily: dialogItemFontFamily,
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
              backgroundColor: checkboxActiveColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () {
              controller.value = List<String>.from(temp.value);
              if (onChanged != null)
                onChanged!(controller.value);
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
    return leadingWidget ??
        (leadingIcon.isNotEmpty
            ? _buildAsset(
                leadingIcon,
                leadingIconWidth,
                leadingIconHeight,
                useLeadingColor,
                leadingColor ?? color,
              )
            : null);
  }

  Widget _getTrailing(Color color) {
    return trailingWidget ??
        (trailingIcon.isNotEmpty
            ? _buildAsset(
                trailingIcon,
                trailingIconWidth,
                trailingIconHeight,
                useTrailingColor,
                trailingColor ?? color,
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
