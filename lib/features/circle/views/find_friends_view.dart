import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_input.dart';
import '../../../core/widgets/custom_button.dart';

class FindFriendsView extends StatelessWidget {
  const FindFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Find Friends",
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontFamily: 'Georgia',
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: CustomInput(
              height: 48,
              hintText: "Search Friends",
              backgroundColor: Colors.white.withAlpha(13),
              borderRadius: 24,
              shadow: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              "Suggestions",
              style: TextStyle(
                color: Colors.white.withAlpha(128),
                fontSize: 14.sp,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 0.75,
              ),
              itemCount: 10,
              itemBuilder: (context, index) => _UserDiscoveryCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class _UserDiscoveryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.postCardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withAlpha(13)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=discovery'),
            backgroundColor: Colors.white.withAlpha(26),
          ),
          SizedBox(height: 12.h),
          Text(
            "Mike Lee",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "2 mutual Friend",
            style: TextStyle(
              color: Colors.white.withAlpha(128),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 12.h),
          CustomButton(
            onPress: () async {},
            title: "Add Friedns", // Matching typo in design image as requested implicitly
            linearGradient: true,
            height: 32.h,
            fontSize: 12,
            radius: 8,
          ),
        ],
      ),
    );
  }
}
