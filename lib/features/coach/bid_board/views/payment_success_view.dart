import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_button.dart';

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      imagePath: AppAssets.bgHome,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // ── Illustration (Mock with Icon/Container) ────────────────
              Container(
                height: 300.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/banner.png'), // Using existing placeholder
                    fit: BoxFit.contain,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Center(
                  child: Icon(Icons.check_circle, color: const Color(0xFF81C784), size: 100.r),
                ),
              ),
              
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
        ),
      ),
    );
  }
}
