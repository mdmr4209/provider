import 'package:newproject/core/theme/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/coach_profile_controller.dart';

class EditCoachProfileWizard extends StatefulWidget {
  const EditCoachProfileWizard({super.key});

  @override
  State<EditCoachProfileWizard> createState() => _EditCoachProfileWizardState();
}

class _EditCoachProfileWizardState extends State<EditCoachProfileWizard> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = Future.delayed(const Duration(milliseconds: 1500));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<CoachProfileController>();

    return BackgroundWidget(
      imagePath: AppAssets.bgMain,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: TextButton(
            onPressed: () {
              if (controller.wizardCurrentPage > 0) {
                controller.wizardPageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.pop(context);
              }
            },
            child: Text(
              "← Back",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.white70Color,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w, top: 16.h),
              child: Text(
                "${controller.wizardCurrentPage + 1}/4",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.coachColorFFC19E5F,
                ),
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: _initFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSkeletonLoader();
            }
            return Column(
              children: [
                // Progress Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                  child: LinearProgressIndicator(
                    value: (controller.wizardCurrentPage + 1) / 4,
                    backgroundColor: AppColors.white10Color,
                    color: AppColors.coachColorFFC19E5F,
                    minHeight: 2.h,
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: controller.wizardPageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) =>
                        controller.setWizardCurrentPage(page),
                    children: [
                      _buildStep1(controller),
                      _buildStep2(controller),
                      _buildStep3(controller),
                      _buildStep4(controller),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 40.h),
          child: CustomButton(
            onPress: () async {
              if (controller.wizardCurrentPage < 3) {
                controller.wizardPageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                // Final Save
                Navigator.pop(context);
              }
            },
            title: controller.wizardCurrentPage < 3
                ? "Save and Continue →"
                : "Confirm and Save",
            linearGradient: true,
          ),
        ),
      ),
    );
  }

  Widget _buildStep1(CoachProfileController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 130.r,
                      height: 130.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.coachColorFFC19E5F,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.coachColorFFC19E5F.withAlpha(80),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://i.pravatar.cc/150?u=coach_kamran',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.coachColorFF42513B,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.whiteColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  "Profile Photo",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Tap to change your photo",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white54Color,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          _buildLabel("Name/ Professional Alias"),
          _buildTextField(controller.nameController, "Enter Here"),
          SizedBox(height: 24.h),
          _buildLabel("Location"),
          _buildTextField(controller.locationController, "Enter Here"),
        ],
      ),
    );
  }

  Widget _buildStep2(CoachProfileController controller) {
    final specialties = [
      "Relationship Coaching",
      "Life Coaching",
      "Career Coaching",
      "Health & Wellness",
      "Divorce Support",
      "Anxiety & Stress Management",
      "Personal Growth",
      "Communication Skills",
    ];
    final styles = [
      "Direct and Honest",
      "Emphathetic and soft",
      "Data-Driven",
      "Spiritual",
      "Action-Oriented",
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Year Of Experience"),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Theme.of(context).extension<AppDesignSystem>()!.panelColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.yearsOfExperience,
                hint: Text(
                  "How You Want To Be Addressed?",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white38Color,
                    fontSize: 14,
                  ),
                ),
                isExpanded: true,
                dropdownColor: Theme.of(
                  context,
                ).extension<AppDesignSystem>()!.accentPanelColor,
                items: ["1-2 Years", "3-5 Years", "5-8 Years", "8+ Years"].map((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (v) => controller.setYearsOfExperience(v),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          _buildLabel("Certification/Education"),
          _buildTextField(controller.certificationController, "Enter Here"),
          SizedBox(height: 32.h),
          _buildLabel("Primary Specialty (Select multiple)"),
          ...specialties.map(
            (s) => _buildCheckboxTile(
              s,
              controller.selectedSpecialties.contains(s),
              () => controller.toggleSpecialty(s),
            ),
          ),
          SizedBox(height: 32.h),
          _buildLabel("My Coaching Style"),
          ...styles.map(
            (s) => _buildCheckboxTile(
              s,
              controller.selectedCoachingStyles.contains(s),
              () => controller.toggleCoachingStyle(s),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(CoachProfileController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Elevator Pitch (Max 250 characters)"),
          _buildTextField(
            controller.pitchController,
            "In one sentence, how do you help people?",
            maxLines: 4,
          ),
          SizedBox(height: 32.h),
          _buildLabel("Bio"),
          _buildTextField(
            controller.bioController,
            "A deeper dive into your philosophy",
            maxLines: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildStep4(CoachProfileController controller) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "This is What Clients Will See Before Reaching Out",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24.h),
          _buildLabel("Per Minute Rate"),
          _buildTextField(controller.perMinuteRateController, "150\$"),
          SizedBox(height: 24.h),
          _buildLabel("Per Text Rate"),
          _buildTextField(controller.perTextRateController, "150\$"),
          SizedBox(height: 24.h),
          _buildLabel("Cancellation Policy"),
          _buildTextField(
            controller.cancellationPolicyController,
            "Write cancellation policy",
            maxLines: 4,
          ),
          SizedBox(height: 24.h),
          _buildLabel("Accept Cancellation Prior"),
          _buildTextField(controller.cancellationPriorController, "48h"),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Service List",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: controller.addServiceOption,
                icon: const Icon(
                  Icons.add,
                  color: AppColors.white70Color,
                  size: 18,
                ),
                label: Text(
                  "Add Option",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white70Color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...List.generate(
            controller.services.length,
            (index) => _buildServiceCard(controller, index),
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppColors.white70Color,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return CustomInput(
      controller: controller,
      height: maxLines == 1 ? 42 : null,
      maxLines: maxLines,
      hintText: hint,
      fontSize: 14,
      hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: AppColors.whiteColor.withAlpha(153),
        fontSize: 14,
      ),
      shadow: true,
      borderRadius: 12,
      borderWidth: 0.50,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: maxLines == 1 ? 0 : 12.h,
      ),
    );
  }

  Widget _buildCheckboxTile(String title, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.white38Color, width: 1.5),
                borderRadius: BorderRadius.circular(4.r),
                color: isSelected
                    ? AppColors.coachColorFFC19E5F
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      color: AppColors.whiteColor,
                      size: 14,
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? AppColors.whiteColor
                    : AppColors.white70Color,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(CoachProfileController controller, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).extension<AppDesignSystem>()!.panelColor.withAlpha(150),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.white10Color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Option ${index + 1}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Active",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.white54Color,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Switch(
                          value: controller.services[index].isActive,
                          onChanged: (v) {
                            setState(
                              () => controller.services[index].isActive = v,
                            );
                          },
                          activeThumbColor: AppColors.coachColorFFC19E5F,
                          activeTrackColor: AppColors.coachColorFFC19E5F
                              .withAlpha(80),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: AppColors.coachColorFFE57373,
                      size: 20,
                    ),
                    onPressed: () => controller.removeServiceOption(index),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildLabel("Duration"),
          _buildTextField(
            TextEditingController(text: controller.services[index].duration),
            "Enter here",
          ),
          SizedBox(height: 16.h),
          _buildLabel("Price"),
          _buildTextField(
            TextEditingController(text: controller.services[index].price),
            "Enter here",
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          child: ShimmerLoader(
            width: double.infinity,
            height: 2.h,
            borderRadius: 0,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      ShimmerLoader(
                        width: 130.r,
                        height: 130.r,
                        borderRadius: 65.r,
                      ),
                      SizedBox(height: 16.h),
                      ShimmerLoader(width: 150.w, height: 20.h),
                      SizedBox(height: 4.h),
                      ShimmerLoader(width: 180.w, height: 14.h),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                ShimmerLoader(width: 150.w, height: 16.h),
                SizedBox(height: 8.h),
                ShimmerLoader(
                  width: double.infinity,
                  height: 50.h,
                  borderRadius: 12.r,
                ),
                SizedBox(height: 24.h),
                ShimmerLoader(width: 100.w, height: 16.h),
                SizedBox(height: 8.h),
                ShimmerLoader(
                  width: double.infinity,
                  height: 50.h,
                  borderRadius: 12.r,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
