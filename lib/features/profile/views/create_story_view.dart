import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateStoryView extends StatelessWidget {
  const CreateStoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B2B1B),
      body: SafeArea(
        child: Stack(
          children: [
            // ── Background / Header ─────────────────────────────────────────
            Positioned(
              top: 20.h,
              left: 20.w,
              right: 20.w,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=me'),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Mike Tyson", style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                      Text("1h", style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            
            // ── Main Content ────────────────────────────────────────────────
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  "My Story",
                  style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // ── Controls ───────────────────────────────────────────────────
            Positioned(
              right: 20.w,
              top: 100.h,
              child: Column(
                children: [
                  _buildControlItem("Text", Colors.red),
                  SizedBox(height: 20.h),
                  _buildControlItem("Bg", Colors.amber),
                  SizedBox(height: 20.h),
                  _buildControlItem("Upload", Colors.white.withAlpha(26), icon: Icons.image_outlined),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlItem(String label, Color color, {IconData? icon}) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
        SizedBox(height: 8.h),
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withAlpha(51)),
          ),
          child: icon != null ? Icon(icon, color: Colors.white, size: 20.r) : null,
        ),
      ],
    );
  }
}
