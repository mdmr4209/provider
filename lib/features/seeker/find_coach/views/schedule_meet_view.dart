import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_controller.dart';
import '../models/coach_model.dart';

class ScheduleMeetView extends StatelessWidget {
  final CoachModel? coach;

  const ScheduleMeetView({super.key, this.coach});

  @override
  Widget build(BuildContext context) {
    final selectedSlotIndex = ValueNotifier<int>(0);
    final selectedTimeSlot = ValueNotifier<String?>(null);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<CoachController>();
      final coachId = coach?.id ?? 'c1';
      controller.fetchCoachSlots(coachId);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Schedule Meet",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: Consumer<CoachController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.slots.isEmpty) {
            return const _ScheduleMeetShimmer();
          }

          if (controller.slots.isEmpty) {
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () => controller.fetchCoachSlots(
                    coach?.id ?? 'c1',
                    isRefresh: true,
                  ),
                  color: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  strokeWidth: 0,
                  elevation: 0,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 100.h),
                      Center(
                        child: Text(
                          "No schedule slots available.",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.whiteColor.withAlpha(128),
                          ),
                        ),
                      ),
                    ],
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
          }

          // If selected time slot is not in available slots and available slots are not empty, default it
          if (selectedTimeSlot.value == null &&
              controller.availableSlots.isNotEmpty) {
            selectedTimeSlot.value = controller.availableSlots[0];
          }

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => controller.fetchCoachSlots(
                  coach?.id ?? 'c1',
                  isRefresh: true,
                ),
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
                      _buildLabel(context, "Choose Date"),
                      _buildPickerContainer(context, 
                        "Mon, Mar 27",
                        Icons.calendar_today_outlined,
                      ),
                      SizedBox(height: 24.h),
                      _buildLabel(context, "Suggestions"),
                      ValueListenableBuilder<int>(
                        valueListenable: selectedSlotIndex,
                        builder: (context, currentIdx, _) {
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2.2,
                                  crossAxisSpacing: 12.w,
                                  mainAxisSpacing: 12.h,
                                ),
                            itemCount: controller.slots.length,
                            itemBuilder: (context, index) {
                              final slot = controller.slots[index];
                              final isSelected = currentIdx == index;
                              return GestureDetector(
                                onTap: () => selectedSlotIndex.value = index,
                                child: _buildDurationCard(context, 
                                  slot.duration,
                                  "\$${slot.price.toStringAsFixed(0)}",
                                  isSelected: isSelected,
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 24.h),
                      _buildLabel(context, "Select slot"),
                      GestureDetector(
                        onTap: () {
                          // Show slot selection dialog/bottomsheet
                          if (controller.availableSlots.isNotEmpty) {
                            _showSlotPicker(
                              context,
                              controller.availableSlots,
                              selectedTimeSlot,
                            );
                          }
                        },
                        child: ValueListenableBuilder<String?>(
                          valueListenable: selectedTimeSlot,
                          builder: (context, time, _) {
                            return _buildPickerContainer(context, 
                              time ?? "Choose from here",
                              Icons.access_time,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ValueListenableBuilder<String?>(
                        valueListenable: selectedTimeSlot,
                        builder: (context, time, _) {
                          if (time == null) return const SizedBox.shrink();
                          return _buildSelectedSlot(context, time, selectedTimeSlot);
                        },
                      ),
                      SizedBox(height: 24.h),
                      Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withAlpha(13),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Cancellation Policy",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.greenColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Amazon Alexa Shopping is seeking a talented, experienced, and self-directed UX Designer to define and drive the future of shopping at Amazon. The ideal candidate is an end-to-end UX Designer with strong visual design skills. They are passionate and have experience designing for new and ambiguous technologies. They have proven ability to motivate through vision and a desire to inspire",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.whiteColor.withAlpha(179),
                                fontSize: 12.sp,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
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
          if (controller.slots.isEmpty) return const SizedBox.shrink();

          return ValueListenableBuilder<int>(
            valueListenable: selectedSlotIndex,
            builder: (context, currentSlotIdx, _) {
              return ValueListenableBuilder<String?>(
                valueListenable: selectedTimeSlot,
                builder: (context, timeSlot, _) {
                  final activeSlotIndex =
                      currentSlotIdx < controller.slots.length
                      ? currentSlotIdx
                      : 0;
                  final slot = controller.slots[activeSlotIndex];
                  final totalAmount = slot.price;

                  return Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: AppColors.coachColorFF1B2B1B,
                      border: Border(
                        top: BorderSide(
                          color: AppColors.whiteColor.withAlpha(13),
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Summary",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.whiteColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildSummaryRow(context, "Duration", slot.duration),
                        _buildSummaryRow(context, "Date", "Mon, Mar 27"),
                        _buildSummaryRow(context, "Time", timeSlot ?? "Not selected"),
                        const Divider(color: AppColors.white10Color),
                        _buildSummaryRow(context, 
                          "Total",
                          "\$${totalAmount.toStringAsFixed(0)}",
                          isTotal: true,
                        ),
                        SizedBox(height: 20.h),
                        CustomButton(
                          onPress: timeSlot != null
                              ? () async => _showPaymentTerms(
                                  context,
                                  controller,
                                  timeSlot,
                                )
                              : null,
                          title: "Pay Now",
                          linearGradient: timeSlot != null,
                          buttonColor: timeSlot != null
                              ? AppColors.buttonColor
                              : AppColors.white10Color,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.whiteColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildPickerContainer(BuildContext context, String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withAlpha(13),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.whiteColor.withAlpha(26)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor, fontSize: 14.sp),
          ),
          Icon(icon, color: AppColors.whiteColor.withAlpha(128), size: 20.r),
        ],
      ),
    );
  }

  Widget _buildDurationCard(
    BuildContext context, String title,
    String price, {
    bool isSelected = true,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withAlpha(isSelected ? 26 : 13),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected ? AppColors.greenColor : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                price,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor.withAlpha(128),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Icon(
            Icons.access_time,
            color: AppColors.whiteColor.withAlpha(128),
            size: 18.r,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedSlot(
    BuildContext context, String slot,
    ValueNotifier<String?> selectedTimeSlot,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withAlpha(13),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            slot,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor, fontSize: 13.sp),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => selectedTimeSlot.value = null,
            child: Icon(
              Icons.cancel,
              color: AppColors.redColor.withAlpha(128),
              size: 16.r,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor.withAlpha(128),
              fontSize: 14.sp,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor,
              fontSize: 14.sp,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showSlotPicker(
    BuildContext context,
    List<String> slots,
    ValueNotifier<String?> selectedTimeSlot,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Text(
                  "Select Time Slot",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(color: AppColors.white10Color),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    final slot = slots[index];
                    return ListTile(
                      title: Text(
                        slot,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor),
                      ),
                      onTap: () {
                        selectedTimeSlot.value = slot;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentTerms(
    BuildContext context,
    CoachController controller,
    String slot,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentTermsView(controller: controller, slot: slot),
      ),
    );
  }
}

class PaymentTermsView extends StatelessWidget {
  final CoachController controller;
  final String slot;

  const PaymentTermsView({
    super.key,
    required this.controller,
    required this.slot,
  });

  @override
  Widget build(BuildContext context) {
    final agreed = ValueNotifier<bool>(false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Payment terms",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            Text(
              "1. Welcome to Ai. By using our services, you agree to abide by the terms and conditions outlined below. These terms govern your access to and\n2. use of Ai tools and services, so please review them carefully before proceeding.\n3. Ai provides innovative tools designed to enhance how you capture and manage voice recordings. Our services include voice-to-text transcription and AI-driven summarization, which are intended\n4. for lawful, ethical purposes only. You must ensure compliance with applicable laws, including obtaining consent from all participants when recording conversations. CleverTalk disclaims liability for any misuse of its tools.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor.withAlpha(179),
                fontSize: 14.sp,
                height: 2.0,
              ),
            ),
            SizedBox(height: 60.h),
          ],
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: agreed,
        builder: (context, currentAgreed, _) {
          return Container(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withAlpha(13),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Willing To Pay Now?",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Please Check Your Terms, Before Moving Forward to payment.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor.withAlpha(128),
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: currentAgreed,
                            onChanged: (v) => agreed.value = v!,
                            activeColor: AppColors.amberColor,
                            checkColor: AppColors.blackColor,
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Agree to ",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.whiteColor.withAlpha(179),
                                  ),
                                ),
                                TextSpan(
                                  text: "Payment Terms",
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.amberColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  onPress: currentAgreed
                      ? () async {
                          final success = await controller.bookSession(slot);
                          if (success && context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PaymentSuccessView(),
                              ),
                            );
                          }
                        }
                      : null,
                  title: "Continue to Pay",
                  linearGradient: currentAgreed,
                  buttonColor: currentAgreed
                      ? AppColors.buttonColor
                      : AppColors.white10Color,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 250.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://ouch-cdn2.icons8.com/6Uq6X_xX_8_Rz_Yq_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X.png',
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              Text(
                "Payment Successful",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Please Check Your Notification, We Just Sent You A Message.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor.withAlpha(128),
                  fontSize: 14.sp,
                ),
              ),
              const Spacer(),
              CustomButton(
                onPress: () async =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                title: "Got it",
                linearGradient: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduleMeetShimmer extends StatelessWidget {
  const _ScheduleMeetShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoader(width: 100.w, height: 16.h, borderRadius: 4.r),
          SizedBox(height: 12.h),
          ShimmerLoader(
            width: double.infinity,
            height: 50.h,
            borderRadius: 12.r,
          ),
          SizedBox(height: 24.h),
          ShimmerLoader(width: 100.w, height: 16.h, borderRadius: 4.r),
          SizedBox(height: 12.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: 2,
            itemBuilder: (context, index) => ShimmerLoader(
              width: double.infinity,
              height: 56.h,
              borderRadius: 12.r,
            ),
          ),
          SizedBox(height: 24.h),
          ShimmerLoader(width: 100.w, height: 16.h, borderRadius: 4.r),
          SizedBox(height: 12.h),
          ShimmerLoader(
            width: double.infinity,
            height: 50.h,
            borderRadius: 12.r,
          ),
          SizedBox(height: 24.h),
          ShimmerLoader(
            width: double.infinity,
            height: 100.h,
            borderRadius: 12.r,
          ),
        ],
      ),
    );
  }
}
