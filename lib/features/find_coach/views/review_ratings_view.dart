import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';

class ReviewRatingsView extends StatelessWidget {
  const ReviewRatingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text("Review and Ratings", style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            _buildRatingSummary(),
            SizedBox(height: 30.h),
            _buildReviewItem(),
            _buildReviewItem(),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Row(
      children: [
        Column(
          children: [
            Text("4.3", style: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold)),
            Text("24 Ratings", style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp)),
          ],
        ),
        SizedBox(width: 30.w),
        Expanded(
          child: Column(
            children: [
              _buildRatingBar(5, 12, 0.8),
              _buildRatingBar(4, 6, 0.4),
              _buildRatingBar(3, 4, 0.3),
              _buildRatingBar(2, 2, 0.1),
              _buildRatingBar(1, 1, 0.05),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBar(int stars, int count, double progress) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Row(children: List.generate(stars, (index) => Icon(Icons.star, color: Colors.amber, size: 10.r))),
          const Spacer(),
          Container(
            width: 140.w,
            height: 4.h,
            decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2.r)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(2.r))),
            ),
          ),
          SizedBox(width: 12.w),
          Text(count.toString(), style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 11.sp)),
        ],
      ),
    );
  }

  Widget _buildReviewItem() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 20.r, backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=reviewer')),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(color: Colors.white.withAlpha(13), borderRadius: BorderRadius.circular(16.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Monalisa gong", style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      Text("25 July, 25", style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 11.sp)),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(children: List.generate(5, (index) => Icon(Icons.star, color: index < 4 ? Colors.amber : Colors.white10, size: 14.r))),
                  SizedBox(height: 12.h),
                  Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and.Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                    style: TextStyle(color: Colors.white.withAlpha(179), fontSize: 12.sp, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
