import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_profile_controller.dart';

class FollowUpSetupView extends StatelessWidget {
  const FollowUpSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CoachProfileController>();

    final intervals = ["7 Days", "60 Days", "30 Days", "90 Days", "6 Months", "12 Months", "14 Months"];

    return BackgroundWidget(
      imagePath: AppAssets.bgHome,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Follow Up Set Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 1500)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSkeletonLoader();
            }
            return Padding(
              padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Follow Up Text", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const Text("Set automated Follow Up Text to send your clients", style: TextStyle(color: Colors.white38, fontSize: 12)),
              
              SizedBox(height: 16.h),
              
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3D2D).withAlpha(100),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: TextField(
                  controller: controller.followUpTextController,
                  maxLines: 8,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Enter here",
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),

              SizedBox(height: 32.h),
              
              const Text("Follow Up Message Set Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              
              SizedBox(height: 16.h),
              
              Wrap(
                spacing: 24.w,
                runSpacing: 16.h,
                children: intervals.map((interval) => _buildCheckbox(controller, interval)).toList(),
              ),

              const Spacer(),

              CustomButton(
                onPress: () async {},
                title: "Save Follow Up Set Up",
                linearGradient: true,
              ),

              SizedBox(height: 20.h),
            ],
          ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCheckbox(CoachProfileController controller, String title) {
    final bool isSelected = controller.selectedFollowUpInterval == title;

    return InkWell(
      onTap: () => controller.setFollowUpInterval(title),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18.r,
            height: 18.r,
            decoration: BoxDecoration(
              border: Border.all(color: isSelected ? const Color(0xFFC19E5F) : Colors.white38, width: 1.5),
              borderRadius: BorderRadius.circular(4.r),
              color: isSelected ? const Color(0xFFC19E5F) : Colors.transparent,
            ),
            child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 12) : null,
          ),
          SizedBox(width: 10.w),
          Text(title, style: TextStyle(color: isSelected ? const Color(0xFFC19E5F) : Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoader(width: 150.w, height: 20.h),
          SizedBox(height: 4.h),
          ShimmerLoader(width: 250.w, height: 14.h),
          SizedBox(height: 16.h),
          ShimmerLoader(width: double.infinity, height: 180.h, borderRadius: 12.r),
          SizedBox(height: 32.h),
          ShimmerLoader(width: 200.w, height: 20.h),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 24.w,
            runSpacing: 16.h,
            children: List.generate(7, (_) => ShimmerLoader(width: 80.w, height: 20.h)),
          ),
          const Spacer(),
          ShimmerLoader(width: double.infinity, height: 50.h, borderRadius: 25.r),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
