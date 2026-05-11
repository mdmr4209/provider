import 'package:flutter/material.dart';
import '../colors/app_color.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.light,
    primaryColor: AppColor.primaryColor,
    scaffoldBackgroundColor: AppColor.backgroundColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.primaryColor,
      brightness: Brightness.light,
      primary: AppColor.primaryColor,
      onPrimary: AppColor.whiteColor,
      surface: AppColor.whiteColor,
      onSurface: AppColor.textColor,
      secondary: AppColor.defaultColor,
      outline: AppColor.borderColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.whiteColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColor.blackColor),
      titleTextStyle: TextStyle(color: AppColor.blackColor, fontSize: 18, fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: AppColor.textColor, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: AppColor.textColor, fontSize: 28, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: AppColor.textColor, fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: AppColor.textColor, fontSize: 20, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: AppColor.textColor, fontSize: 16),
      bodyMedium: TextStyle(color: AppColor.textColor2, fontSize: 14),
      bodySmall: TextStyle(color: AppColor.textColor3, fontSize: 12),
    ),
    cardTheme: CardThemeData(
      color: AppColor.whiteColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: AppColor.whiteColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.whiteColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.primaryColor, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColor.hintTextColor),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: const TextStyle(color: AppColor.textColor),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(AppColor.whiteColor),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColor.textColor,
      contentTextStyle: const TextStyle(color: AppColor.whiteColor),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.dark,
    primaryColor: AppColor.primaryColor,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColor.primaryColor,
      brightness: Brightness.dark,
      primary: AppColor.primaryColor,
      onPrimary: AppColor.whiteColor,
      surface: const Color(0xFF1E1E1E),
      onSurface: AppColor.whiteColor,
      secondary: AppColor.defaultColor,
      outline: Colors.white24,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
      bodySmall: TextStyle(color: Colors.white54, fontSize: 12),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.primaryColor,
        foregroundColor: AppColor.whiteColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColor.primaryColor, width: 2),
      ),
      hintStyle: const TextStyle(color: Colors.white38),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: const TextStyle(color: Colors.white),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(const Color(0xFF2C2C2C)),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF323232),
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
