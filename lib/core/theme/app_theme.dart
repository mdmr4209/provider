import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import 'design_system.dart';

class AppTheme {
  // Common Gradients for the Design System
  static const _goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryColor,
      AppColors.buttonColor1,
      AppColors.primaryColor,
    ],
  );

  static const _deepGoldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFD0B47D),
      Color(0xFFAC823A),
    ],
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Segoe UI',
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    primaryColorDark: AppColors.defaultColor,
    hintColor: AppColors.hintTextColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    extensions: [
      AppDesignSystem(
        primaryGradient: _goldGradient,
        secondaryGradient: _goldGradient,
        deepGradient: _deepGoldGradient,
        glassOpacity: 0.1,
        glassBorderOpacity: 0.15,
      ),
    ],
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
      primary: AppColors.primaryColor,
      onPrimary: AppColors.whiteColor,
      surface: AppColors.whiteColor,
      onSurface: AppColors.textColor,
      secondary: AppColors.defaultColor,
      outline: AppColors.borderColor,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.blackColor),
      titleTextStyle: TextStyle(
        color: AppColors.blackColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: AppColors.textColor, fontSize: 36.sp, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: AppColors.textColor, fontSize: 28.sp, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: AppColors.textColor, fontSize: 24.sp, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: AppColors.textColor, fontSize: 22.sp, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(color: AppColors.textColor, fontSize: 18.sp, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: AppColors.textColor, fontSize: 16.sp, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
      bodyMedium: TextStyle(color: AppColors.textColor, fontSize: 12.sp),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: AppColors.hintTextColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: AppColors.primaryColor,
      labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.whiteColor,
      disabledColor: AppColors.lightGrey,
      selectedColor: AppColors.primaryColor.withAlpha(51),
      secondarySelectedColor: AppColors.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      labelStyle: TextStyle(color: AppColors.blackColor, fontSize: 12.sp),
      secondaryLabelStyle: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: AppColors.primaryColor.withAlpha(51)),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primaryColor,
      inactiveTrackColor: AppColors.primaryColor.withAlpha(51),
      thumbColor: AppColors.primaryColor,
      overlayColor: AppColors.primaryColor.withAlpha(32),
      valueIndicatorColor: AppColors.primaryColor,
      valueIndicatorTextStyle: const TextStyle(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide:  BorderSide(color: Colors.transparent)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide:  BorderSide(color: Colors.transparent)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: Colors.transparent, width: 2.r)),
      hintStyle: const TextStyle(color: AppColors.hintTextColor),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.defaultColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(color: AppColors.primaryColor.withAlpha(51), width: 1),
      ),
      titleTextStyle: TextStyle(
        color: AppColors.textColor,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      contentTextStyle: TextStyle(
        color: AppColors.textColor.withAlpha(217),
        fontSize: 13.sp,
        fontFamily: 'Segoe UI',
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.whiteColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Segoe UI',
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    hintColor: Colors.white38,
    scaffoldBackgroundColor: Colors.transparent,
    extensions: [
      AppDesignSystem(
        primaryGradient: _goldGradient,
        secondaryGradient: _goldGradient,
        deepGradient: _deepGoldGradient,
        glassOpacity: 0.15,
        glassBorderOpacity: 0.25,
      ),
    ],
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.dark,
      primary: AppColors.primaryColor,
      onPrimary: AppColors.whiteColor,
      surface: const Color(0xFF1E1E1E),
      onSurface: AppColors.whiteColor,
      secondary: AppColors.defaultColor,
      outline: Colors.white24,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16.sp),
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 14.sp),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primaryColor,
      unselectedLabelColor: Colors.white38,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: AppColors.primaryColor,
      labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF2C2C2C),
      disabledColor: Colors.white12,
      selectedColor: AppColors.primaryColor.withAlpha(102),
      secondarySelectedColor: AppColors.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      labelStyle: TextStyle(color: Colors.white, fontSize: 12.sp),
      secondaryLabelStyle: TextStyle(color: Colors.white, fontSize: 12.sp),
      brightness: Brightness.dark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: AppColors.primaryColor.withAlpha(102)),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primaryColor,
      inactiveTrackColor: AppColors.primaryColor.withAlpha(51),
      thumbColor: AppColors.primaryColor,
      overlayColor: AppColors.primaryColor.withAlpha(32),
      valueIndicatorColor: AppColors.primaryColor,
      valueIndicatorTextStyle: const TextStyle(color: Colors.white),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C).withAlpha(200),
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: Colors.white24)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: Colors.white24)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.primaryColor, width: 2.r)),
      hintStyle: const TextStyle(color: Colors.white38),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF20341F),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(color: AppColors.primaryColor.withAlpha(102), width: 1.5),
      ),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      contentTextStyle: TextStyle(
        color: Colors.white.withAlpha(217),
        fontSize: 15.sp,
        fontFamily: 'Segoe UI',
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: const Color(0xFF20341F),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
    ),
  );
}
