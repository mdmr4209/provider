import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/widgets/custom_button.dart';
import '../../../../../../core/widgets/input_text_widget.dart';
import '../../../../../../core/widgets/background_widget.dart';
import '../../../../../../core/services/api_service.dart';
import '../../../../../../routes/app_router.dart';
import '../../../../../coach/profile/controllers/coach_profile_controller.dart';
import '../../../controllers/auth_controller.dart';
import 'coach_setup_base_view.dart';

// Helper Continue Button following existing UI layout
Widget _buildContinueButton({
  required bool isEnabled,
  required VoidCallback onPress,
}) {
  return CustomButton(
    title: "Continue →",
    linearGradient: isEnabled ? true : false,
    onPress: isEnabled ? () async => onPress() : null,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. CoachWelcomeView
// ─────────────────────────────────────────────────────────────────────────────
class CoachWelcomeView extends StatelessWidget {
  const CoachWelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      imagePath: 'assets/images/bg.png',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  "Welcome 👋",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontFamily: 'Georgia',
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  "We’re excited to have you join as a coach.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontFamily: 'Georgia',
                    color: AppColors.whiteColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Let’s set up your profile so clients can find and connect with you.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textColor,
                    fontFamily: 'Segoe UI',
                  ),
                ),
                const Spacer(),
                CustomButton(
                  title: "Continue →",
                  linearGradient: true,
                  onPress: () async {
                    context.push(AppRoutes.coachBasics);
                  },
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. CoachBasicsView (Step 2/10)
// ─────────────────────────────────────────────────────────────────────────────
class CoachBasicsView extends StatelessWidget {
  const CoachBasicsView({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = context.read<CoachProfileController>();
    return CoachSetupBaseView(
      currentStep: 2,
      totalSteps: 10,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "Let’s Start With The Basics",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Georgia',
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              "Name/ Professional Alias",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            ListenableBuilder(
              listenable: profileController.nameController,
              builder: (context, _) {
                return InputTextWidget(
                  hintText: "How you want to be addressed?",
                  controller: profileController.nameController,
                  onChanged: (_) {}, // Let controller handle it
                );
              },
            ),
            SizedBox(height: 24.h),
            Text(
              "Location (Optional)",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            InputTextWidget(
              hintText: "City level — useful for time zones",
              controller: profileController.locationController,
            ),
            const Spacer(),
            ListenableBuilder(
              listenable: profileController.nameController,
              builder: (context, _) {
                final isNameEntered = profileController.nameController.text
                    .trim()
                    .isNotEmpty;
                return _buildContinueButton(
                  isEnabled: isNameEntered,
                  onPress: () {
                    // Update main AuthController name as well
                    context.read<AuthController>().nameController.text =
                        profileController.nameController.text.trim();
                    context.push(AppRoutes.coachMatch);
                  },
                );
              },
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. CoachMatchView (Step 3/10)
// ─────────────────────────────────────────────────────────────────────────────
class CoachMatchView extends StatelessWidget {
  const CoachMatchView({super.key});

  static const List<String> specialties = [
    "Relationship Coaching",
    "Life Coaching",
    "Career Coaching",
    "Health & Wellness",
    "Divorce Support",
    "Anxiety & Stress Management",
    "Personal Growth",
    "Communication Skills",
  ];

  void _showExperiencePicker(
    BuildContext context,
    CoachProfileController controller,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.popupBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        final List<String> options = [
          "Under 1 Year",
          "1-3 Years",
          "3-5 Years",
          "5-10 Years",
          "10+ Years",
        ];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Text(
                  "Years of Experience",
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(color: AppColors.dividerColor.withAlpha(100), height: 1),
              ...options.map(
                (opt) => ListTile(
                  title: Text(
                    opt,
                    style: TextStyle(
                      color: opt == controller.selectedExperience
                          ? AppColors.iconColor
                          : AppColors.textColor,
                      fontWeight: opt == controller.selectedExperience
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: opt == controller.selectedExperience
                      ? Icon(Icons.check, color: AppColors.iconColor)
                      : null,
                  onTap: () {
                    controller.setSelectedExperience(opt);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCheckbox({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Row(
          children: [
            Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? AppColors.iconColor
                      : AppColors.inputBorderColor,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(4.r),
                color: isSelected ? AppColors.iconColor : Colors.transparent,
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 14.r,
                      color: AppColors.backgroundColor,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.iconColor : AppColors.textColor,
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadedFile(String fileName, VoidCallback onDelete) {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.buttonColor4,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.buttonBorderColor4),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: AppColors.greenColor.withAlpha(40),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Icon(
              Icons.insert_drive_file,
              color: AppColors.greenColor,
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              fileName,
              style: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.close,
              color: AppColors.textColor.withAlpha(150),
              size: 18.r,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CoachProfileController>();

    final bool isContinueEnabled =
        controller.selectedSpecialties.isNotEmpty &&
        controller.selectedExperience != "Select Experience" &&
        controller.uploadedFiles.isNotEmpty;

    return CoachSetupBaseView(
      currentStep: 3,
      totalSteps: 10,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                "Help Us Match You With The Right Client",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: 'Georgia',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "Primary Specialty (Select multiple)",
                style: TextStyle(
                  color: AppColors.textColor.withAlpha(200),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              ...specialties.map(
                (spec) => _buildCheckbox(
                  label: spec,
                  isSelected: controller.selectedSpecialties.contains(spec),
                  onTap: () {
                    controller.toggleSpecialty(spec);
                  },
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Year of Experience",
                style: TextStyle(
                  color: AppColors.textColor.withAlpha(200),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () => _showExperiencePicker(context, controller),
                child: Container(
                  height: 56.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.buttonColor4,
                    border: Border.all(color: AppColors.buttonBorderColor4),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.selectedExperience,
                        style: TextStyle(
                          color:
                              controller.selectedExperience ==
                                  "Select Experience"
                              ? AppColors.hintTextColor
                              : AppColors.textColor,
                          fontSize: 16.sp,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: AppColors.textColor),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "Certification/Education",
                style: TextStyle(
                  color: AppColors.textColor.withAlpha(200),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              if (controller.uploadedFiles.isEmpty && !controller.isUploading)
                GestureDetector(
                  onTap: () => controller.simulateUpload(() {}),
                  child: Container(
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: AppColors.buttonColor4,
                      border: Border.all(color: AppColors.buttonBorderColor4),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor3,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.upload,
                                color: AppColors.backgroundColor,
                                size: 16.r,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "Upload",
                                style: TextStyle(
                                  color: AppColors.backgroundColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          "Click to upload files",
                          style: TextStyle(
                            color: AppColors.hintTextColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (controller.isUploading)
                Container(
                  height: 56.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.buttonColor4,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: CircularProgressIndicator(
                      color: AppColors.iconColor,
                      strokeWidth: 2,
                    ),
                  ),
                )
              else
                ...controller.uploadedFiles.map(
                  (file) => _buildUploadedFile(file, () {
                    controller.removeUploadedFile(file);
                  }),
                ),
              SizedBox(height: 40.h),
              _buildContinueButton(
                isEnabled: isContinueEnabled,
                onPress: () => context.push(AppRoutes.coachStyle),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. CoachStyleView (Step 4/10)
// ─────────────────────────────────────────────────────────────────────────────
class CoachStyleView extends StatelessWidget {
  const CoachStyleView({super.key});

  static const List<String> styles = [
    "Direct and Honest",
    "Empathetic and soft",
    "Data-Driven",
    "Spiritual",
    "Action-Oriented",
  ];

  Widget _buildCheckbox({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: Row(
          children: [
            Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? AppColors.iconColor
                      : AppColors.inputBorderColor,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(4.r),
                color: isSelected ? AppColors.iconColor : Colors.transparent,
              ),
              alignment: Alignment.center,
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 14.r,
                      color: AppColors.backgroundColor,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.iconColor : AppColors.textColor,
                fontSize: 16.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CoachProfileController>();
    return CoachSetupBaseView(
      currentStep: 4,
      totalSteps: 10,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "Tell Us About Your Coaching Style",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Georgia',
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "My Coaching Style",
              style: TextStyle(
                color: AppColors.textColor.withAlpha(200),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            ...styles.map(
              (style) => _buildCheckbox(
                label: style,
                isSelected: controller.selectedCoachingStyles.contains(style),
                onTap: () {
                  controller.toggleCoachingStyle(style);
                },
              ),
            ),
            const Spacer(),
            _buildContinueButton(
              isEnabled: controller.selectedCoachingStyles.isNotEmpty,
              onPress: () => context.push(AppRoutes.coachPitchBio),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4.1. CoachPitchBioView (Step 5/10)
// ─────────────────────────────────────────────────────────────────────────────
class CoachPitchBioView extends StatelessWidget {
  const CoachPitchBioView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CoachProfileController>();
    return CoachSetupBaseView(
      currentStep: 5,
      totalSteps: 10,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "This is What Clients Will See Before Reaching Out",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Georgia',
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              "Elevator Pitch (Max 250 characters)",
              style: TextStyle(
                color: AppColors.textColor.withAlpha(200),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            ListenableBuilder(
              listenable: controller.pitchController,
              builder: (context, _) => InputTextWidget(
                hintText: "In one sentence, how do you help people?",
                controller: controller.pitchController,
                keyboardType: TextInputType.multiline,
                onChanged: (_) {},
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "Bio",
              style: TextStyle(
                color: AppColors.textColor.withAlpha(200),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            ListenableBuilder(
              listenable: controller.bioController,
              builder: (context, _) => InputTextWidget(
                hintText: "A deeper dive into your philosophy",
                controller: controller.bioController,
                keyboardType: TextInputType.multiline,
                onChanged: (_) {},
              ),
            ),
            const Spacer(),
            ListenableBuilder(
              listenable: Listenable.merge([
                controller.pitchController,
                controller.bioController,
              ]),
              builder: (context, _) => _buildContinueButton(
                isEnabled:
                    controller.pitchController.text.trim().isNotEmpty &&
                    controller.bioController.text.trim().isNotEmpty,
                onPress: () => context.push(AppRoutes.coachAvailability),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4.2. CoachAvailabilityView (Step 6/10)
// ─────────────────────────────────────────────────────────────────────────────
class CoachAvailabilityView extends StatelessWidget {
  const CoachAvailabilityView({super.key});

  void _showDayPicker(BuildContext context, CoachProfileController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.popupBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        final List<String> days = [
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday",
          "Sunday",
        ];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: days
                .map(
                  (d) => ListTile(
                    title: Text(
                      d,
                      style: const TextStyle(color: AppColors.textColor),
                    ),
                    onTap: () {
                      controller.updateAvailabilityField(day: d);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void _showTimePicker(
    BuildContext context,
    CoachProfileController controller,
    bool isStart,
    bool isOnTab,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.popupBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        final List<String> times = [
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
        ];
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: times
                .map(
                  (t) => ListTile(
                    title: Text(
                      t,
                      style: const TextStyle(color: AppColors.textColor),
                    ),
                    onTap: () {
                      if (isOnTab) {
                        if (isStart)
                          controller.updateAvailabilityField(onStart: t);
                        else
                          controller.updateAvailabilityField(onEnd: t);
                      } else {
                        if (isStart)
                          controller.updateAvailabilityField(offStart: t);
                        else
                          controller.updateAvailabilityField(offEnd: t);
                      }
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void _showDatePicker(CoachProfileController controller, bool isFrom) {
    if (isFrom)
      controller.updateAvailabilityField(fromDate: "31/08/2026");
    else
      controller.updateAvailabilityField(toDate: "31/08/2026");
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CoachProfileController>();
    return CoachSetupBaseView(
      currentStep: 6,
      totalSteps: 10,
      title: "Manage availability",
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            // Custom Tab Bar
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.toggleIsOnDays(true),
                    child: Column(
                      children: [
                        Text(
                          "On Days",
                          style: TextStyle(
                            color: controller.isOnDays
                                ? AppColors.iconColor
                                : AppColors.textColor.withAlpha(150),
                            fontSize: 16.sp,
                            fontWeight: controller.isOnDays
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 2.h,
                          color: controller.isOnDays
                              ? AppColors.iconColor
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.toggleIsOnDays(false),
                    child: Column(
                      children: [
                        Text(
                          "Off Days",
                          style: TextStyle(
                            color: !controller.isOnDays
                                ? AppColors.iconColor
                                : AppColors.textColor.withAlpha(150),
                            fontSize: 16.sp,
                            fontWeight: !controller.isOnDays
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 2.h,
                          color: !controller.isOnDays
                              ? AppColors.iconColor
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: SingleChildScrollView(
                child: controller.isOnDays
                    ? _buildOnDaysTab(context, controller)
                    : _buildOffDaysTab(context, controller),
              ),
            ),
            _buildContinueButton(
              isEnabled: true,
              onPress: () => context.push(AppRoutes.coachRatesServices),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOnDaysTab(
    BuildContext context,
    CoachProfileController controller,
  ) {
    final bool canSave =
        controller.setupSelectedDay != "Enter here" &&
        controller.onStartTime != "Enter here" &&
        controller.onEndTime != "Enter here";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.buttonColor4.withAlpha(50),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.buttonBorderColor4.withAlpha(50),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Days of Week",
                style: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () => _showDayPicker(context, controller),
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: AppColors.buttonColor4,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.buttonBorderColor4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        controller.setupSelectedDay,
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14.sp,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: AppColors.textColor,
                        size: 20.r,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Time",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () =>
                              _showTimePicker(context, controller, true, true),
                          child: Container(
                            height: 48.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: AppColors.buttonColor4,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.buttonBorderColor4,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: AppColors.textColor,
                                  size: 18.r,
                                ),
                                Text(
                                  controller.onStartTime,
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "End Time",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () =>
                              _showTimePicker(context, controller, false, true),
                          child: Container(
                            height: 48.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: AppColors.buttonColor4,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.buttonBorderColor4,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: AppColors.textColor,
                                  size: 18.r,
                                ),
                                Text(
                                  controller.onEndTime,
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              CustomButton(
                title: "Save Availability",
                buttonColor: canSave
                    ? AppColors.iconColor
                    : AppColors.buttonColor4,
                textColor: canSave
                    ? Colors.white
                    : AppColors.whiteColor.withAlpha(100),
                onPress: canSave
                    ? () async {
                        controller.saveSetupOnDay();
                      }
                    : null,
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          "Current Availability",
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        ...controller.onDaysList.map(
          (item) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.buttonColor4.withAlpha(30),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.buttonBorderColor4.withAlpha(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["day"]!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item["time"]!,
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => controller.removeSetupOnDay(item),
                  child: Icon(
                    Icons.cancel,
                    color: Colors.redAccent.withAlpha(200),
                    size: 22.r,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOffDaysTab(
    BuildContext context,
    CoachProfileController controller,
  ) {
    final bool canSave =
        controller.selectedFromDate != "Select one" &&
        controller.selectedToDate != "Select one" &&
        controller.offStartTime != "Enter here" &&
        controller.offEndTime != "Enter here";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.buttonColor4.withAlpha(50),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.buttonBorderColor4.withAlpha(50),
            ),
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
                        Text(
                          "From",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => _showDatePicker(controller, true),
                          child: Container(
                            height: 48.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: AppColors.buttonColor4,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.buttonBorderColor4,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: AppColors.textColor,
                                  size: 18.r,
                                ),
                                Text(
                                  controller.selectedFromDate,
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Start Time",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () =>
                              _showTimePicker(context, controller, true, false),
                          child: Container(
                            height: 48.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: AppColors.buttonColor4,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.buttonBorderColor4,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: AppColors.textColor,
                                  size: 18.r,
                                ),
                                Text(
                                  controller.offStartTime,
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "To",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => _showDatePicker(controller, false),
                          child: Container(
                            height: 48.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: AppColors.buttonColor4,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.buttonBorderColor4,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: AppColors.textColor,
                                  size: 18.r,
                                ),
                                Text(
                                  controller.selectedToDate,
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "End Time",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => _showTimePicker(
                            context,
                            controller,
                            false,
                            false,
                          ),
                          child: Container(
                            height: 48.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: AppColors.buttonColor4,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.buttonBorderColor4,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: AppColors.textColor,
                                  size: 18.r,
                                ),
                                Text(
                                  controller.offEndTime,
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              CustomButton(
                title: "Save Availability",
                buttonColor: canSave
                    ? AppColors.iconColor
                    : AppColors.buttonColor4,
                textColor: canSave
                    ? Colors.white
                    : AppColors.whiteColor.withAlpha(100),
                onPress: canSave
                    ? () async {
                        controller.saveSetupOffDay();
                      }
                    : null,
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          "Current Unavailability",
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        ...controller.offDaysList.map(
          (item) => Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.buttonColor4.withAlpha(30),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.buttonBorderColor4.withAlpha(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Starts  ",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          item["start"]!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          "Ends    ",
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          item["end"]!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => controller.removeSetupOffDay(item),
                  child: Icon(
                    Icons.cancel,
                    color: Colors.redAccent.withAlpha(200),
                    size: 22.r,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4.3. CoachRatesServicesView (Step 7/10)
// ─────────────────────────────────────────────────────────────────────────────
class CoachRatesServicesView extends StatelessWidget {
  const CoachRatesServicesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<CoachProfileController>();
    return CoachSetupBaseView(
      currentStep: 7,
      totalSteps: 10,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Text(
                "This is What Clients Will See Before Reaching Out",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: 'Georgia',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "Per Minute Rate",
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              InputTextWidget(
                hintText: "Rate per minute",
                controller: controller.perMinuteRateController,
              ),
              SizedBox(height: 16.h),
              Text(
                "Per Text Rate",
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              InputTextWidget(
                hintText: "Rate per text message",
                controller: controller.perTextRateController,
              ),
              SizedBox(height: 16.h),
              Text(
                "Cancellation Policy",
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              InputTextWidget(
                hintText: "Write cancellation policy",
                controller: controller.cancellationPolicyController,
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: 16.h),
              Text(
                "Accept Cancellation Prior",
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              InputTextWidget(
                hintText: "Prior window (e.g. 48h)",
                controller: controller.cancellationPriorController,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Service List",
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.addServiceOption();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.buttonColor4,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.buttonBorderColor4),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: AppColors.textColor,
                            size: 16.r,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Add Option",
                            style: TextStyle(
                              color: AppColors.textColor,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ...controller.services.asMap().entries.map(
                (entry) => _buildServiceOptionCard(
                  context,
                  controller,
                  entry.key,
                  entry.value,
                ),
              ),
              SizedBox(height: 32.h),
              CustomButton(
                title: "Confirm and Save",
                linearGradient: true,
                onPress: () async {
                  context.push(AppRoutes.setup11);
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceOptionCard(
    BuildContext context,
    CoachProfileController controller,
    int index,
    CoachServiceOption opt,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.buttonColor4.withAlpha(40),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.buttonBorderColor4.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                opt.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Active",
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    height: 20.h,
                    child: Switch(
                      value: opt.isActive,
                      activeColor: AppColors.iconColor,
                      onChanged: (val) {
                        // Fixed by agent
                        controller.updateServiceOption(opt, isActive: val);
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () => controller.removeServiceOption(index),
                    child: Icon(
                      Icons.delete,
                      color: Colors.redAccent.withAlpha(200),
                      size: 20.r,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            "Duration",
            style: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
          ),
          SizedBox(height: 6.h),
          InputTextWidget(
            hintText: "Enter here",
            controller:
                TextEditingController(
                    text: opt.duration == "Enter here" ? "" : opt.duration,
                  )
                  ..selection = TextSelection.collapsed(
                    offset: (opt.duration == "Enter here" ? "" : opt.duration)
                        .length,
                  ),
            onChanged: (val) {
              controller.updateServiceOption(opt, duration: val);
            },
          ),
          SizedBox(height: 12.h),
          Text(
            "Price",
            style: TextStyle(color: AppColors.textColor, fontSize: 14.sp),
          ),
          SizedBox(height: 6.h),
          InputTextWidget(
            hintText: "Enter here",
            controller:
                TextEditingController(
                    text: opt.price == "Enter here" ? "" : opt.price,
                  )
                  ..selection = TextSelection.collapsed(
                    offset: (opt.price == "Enter here" ? "" : opt.price).length,
                  ),
            onChanged: (val) {
              controller.updateServiceOption(opt, price: val);
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. CoachSetupCompleteView
// ─────────────────────────────────────────────────────────────────────────────
class CoachSetupCompleteView extends StatelessWidget {
  const CoachSetupCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    final name = context.watch<AuthController>().nameController.text.trim();
    return BackgroundWidget(
      imagePath: 'assets/images/bg.png',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 160.r,
                    height: 160.r,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC9A84C).withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 130.r,
                    height: 130.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC9A84C),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(AppAssets.logo, width: 80.r),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        "✨ 🎉 🥳",
                        style: TextStyle(fontSize: 100.sp),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),
              Text(
                "Your Profile is Complete",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontFamily: 'Georgia',
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  "Welcome, ${name.isNotEmpty ? name : "Coach"}. Your profile has been created successfully. Let's start connecting you with clients who need your support!✨",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textColor,
                    fontFamily: 'Segoe UI',
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomButton(
                  height: 56.h,
                  title: "Go to Home →",
                  linearGradient: true,
                  buttonColor: const Color(0xFFC9A84C),
                  textColor: Colors.white,
                  onPress: () async {
                    final router = GoRouter.of(context);
                    await ApiService.store(
                      key: 'show_nav_guide',
                      value: 'true',
                    );
                    router.go(AppRoutes.home);
                  },
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
