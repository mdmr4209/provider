import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class SubscriptionPlanView extends StatelessWidget {
  final ValueNotifier<int> _selectedPlan = ValueNotifier<int>(0);

  SubscriptionPlanView({super.key});

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
        title: Text(
          "Choose Plan",
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _selectedPlan,
        builder: (context, selectedPlan, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                _buildPlanCard(
                  index: 0,
                  title: "Essential",
                  price: "\$14.99",
                  messages: "08",
                  groups: "Join 1 Groups",
                  isPopular: true,
                  selectedPlan: selectedPlan,
                ),
                SizedBox(height: 16.h),
                _buildPlanCard(
                  index: 1,
                  title: "Professional",
                  price: "\$49.00",
                  messages: "30",
                  groups: "Join 3 Groups",
                  selectedPlan: selectedPlan,
                ),
                SizedBox(height: 16.h),
                _buildPlanCard(
                  index: 2,
                  title: "Elite",
                  price: "\$125.0",
                  messages: "Unlimited",
                  groups: "Join Unlimited Groups",
                  selectedPlan: selectedPlan,
                ),
                SizedBox(height: 40.h),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.r),
        child: CustomButton(
          onPress: () async {
            // Handle payment
          },
          title: "Proceed To Pay",
          linearGradient: true,
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String title,
    required String price,
    required String messages,
    required String groups,
    required int selectedPlan,
    bool isPopular = false,
  }) {
    final isSelected = selectedPlan == index;
    return GestureDetector(
      onTap: () => _selectedPlan.value = index,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(isSelected ? 13 : 8),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.transparent,
            width: 1.5.r,
          ),
        ),
        child: Stack(
          children: [
            if (isPopular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(204),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.r),
                      bottomLeft: Radius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    "Most Popular",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white.withAlpha(128),
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          price,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "USD / month",
                          style: TextStyle(
                            color: Colors.white.withAlpha(102),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60.h,
                    width: 1.r,
                    color: Colors.white.withAlpha(26),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          messages,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Cold Start message",
                          style: TextStyle(
                            color: Colors.white.withAlpha(128),
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          groups,
                          style: TextStyle(
                            color: Colors.white.withAlpha(128),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
