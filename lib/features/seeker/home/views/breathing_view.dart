import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:newproject/core/widgets/background_widget.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_app_dialog.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/gradient_timer_painter.dart';
import '../controllers/home_controller.dart';

class BreathingView extends StatelessWidget {
  final String title;
  final String subtitle;

  const BreathingView({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ChangeNotifierProvider<BreathingController>(
      create: (_) => BreathingController(context),
      child: Consumer<BreathingController>(
        builder: (context, controller, child) {
          return BackgroundWidget(
            imagePath: AppAssets.bgHome,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.white70Color,
                        ),
                      ),
                    ),
                    const Spacer(flex: 1),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: textTheme.titleSmall?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 270.r,
                          height: 270.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(
                          width: 250.r,
                          height: 250.r,
                          child: GradientTimerGauge(
                            progress: controller.progress,
                            size: 250,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "00:${controller.secondsRemaining.toString().padLeft(2, '0')}",
                              style: textTheme.titleSmall?.copyWith(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 25.h),
                            Text(
                              controller.phaseText,
                              style: textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.secondaryColorLight,
                                fontFamily: 'Georgia',
                              ),
                            ),
                            SizedBox(height: 25.h),
                            Text(
                              "Round ${controller.currentRound}/3",
                              style: textTheme.bodyLarge?.copyWith(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(flex: 2),
                    Text(
                      "4 sec each · 3 rounds · guided breathing",
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 60.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BreathingController extends ChangeNotifier {
  final BuildContext context;
  int _secondsRemaining = 4;
  int _currentRound = 1;
  String _phaseText = "Breathe In";
  Timer? _timer;
  double _progress = 1.0;
  int _ticksInPhase = 0;

  int get secondsRemaining => _secondsRemaining;
  int get currentRound => _currentRound;
  String get phaseText => _phaseText;
  double get progress => _progress;

  BreathingController(this.context) {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _ticksInPhase++;
      _progress = 1.0 - (_ticksInPhase / 40.0);
      _secondsRemaining = 4 - (_ticksInPhase ~/ 10);
      if (_secondsRemaining < 1) _secondsRemaining = 1;

      if (_ticksInPhase >= 40) {
        _ticksInPhase = 0;
        _nextPhase();
      }
      notifyListeners();
    });
  }

  void _nextPhase() {
    _progress = 1.0;
    _secondsRemaining = 4;

    if (_phaseText == "Breathe In") {
      _phaseText = "Hold";
    } else if (_phaseText == "Hold") {
      _phaseText = "Breathe Out";
    } else {
      if (_currentRound < 3) {
        _currentRound++;
        _phaseText = "Breathe In";
      } else {
        _timer?.cancel();
        _showFeelingBetterDialog();
      }
    }
  }

  void _showFeelingBetterDialog() {
    showAppCustomDialog(
      context,
      title: "Good. Are you feeling better?",
      description: "",
      primaryText: "Yes, I feel better",
      onPrimaryTap: () => _showConnectCoachDialog(),
      secondaryText: "No",
      onSecondaryTap: () => _showSupportJournalDialog(),
    );
  }

  void _showConnectCoachDialog() {
    showAppCustomDialog(
      context,
      title:
          "We're glad you're feeling calmer. Would you like to connect with a Coach for more support?",
      description: "",
      primaryText: "Yes Connect me with a coach",
      onPrimaryTap: () {
        context.pop();
      },
      secondaryText: "No",
      onSecondaryTap: () => context.pop(),
    );
  }

  void _showSupportJournalDialog() {
    final name =
        context.read<HomeController>().dashboardModel?.data?.user?.name ??
        "Rahim";

    showDialog(
      context: context,
      barrierColor: AppColors.defaultColor.withAlpha(230),
      builder: (dialogCtx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: AppColors.defaultColor,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: AppColors.coachColorFFD4AF37.withAlpha(102),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.sb2Logo, height: 60.h),
              SizedBox(height: 20.h),
              Text(
                "We're still here to support you $name",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Sorry you are not feeling any better, what is going on?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor.withAlpha(217),
                  fontSize: 14.sp,
                  fontFamily: 'Proxima Nova',
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                maxLines: 4,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor),
                decoration: InputDecoration(
                  hintText: "Write here",
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor.withAlpha(102),
                  ),
                  filled: true,
                  fillColor: AppColors.coachColorFF21321E,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              CustomButton(
                onPress: () async {
                  Navigator.pop(dialogCtx);
                  _showSorrySupportDialog();
                },
                title: "Submit",
                linearGradient: true,
                height: 52,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSorrySupportDialog() {
    showDialog(
      context: context,
      barrierColor: AppColors.defaultColor.withAlpha(230),
      builder: (dialogCtx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: AppColors.defaultColor,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: AppColors.coachColorFFD4AF37.withAlpha(102),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.sb2Logo, height: 60.h),
              SizedBox(height: 20.h),
              Text(
                "I am so sorry you feel this way",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Would you like me to redirect you to one of our expert coaches, who can help you?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor.withAlpha(217),
                  fontSize: 14.sp,
                  fontFamily: 'Proxima Nova',
                ),
              ),
              SizedBox(height: 32.h),
              GestureDetector(
                onTap: () {
                  Navigator.pop(dialogCtx);
                  context.pop();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.whiteColor.withAlpha(102),
                    ),
                  ),
                  child: Text(
                    "Yes, Connect me with a coach",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              CustomButton(
                onPress: () async {
                  Navigator.pop(dialogCtx);
                  context.pop();
                },
                title: "No, I will stay on this page",
                linearGradient: true,
                height: 52,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
