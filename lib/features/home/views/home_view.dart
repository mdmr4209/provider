import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../core/widgets/glass_widget.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      imagePath: AppAssets.bgHome,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor:
              Colors.transparent, // Background handled by BackgroundWidget
          body: Consumer<HomeController>(
            builder: (context, home, _) {
              if (home.isLoading || home.dashboardData.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF3D194)),
                );
              }

              final data = home.dashboardData['data'] ?? {};
              final user = data['user'] ?? {};
              final timer = data['timer'] ?? {};
              final wisdom = data['dailyWisdom'] ?? {};
              final journal = data['journal'] ?? {};

              return SafeArea(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  children: [
                    SizedBox(height: 10.h),
                    // ── Header ───────────────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "WELCOME BACK",
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontFamily: 'Georgia',
                                    color: AppColors.whiteColor,
                                  ),
                            ),
                            Text(
                              "${user['name'] ?? 'Jonathan'} 👋",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontFamily: 'Georgia',
                                    color: AppColors.whiteColor,
                                  ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {},
                          child: SvgPicture.asset(
                            AppAssets.notify,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFFF3D194),
                              BlendMode.srcIn,
                            ),
                            width: 28.r,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // ── Circular Timer ───────────────────────────────────────────
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer ambient glow
                          Container(
                            width: 240.r,
                            height: 240.r,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFFCDC175).withOpacity(0.5),
                                width: 1.r,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFCDC175,
                                  ).withOpacity(0.50),
                                  blurRadius: 80,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                          ),

                          // Syncfusion Radial Gauge
                          SizedBox(
                            width: 245.r,
                            height: 245.r,
                            child: SfRadialGauge(
                              axes: [
                                RadialAxis(
                                  minimum: 0,
                                  maximum: 100,
                                  startAngle: 270,
                                  endAngle: 270,
                                  showLabels: false,
                                  showTicks: false,
                                  axisLineStyle: AxisLineStyle(
                                    thickness: 14.r,
                                    color: const Color(0xFF41503C),
                                    thicknessUnit: GaugeSizeUnit.logicalPixel,
                                  ),
                                  pointers: [
                                    RangePointer(
                                      value:
                                          ((timer['progress'] as num?)
                                                  ?.toDouble() ??
                                              0.8) *
                                          100,
                                      width: 14.r,
                                      sizeUnit: GaugeSizeUnit.logicalPixel,
                                      cornerStyle: CornerStyle.bothCurve,
                                      gradient: const SweepGradient(
                                        colors: [
                                          // still transparent
                                          Color(
                                            0x55E6DBC9,
                                          ), // faint cream starts
                                          Color(
                                            0xAAE6DBC9,
                                          ), // faint cream starts
                                          Color(0xAAE6DBC9), // mid cream
                                          Color(0xFFE6DBC9), // mid cream
                                          Color(0xFFE6DBC9), // full cream
                                          Color(0xFFFFFFFF), // bright white tip
                                        ],
                                        stops: [
                                          0.0,
                                          0.35,
                                          0.55,
                                          0.72,
                                          0.88,
                                          1.0,
                                        ],
                                      ),
                                    ),
                                  ],
                                  // Decorative gold ring
                                  annotations: [
                                    GaugeAnnotation(
                                      widget: Container(
                                        width: 200.r,
                                        height: 200.r,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFFFEEF8E),
                                            width: 1.r,
                                          ),
                                          color: const Color(0xFF44523A),
                                        ),
                                      ),
                                      angle: 90,
                                      positionFactor: 0.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Text content
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                user['status'] ?? "YOU ARE\nSTRONG ✨",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontFamily: 'Georgia',
                                      color: AppColors.whiteColor,
                                    ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "${timer['days'] ?? '32'}:${timer['hours'] ?? '00'}:${timer['mins'] ?? '11'}",
                                style: Theme.of(context).textTheme.displayLarge
                                    ?.copyWith(
                                      color: AppColors.secondaryColorLight,
                                    ),
                              ),
                              Text(
                                "Days    Hours    Mins",
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: AppColors.textColor),
                              ),
                              SizedBox(height: 18.h),
                              GestureDetector(
                                onTap: home.resetTimer,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFF62745E),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 0.58.r,
                                        color: const Color(0xFF8EA689),
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        13.95.r,
                                      ),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x3D000000),
                                        blurRadius: 6,
                                        offset: Offset(0, 6),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Reset ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color:
                                                  AppColors.secondaryColorLight,
                                            ),
                                      ),
                                      SvgPicture.asset(
                                        AppAssets.reset,
                                        height: 16.r,
                                        width: 16.r,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // ── Action Buttons ───────────────────────────────────────────
                    _buildActionButton(
                      context: context,
                      title: "HELP! I broke No Contact 💔",
                      color: const Color(0xFFB03030),
                      onTap: () => home.handleBreakNoContact(context),
                    ),
                    SizedBox(height: 16.h),
                    _buildActionButton(
                      context: context,
                      title: "I'm About to Relapse — HELP! 🚨",
                      color: const Color(0xFFC96630),
                      onTap: () => home.handleRelapsePrevention(context),
                    ),

                    SizedBox(height: 24.h),

                    // ── Daily Wisdom Card ────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.r),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.buttonColor1,
                            AppColors.primaryColor,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                AppAssets.feather,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.whiteColor,
                                  BlendMode.srcIn,
                                ),
                                width: 22.r,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "DAILY WISDOM",
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontFamily: 'Georgia',
                                      color: AppColors.blackColor,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "\"${wisdom['quote'] ?? ''}\"",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  fontFamily: 'Georgia',
                                  color: AppColors.blackColor,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            "— ${wisdom['author'] ?? ''}",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontFamily: 'Georgia',
                                  color: AppColors.whiteColor,
                                ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // ── Today's Journal Card ─────────────────────────────────────
                    GlassWidget(
                      width: double.infinity,
                      height: 72,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1F3A2F).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.journal,
                              colorFilter: ColorFilter.mode(
                                Colors.white.withOpacity(0.8),
                                BlendMode.srcIn,
                              ),
                              width: 26.r,
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Today's Journal",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Segoe UI',
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    journal['prompt'] ??
                                        "Tap to write about your day...",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 13,
                                      fontFamily: 'Segoe UI',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              journal['actionText'] ?? "Write →",
                              style: const TextStyle(
                                color: Color(0xFFF3D194),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Segoe UI',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 120.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58.h,
        width: double.infinity,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.95), color],
          ),

          border: Border.all(color: Colors.white.withOpacity(0.10)),

          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),

            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Stack(
          children: [
            /// TOP SHINE
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 24.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14.r),
                    topRight: Radius.circular(14.r),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            /// TEXT
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16.sp,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
