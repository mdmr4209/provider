import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';

class ScheduleMeetView extends StatefulWidget {
  const ScheduleMeetView({super.key});

  @override
  State<ScheduleMeetView> createState() => _ScheduleMeetViewState();
}

class _ScheduleMeetViewState extends State<ScheduleMeetView> {
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
        title: Text("Schedule Meet", style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Choose Date"),
            _buildPickerContainer("Mon, Mar 27", Icons.calendar_today_outlined),
            SizedBox(height: 24.h),
            _buildLabel("Suggestions"),
            Row(
              children: [
                Expanded(child: _buildDurationCard("30 Min", "\$75")),
                SizedBox(width: 12.w),
                Expanded(child: _buildDurationCard("60 Minutes", "\$150")),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(child: _buildDurationCard("30 Min", "\$75", isSelected: false)),
                SizedBox(width: 12.w),
                Expanded(child: _buildDurationCard("60 Minutes", "\$150", isSelected: false)),
              ],
            ),
            SizedBox(height: 24.h),
            _buildLabel("Select slot"),
            _buildPickerContainer("Choose from here", Icons.access_time),
            SizedBox(height: 16.h),
            _buildSelectedSlot("09:00 AM - 09:30 AM"),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(color: Colors.white.withAlpha(13), borderRadius: BorderRadius.circular(12.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Cancellation Policy", style: TextStyle(color: Colors.green, fontSize: 14.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Text(
                    "Amazon Alexa Shopping is seeking a talented, experienced, and self-directed UX Designer to define and drive the future of shopping at Amazon. The ideal candidate is an end-to-end UX Designer with strong visual design skills. They are passionate and have experience designing for new and ambiguous technologies. They have proven ability to motivate through vision and a desire to inspire",
                    style: TextStyle(color: Colors.white.withAlpha(179), fontSize: 12.sp, height: 1.5),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
      bottomNavigationBar: _buildSummarySection(),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildPickerContainer(String text, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(color: Colors.white.withAlpha(13), borderRadius: BorderRadius.circular(12.r), border: Border.all(color: Colors.white.withAlpha(26))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
          Icon(icon, color: Colors.white.withAlpha(128), size: 20.r),
        ],
      ),
    );
  }

  Widget _buildDurationCard(String title, String price, {bool isSelected = true}) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(isSelected ? 26 : 13),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isSelected ? Colors.green : Colors.transparent),
      ),
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

  Widget _buildSelectedSlot(String slot) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(color: Colors.white.withAlpha(13), borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(slot, style: TextStyle(color: Colors.white, fontSize: 13.sp)),
          SizedBox(width: 8.w),
          Icon(Icons.cancel, color: Colors.red.withAlpha(128), size: 16.r),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(color: const Color(0xFF1B2B1B), border: Border(top: BorderSide(color: Colors.white.withAlpha(13)))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Summery", style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 16.h),
          _buildSummaryRow("Duration", "30 min"),
          _buildSummaryRow("Date", "Wed, Mar 29"),
          _buildSummaryRow("Time", "09:00 AM - 10:00 AM"),
          const Divider(color: Colors.white10),
          _buildSummaryRow("Total", "\$565", isTotal: true),
          SizedBox(height: 20.h),
          CustomButton(onPress: () async => _showPaymentTerms(context), title: "Pay Now", linearGradient: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 14.sp)),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  void _showPaymentTerms(BuildContext context) {
     Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentTermsView()));
  }
}

class PaymentTermsView extends StatefulWidget {
  const PaymentTermsView({super.key});

  @override
  State<PaymentTermsView> createState() => _PaymentTermsViewState();
}

class _PaymentTermsViewState extends State<PaymentTermsView> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text("Payment terms", style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            Text(
              "1. Welcome to Ai. By using our services, you agree to abide by the terms and conditions outlined below. These terms govern your access to and\n2. use of Ai tools and services, so please review them carefully before proceeding.\n3. Ai provides innovative tools designed to enhance how you capture and manage voice recordings. Our services include voice-to-text transcription and AI-driven summarization, which are intended\n4. for lawful, ethical purposes only. You must ensure compliance with applicable laws, including obtaining consent from all participants when recording conversations. CleverTalk disclaims liability for any misuse of its tools.",
              style: TextStyle(color: Colors.white.withAlpha(179), fontSize: 14.sp, height: 2.0),
            ),
            SizedBox(height: 60.h),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(color: Colors.white.withAlpha(13), borderRadius: BorderRadius.circular(12.r)),
              child: Column(
                children: [
                  Text("Willing To Pay Now?", style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.h),
                  Text("Please Check Your Terms, Before Moving Forward to payment.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp)),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _agreed,
                        onChanged: (v) => setState(() => _agreed = v!),
                        activeColor: Colors.amber,
                        checkColor: Colors.black,
                      ),
                      Text.rich(TextSpan(children: [
                        TextSpan(text: "Agree to ", style: TextStyle(color: Colors.white.withAlpha(179))),
                        const TextSpan(text: "Payment Terms", style: TextStyle(color: Colors.amber)),
                      ])),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            CustomButton(
              onPress: _agreed ? () async => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentSuccessView())) : null,
              title: "Continue to Pay",
              linearGradient: _agreed,
              buttonColor: _agreed ? AppColors.buttonColor : Colors.white10,
            ),
          ],
        ),
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
              // Illustration (assuming placeholder for success image)
              Container(
                height: 250.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: NetworkImage('https://ouch-cdn2.icons8.com/6Uq6X_xX_8_Rz_Yq_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X_X.png'), fit: BoxFit.contain),
                ),
              ),
              SizedBox(height: 40.h),
              Text("Payment Successful", style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 12.h),
              Text("Please Check Your Notification, We Just Sent You A Message.", textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 14.sp)),
              const Spacer(),
              CustomButton(onPress: () async => Navigator.of(context).popUntil((route) => route.isFirst), title: "Got it", linearGradient: true),
            ],
          ),
        ),
      ),
    );
  }
}
