import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';

class CoachFindFriendsView extends StatelessWidget {
  const CoachFindFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      imagePath: AppAssets.bgMain,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Find Friends", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 1500)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSkeletonLoader();
            }
            return Column(
              children: [
            SizedBox(height: 20.h),
            // --- Search Bar ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3D2D),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.white38),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Search Friends",
                          hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 32.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text("Suggestions", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ),
            ),

            SizedBox(height: 16.h),

            // --- Friends Grid ---
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  childAspectRatio: 0.8,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return _buildFriendCard("Mike Lee", "2 mutual Friend");
                },
              ),
            ),
          ],
        );
      },
        ),
      ),
    );
  }

  Widget _buildFriendCard(String name, String mutual) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=mike'),
          ),
          SizedBox(height: 12.h),
          Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          Text(mutual, style: const TextStyle(color: Colors.white38, fontSize: 11)),
          const Spacer(),
          CustomButton(
            onPress: () async {},
            title: "Add Friedns", // matching typo in design
            height: 32.h,
            fontSize: 12,
            radius: 8.r,
            linearGradient: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ShimmerLoader(width: double.infinity, height: 48.h, borderRadius: 24.r),
        ),
        SizedBox(height: 32.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ShimmerLoader(width: 100.w, height: 16.h),
          ),
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 0.8,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3D2D),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    ShimmerLoader(width: 80.r, height: 80.r, borderRadius: 40.r),
                    SizedBox(height: 12.h),
                    ShimmerLoader(width: 100.w, height: 16.h),
                    SizedBox(height: 4.h),
                    ShimmerLoader(width: 80.w, height: 12.h),
                    const Spacer(),
                    ShimmerLoader(width: double.infinity, height: 32.h, borderRadius: 8.r),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
