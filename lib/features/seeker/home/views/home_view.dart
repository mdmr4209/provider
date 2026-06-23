import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/navigation_service.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../../../../core/widgets/glass_widget.dart';
import '../../../../routes/app_router.dart';
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
          backgroundColor: Colors.transparent,
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

              return Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () => home.fetchDashboardData(isRefresh: true),
                    color: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    strokeWidth: 0,
                    elevation: 0,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      slivers: [
                        // ── Sliver App Bar (Header) ──────────────────────────────────────────
                        SliverAppBar(
                          // backgroundColor: Colors.transparent,
                          elevation: 0,
                          pinned: false,
                          floating: true,
                          expandedHeight: 50.h,
                          automaticallyImplyLeading: false,
                          flexibleSpace: FlexibleSpaceBar(
                            expandedTitleScale: 1,
                            titlePadding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                            ),
                            centerTitle: false,
                            title: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "WELCOME BACK",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontFamily: 'Georgia',
                                    color: AppColors.whiteColor.withAlpha(204),
                                    fontSize: 10.sp,
                                  ),
                                ),
                                Text(
                                  "${user?.name ?? 'Jonathan'} 👋",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontFamily: 'Georgia',
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: Center(
                                child: InkWell(
                                  onTap: () =>
                                      context.push(AppRoutes.notification),
                                  borderRadius: BorderRadius.circular(20.r),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.r),
                                    child: SvgPicture.asset(
                                      AppAssets.notify,
                                      colorFilter: const ColorFilter.mode(
                                        AppColors.borderColor,
                                        BlendMode.srcIn,
                                      ),
                                      width: 28.r,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // ── Main Content ───────────────────────────────────────────────────
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              SizedBox(height: 20.h),

                              // Circular Timer
                              Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 240.r,
                                      height: 240.r,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(
                                            0xFFCDC175,
                                          ).withAlpha(128),
                                          width: 1.r,
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFCDC175,
                                            ).withAlpha(128),
                                            blurRadius: 80,
                                            spreadRadius: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 245.r,
                                      height: 245.r,
                                      child: SfRadialGauge(
                                        enableLoadingAnimation: false,
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
                                              color:
                                                  AppColors.coachColorFF41503C,
                                            ),
                                            pointers: [
                                              RangePointer(
                                                value:
                                                    (timer?.progress ?? 0.8) *
                                                    100,
                                                width: 14.r,
                                                enableAnimation: false,
                                                cornerStyle:
                                                    CornerStyle.bothCurve,
                                                gradient: const SweepGradient(
                                                  colors: [
                                                    AppColors
                                                        .coachColor55E6DBC9,
                                                    AppColors
                                                        .coachColorAAE6DBC9,
                                                    AppColors.softBeige,
                                                    AppColors.textWhiteColor,
                                                  ],
                                                ),
                                              ),
                                            ],
                                            annotations: [
                                              GaugeAnnotation(
                                                widget: Container(
                                                  width: 200.r,
                                                  height: 200.r,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: const Color(
                                                        0xFFFEEF8E,
                                                      ),
                                                      width: 1.r,
                                                    ),
                                                    color: const Color(
                                                      0xFF44523A,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          user?.status ?? "YOU ARE\nSTRONG ✨",
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontFamily: 'Georgia',
                                                color: AppColors.whiteColor,
                                              ),
                                        ),
                                        SizedBox(height: 12.h),
                                        SizedBox(
                                          width: .480.sw,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              _buildTimerUnit(
                                                context,
                                                timer?.displayDays.toString() ??
                                                    '0',
                                                "Days",
                                              ),
                                              _buildTimerSeparator(context),
                                              _buildTimerUnit(
                                                context,
                                                timer?.displayHours
                                                        .toString()
                                                        .padLeft(2, '0') ??
                                                    '00',
                                                "Hours",
                                              ),
                                              _buildTimerSeparator(context),
                                              _buildTimerUnit(
                                                context,
                                                timer?.displayMins
                                                        .toString()
                                                        .padLeft(2, '0') ??
                                                    '00',
                                                "Mins",
                                              ),
                                            ],
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
                                              color:
                                                  AppColors.coachColorFF62745E,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 0.58.r,
                                                  color: const Color(
                                                    0xFF8EA689,
                                                  ),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      13.95.r,
                                                    ),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Reset ",
                                                  style: theme
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: AppColors
                                                            .secondaryColorLight,
                                                      ),
                                                ),
                                                SvgPicture.asset(
                                                  AppAssets.reset,
                                                  height: 16.r,
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

                              _buildActionButton(
                                context: context,
                                title: "HELP! I broke No Contact 💔",
                                color: AppColors.coachColorFFB03030,
                                onTap: () => home.handleBreakNoContact(context),
                              ),
                              SizedBox(height: 16.h),
                              _buildActionButton(
                                context: context,
                                title: "I'm About to Relapse — HELP! 🚨",
                                color: AppColors.coachColorFFC96630,
                                onTap: () =>
                                    home.handleRelapsePrevention(context),
                              ),

                              SizedBox(height: 24.h),

                              // Daily Wisdom Card
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
                                  ),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.feather,
                                          width: 22.r,
                                          colorFilter: const ColorFilter.mode(
                                            AppColors.blackColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          "DAILY WISDOM",
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                fontFamily: 'Georgia',
                                                color: AppColors.blackColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      "\"${wisdom?.quote ?? ''}\"",
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontFamily: 'Georgia',
                                            color: AppColors.blackColor,
                                            fontStyle: FontStyle.italic,
                                          ),
                                    ),
                                    SizedBox(height: 14.h),
                                    Text(
                                      "— ${wisdom?.author ?? ''}",
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            fontFamily: 'Georgia',
                                            color: AppColors.whiteColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 16.h),

                              // Journal Card
                              GlassWidget(
                                width: double.infinity,
                                height: 72.h,
                                child: Container(
                                  padding: EdgeInsets.all(15.r),
                                  decoration: BoxDecoration(
                                    color: AppColors.defaultColorAlpha2
                                        .withAlpha(77),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  AppAssets.journal,
                                                  width: 22.w,
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  "Today's Journal",
                                                  style: theme
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                        fontFamily: 'Georgia',
                                                        color:
                                                            AppColors.textColor,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              journal?.prompt ??
                                                  "Tap to write...",
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    fontFamily: 'Georgia',
                                                    fontStyle: FontStyle.italic,
                                                    color: AppColors.textColor,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () =>
                                            NavigationService.goToWriteJournal(),
                                        child: Text(
                                          journal?.actionText ?? "Write →",
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: AppColors.iconColor,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 120.h),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (home.isRefreshing)
                    Positioned(
                      top: 16.h,
                      left: 0,
                      right: 0,
                      child: const Center(child: CustomLoader(size: 100)),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTimerUnit(BuildContext context, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.secondaryColorLight,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Georgia',
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textColor.withAlpha(179),
            fontSize: 10.sp,
            fontFamily: 'Georgia',
          ),
        ),
      ],
    );
  }

  Widget _buildTimerSeparator(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ":",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.secondaryColorLight,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildShimmerHome(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
          SizedBox(height: 10.h),
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
          Center(
            child: ShimmerLoader(
              width: 240.r,
              height: 240.r,
              borderRadius: 120.r,
            ),
          ),
          SizedBox(height: 60.h),
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
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 58.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: LinearGradient(colors: [color.withAlpha(242), color]),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha(89),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.w800,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}
