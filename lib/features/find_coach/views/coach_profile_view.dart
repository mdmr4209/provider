import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import 'schedule_meet_view.dart';
import 'review_ratings_view.dart';

class CoachProfileView extends StatelessWidget {
  const CoachProfileView({super.key});

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
        title: Text("Coach Profile", style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.more_horiz, color: Colors.white), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40.r,
                  backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=coach_pearl'),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("CoachPearl (28y)", style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      Text("Founder & Head Coach", style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 13.sp)),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewRatingsView())),
                        child: Row(
                          children: [
                            Text("4", style: TextStyle(color: Colors.amber, fontSize: 13.sp, fontWeight: FontWeight.bold)),
                            Icon(Icons.star, color: Colors.amber, size: 14.r),
                            Text(" (1,248 reviews)", style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp)),
                          ],
                        ),
                      ),
                      Text("5 Year Experience", style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp)),
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
                Expanded(child: CustomButton(onPress: () async {}, title: "Message", buttonColor: Colors.white.withAlpha(13), borderColor: Colors.transparent, height: 36, fontSize: 13)),
              ],
            ),
            SizedBox(height: 24.h),
            _buildSection("Bio", "Amazon Alexa Shopping is seeking a talented, experienced, and self-directed UX Designer to define and drive the future of shopping at Amazon."),
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
            Row(
              children: [
                Expanded(child: _buildSessionCard("30 Min", "\$75")),
                SizedBox(width: 12.w),
                Expanded(child: _buildSessionCard("60 Minutes", "\$150")),
              ],
            ),
            SizedBox(height: 24.h),
            _buildSection("Coaching Bio", "Amazon Alexa Shopping is seeking a talented, experienced, and self-directed UX Designer to define and drive the future of shopping at Amazon. The ideal candidate is an end-to-end UX Designer with strong visual design skills. They are passionate and have experience designing for new and ambiguous technologies. They have proven ability to motivate through vision and a desire to inspire"),
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
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(color: const Color(0xFF1B2B1B), border: Border(top: BorderSide(color: Colors.white.withAlpha(13)))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(child: CustomButton(onPress: () async {}, title: "Text Now", buttonColor: Colors.white.withAlpha(13), borderColor: Colors.transparent, trailingWidget: Icon(Icons.chat_bubble_outline, color: Colors.white, size: 20.r))),
                SizedBox(width: 12.w),
                Expanded(child: CustomButton(onPress: () async => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScheduleMeetView())), title: "Schedule Now", buttonColor: const Color(0xFF2D402D), borderColor: Colors.transparent, trailingWidget: Icon(Icons.calendar_today_outlined, color: Colors.white, size: 20.r))),
              ],
            ),
            SizedBox(height: 12.h),
            CustomButton(onPress: () async {}, title: "Call Now", linearGradient: true, leadingWidget: Icon(Icons.call_outlined, color: Colors.white, size: 20.r)),
          ],
        ),
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
