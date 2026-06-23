import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/input_text_widget.dart';
import '../../../../../core/widgets/background_widget.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../routes/app_router.dart';
import '../../controllers/auth_controller.dart';
import 'setup_base_view.dart';

// Helper Continue Button following existing UI layout
Widget _buildContinueButton({
  required bool isEnabled,
  required VoidCallback onPress,
}) {
  return CustomButton(
    title: "Continue →",
    linearGradient: isEnabled,
    buttonColor: isEnabled ? AppColors.buttonColor3 : AppColors.buttonColor4,
    textColor: isEnabled ? AppColors.textColor3 : AppColors.whiteColor,
    borderColor: isEnabled ? Colors.transparent : AppColors.buttonBorderColor4,
    borderShadowColor: isEnabled
        ? Colors.transparent
        : AppColors.buttonShadowColor4,
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
class CoachBasicsView extends StatefulWidget {
  const CoachBasicsView({super.key});

  @override
  State<CoachBasicsView> createState() => _CoachBasicsViewState();
}

class _CoachBasicsViewState extends State<CoachBasicsView> {
  final nameController = TextEditingController();
  final locationController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
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
            InputTextWidget(
              hintText: "How you want to be addressed?",
              controller: nameController,
              onChanged: (_) => setState(() {}),
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
              controller: locationController,
              onChanged: (_) => setState(() {}),
            ),
            const Spacer(),
            ListenableBuilder(
              listenable: nameController,
              builder: (context, _) {
                final isNameEntered = nameController.text.trim().isNotEmpty;
                return _buildContinueButton(
                  isEnabled: isNameEntered,
                  onPress: () {
                    // Update main AuthController name as well
                    context.read<AuthController>().nameController.text =
                        nameController.text.trim();
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
class CoachMatchView extends StatefulWidget {
  const CoachMatchView({super.key});

  @override
  State<CoachMatchView> createState() => _CoachMatchViewState();
}

class _CoachMatchViewState extends State<CoachMatchView> {
  final List<String> specialties = [
    "Relationship Coaching",
    "Life Coaching",
    "Career Coaching",
    "Health & Wellness",
    "Divorce Support",
    "Anxiety & Stress Management",
    "Personal Growth",
    "Communication Skills",
  ];

  final Set<String> selectedSpecialties = {};
  String selectedExperience = "Select Experience";
  final List<String> uploadedFiles = [];
  bool isUploading = false;

  void _showExperiencePicker() {
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: opt == selectedExperience
                          ? AppColors.iconColor
                          : AppColors.textColor,
                      fontWeight: opt == selectedExperience
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: opt == selectedExperience
                      ? Icon(Icons.check, color: AppColors.iconColor)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedExperience = opt;
                    });
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

  Future<void> _simulateUpload() async {
    setState(() {
      isUploading = true;
    });
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() {
        isUploading = false;
        uploadedFiles.add("RYT 200 Yoga Certification");
      });
    }
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textColor, fontSize: 14.sp),
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
    final bool isContinueEnabled =
        selectedSpecialties.isNotEmpty &&
        selectedExperience != "Select Experience" &&
        uploadedFiles.isNotEmpty;

    return SetupBaseView(
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textColor.withAlpha(200),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16.h),
              ...specialties.map(
                (spec) => _buildCheckbox(
                  label: spec,
                  isSelected: selectedSpecialties.contains(spec),
                  onTap: () {
                    setState(() {
                      if (selectedSpecialties.contains(spec)) {
                        selectedSpecialties.remove(spec);
                      } else {
                        selectedSpecialties.add(spec);
                      }
                    });
                  },
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Year of Experience",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textColor.withAlpha(200),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _showExperiencePicker,
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
                        selectedExperience,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: selectedExperience == "Select Experience"
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textColor.withAlpha(200),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              if (uploadedFiles.isEmpty && !isUploading)
                GestureDetector(
                  onTap: _simulateUpload,
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
                                Icons.upload_file,
                                color: AppColors.whiteColor,
                                size: 18.r,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                "Upload",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.whiteColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          "Click to upload files",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.hintTextColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (isUploading)
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
                ...uploadedFiles.map(
                  (file) => _buildUploadedFile(file, () {
                    setState(() {
                      uploadedFiles.remove(file);
                    });
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
class CoachStyleView extends StatefulWidget {
  const CoachStyleView({super.key});

  @override
  State<CoachStyleView> createState() => _CoachStyleViewState();
}

class _CoachStyleViewState extends State<CoachStyleView> {
  final List<String> styles = [
    "Direct and Honest",
    "Empathetic and soft",
    "Data-Driven",
    "Spiritual",
    "Action-Oriented",
  ];

  final Set<String> selectedStyles = {};

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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    return SetupBaseView(
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textColor.withAlpha(200),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            ...styles.map(
              (style) => _buildCheckbox(
                label: style,
                isSelected: selectedStyles.contains(style),
                onTap: () {
                  setState(() {
                    if (selectedStyles.contains(style)) {
                      selectedStyles.remove(style);
                    } else {
                      selectedStyles.add(style);
                    }
                  });
                },
              ),
            ),
            const Spacer(),
            _buildContinueButton(
              isEnabled: selectedStyles.isNotEmpty,
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
class CoachPitchBioView extends StatefulWidget {
  const CoachPitchBioView({super.key});

  @override
  State<CoachPitchBioView> createState() => _CoachPitchBioViewState();
}

class _CoachPitchBioViewState extends State<CoachPitchBioView> {
  final pitchController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void dispose() {
    pitchController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textColor.withAlpha(200),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            InputTextWidget(
              hintText: "In one sentence, how do you help people?",
              controller: pitchController,
              keyboardType: TextInputType.multiline,
              onChanged: (_) => setState(() {}),
            ),
            SizedBox(height: 24.h),
            Text(
              "Bio",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textColor.withAlpha(200),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            InputTextWidget(
              hintText: "A deeper dive into your philosophy",
              controller: bioController,
              keyboardType: TextInputType.multiline,
              onChanged: (_) => setState(() {}),
            ),
            const Spacer(),
            _buildContinueButton(
              isEnabled:
                  pitchController.text.trim().isNotEmpty &&
                  bioController.text.trim().isNotEmpty,
              onPress: () => context.push(AppRoutes.coachAvailability),
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
class CoachAvailabilityView extends StatefulWidget {
  const CoachAvailabilityView({super.key});

  @override
  State<CoachAvailabilityView> createState() => _CoachAvailabilityViewState();
}

class _CoachAvailabilityViewState extends State<CoachAvailabilityView> {
  bool isOnDays = true;

  // On Days State
  String selectedDay = "Enter here";
  String onStartTime = "Enter here";
  String onEndTime = "Enter here";
  final List<Map<String, String>> onDaysList = [
    {"day": "Monday", "time": "09:00 AM - 12:00 PM"},
    {"day": "Monday", "time": "09:00 AM - 12:00 PM"},
    {"day": "Tuesday", "time": "09:00 AM - 12:00 PM"},
    {"day": "Tuesday", "time": "09:00 AM - 12:00 PM"},
    {"day": "Tuesday", "time": "09:00 AM - 12:00 PM"},
  ];

  // Off Days State
  String selectedFromDate = "Select one";
  String selectedToDate = "Select one";
  String offStartTime = "Enter here";
  String offEndTime = "Enter here";
  final List<Map<String, String>> offDaysList = [
    {"start": "31/08/2026; 12:00PM", "end": "31/08/2026; 12:00PM"},
    {"start": "31/08/2026; 12:00PM", "end": "31/08/2026; 12:00PM"},
    {"start": "31/08/2026; 12:00PM", "end": "31/08/2026; 12:00PM"},
    {"start": "31/08/2026; 12:00PM", "end": "31/08/2026; 12:00PM"},
  ];

  void _showDayPicker() {
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textColor),
                    ),
                    onTap: () {
                      setState(() => selectedDay = d);
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

  void _showTimePicker(bool isStart, bool isOnTab) {
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textColor),
                    ),
                    onTap: () {
                      setState(() {
                        if (isOnTab) {
                          if (isStart) {
                            onStartTime = t;
                          } else {
                            onEndTime = t;
                          }
                        } else {
                          if (isStart) {
                            offStartTime = t;
                          } else {
                            offEndTime = t;
                          }
                        }
                      });
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

  void _showDatePicker(bool isFrom) {
    setState(() {
      if (isFrom) {
        selectedFromDate = "31/08/2026";
      } else {
        selectedToDate = "31/08/2026";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
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
                    onTap: () => setState(() => isOnDays = true),
                    child: Column(
                      children: [
                        Text(
                          "On Days",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isOnDays
                                ? AppColors.iconColor
                                : AppColors.textColor.withAlpha(150),
                            fontSize: 16.sp,
                            fontWeight: isOnDays
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 2.h,
                          color: isOnDays
                              ? AppColors.iconColor
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isOnDays = false),
                    child: Column(
                      children: [
                        Text(
                          "Off Days",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: !isOnDays
                                ? AppColors.iconColor
                                : AppColors.textColor.withAlpha(150),
                            fontSize: 16.sp,
                            fontWeight: !isOnDays
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          height: 2.h,
                          color: !isOnDays
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
                child: isOnDays ? _buildOnDaysTab() : _buildOffDaysTab(),
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

  Widget _buildOnDaysTab() {
    final bool canSave =
        selectedDay != "Enter here" &&
        onStartTime != "Enter here" &&
        onEndTime != "Enter here";

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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textColor, fontSize: 14.sp),
              ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _showDayPicker,
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
                        selectedDay,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => _showTimePicker(true, true),
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
                                  onStartTime,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => _showTimePicker(false, true),
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
                                  onEndTime,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    ? AppColors.whiteColor
                    : AppColors.whiteColor.withAlpha(100),
                onPress: canSave
                    ? () async {
                        setState(() {
                          onDaysList.add({
                            "day": selectedDay,
                            "time": "$onStartTime - $onEndTime",
                          });
                          selectedDay = "Enter here";
                          onStartTime = "Enter here";
                          onEndTime = "Enter here";
                        });
                      }
                    : null,
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          "Current Availability",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        ...onDaysList.map(
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item["time"]!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => setState(() => onDaysList.remove(item)),
                  child: Icon(
                    Icons.cancel,
                    color: AppColors.redAccentColor.withAlpha(200),
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

  Widget _buildOffDaysTab() {
    final bool canSave =
        selectedFromDate != "Select one" &&
        selectedToDate != "Select one" &&
        offStartTime != "Enter here" &&
        offEndTime != "Enter here";

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
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => _showDatePicker(true),
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
                                  selectedFromDate,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => _showTimePicker(true, false),
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
                                  offStartTime,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => _showDatePicker(false),
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
                                  selectedToDate,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textColor,
                            fontSize: 14.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => _showTimePicker(false, false),
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
                                  offEndTime,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    ? AppColors.whiteColor
                    : AppColors.whiteColor.withAlpha(100),
                onPress: canSave
                    ? () async {
                        setState(() {
                          offDaysList.add({
                            "start": "$selectedFromDate; $offStartTime",
                            "end": "$selectedToDate; $offEndTime",
                          });
                          selectedFromDate = "Select one";
                          selectedToDate = "Select one";
                          offStartTime = "Enter here";
                          offEndTime = "Enter here";
                        });
                      }
                    : null,
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        Text(
          "Current Unavailability",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        ...offDaysList.map(
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
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textColor,
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          item["start"]!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.whiteColor,
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
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textColor,
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          item["end"]!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.whiteColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => setState(() => offDaysList.remove(item)),
                  child: Icon(
                    Icons.cancel,
                    color: AppColors.redAccentColor.withAlpha(200),
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
class CoachRatesServicesView extends StatefulWidget {
  const CoachRatesServicesView({super.key});

  @override
  State<CoachRatesServicesView> createState() => _CoachRatesServicesViewState();
}

class _CoachRatesServicesViewState extends State<CoachRatesServicesView> {
  final perMinuteController = TextEditingController(text: "150\$");
  final perTextController = TextEditingController(text: "150\$");
  final cancellationPolicyController = TextEditingController(
    text: "Write cancellation policy",
  );
  final cancelPriorController = TextEditingController(text: "48h");

  final List<Map<String, dynamic>> services = [
    {
      "title": "Option 1",
      "duration": "Enter here",
      "price": "Enter here",
      "active": true,
    },
    {
      "title": "Option 2",
      "duration": "Enter here",
      "price": "Enter here",
      "active": true,
    },
    {
      "title": "Option 3",
      "duration": "Enter here",
      "price": "Enter here",
      "active": true,
    },
  ];

  @override
  void dispose() {
    perMinuteController.dispose();
    perTextController.dispose();
    cancellationPolicyController.dispose();
    cancelPriorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
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
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              InputTextWidget(
                hintText: "Rate per minute",
                controller: perMinuteController,
              ),
              SizedBox(height: 16.h),
              Text(
                "Per Text Rate",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              InputTextWidget(
                hintText: "Rate per text message",
                controller: perTextController,
              ),
              SizedBox(height: 16.h),
              Text(
                "Cancellation Policy",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              InputTextWidget(
                hintText: "Write cancellation policy",
                controller: cancellationPolicyController,
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: 16.h),
              Text(
                "Accept Cancellation Prior",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              InputTextWidget(
                hintText: "Prior window (e.g. 48h)",
                controller: cancelPriorController,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Service List",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        services.add({
                          "title": "Option ${services.length + 1}",
                          "duration": "Enter here",
                          "price": "Enter here",
                          "active": true,
                        });
                      });
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
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
              ...services.map((opt) => _buildServiceOptionCard(opt)),
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

  Widget _buildServiceOptionCard(Map<String, dynamic> opt) {
    final durCtrl = TextEditingController(
      text: opt["duration"] == "Enter here" ? "" : opt["duration"],
    );
    final prCtrl = TextEditingController(
      text: opt["price"] == "Enter here" ? "" : opt["price"],
    );

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
                opt["title"]!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Active",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textColor,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    height: 20.h,
                    child: Switch(
                      value: opt["active"] as bool,
                      activeThumbColor: AppColors.iconColor,
                      onChanged: (val) {
                        setState(() {
                          opt["active"] = val;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () => setState(() => services.remove(opt)),
                    child: Icon(
                      Icons.delete,
                      color: AppColors.redAccentColor.withAlpha(200),
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textColor, fontSize: 14.sp),
          ),
          SizedBox(height: 6.h),
          InputTextWidget(
            hintText: "Enter here",
            controller: durCtrl,
            onChanged: (val) => opt["duration"] = val,
          ),
          SizedBox(height: 12.h),
          Text(
            "Price",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textColor, fontSize: 14.sp),
          ),
          SizedBox(height: 6.h),
          InputTextWidget(
            hintText: "Enter here",
            controller: prCtrl,
            onChanged: (val) => opt["price"] = val,
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
                      color: AppColors.iconColor.withAlpha(30),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 130.r,
                    height: 130.r,
                    decoration: const BoxDecoration(
                      color: AppColors.iconColor,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(AppAssets.logo, width: 80.r),
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Text(
                        "✨ 🎉 🥳",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 100.sp),
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
                  buttonColor: AppColors.iconColor,
                  textColor: AppColors.whiteColor,
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
