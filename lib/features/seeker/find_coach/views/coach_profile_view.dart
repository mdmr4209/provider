import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_controller.dart';
import '../models/coach_model.dart';
import 'schedule_meet_view.dart';
import 'review_ratings_view.dart';
import 'package:go_router/go_router.dart';
import '../../../../routes/app_router.dart';

class CoachProfileView extends StatelessWidget {
  final CoachModel? coach;

  const CoachProfileView({super.key, this.coach});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<CoachController>();
      final coachId = coach?.id ?? controller.heroCoach?.id ?? 'c1';
      controller.fetchCoachSlots(coachId);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Coach Profile", style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.more_horiz, color: Colors.white), onPressed: () {})],
      ),
      body: Consumer<CoachController>(
        builder: (context, controller, child) {
          final displayCoach = coach ?? controller.heroCoach;
          if (displayCoach == null) {
            return const SafeArea(child: _CoachProfileShimmer());
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => controller.fetchCoachesDiscover(isRefresh: true),
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
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40.r,
                        backgroundImage: NetworkImage(displayCoach.avatar),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${displayCoach.name} (28y)", style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                            Text(displayCoach.title, style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 13.sp)),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ReviewRatingsView(coach: displayCoach)),
                              ),
                              child: Row(
                                children: [
                                  Text("${displayCoach.rating.toStringAsFixed(1)}", style: TextStyle(color: Colors.amber, fontSize: 13.sp, fontWeight: FontWeight.bold)),
                                  Icon(Icons.star, color: Colors.amber, size: 14.r),
                                  Text(" (${displayCoach.reviews} reviews)", style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp)),
                                ],
                              ),
                            ),
                            Text(displayCoach.experience, style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(child: CustomButton(onPress: () async {}, title: "Unfriend", linearGradient: true, height: 36, fontSize: 13)),
                      SizedBox(width: 10.w),
                      Expanded(child: CustomButton(
                        onPress: () async {
                          context.push(
                            AppRoutes.chat,
                            extra: {
                              'name': displayCoach.name,
                              'avatar': displayCoach.avatar,
                              'isCoach': true,
                            },
                          );
                        },
                        title: "Message",
                        buttonColor: Colors.white.withAlpha(13),
                        borderColor: Colors.transparent,
                        height: 36,
                        fontSize: 13,
                      )),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _buildSection("Bio", displayCoach.bio),
                  SizedBox(height: 24.h),
                  _buildSection("Pay as you go", ""),
                  Row(
                    children: [
                      _buildTag("\$ 150/min"),
                      SizedBox(width: 10.w),
                      _buildTag("\$ 150/per text"),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  _buildSection("Scheduled Sessions", ""),
                  if (controller.isLoading)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Row(
                        children: [
                          Expanded(child: ShimmerLoader(height: 56.h, borderRadius: 12.r)),
                          SizedBox(width: 12.w),
                          Expanded(child: ShimmerLoader(height: 56.h, borderRadius: 12.r)),
                        ],
                      ),
                    )
                  else if (controller.slots.isEmpty)
                    Text("No scheduled sessions available.", style: TextStyle(color: Colors.white.withAlpha(128)))
                  else
                    Row(
                      children: List.generate(controller.slots.length, (index) {
                        final slot = controller.slots[index];
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: index < controller.slots.length - 1 ? 12.w : 0),
                            child: _buildSessionCard(slot.duration, "\$${slot.price.toStringAsFixed(0)}"),
                          ),
                        );
                      }),
                    ),
                  SizedBox(height: 24.h),
                  _buildSection("Coaching Bio", displayCoach.bio),
                  SizedBox(height: 24.h),
                  _buildSection("Certification/ Education", "Licensed Professional Counselor (LPC), Certified Life Coach"),
                  SizedBox(height: 24.h),
                  _buildSection("Coaching Style", ""),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: ["Direct & Honest", "Data-Driven", "Empathetic & Soft", "Spiritual", "Action-Oriented"].map((e) => _buildTag(e)).toList(),
                  ),
                  SizedBox(height: 24.h),
                  _buildSection("Coaching Specialty", ""),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: ["Communication Skill", "Health and wellness", "Career Coaching", "Life Coaching", "Divorce Support", "Personal Growth", "Anxiety and Stress Management", "Relationship Coaching"].map((e) => _buildTag(e)).toList(),
                  ),
                  SizedBox(height: 100.h),
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
      bottomNavigationBar: Consumer<CoachController>(
        builder: (context, controller, child) {
          final displayCoach = coach ?? controller.heroCoach;
          if (displayCoach == null) return const SizedBox.shrink();

          return Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(color: const Color(0xFF1B2B1B), border: Border(top: BorderSide(color: Colors.white.withAlpha(13)))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(child: CustomButton(
                      onPress: () async {
                        context.push(
                          AppRoutes.chat,
                          extra: {
                            'name': displayCoach.name,
                            'avatar': displayCoach.avatar,
                            'isCoach': true,
                          },
                        );
                      },
                      title: "Text Now",
                      buttonColor: Colors.white.withAlpha(13),
                      borderColor: Colors.transparent,
                      trailingWidget: Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20.r),
                    )),
                    SizedBox(width: 12.w),
                    Expanded(child: CustomButton(
                      onPress: () async => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ScheduleMeetView(coach: displayCoach)),
                      ),
                      title: "Schedule Now",
                      buttonColor: const Color(0xFF2D402D),
                      borderColor: Colors.transparent,
                      trailingWidget: Icon(Icons.calendar_today_outlined, color: Colors.white, size: 20.r),
                    )),
                  ],
                ),
                SizedBox(height: 12.h),
                CustomButton(
                  onPress: () async {
                    context.push(
                      AppRoutes.call,
                      extra: {
                        'name': displayCoach.name,
                        'avatar': displayCoach.avatar,
                        'rate': '2\$/Min',
                      },
                    );
                  },
                  title: "Call Now",
                  linearGradient: true,
                  leadingWidget: Icon(Icons.call_outlined, color: Colors.white, size: 20.r),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
        if (content.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Text(content, style: TextStyle(color: Colors.white.withAlpha(179), fontSize: 13.sp, height: 1.5)),
        ],
      ],
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(color: Colors.white.withAlpha(13), borderRadius: BorderRadius.circular(20.r)),
      child: Text(label, style: TextStyle(color: Colors.white.withAlpha(204), fontSize: 12.sp)),
    );
  }

  Widget _buildSessionCard(String title, String price) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(color: Colors.white.withAlpha(13), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: Colors.white.withAlpha(13))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500)),
              Text(price, style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp)),
            ],
          ),
          Icon(Icons.access_time, color: Colors.white.withAlpha(128), size: 18.r),
        ],
      ),
    );
  }
}

class _CoachProfileShimmer extends StatelessWidget {
  const _CoachProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShimmerLoader(width: 80.r, height: 80.r, borderRadius: 40.r),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoader(width: 150.w, height: 18.h, borderRadius: 4.r),
                    SizedBox(height: 8.h),
                    ShimmerLoader(width: 100.w, height: 12.h, borderRadius: 4.r),
                    SizedBox(height: 8.h),
                    ShimmerLoader(width: 120.w, height: 12.h, borderRadius: 4.r),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(child: ShimmerLoader(height: 36.h, borderRadius: 8.r)),
              SizedBox(width: 10.w),
              Expanded(child: ShimmerLoader(height: 36.h, borderRadius: 8.r)),
            ],
          ),
          SizedBox(height: 24.h),
          ShimmerLoader(width: 60.w, height: 16.h, borderRadius: 4.r),
          SizedBox(height: 12.h),
          ShimmerLoader(width: double.infinity, height: 60.h, borderRadius: 8.r),
          SizedBox(height: 24.h),
          ShimmerLoader(width: 100.w, height: 16.h, borderRadius: 4.r),
          SizedBox(height: 12.h),
          Row(
            children: [
              ShimmerLoader(width: 80.w, height: 32.h, borderRadius: 16.r),
              SizedBox(width: 10.w),
              ShimmerLoader(width: 100.w, height: 32.h, borderRadius: 16.r),
            ],
          ),
          SizedBox(height: 24.h),
          ShimmerLoader(width: 140.w, height: 16.h, borderRadius: 4.r),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(child: ShimmerLoader(height: 56.h, borderRadius: 12.r)),
              SizedBox(width: 12.w),
              Expanded(child: ShimmerLoader(height: 56.h, borderRadius: 12.r)),
            ],
          ),
        ],
      ),
    );
  }
}
