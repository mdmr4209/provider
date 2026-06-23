import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/app_colors.dart';
import 'design_system.dart';

class AppTheme {
  // ── Shared Gradients ─────────────────────────────────────────────────────
  static const _goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryColor, // #AC823A
      AppColors.buttonColor1, // #D0B47D
      AppColors.primaryColor, // #AC823A
    ],
  );

  static const _deepGoldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.buttonColor1, AppColors.buttonColor],
  );

  static const _progressBarGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.buttonColor, AppColors.borderColor],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════════
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Segoe UI',
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    primaryColorDark: AppColors.defaultColor,
    hintColor: AppColors.hintTextColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,

    // ── Design System Extension ────────────────────────────────────────────
    extensions: [
      AppDesignSystem(
        // Gradients
        primaryGradient: _goldGradient,
        secondaryGradient: _goldGradient,
        deepGradient: _deepGoldGradient,
        progressBarGradient: _progressBarGradient,

        // Glass
        glassOpacity: 0.1,
        glassBorderOpacity: 0.15,

        // Card / Container tokens  (from buttonColor4 / buttonBorderColor4)
        cardFillColor: AppColors.buttonColor4, // #BA384737
        cardBorderColor: AppColors.buttonBorderColor4, // #66EBEBEB
        cardFillMuted: AppColors.buttonColor4.withAlpha(30),
        cardBorderMuted: AppColors.buttonBorderColor4.withAlpha(30),

        // Input
        inputFillColor: AppColors.coachColorFF21321E,
        inputBorderColor: AppColors.coachColorFF334B2F,
        inputShadowColor: AppColors.coachColorFF2E4429,
        inputFocusBorderColor: AppColors.iconColor, // #C9A84C
        // Tab Bar
        tabactiveThumbColor: AppColors.iconColor,
        tabInactiveThumbColor: AppColors.textColor.withAlpha(150),
        tabIndicatorColor: AppColors.iconColor,

        // Checkbox
        checkboxactiveThumbColor: AppColors.iconColor,
        checkboxInactiveThumbColor: AppColors.inputBorderColor,
        checkboxCheckColor: AppColors.backgroundColor,

        // Bottom Sheet
        bottomSheetBackground: AppColors.popupBackgroundColor, // #20341F
        bottomSheetDivider: AppColors.dividerColor.withAlpha(100),
        bottomSheetSelectedItem: AppColors.iconColor,

        // Upload / Chip
        uploadPillColor: AppColors.buttonColor3, // #434928
        addChipFillColor: AppColors.buttonColor4,
        addChipBorderColor: AppColors.buttonBorderColor4,

        // Celebration Badge
        badgeGlowColor: AppColors.iconColor.withAlpha(30),
        badgeSolidColor: AppColors.iconColor,

        // Status Bar
        statusBarColor: AppColors.colorFF111B10,
      ),
    ],

    // ── Color Scheme ───────────────────────────────────────────────────────
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
      primary: AppColors.primaryColor, // #AC823A
      onPrimary: AppColors.whiteColor, // #FFFFFF
      surface: AppColors.whiteColor,
      onSurface: AppColors.textColor, // #DAE0DA
      secondary: AppColors.defaultColor, // #22331F
      outline: AppColors.borderColor, // #F3D194
      error: AppColors.redAlphaColor, // #F44336
    ),

    // ── AppBar ─────────────────────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      scrolledUnderElevation: 0,
      surfaceTintColor: AppColors.backgroundColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: AppColors.textColor2,
      ), // #8CA08B muted icons
      titleTextStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
    ),

    // ── Text Theme ─────────────────────────────────────────────────────────
    //   Sizes aligned with coach folder actual usage:
    //   headlineLarge 24sp  → welcome/completion headings (Georgia)
    //   titleLarge    22sp  → page titles (Georgia)
    //   titleMedium   18sp  → appBar titles
    //   titleSmall    16sp  → button text (Proxima Nova via CustomButton)
    //   bodyLarge     14sp  → form field labels, descriptions
    //   bodyMedium    12sp  → step counter, completion text
    //   bodySmall     11sp  → error text, captions
    //   labelLarge    14sp  → input title labels
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 36.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      displayMedium: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      headlineLarge: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      titleLarge: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      titleMedium: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textColor,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: AppColors.textColor.withAlpha(200),
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: AppColors.textColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        color: AppColors.textColor.withAlpha(200),
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: AppColors.hintTextColor,
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
      ),
    ),

    // ── Tab Bar ─────────────────────────────────────────────────────────────
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.iconColor, // gold active
      unselectedLabelColor: AppColors.textColor.withAlpha(150),
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: AppColors.iconColor,
      labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
      ),
    ),

    // ── Chip ───────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.buttonColor4,
      disabledColor: AppColors.lightGrey,
      selectedColor: AppColors.primaryColor.withAlpha(51),
      secondarySelectedColor: AppColors.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      labelStyle: TextStyle(color: AppColors.textColor, fontSize: 12.sp),
      secondaryLabelStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 12.sp,
      ),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: AppColors.primaryColor.withAlpha(51)),
      ),
    ),

    // ── Slider ─────────────────────────────────────────────────────────────
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primaryColor,
      inactiveTrackColor: AppColors.primaryColor.withAlpha(51),
      thumbColor: AppColors.primaryColor,
      overlayColor: AppColors.primaryColor.withAlpha(32),
      valueIndicatorColor: AppColors.primaryColor,
      valueIndicatorTextStyle: TextStyle(color: AppColors.whiteColor),
    ),

    // ── Input Decoration ───────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.coachColorFF21321E,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: const BorderSide(color: AppColors.coachColorFF334B2F),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: const BorderSide(color: AppColors.coachColorFF334B2F),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(
          color: AppColors.iconColor,
          width: 1.5,
        ), // gold on focus
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: AppColors.redAlphaColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: AppColors.redAlphaColor, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: AppColors.inputBorderColor.withAlpha(50)),
      ),
      hintStyle: TextStyle(
        color: AppColors.hintTextColor, // #A9A8A8
        fontSize: 14.sp,
      ),
      labelStyle: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
    ),

    // ── Elevated Button ────────────────────────────────────────────────────
    //   CustomButton resolves from this for default colors
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor, // #AC823A
        foregroundColor: AppColors.whiteColor, // #FFFFFF
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        textStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w900,
          fontFamily: 'Proxima Nova',
        ),
      ),
    ),

    // ── Switch ─────────────────────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.iconColor;
        return AppColors.textColor;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.iconColor.withAlpha(80);
        }
        return AppColors.buttonColor4;
      }),
    ),

    // ── Dialog ─────────────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.defaultColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(color: AppColors.primaryColor.withAlpha(51), width: 1),
      ),
      titleTextStyle: TextStyle(
        color: AppColors.whiteColor,
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

    // ── Bottom Sheet ───────────────────────────────────────────────────────
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.popupBackgroundColor, // #20341F
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
    ),

    // ── Divider ────────────────────────────────────────────────────────────
    dividerTheme: DividerThemeData(
      color: AppColors.dividerColor.withAlpha(100),
      thickness: 1,
      space: 1,
    ),

    // ── Progress Indicator ─────────────────────────────────────────────────
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.iconColor, // gold spinner
      linearTrackColor: AppColors.iconColor.withAlpha(30),
    ),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME
  // ═══════════════════════════════════════════════════════════════════════════
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Segoe UI',
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.white38Color,
    scaffoldBackgroundColor: Colors.transparent,

    // ── Design System Extension ────────────────────────────────────────────
    extensions: [
      AppDesignSystem(
        // Gradients
        primaryGradient: _goldGradient,
        secondaryGradient: _goldGradient,
        deepGradient: _deepGoldGradient,
        progressBarGradient: _progressBarGradient,

        // Glass — slightly more opaque for dark mode
        glassOpacity: 0.15,
        glassBorderOpacity: 0.25,

        // Card / Container tokens
        cardFillColor: AppColors.buttonColor4,
        cardBorderColor: AppColors.buttonBorderColor4,
        cardFillMuted: AppColors.buttonColor4.withAlpha(30),
        cardBorderMuted: AppColors.buttonBorderColor4.withAlpha(30),

        // Input
        inputFillColor: AppColors.coachColorFF21321E,
        inputBorderColor: AppColors.coachColorFF334B2F,
        inputShadowColor: AppColors.coachColorFF2E4429,
        inputFocusBorderColor: AppColors.iconColor,

        // Tab Bar
        tabactiveThumbColor: AppColors.iconColor,
        tabInactiveThumbColor: AppColors.white38Color,
        tabIndicatorColor: AppColors.iconColor,

        // Checkbox
        checkboxactiveThumbColor: AppColors.iconColor,
        checkboxInactiveThumbColor: AppColors.white24Color,
        checkboxCheckColor: AppColors.backgroundColor,

        // Bottom Sheet
        bottomSheetBackground: AppColors.popupBackgroundColor,
        bottomSheetDivider: AppColors.white24Color,
        bottomSheetSelectedItem: AppColors.iconColor,

        // Upload / Chip
        uploadPillColor: AppColors.buttonColor3,
        addChipFillColor: AppColors.buttonColor4,
        addChipBorderColor: AppColors.buttonBorderColor4,

        // Celebration Badge
        badgeGlowColor: AppColors.iconColor.withAlpha(30),
        badgeSolidColor: AppColors.iconColor,

        // Status Bar
        statusBarColor: AppColors.colorFF111B10,
      ),
    ],

    // ── Color Scheme ───────────────────────────────────────────────────────
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.dark,
      primary: AppColors.primaryColor,
      onPrimary: AppColors.whiteColor,
      surface: AppColors.defaultColor, // #22331F
      onSurface: AppColors.whiteColor,
      secondary: AppColors.defaultColor,
      outline: AppColors.white24Color,
      error: AppColors.redAlphaColor,
    ),

    // ── AppBar ─────────────────────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      scrolledUnderElevation: 0,
      surfaceTintColor: AppColors.backgroundColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.whiteColor),
      titleTextStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
    ),

    // ── Text Theme ─────────────────────────────────────────────────────────
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 36.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      displayMedium: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 28.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      headlineLarge: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      titleLarge: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      titleMedium: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: AppColors.textColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textColor,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: AppColors.textColor.withAlpha(200),
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: AppColors.textColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: TextStyle(
        color: AppColors.textColor.withAlpha(200),
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: AppColors.white38Color,
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
      ),
    ),

    // ── Tab Bar ─────────────────────────────────────────────────────────────
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.iconColor,
      unselectedLabelColor: AppColors.white38Color,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: AppColors.iconColor,
      labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      unselectedLabelStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
      ),
    ),

    // ── Chip ───────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.buttonColor4,
      disabledColor: AppColors.white12Color,
      selectedColor: AppColors.primaryColor.withAlpha(102),
      secondarySelectedColor: AppColors.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      labelStyle: TextStyle(color: AppColors.whiteColor, fontSize: 12.sp),
      secondaryLabelStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 12.sp,
      ),
      brightness: Brightness.dark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: AppColors.primaryColor.withAlpha(102)),
      ),
    ),

    // ── Slider ─────────────────────────────────────────────────────────────
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primaryColor,
      inactiveTrackColor: AppColors.primaryColor.withAlpha(51),
      thumbColor: AppColors.primaryColor,
      overlayColor: AppColors.primaryColor.withAlpha(32),
      valueIndicatorColor: AppColors.primaryColor,
      valueIndicatorTextStyle: TextStyle(color: AppColors.whiteColor),
    ),

    // ── Input Decoration ───────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.coachColorFF21321E,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: const BorderSide(color: AppColors.coachColorFF334B2F),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: const BorderSide(color: AppColors.coachColorFF334B2F),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: AppColors.iconColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: AppColors.redAlphaColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: AppColors.redAlphaColor, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24.r),
        borderSide: BorderSide(color: AppColors.inputBorderColor.withAlpha(50)),
      ),
      hintStyle: TextStyle(color: AppColors.white38Color, fontSize: 14.sp),
      labelStyle: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
    ),

    // ── Elevated Button ────────────────────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        textStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w900,
          fontFamily: 'Proxima Nova',
        ),
      ),
    ),

    // ── Switch ─────────────────────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.iconColor;
        return AppColors.textColor;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.iconColor.withAlpha(80);
        }
        return AppColors.buttonColor4;
      }),
    ),

    // ── Dialog ─────────────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.popupBackgroundColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
        side: BorderSide(
          color: AppColors.primaryColor.withAlpha(102),
          width: 1.5,
        ),
      ),
      titleTextStyle: TextStyle(
        color: AppColors.whiteColor,
        fontSize: 22.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Georgia',
      ),
      contentTextStyle: TextStyle(
        color: AppColors.whiteColor.withAlpha(217),
        fontSize: 15.sp,
        fontFamily: 'Segoe UI',
      ),
    ),

    // ── Bottom Sheet ───────────────────────────────────────────────────────
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.popupBackgroundColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
    ),

    // ── Divider ────────────────────────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: AppColors.white24Color,
      thickness: 1,
      space: 1,
    ),

    // ── Progress Indicator ─────────────────────────────────────────────────
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.iconColor,
      linearTrackColor: AppColors.iconColor.withAlpha(30),
    ),
  );
}
