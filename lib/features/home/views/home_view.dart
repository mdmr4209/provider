import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../core/widgets/custom_loader.dart';
import '../../../core/widgets/glass_widget.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BackgroundWidget(
      imagePath: AppAssets.bgHome,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor:
              Colors.transparent, // Background handled by BackgroundWidget
          body: Consumer<HomeController>(
            builder: (context, home, _) {
              if (home.isLoading || home.dashboardModel == null) {
                return _buildShimmerHome(context);
              }

              final dashboard = home.dashboardModel!.data;
              final user = dashboard?.user;
              final timer = dashboard?.timer;
              final wisdom = dashboard?.dailyWisdom;
              final journal = dashboard?.journal;

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
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontFamily: 'Georgia',
                                color: AppColors.whiteColor,
                              ),
                            ),
                            Text(
                              "${user?.name ?? 'Jonathan'} 👋",
                              style: theme.textTheme.titleLarge?.copyWith(
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
                                      value: (timer?.progress ?? 0.8) * 100,
                                      width: 14.r,
                                      sizeUnit: GaugeSizeUnit.logicalPixel,
                                      cornerStyle: CornerStyle.bothCurve,
                                      gradient: const SweepGradient(
                                        colors: [
                                          Color(0x55E6DBC9),
                                          Color(0xAAE6DBC9),
                                          Color(0xAAE6DBC9),
                                          Color(0xFFE6DBC9),
                                          Color(0xFFE6DBC9),
                                          Color(0xFFFFFFFF),
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
                                user?.status ?? "YOU ARE\nSTRONG ✨",
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontFamily: 'Georgia',
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "${timer?.days ?? '32'}:${timer?.hours?.toString().padLeft(2, '0') ?? '00'}:${timer?.mins?.toString().padLeft(2, '0') ?? '11'}",
                                style: theme.textTheme.displayLarge?.copyWith(
                                  color: AppColors.secondaryColorLight,
                                ),
                              ),
                              Text(
                                "Days    Hours    Mins",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: AppColors.textColor,
                                ),
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
                                        style: theme.textTheme.bodyMedium
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
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontFamily: 'Georgia',
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "\"${wisdom?.quote ?? ''}\"",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontFamily: 'Georgia',
                              color: AppColors.blackColor,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            "— ${wisdom?.author ?? ''}",
                            style: theme.textTheme.bodyMedium?.copyWith(
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
                      height: 72.h,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15.r),
                        decoration: BoxDecoration(
                          color: AppColors.defaultColorAlpha2.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.whiteColor.withOpacity(0.08),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          spacing: 10.w,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppAssets.journal,
                                        colorFilter: ColorFilter.mode(
                                          Colors.white.withOpacity(0.8),
                                          BlendMode.srcIn,
                                        ),
                                        width: 22.30.w,
                                        height: 21.h,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        "Today's Journal",
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              fontFamily: 'Georgia',
                                              color: AppColors.textColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    journal?.prompt ??
                                        "Tap to write about your day...",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontFamily: 'Georgia',
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(4.r),
                              child: Text(
                                journal?.actionText ?? "Write →",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.iconColor,
                                ),
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

  Widget _buildShimmerHome(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
          SizedBox(height: 10.h),
          // Header Shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoader(width: 100.w, height: 16.h),
                  SizedBox(height: 8.h),
                  ShimmerLoader(width: 150.w, height: 24.h),
                ],
              ),
              ShimmerLoader(width: 28.r, height: 28.r, borderRadius: 14.r),
            ],
          ),
          SizedBox(height: 40.h),
          // Timer Shimmer
          Center(
            child: ShimmerLoader(
              width: 240.r,
              height: 240.r,
              borderRadius: 120.r,
            ),
          ),
          SizedBox(height: 60.h),
          // Buttons Shimmer
          ShimmerLoader(
            width: double.infinity,
            height: 58.h,
            borderRadius: 14.r,
          ),
          SizedBox(height: 16.h),
          ShimmerLoader(
            width: double.infinity,
            height: 58.h,
            borderRadius: 14.r,
          ),
          SizedBox(height: 24.h),
          // Wisdom Card Shimmer
          ShimmerLoader(
            width: double.infinity,
            height: 160.h,
            borderRadius: 16.r,
          ),
          SizedBox(height: 16.h),
          // Journal Card Shimmer
          ShimmerLoader(
            width: double.infinity,
            height: 72.h,
            borderRadius: 16.r,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
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
                style: theme.textTheme.bodyLarge?.copyWith(
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
