import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_profile_controller.dart';

class ManageAvailabilityView extends StatelessWidget {
  const ManageAvailabilityView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CoachProfileController>();

    return BackgroundWidget(
      imagePath: AppAssets.bgMain,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.west, color: Color(0xFF5E7958), size: 24),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Manage availability',
            style: TextStyle(
              color: Color(0xFFF5F0E8),
              fontSize: 16,
              fontFamily: 'Georgia',
              fontWeight: FontWeight.w400,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 1500)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSkeletonLoader();
            }
            return SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Tabs ---
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.toggleIsOnDays(true),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "On Days", 
                              style: TextStyle(
                                color: controller.isOnDays ? Colors.white : Colors.white70, 
                                fontWeight: controller.isOnDays ? FontWeight.bold : FontWeight.normal
                              )
                            ),
                            if (controller.isOnDays) Container(margin: const EdgeInsets.only(top: 4), height: 2, width: 40, color: const Color(0xFFC19E5F)),
                          ],
                        ),
                      ),
                      SizedBox(width: 24.w),
                      GestureDetector(
                        onTap: () => controller.toggleIsOnDays(false),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Off Days", 
                              style: TextStyle(
                                color: !controller.isOnDays ? Colors.white : Colors.white70, 
                                fontWeight: !controller.isOnDays ? FontWeight.bold : FontWeight.normal
                              )
                            ),
                            if (!controller.isOnDays) Container(margin: const EdgeInsets.only(top: 4), height: 2, width: 45, color: const Color(0xFFC19E5F)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  
                  if (controller.isOnDays) _buildOnDays(context, controller) else _buildOffDays(context, controller),

                  SizedBox(height: 100.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOnDays(BuildContext context, CoachProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              const Text("Days of Week", style: TextStyle(color: Colors.white70, fontSize: 13)),
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
                        const Text("Start Time", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        SizedBox(height: 8.h),
                        _buildSelectionField(
                          context,
                          controller.selectedStartTime ?? "Enter here",
                          Icons.access_time,
                          isSmall: true,
                          onTap: () => _showTimePicker(context, controller, true),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("End Time", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        SizedBox(height: 8.h),
                        _buildSelectionField(
                          context,
                          controller.selectedEndTime ?? "Enter here",
                          Icons.access_time,
                          isSmall: true,
                          onTap: () => _showTimePicker(context, controller, false),
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
        const Text("Current Availability", style: TextStyle(color: Colors.white70, fontSize: 14)),
        SizedBox(height: 16.h),
        ...List.generate(controller.currentAvailability.length, (index) {
          final item = controller.currentAvailability[index];
          return _buildAvailabilityTile(context, controller, item, index);
        }),
      ],
    );
  }

  Widget _buildOffDays(BuildContext context, CoachProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("From", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        SizedBox(height: 8.h),
                        _buildSelectionField(
                          context,
                          controller.selectedFromDate,
                          Icons.keyboard_arrow_right,
                          onTap: () => _showDatePicker(context, controller, true),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Start Time", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        SizedBox(height: 8.h),
                        _buildSelectionField(
                          context,
                          controller.offStartTime,
                          Icons.access_time,
                          isSmall: true,
                          onTap: () => _showTimePickerOff(context, controller, true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("To", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        SizedBox(height: 8.h),
                        _buildSelectionField(
                          context,
                          controller.selectedToDate,
                          Icons.keyboard_arrow_right,
                          onTap: () => _showDatePicker(context, controller, false),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("End Time", style: TextStyle(color: Colors.white70, fontSize: 13)),
                        SizedBox(height: 8.h),
                        _buildSelectionField(
                          context,
                          controller.offEndTime,
                          Icons.access_time,
                          isSmall: true,
                          onTap: () => _showTimePickerOff(context, controller, false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              CustomButton(
                onPress: () async {
                  controller.saveSetupOffDay();
                },
                title: "Save Availability",
                linearGradient: true,
              ),
            ],
          ),
        ),

        SizedBox(height: 32.h),
        const Text("Current Unavailability", style: TextStyle(color: Colors.white70, fontSize: 14)),
        SizedBox(height: 16.h),

        ...List.generate(controller.offDaysList.length, (index) {
          final item = controller.offDaysList[index];
          return _buildOffDayTile(context, controller, item, index);
        }),
      ],
    );
  }

  Widget _buildSelectionField(BuildContext context, String hint, IconData icon, {bool isSmall = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isSmall ? 10.h : 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2E1F),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  if (icon == Icons.access_time) const Icon(Icons.access_time, color: Colors.white38, size: 16),
                  if (icon == Icons.access_time) SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: hint == "Enter here" || hint == "Select one" ? Colors.white38 : Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (icon != Icons.access_time) Icon(icon, color: Colors.white38, size: 18),
          ],
        ),
      ),
    );
  }

  void _showDayPicker(BuildContext context, CoachProfileController controller) {
    final days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    _showCustomPicker(context, "Select Day", days, (val) => controller.setAvailabilityDay(val));
  }

  void _showTimePicker(BuildContext context, CoachProfileController controller, bool isStart) {
    final times = ["09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM", "05:00 PM", "06:00 PM", "07:00 PM", "08:00 PM"];
    _showCustomPicker(context, "Select Time", times, (val) {
      if (isStart) controller.setStartTime(val);
      else controller.setEndTime(val);
    });
  }

  void _showTimePickerOff(BuildContext context, CoachProfileController controller, bool isStart) {
    final times = ["09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM", "05:00 PM", "06:00 PM", "07:00 PM", "08:00 PM"];
    _showCustomPicker(context, "Select Time", times, (val) {
      if (isStart) controller.updateAvailabilityField(offStart: val);
      else controller.updateAvailabilityField(offEnd: val);
    });
  }

  Future<void> _showDatePicker(BuildContext context, CoachProfileController controller, bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFC19E5F),
              onPrimary: Colors.white,
              surface: Color(0xFF1B2B1B),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      final formatted = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      if (isStart) {
        controller.updateAvailabilityField(fromDate: formatted);
      } else {
        controller.updateAvailabilityField(toDate: formatted);
      }
    }
  }

  void _showCustomPicker(BuildContext context, String title, List<String> items, Function(String) onSelect) {
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
              child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const Divider(color: Colors.white10, height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(items[index], textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70)),
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

  Widget _buildAvailabilityTile(BuildContext context, CoachProfileController controller, CoachAvailability item, int index) {
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
              Text(item.day, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 4.h),
              Text(item.timeRange, style: const TextStyle(color: Colors.white38, fontSize: 12)),
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

  Widget _buildOffDayTile(BuildContext context, CoachProfileController controller, Map<String, String> item, int index) {
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
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Starts", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      SizedBox(height: 4.h),
                      Text(item['start'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Ends", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      SizedBox(height: 4.h),
                      Text(item['end'] ?? '', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: () {
              controller.removeSetupOffDay(item);
            },
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

  void _showDeleteConfirmation(BuildContext context, CoachProfileController controller, int index) {
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
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A5D4A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('No', style: TextStyle(color: Colors.white)),
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Yes', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerLoader(width: double.infinity, height: 280.h, borderRadius: 16.r),
          SizedBox(height: 32.h),
          ShimmerLoader(width: 150.w, height: 16.h),
          SizedBox(height: 16.h),
          ...List.generate(3, (_) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: ShimmerLoader(width: double.infinity, height: 72.h, borderRadius: 12.r),
          )),
        ],
      ),
    );
  }
}
