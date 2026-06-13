import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/coach_profile_controller.dart';

class ManageAvailabilityView extends StatelessWidget {
  const ManageAvailabilityView({super.key});

  @override
  Widget build(BuildContext context) {
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
          title: const Text("Manage availability",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Add Availability Card ---
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D3D2D).withAlpha(150),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Days of Week",
                        style: TextStyle(color: Colors.white70, fontSize: 13)),
                    SizedBox(height: 8.h),
                    _buildSelectionField(
                      context,
                      controller.selectedDay ?? "Enter here",
                      Icons.keyboard_arrow_right,
                      onTap: () => _showDayPicker(context, controller),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Start Time",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 13)),
                              SizedBox(height: 8.h),
                              _buildSelectionField(
                                context,
                                controller.selectedStartTime ?? "Enter here",
                                Icons.access_time,
                                isSmall: true,
                                onTap: () => _showTimePicker(
                                    context, controller, true),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("End Time",
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 13)),
                              SizedBox(height: 8.h),
                              _buildSelectionField(
                                context,
                                controller.selectedEndTime ?? "Enter here",
                                Icons.access_time,
                                isSmall: true,
                                onTap: () => _showTimePicker(
                                    context, controller, false),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    CustomButton(
                      onPress: () async {
                        controller.saveAvailability();
                      },
                      title: "Save Availability",
                      linearGradient: true,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),
              const Text("Current Availability",
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              SizedBox(height: 16.h),

              // --- Current Availability List ---
              ...List.generate(controller.currentAvailability.length, (index) {
                final item = controller.currentAvailability[index];
                return _buildAvailabilityTile(context, controller, item, index);
              }),

              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionField(BuildContext context, String hint, IconData icon,
      {bool isSmall = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 16.w, vertical: isSmall ? 10.h : 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2E1F),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (icon == Icons.access_time)
                  Icon(icon, color: Colors.white38, size: 16),
                if (icon == Icons.access_time) SizedBox(width: 8.w),
                Text(hint,
                    style: TextStyle(
                        color: hint == "Enter here"
                            ? Colors.white38
                            : Colors.white,
                        fontSize: 14)),
              ],
            ),
            if (icon != Icons.access_time)
              Icon(icon, color: Colors.white38, size: 18),
          ],
        ),
      ),
    );
  }

  void _showDayPicker(BuildContext context, CoachProfileController controller) {
    final days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    ];
    _showCustomPicker(context, "Select Day", days, (val) {
      controller.setAvailabilityDay(val);
    });
  }

  void _showTimePicker(
      BuildContext context, CoachProfileController controller, bool isStart) {
    final times = [
      "09:00 AM",
      "10:00 AM",
      "11:00 AM",
      "12:00 PM",
      "01:00 PM",
      "02:00 PM",
      "03:00 PM",
      "04:00 PM",
      "05:00 PM",
      "06:00 PM",
      "07:00 PM",
      "08:00 PM"
    ];
    _showCustomPicker(context, "Select Time", times, (val) {
      if (isStart) {
        controller.setStartTime(val);
      } else {
        controller.setEndTime(val);
      }
    });
  }

  void _showCustomPicker(BuildContext context, String title, List<String> items,
      Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1B2B1B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            const Divider(color: Colors.white10, height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(items[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70)),
                  onTap: () {
                    onSelect(items[index]);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityTile(BuildContext context,
      CoachProfileController controller, CoachAvailability item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D).withAlpha(150),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.day,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              SizedBox(height: 4.h),
              Text(item.timeRange,
                  style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          GestureDetector(
            onTap: () => _showDeleteConfirmation(context, controller, index),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(40),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: const Icon(Icons.close, color: Colors.redAccent, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, CoachProfileController controller, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B2B1B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Text(
              'Do you want to Delete this availability time?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A5D4A),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child:
                        const Text('No', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.removeAvailability(index);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC19E5F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Yes',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
