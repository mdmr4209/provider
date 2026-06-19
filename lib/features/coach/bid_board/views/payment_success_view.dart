import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF2D3D2A),
      body: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 1500)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildSkeletonLoader();
          }
          return Padding(
            padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            // ── Illustration (Mock with Icon/Container) ────────────────
            Image.asset(AppAssets.paySuccess),

            SizedBox(height: 40.h),

            const Text(
              "Payment Successful",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 16.h),

            const Text(
              "Please Check Your Notification, We Just Sent You A Message.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 15, height: 1.5),
            ),

            const Spacer(),

            CustomButton(
              onPress: () async {
                // Pop back to Raffle Draw or Bid Board
                Navigator.pop(context); // From Success
                Navigator.pop(context); // From Buy
              },
              title: "Got it",
              linearGradient: true,
            ),

            SizedBox(height: 20.h),
          ],
        ),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          ShimmerLoader(width: double.infinity, height: 300.h, borderRadius: 20.r),
          SizedBox(height: 40.h),
          ShimmerLoader(width: 200.w, height: 28.h),
          SizedBox(height: 16.h),
          ShimmerLoader(width: double.infinity, height: 16.h),
          SizedBox(height: 8.h),
          ShimmerLoader(width: 250.w, height: 16.h),
          const Spacer(),
          ShimmerLoader(width: double.infinity, height: 50.h, borderRadius: 25.r),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
