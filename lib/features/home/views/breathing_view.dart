import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_app_dialog.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/gradient_timer_painter.dart';
import '../controllers/home_controller.dart';

class BreathingView extends StatefulWidget {
  final String title;
  final String subtitle;

  const BreathingView({super.key, required this.title, required this.subtitle});

  @override
  State<BreathingView> createState() => _BreathingViewState();
}

class _BreathingViewState extends State<BreathingView> {
  int _secondsRemaining = 4;
  int _currentRound = 1;
  String _phaseText = "Breathe In";
  Timer? _timer;
  double _progress = 1.0;
  int _ticksInPhase = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted) return;
      setState(() {
        _ticksInPhase++;
        _progress = 1.0 - (_ticksInPhase / 40.0);
        _secondsRemaining = 4 - (_ticksInPhase ~/ 10);
        if (_secondsRemaining < 1) _secondsRemaining = 1;

        if (timer.tick % 10 == 0) {}

        if (_ticksInPhase >= 40) {
          _ticksInPhase = 0;
          _nextPhase();
        }
      });
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

  // ── Dialog Sequence ────────────────────────────────────────────────────────

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
        // Handle redirect to coach logic here
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
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: AppColors.defaultColor,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: const Color(0xFFD4AF37).withAlpha(102),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Sorry you are not feeling any better, what is going on?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withAlpha(217),
                  fontSize: 14.sp,
                  fontFamily: 'Proxima Nova',
                ),
              ),
              SizedBox(height: 20.h),
              TextField(
                maxLines: 4,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Write here",
                  hintStyle: TextStyle(color: Colors.white.withAlpha(102)),
                  filled: true,
                  fillColor: Colors.black.withAlpha(51),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              CustomButton(
                onPress: () async {
                  Navigator.pop(context);
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
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Container(
          padding: EdgeInsets.all(24.r),
          decoration: BoxDecoration(
            color: AppColors.defaultColor,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: const Color(0xFFD4AF37).withAlpha(102),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Would you like me to redirect you to one of our expert coaches, who can help you?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withAlpha(217),
                  fontSize: 14.sp,
                  fontFamily: 'Proxima Nova',
                ),
              ),
              SizedBox(height: 32.h),
              // Image 4 style: "Yes" is outline, "No" is filled
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  context.pop(); // Action for Yes
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white.withAlpha(102)),
                  ),
                  child: Text(
                    "Yes, Connect me with a coach",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              CustomButton(
                onPress: () async {
                  Navigator.pop(context);
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

  // ── Helper ────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4A5D44), Color(0xFF22331F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ),
              const Spacer(flex: 1),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  widget.title,
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
                  widget.subtitle,
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
                    decoration: BoxDecoration(shape: BoxShape.circle),
                  ),
                  SizedBox(
                    width: 250.r,
                    height: 250.r,
                    child: GradientTimerGauge(progress: _progress, size: 250),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "00:${_secondsRemaining.toString().padLeft(2, '0')}",
                        style: textTheme.titleSmall?.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        _phaseText,
                        style: textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryColorLight,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        "Round $_currentRound/3",
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
  }
}
