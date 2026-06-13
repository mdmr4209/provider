import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';

class ReportToAdminView extends StatelessWidget {
  final ValueNotifier<String?> _selectedReason = ValueNotifier<String?>(null);
  final TextEditingController _detailsController = TextEditingController();

  final List<String> _reasons = const ["Abuse", "Spam", "Harassment"];

  ReportToAdminView({super.key});

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
          "Report to Admin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontFamily: 'Georgia',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Select Reason"),
            GestureDetector(
              onTap: () => _showReasonPicker(context),
              child: ValueListenableBuilder<String?>(
                valueListenable: _selectedReason,
                builder: (context, selectedReason, _) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(13),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: Colors.white.withAlpha(26)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedReason ?? "Choose reason",
                          style: TextStyle(
                            color: selectedReason == null
                                ? Colors.white.withAlpha(102)
                                : Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withAlpha(128),
                          size: 16.r,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24.h),
            _buildLabel("Provide Report Details"),
            CustomInput(
              hintText: "Enter here",
              backgroundColor: Colors.white.withAlpha(13),
              borderRadius: 16,
              shadow: false,
              height: 200,
              maxLines: 8,
              controller: _detailsController,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20.r),
        child: CustomButton(
          onPress: () async {
            if (_selectedReason.value == null) return;
            Navigator.pop(context);
          },
          title: "Report",
          linearGradient: true,
        ),
      ),
    );
  }

  void _showReasonPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B2B1B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: _reasons
            .map(
              (reason) => ListTile(
                title: Text(
                  reason,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  _selectedReason.value = reason;
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withAlpha(179),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
