import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_input.dart';
import '../../../core/widgets/custom_button.dart';

class CreateGroupView extends StatefulWidget {
  const CreateGroupView({super.key});

  @override
  State<CreateGroupView> createState() => _CreateGroupViewState();
}

class _CreateGroupViewState extends State<CreateGroupView> {
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
        title: Text(
          "Create New Group",
          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFieldTitle("Group Name"),
            const CustomInput(
              hintText: "Enter here",
              backgroundColor: Color(0xFF21321E),
              borderColor: Color(0xFF334B2F),
              borderRadius: 12,
            ),
            SizedBox(height: 20.h),
            _buildFieldTitle("Group Logo"),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: const Color(0xFF21321E),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xFF334B2F)),
              ),
              child: Row(
                children: [
                  CustomButton(
                    onPress: () async {},
                    title: "Upload",
                    width: 80,
                    height: 32,
                    fontSize: 12,
                    buttonColor: const Color(0xFF334B2F),
                    borderColor: Colors.transparent,
                    radius: 8,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    "False Logo.jpeg",
                    style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 14.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            _buildFieldTitle("Group Instruction"),
            const CustomInput(
              hintText: "Share Your Thoughts",
              maxLines: 10,
              leadingIcon: AppAssets.feather,
              backgroundColor: Color(0xFF21321E),
              borderColor: Color(0xFF334B2F),
              borderRadius: 24,
            ),
            const Spacer(),
            CustomButton(
              onPress: () async {},
              title: "Create",
              linearGradient: true,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 14.sp),
      ),
    );
  }
}
