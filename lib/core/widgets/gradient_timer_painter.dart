import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

/// A Stateless circular gauge that displays progress with a premium gradient.
/// Designed for high-frequency updates (e.g., a 4s breathing cycle).
class GradientTimerGauge extends StatelessWidget {
  final double progress; // Expects 1.0 (full) down to 0.0 (empty)
  final double size;

  const GradientTimerGauge({
    super.key,
    required this.progress,
    this.size = 245,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Outer Decorative Ring (Thin Gold Line matching the picture) ──
          Container(
            width: size.r,
            height: size.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFC4B65D).withAlpha(230),
                width: 1.2.r, // Sharp thin line like the mockup
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC4B65D).withAlpha(128),
                  blurRadius: 80,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),

          // ── Syncfusion Radial Gauge ──────────────────────────────────────────
          SizedBox(
            width: size.r - 2.r, // Sitting perfectly inside the gold border
            height: size.r - 2.r,
            child: SfRadialGauge(
              enableLoadingAnimation: false,
              axes: [
                RadialAxis(
                  minimum: 0,
                  maximum: 1, // Normalized progress range
                  startAngle: 270, // Start from the top (12 o'clock)
                  endAngle: 270,
                  showLabels: false,
                  showTicks: false,
                  radiusFactor: 1.0,
                  // ── Recessed Track Style (Updated to match the picture's depth) ──
                  axisLineStyle: AxisLineStyle(
                    thickness: 14.r,
                    color: const Color(
                      0xFF384636,
                    ), // Dark green recessed shadow color
                    thicknessUnit: GaugeSizeUnit.logicalPixel,
                  ),
                  annotations: [
                    // Center fill area with shadow to create depth shown in the picture
                    GaugeAnnotation(
                      positionFactor: 0.0,
                      angle: 90,
                      widget: Container(
                        width: size.r - 31.r, // Proportional to center area
                        height: size.r - 31.r,
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF5C6F59,
                          ), // Main green background
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(128),
                              blurRadius: 10,
                              offset: const Offset(
                                -2,
                                -2,
                              ), // Inner shadow effect
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  pointers: [
                    // The actual progress indicator (drains from 1.0 to 0.0)
                    RangePointer(
                      value: progress,
                      width: 14.r,
                      sizeUnit: GaugeSizeUnit.logicalPixel,
                      cornerStyle: CornerStyle.bothCurve,
                      enableAnimation: false,
                      gradient: const SweepGradient(
                        colors: [
                          Color(0x00AF935B), // transparent tail
                          Color(0x55AF935B),
                          Color(0xAAAF935B),
                          Color(0xFFAF935B),
                          Color(0xFFE9D19E), // bright leading head
                        ],
                        stops: [0.0, 0.2, 0.5, 0.8, 1.0],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
