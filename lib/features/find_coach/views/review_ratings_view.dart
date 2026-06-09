import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_loader.dart';
import '../controllers/coach_controller.dart';
import '../models/coach_model.dart';

class ReviewRatingsView extends StatelessWidget {
  final CoachModel? coach;

  const ReviewRatingsView({super.key, this.coach});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<CoachController>();
      final coachId = coach?.id ?? 'c1';
      controller.fetchCoachReviews(coachId);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text("Review and Ratings", style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        centerTitle: true,
      ),
      body: Consumer<CoachController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.reviews.isEmpty) {
            return const _ReviewRatingsShimmer();
          }

          final rating = coach?.rating ?? 4.9;
          final reviewsCount = coach?.reviews ?? 187;

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => controller.fetchCoachReviews(coach?.id ?? 'c1', isRefresh: true),
                color: Colors.transparent,
                backgroundColor: Colors.transparent,
                strokeWidth: 0,
                elevation: 0,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(20.r),
                  child: Column(
              children: [
                _buildRatingSummary(rating, reviewsCount),
                SizedBox(height: 30.h),
                if (controller.reviews.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text("No reviews yet.", style: TextStyle(color: Colors.white.withAlpha(128))),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.reviews.length,
                    itemBuilder: (context, index) {
                      final review = controller.reviews[index];
                      return _buildReviewItem(
                        review.reviewerName,
                        review.reviewerAvatar,
                        review.date,
                        review.rating,
                        review.content,
                      );
                    },
                  ),
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
    );
  }

  Widget _buildRatingSummary(double rating, int reviewsCount) {
    return Row(
      children: [
        Column(
          children: [
            Text(rating.toStringAsFixed(1), style: TextStyle(color: Colors.white, fontSize: 32.sp, fontWeight: FontWeight.bold)),
            Text("$reviewsCount Ratings", style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp)),
          ],
        ),
        SizedBox(width: 30.w),
        Expanded(
          child: Column(
            children: [
              _buildRatingBar(5, (reviewsCount * 0.8).round(), 0.8),
              _buildRatingBar(4, (reviewsCount * 0.12).round(), 0.4),
              _buildRatingBar(3, (reviewsCount * 0.05).round(), 0.3),
              _buildRatingBar(2, (reviewsCount * 0.02).round(), 0.1),
              _buildRatingBar(1, (reviewsCount * 0.01).round(), 0.05),
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

  Widget _buildReviewItem(String name, String avatar, String date, double rating, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 20.r, backgroundImage: NetworkImage(avatar)),
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
                      Text(name, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      Text(date, style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 11.sp)),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < rating.round() ? Colors.amber : Colors.white10,
                        size: 14.r,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    content,
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

class _ReviewRatingsShimmer extends StatelessWidget {
  const _ReviewRatingsShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(20.r),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  ShimmerLoader(width: 60.w, height: 32.h, borderRadius: 4.r),
                  SizedBox(height: 6.h),
                  ShimmerLoader(width: 80.w, height: 12.h, borderRadius: 4.r),
                ],
              ),
              SizedBox(width: 30.w),
              Expanded(
                child: Column(
                  children: List.generate(5, (index) => Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: ShimmerLoader(width: double.infinity, height: 8.h, borderRadius: 4.r),
                  )),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: ShimmerLoader(width: double.infinity, height: 100.h, borderRadius: 16.r),
            ),
          ),
        ],
      ),
    );
  }
}
