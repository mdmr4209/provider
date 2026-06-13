import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/coach_bid_controller.dart';
import 'payment_success_view.dart';

class BuyTicketsView extends StatelessWidget {
  const BuyTicketsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CoachBidController>();

    return BackgroundWidget(
      imagePath: AppAssets.bgHome,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Raffle Draw", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              // ── Price Card ─────────────────────────────────────────────
              Container(
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3D2D),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Daily Raffle Update", style: TextStyle(color: Colors.white54, fontSize: 13)),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            const Text("\$5.00", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                            const Text(" /Ticket", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    const Icon(Icons.confirmation_number_outlined, color: Color(0xFF81C784), size: 40),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              const Text("Proffered Times", style: TextStyle(color: Colors.white70, fontSize: 14)),
              SizedBox(height: 12.h),
              
              // ── Quantity Input ──────────────────────────────────────────
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3D2D),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TextField(
                  controller: controller.ticketQuantityController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Enter amount of tickets",
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const Spacer(),

              CustomButton(
                onPress: () async {
                   controller.buyTickets(context);
                   Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentSuccessView()));
                },
                title: "Pay Now",
                linearGradient: true,
              ),

              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
