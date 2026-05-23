import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Segoe UI',
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.hintTextColor, // Global color for hints and obscure icons
    // Set to transparent so BackgroundWidget is visible
    scaffoldBackgroundColor: Colors.transparent,
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
      backgroundColor: Colors.transparent, // Made transparent
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
      bodySmall: TextStyle(color: AppColors.textColor, fontSize: 10.sp),
    ),
    cardTheme: CardThemeData(
      color: AppColors.whiteColor.withAlpha(200),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        minimumSize: Size(double.infinity, 50.sp),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: AppColors.inputBorderColor)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: AppColors.inputBorderColor)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide(color: AppColors.primaryColor, width: 2.r)),
      hintStyle: const TextStyle(color: AppColors.hintTextColor),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Segoe UI',
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    hintColor: Colors.white38, // Global color for hints and obscure icons in dark mode
    scaffoldBackgroundColor: Colors.transparent,
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
      bodySmall: TextStyle(color: Colors.white54, fontSize: 12.sp),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E).withAlpha(200),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
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
  );
}
