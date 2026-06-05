import 'package:flutter/material.dart';

@immutable
class AppDesignSystem extends ThemeExtension<AppDesignSystem> {
  final LinearGradient primaryGradient;
  final LinearGradient secondaryGradient;
  final LinearGradient deepGradient;
  final double glassBlur;
  final double glassOpacity;
  final double glassBorderOpacity;
  final BoxShadow softShadow;
  final BoxShadow deepShadow;
  final Duration navDuration;

  const AppDesignSystem({
    required this.primaryGradient,
    required this.secondaryGradient,
    required this.deepGradient,
    this.glassBlur = 15.0,
    this.glassOpacity = 0.15,
    this.glassBorderOpacity = 0.2,
    this.navDuration = const Duration(milliseconds: 400),
    this.softShadow = const BoxShadow(
      color: Color(0x14000000),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
    this.deepShadow = const BoxShadow(
      color: Color(0x3D000000),
      blurRadius: 20,
      offset: Offset(0, 10),
    ),
  });

  @override
  AppDesignSystem copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? secondaryGradient,
    LinearGradient? deepGradient,
    double? glassBlur,
    double? glassOpacity,
    double? glassBorderOpacity,
    BoxShadow? softShadow,
    BoxShadow? deepShadow,
    Duration? navDuration,
  }) {
    return AppDesignSystem(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      secondaryGradient: secondaryGradient ?? this.secondaryGradient,
      deepGradient: deepGradient ?? this.deepGradient,
      glassBlur: glassBlur ?? this.glassBlur,
      glassOpacity: glassOpacity ?? this.glassOpacity,
      glassBorderOpacity: glassBorderOpacity ?? this.glassBorderOpacity,
      softShadow: softShadow ?? this.softShadow,
      deepShadow: deepShadow ?? this.deepShadow,
      navDuration: navDuration ?? this.navDuration,
    );
  }

  @override
  AppDesignSystem lerp(ThemeExtension<AppDesignSystem>? other, double t) {
    if (other is! AppDesignSystem) return this;
    return AppDesignSystem(
      primaryGradient: LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      secondaryGradient: LinearGradient.lerp(secondaryGradient, other.secondaryGradient, t)!,
      deepGradient: LinearGradient.lerp(deepGradient, other.deepGradient, t)!,
      glassBlur: lerpDouble(glassBlur, other.glassBlur, t)!,
      glassOpacity: lerpDouble(glassOpacity, other.glassOpacity, t)!,
      glassBorderOpacity: lerpDouble(glassBorderOpacity, other.glassBorderOpacity, t)!,
      softShadow: BoxShadow.lerp(softShadow, other.softShadow, t)!,
      deepShadow: BoxShadow.lerp(deepShadow, other.deepShadow, t)!,
      navDuration: t < 0.5 ? navDuration : other.navDuration,
    );
  }

  double? lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    return (a ?? 0.0) + ((b ?? 0.0) - (a ?? 0.0)) * t;
  }
}
