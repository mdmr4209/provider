import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../res/colors/app_color.dart';

class Dropdown extends StatelessWidget {
  final dynamic controller; // RxString for single, RxList<String> for multi
  final List<String> items; // Dynamic list of selectable items
  final String title; // Label above dropdown
  final String? hintText; // Optional hint for empty selection
  final double? height; // Optional height override
  final double? contentVertical; // Optional height override
  final double? contentHorizontal; // Optional height override
  final bool shadow; // Enable shadow
  final EdgeInsets? padding; // Optional padding
  final Color? menuBackgroundColor; // Popup menu background
  final Color? selectedTextColor; // Selected item text color
  final Color? menuTextColor; // Menu item text color
  final Color? iconColor; // Dropdown icon color
  final bool useRawItems; // If true, display items as-is (no .tr)
  final bool multiSelect; // Toggle single/multi-selection

  const Dropdown({
    super.key,
    required this.controller,
    required this.items,
    required this.title,
    this.hintText,
    this.height,
    this.contentVertical,
    this.contentHorizontal,
    this.shadow = true,
    this.padding,
    this.menuBackgroundColor,
    this.selectedTextColor,
    this.menuTextColor,
    this.iconColor,
    this.useRawItems = false,
    this.multiSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
            child: Text(
              title,
              style: TextStyle(
                color: AppColor.defaultColor,
                fontSize: 14.sp,
                fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Dropdown
          Container(
            height: height ?? 45.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColor.otpColor,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: shadow
                  ? [
                BoxShadow(
                  color: AppColor.boxShadowColor.withOpacity(0.1),
                  blurRadius: 4.r,
                  offset: Offset(0, 2.h),
                ),
              ]
                  : null,
              border: Border.all(color: AppColor.otpColor, width: 1.w),
            ),
            child: Directionality(
              textDirection: Get.locale?.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr,
              child: multiSelect
                  ? _buildMultiSelect(context)
                  : _buildSingleSelect(context),
            ),
          ),
        ],
      ),
    );
  }

  // Single Selection Dropdown
  Widget _buildSingleSelect(BuildContext context) {
    if (controller is! RxString) {
      throw Exception('Controller must be RxString for single selection');
    }
    return DropdownButtonFormField<String>(
      value: controller.value.isEmpty ? null : controller.value,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText ?? 'select_option'.tr,
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 14.sp,
          fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: contentHorizontal?.w??15.w,vertical: contentVertical?.h??11.w),
      ),
      dropdownColor: menuBackgroundColor ?? AppColor.otpColor,
      icon: Icon(
        Icons.arrow_drop_down,
        color: iconColor ?? AppColor.defaultColor,
        size: 24.sp,
      ),
      style: TextStyle(
        color: selectedTextColor ?? AppColor.textColor,
        fontSize: 14.sp,
        fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
        fontWeight: FontWeight.w500,
      ),
      onChanged: (String? newValue) {
        if (newValue != null) {
          controller.value = newValue;
        }
      },
      items: items.map<DropdownMenuItem<String>>((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            useRawItems ? item : item.tr,
            style: TextStyle(
              color: menuTextColor ?? AppColor.textColor,
              fontSize: 14.sp,
              fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
            ),
          ),
        );
      }).toList(),
    );
  }

  // Multi-Selection Dropdown
  Widget _buildMultiSelect(BuildContext context) {
    if (controller is! RxList<String>) {
      throw Exception('Controller must be RxList<String> for multi-selection');
    }
    final RxList<String> selectedItems = controller;
    return GestureDetector(
      onTap: () => _showMultiSelectDialog(context, selectedItems),
      child: InputDecorator(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: selectedItems.isEmpty ? (hintText ?? 'select_option'.tr) : '',
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14.sp,
            fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                selectedItems.isEmpty
                    ? hintText ?? 'select_option'.tr
                    : selectedItems.map((item) => useRawItems ? item : item.tr).join(', '),
                style: TextStyle(
                  color: selectedItems.isEmpty
                      ? Colors.grey[600]
                      : selectedTextColor ?? AppColor.textColor,
                  fontSize: 14.sp,
                  fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: iconColor ?? AppColor.defaultColor,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  // Dialog for Multi-Selection
  Future<void> _showMultiSelectDialog(BuildContext context, RxList<String> selectedItems) async {
    final RxList<String> tempSelected = RxList<String>(List.from(selectedItems));
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: menuBackgroundColor ?? AppColor.otpColor,
          title: Text(
            title,
            style: TextStyle(
              color: AppColor.defaultColor,
              fontSize: 16.sp,
              fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Obx(
                  () => Column(
                mainAxisSize: MainAxisSize.min,
                children: items.map((item) {
                  return CheckboxListTile(
                    title: Text(
                      useRawItems ? item : item.tr,
                      style: TextStyle(
                        color: menuTextColor ?? AppColor.textColor,
                        fontSize: 14.sp,
                        fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
                      ),
                    ),
                    value: tempSelected.contains(item),
                    onChanged: (bool? checked) {
                      if (checked == true) {
                        tempSelected.add(item);
                      } else {
                        tempSelected.remove(item);
                      }
                    },
                    activeColor: AppColor.defaultColor,
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'cancel'.tr,
                style: TextStyle(
                  color: AppColor.defaultColor,
                  fontSize: 14.sp,
                  fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                selectedItems.assignAll(tempSelected);
                Navigator.pop(context);
              },
              child: Text(
                'ok'.tr,
                style: TextStyle(
                  color: AppColor.defaultColor,
                  fontSize: 14.sp,
                  fontFamily: Get.locale?.languageCode == 'ar' ? 'ArabicFont' : 'Proxima Nova',
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}