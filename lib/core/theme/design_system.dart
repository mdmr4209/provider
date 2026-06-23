import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

@immutable
class AppDesignSystem extends ThemeExtension<AppDesignSystem> {
  // ── Gradients ──────────────────────────────────────────────────────────────
  final LinearGradient primaryGradient;
  final LinearGradient secondaryGradient;
  final LinearGradient deepGradient;
  final LinearGradient progressBarGradient;

  // ── Glass / Blur ───────────────────────────────────────────────────────────
  final double glassBlur;
  final double glassOpacity;
  final double glassBorderOpacity;

  // ── Shadows ────────────────────────────────────────────────────────────────
  final BoxShadow softShadow;
  final BoxShadow deepShadow;

  // ── Animation ──────────────────────────────────────────────────────────────
  final Duration navDuration;

  // ── Card / Container Colors ────────────────────────────────────────────────
  final Color cardFillColor;
  final Color cardBorderColor;
  final Color cardFillMuted; // lower alpha variant for saved-item cards
  final Color cardBorderMuted; // lower alpha variant for saved-item borders

  // ── Coach Specific Panels ──────────────────────────────────────────────────
  final Color panelColor;
  final Color accentPanelColor;

  // ── Input Field Colors ─────────────────────────────────────────────────────
  final Color inputFillColor;
  final Color inputBorderColor;
  final Color inputFocusBorderColor;
  final Color inputShadowColor;
  final Color inputHintColor;

  // ── Tab Bar ────────────────────────────────────────────────────────────────
  final Color tabactiveThumbColor;
  final Color tabInactiveThumbColor;
  final Color tabIndicatorColor;

  // ── Checkbox ───────────────────────────────────────────────────────────────
  final Color checkboxactiveThumbColor;
  final Color checkboxInactiveThumbColor;
  final Color checkboxCheckColor;

  // ── Bottom Sheet ───────────────────────────────────────────────────────────
  final Color bottomSheetBackground;
  final Color bottomSheetDivider;
  final Color bottomSheetSelectedItem;

  // ── Upload / Chip Buttons ──────────────────────────────────────────────────
  final Color uploadPillColor;
  final Color addChipFillColor;
  final Color addChipBorderColor;

  // ── Celebration Badge ──────────────────────────────────────────────────────
  final Color badgeGlowColor;
  final Color badgeSolidColor;

  // ── Status Bar ─────────────────────────────────────────────────────────────
  final Color statusBarColor;

  const AppDesignSystem({
    // Gradients
    required this.primaryGradient,
    required this.secondaryGradient,
    required this.deepGradient,
    this.progressBarGradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [AppColors.buttonColor, AppColors.borderColor],
    ),

    // Glass
    this.glassBlur = 15.0,
    this.glassOpacity = 0.15,
    this.glassBorderOpacity = 0.2,

    // Shadows
    this.softShadow = const BoxShadow(
      color: AppColors.color14000000,
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
    this.deepShadow = const BoxShadow(
      color: AppColors.color3D000000,
      blurRadius: 20,
      offset: Offset(0, 10),
    ),

    // Animation
    this.navDuration = const Duration(milliseconds: 400),

    // Card / Container  (buttonColor4 + buttonBorderColor4 from AppColors)
    this.cardFillColor = AppColors.buttonColor4,
    this.cardBorderColor = AppColors.inputBorderColor,
    this.cardFillMuted = AppColors.color4D384737, // ~30 alpha
    this.cardBorderMuted = AppColors.color4DEBEBEB, // ~30 alpha
    // Coach Specific Panels
    this.panelColor = AppColors.colorFF2D3D2D,
    this.accentPanelColor = AppColors.colorFF1B2B1B,

    // Input
    this.inputFillColor = AppColors.colorFF21321E,
    this.inputBorderColor = AppColors.colorFF334B2F,
    this.inputFocusBorderColor = AppColors.iconColor,
    this.inputShadowColor = AppColors.colorFF2E4429,
    this.inputHintColor = AppColors.greyColor,

    // Tab Bar
    this.tabactiveThumbColor = AppColors.iconColor,
    this.tabInactiveThumbColor = AppColors.color96DAE0DA, // textColor alpha 150
    this.tabIndicatorColor = AppColors.iconColor,

    // Checkbox
    this.checkboxactiveThumbColor = AppColors.iconColor,
    this.checkboxInactiveThumbColor = AppColors.inputBorderColor,
    this.checkboxCheckColor = AppColors.backgroundColor,

    // Bottom Sheet
    this.bottomSheetBackground = AppColors.popupBackgroundColor,
    this.bottomSheetDivider = AppColors.color64C7C7C7,
    this.bottomSheetSelectedItem = AppColors.iconColor,

    // Upload / Chip
    this.uploadPillColor = AppColors.buttonColor3,
    this.addChipFillColor = AppColors.buttonColor4,
    this.addChipBorderColor = AppColors.inputBorderColor,

    // Celebration
    this.badgeGlowColor = AppColors.color1EC9A84C, // alpha ~30
    this.badgeSolidColor = AppColors.iconColor,

    // Status Bar
    this.statusBarColor = AppColors.colorFF111B10,
  });

  @override
  AppDesignSystem copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? secondaryGradient,
    LinearGradient? deepGradient,
    LinearGradient? progressBarGradient,
    double? glassBlur,
    double? glassOpacity,
    double? glassBorderOpacity,
    BoxShadow? softShadow,
    BoxShadow? deepShadow,
    Duration? navDuration,
    Color? cardFillColor,
    Color? cardBorderColor,
    Color? cardFillMuted,
    Color? cardBorderMuted,
    Color? panelColor,
    Color? accentPanelColor,
    Color? inputFillColor,
    Color? inputBorderColor,
    Color? inputFocusBorderColor,
    Color? inputShadowColor,
    Color? inputHintColor,
    Color? tabactiveThumbColor,
    Color? tabInactiveThumbColor,
    Color? tabIndicatorColor,
    Color? checkboxactiveThumbColor,
    Color? checkboxInactiveThumbColor,
    Color? checkboxCheckColor,
    Color? bottomSheetBackground,
    Color? bottomSheetDivider,
    Color? bottomSheetSelectedItem,
    Color? uploadPillColor,
    Color? addChipFillColor,
    Color? addChipBorderColor,
    Color? badgeGlowColor,
    Color? badgeSolidColor,
    Color? statusBarColor,
  }) {
    return AppDesignSystem(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      secondaryGradient: secondaryGradient ?? this.secondaryGradient,
      deepGradient: deepGradient ?? this.deepGradient,
      progressBarGradient: progressBarGradient ?? this.progressBarGradient,
      glassBlur: glassBlur ?? this.glassBlur,
      glassOpacity: glassOpacity ?? this.glassOpacity,
      glassBorderOpacity: glassBorderOpacity ?? this.glassBorderOpacity,
      softShadow: softShadow ?? this.softShadow,
      deepShadow: deepShadow ?? this.deepShadow,
      navDuration: navDuration ?? this.navDuration,
      cardFillColor: cardFillColor ?? this.cardFillColor,
      cardBorderColor: cardBorderColor ?? this.cardBorderColor,
      cardFillMuted: cardFillMuted ?? this.cardFillMuted,
      cardBorderMuted: cardBorderMuted ?? this.cardBorderMuted,
      panelColor: panelColor ?? this.panelColor,
      accentPanelColor: accentPanelColor ?? this.accentPanelColor,
      inputFillColor: inputFillColor ?? this.inputFillColor,
      inputBorderColor: inputBorderColor ?? this.inputBorderColor,
      inputFocusBorderColor:
          inputFocusBorderColor ?? this.inputFocusBorderColor,
      inputShadowColor: inputShadowColor ?? this.inputShadowColor,
      inputHintColor: inputHintColor ?? this.inputHintColor,
      tabactiveThumbColor: tabactiveThumbColor ?? this.tabactiveThumbColor,
      tabInactiveThumbColor:
          tabInactiveThumbColor ?? this.tabInactiveThumbColor,
      tabIndicatorColor: tabIndicatorColor ?? this.tabIndicatorColor,
      checkboxactiveThumbColor:
          checkboxactiveThumbColor ?? this.checkboxactiveThumbColor,
      checkboxInactiveThumbColor:
          checkboxInactiveThumbColor ?? this.checkboxInactiveThumbColor,
      checkboxCheckColor: checkboxCheckColor ?? this.checkboxCheckColor,
      bottomSheetBackground:
          bottomSheetBackground ?? this.bottomSheetBackground,
      bottomSheetDivider: bottomSheetDivider ?? this.bottomSheetDivider,
      bottomSheetSelectedItem:
          bottomSheetSelectedItem ?? this.bottomSheetSelectedItem,
      uploadPillColor: uploadPillColor ?? this.uploadPillColor,
      addChipFillColor: addChipFillColor ?? this.addChipFillColor,
      addChipBorderColor: addChipBorderColor ?? this.addChipBorderColor,
      badgeGlowColor: badgeGlowColor ?? this.badgeGlowColor,
      badgeSolidColor: badgeSolidColor ?? this.badgeSolidColor,
      statusBarColor: statusBarColor ?? this.statusBarColor,
    );
  }

  @override
  AppDesignSystem lerp(ThemeExtension<AppDesignSystem>? other, double t) {
    if (other is! AppDesignSystem) return this;
    return AppDesignSystem(
      // Gradients
      primaryGradient: LinearGradient.lerp(
        primaryGradient,
        other.primaryGradient,
        t,
      )!,
      secondaryGradient: LinearGradient.lerp(
        secondaryGradient,
        other.secondaryGradient,
        t,
      )!,
      deepGradient: LinearGradient.lerp(deepGradient, other.deepGradient, t)!,
      progressBarGradient: LinearGradient.lerp(
        progressBarGradient,
        other.progressBarGradient,
        t,
      )!,

      // Glass
      glassBlur: _lerpDouble(glassBlur, other.glassBlur, t),
      glassOpacity: _lerpDouble(glassOpacity, other.glassOpacity, t),
      glassBorderOpacity: _lerpDouble(
        glassBorderOpacity,
        other.glassBorderOpacity,
        t,
      ),

      // Shadows
      softShadow: BoxShadow.lerp(softShadow, other.softShadow, t)!,
      deepShadow: BoxShadow.lerp(deepShadow, other.deepShadow, t)!,

      // Animation
      navDuration: t < 0.5 ? navDuration : other.navDuration,

      // Colors
      cardFillColor: Color.lerp(cardFillColor, other.cardFillColor, t)!,
      cardBorderColor: Color.lerp(cardBorderColor, other.cardBorderColor, t)!,
      cardFillMuted: Color.lerp(cardFillMuted, other.cardFillMuted, t)!,
      cardBorderMuted: Color.lerp(cardBorderMuted, other.cardBorderMuted, t)!,
      panelColor: Color.lerp(panelColor, other.panelColor, t)!,
      accentPanelColor: Color.lerp(
        accentPanelColor,
        other.accentPanelColor,
        t,
      )!,
      inputFillColor: Color.lerp(inputFillColor, other.inputFillColor, t)!,
      inputBorderColor: Color.lerp(
        inputBorderColor,
        other.inputBorderColor,
        t,
      )!,
      inputFocusBorderColor: Color.lerp(
        inputFocusBorderColor,
        other.inputFocusBorderColor,
        t,
      )!,
      inputShadowColor: Color.lerp(
        inputShadowColor,
        other.inputShadowColor,
        t,
      )!,
      inputHintColor: Color.lerp(inputHintColor, other.inputHintColor, t)!,
      tabactiveThumbColor: Color.lerp(
        tabactiveThumbColor,
        other.tabactiveThumbColor,
        t,
      )!,
      tabInactiveThumbColor: Color.lerp(
        tabInactiveThumbColor,
        other.tabInactiveThumbColor,
        t,
      )!,
      tabIndicatorColor: Color.lerp(
        tabIndicatorColor,
        other.tabIndicatorColor,
        t,
      )!,
      checkboxactiveThumbColor: Color.lerp(
        checkboxactiveThumbColor,
        other.checkboxactiveThumbColor,
        t,
      )!,
      checkboxInactiveThumbColor: Color.lerp(
        checkboxInactiveThumbColor,
        other.checkboxInactiveThumbColor,
        t,
      )!,
      checkboxCheckColor: Color.lerp(
        checkboxCheckColor,
        other.checkboxCheckColor,
        t,
      )!,
      bottomSheetBackground: Color.lerp(
        bottomSheetBackground,
        other.bottomSheetBackground,
        t,
      )!,
      bottomSheetDivider: Color.lerp(
        bottomSheetDivider,
        other.bottomSheetDivider,
        t,
      )!,
      bottomSheetSelectedItem: Color.lerp(
        bottomSheetSelectedItem,
        other.bottomSheetSelectedItem,
        t,
      )!,
      uploadPillColor: Color.lerp(uploadPillColor, other.uploadPillColor, t)!,
      addChipFillColor: Color.lerp(
        addChipFillColor,
        other.addChipFillColor,
        t,
      )!,
      addChipBorderColor: Color.lerp(
        addChipBorderColor,
        other.addChipBorderColor,
        t,
      )!,
      badgeGlowColor: Color.lerp(badgeGlowColor, other.badgeGlowColor, t)!,
      badgeSolidColor: Color.lerp(badgeSolidColor, other.badgeSolidColor, t)!,
      statusBarColor: Color.lerp(statusBarColor, other.statusBarColor, t)!,
    );
  }

  static double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}
