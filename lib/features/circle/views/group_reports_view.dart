import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_input.dart';
import '../../../core/widgets/custom_button.dart';

class GroupReportsView extends StatelessWidget {
  const GroupReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_alt, color: AppColors.secondaryColorLight, size: 24.r),
            SizedBox(width: 8.w),
            Text(
              "List of Reports",
              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: CustomInput(
              height: 48,
              hintText: "Search Follower",
              backgroundColor: Colors.white.withAlpha(13),
              borderRadius: 24,
              shadow: false,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 8,
              itemBuilder: (context, index) => _ReportTile(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.postCardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=reporter'),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              "Miles Esther",
              style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
          CustomButton(
            onPress: () async => _showReportDetails(context),
            title: "View Report",
            width: 100,
            height: 32,
            fontSize: 12,
            buttonColor: Colors.white.withAlpha(13),
            borderColor: Colors.transparent,
            radius: 8,
          ),
        ],
      ),
    );
  }

  void _showReportDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: const Color(0xFF20341F),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withAlpha(13)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Harassment Report", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: Colors.white.withAlpha(128), size: 20.r),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=reported'),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text("Coach Pearl", style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w500)),
                  ),
                  Icon(Icons.visibility_outlined, color: AppColors.secondaryColorLight, size: 16.r),
                  SizedBox(width: 4.w),
                  Text("View", style: TextStyle(color: AppColors.secondaryColorLight, fontSize: 13.sp)),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(26),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "Amazon Alexa Shopping is seeking a talented, experienced, and self-directed UX Designer to define and drive the future of shopping at Amazon.",
                  style: TextStyle(color: Colors.white.withAlpha(179), fontSize: 13.sp, height: 1.5),
                ),
              ),
              SizedBox(height: 24.h),
              CustomButton(
                onPress: () async => Navigator.pop(context),
                title: "Mark resolved",
                linearGradient: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
