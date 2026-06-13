import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/profile_controller.dart';

class PointView extends StatelessWidget {
  const PointView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<ProfileController>();
      if (controller.history.isEmpty && !controller.isLoading) {
        controller.fetchPointHistory();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Credit Balance",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontFamily: 'Georgia',
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<ProfileController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.history.isEmpty) {
            return const SafeArea(child: _PointShimmer());
          }

          final pointsDigits = controller.currentPoints.toString().padLeft(3, '0').split('');
          final pointsStr = pointsDigits.join(' ');

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => controller.fetchPointHistory(isRefresh: true),
                color: Colors.transparent,
                backgroundColor: Colors.transparent,
                strokeWidth: 0,
                elevation: 0,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Credit Balance Card ────────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B2B1B), Color(0xFF2D402D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: Colors.white.withAlpha(13)),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Credits Balance",
                            style: TextStyle(
                              color: Colors.white.withAlpha(204),
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            pointsStr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: -10,
                        top: -10,
                        child: Opacity(
                          opacity: 0.1,
                          child: Row(
                            children: [
                              _buildCircle(40),
                              Transform.translate(offset: const Offset(-20, 10), child: _buildCircle(45)),
                              Transform.translate(offset: const Offset(-40, 0), child: _buildCircle(35)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "Valid Until 23 April 2026",
                  style: TextStyle(
                    color: Colors.white.withAlpha(128),
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 16.h),
                const Divider(color: Colors.white12),
                SizedBox(height: 24.h),
                // ── Instructions ────────────────────────────────────────────────
                _buildNumberedText("1.", "Welcome to Ai. By using our services, you agree to abide by the terms and conditions outlined below. These terms govern your access to and"),
                _buildNumberedText("2.", "use of Ai tools and services, so please review them carefully before proceeding."),
                _buildNumberedText("3.", "Ai provides innovative tools designed to enhance how you capture and manage voice recordings. Our services include voice-to-text transcription and AI-driven summarization, which are intended"),
                _buildNumberedText("4.", "for lawful, ethical purposes only. You must ensure compliance with applicable laws, including obtaining consent from all participants when recording conversations. CleverTalk disclaims liability for any misuse of its tools."),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
        if (controller.isRefreshing)
          Positioned(
            top: 16.h,
            left: 0,
            right: 0,
            child: const Center(child: CustomLoader(size: 150)),
          ),
      ],
    );
  },
),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.r),
        child: CustomButton(
          onPress: () async {
            // Handle buy more credits
          },
          title: "Buy More Credits",
          linearGradient: true,
        ),
      ),
    );
  }

  Widget _buildCircle(double size) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildNumberedText(String number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24.w,
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white.withAlpha(179),
                fontSize: 14.sp,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withAlpha(179),
                fontSize: 14.sp,
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PointShimmer extends StatelessWidget {
  const _PointShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoader(width: double.infinity, height: 120.h, borderRadius: 16.r),
          SizedBox(height: 24.h),
          ShimmerLoader(width: 150.w, height: 16.h, borderRadius: 4.r),
          SizedBox(height: 16.h),
          const Divider(color: Colors.white12),
          SizedBox(height: 24.h),
          Column(
            children: List.generate(3, (index) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Row(
                children: [
                  ShimmerLoader(width: 24.w, height: 20.h, borderRadius: 4.r),
                  SizedBox(width: 12.w),
                  Expanded(child: ShimmerLoader(height: 40.h, borderRadius: 4.r)),
                ],
              ),
            )),
          ),
        ],
      ),
    );
  }
}
