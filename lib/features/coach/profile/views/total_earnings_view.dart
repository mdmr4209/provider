import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/coach_profile_controller.dart';
import 'withdrawal_request_view.dart';

class TotalEarningsView extends StatelessWidget {
  const TotalEarningsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CoachProfileController>();

    return BackgroundWidget(
      imagePath: AppAssets.bgHome,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Total Earnings", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              // --- Balance Card ---
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3D2D).withAlpha(150),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Balance", style: TextStyle(color: Colors.white70, fontSize: 13)),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.balance.toStringAsFixed(0).padLeft(3, '0'),
                          style: TextStyle(color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold, letterSpacing: 8),
                        ),
                        // Mock overlapping circles
                        Stack(
                          children: [
                            Container(width: 30.r, height: 30.r, decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.circle)),
                            Positioned(left: 10, child: Container(width: 30.r, height: 30.r, decoration: BoxDecoration(color: Colors.white.withAlpha(15), shape: BoxShape.circle))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40.h),
              
              CustomButton(
                onPress: () async {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => const WithdrawalRequestView()));
                },
                title: "Request Withdrawal",
                linearGradient: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
