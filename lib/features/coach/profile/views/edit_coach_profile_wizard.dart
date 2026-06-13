import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/coach_profile_controller.dart';

class EditCoachProfileWizard extends StatefulWidget {
  const EditCoachProfileWizard({super.key});

  @override
  State<EditCoachProfileWizard> createState() => _EditCoachProfileWizardState();
}

class _EditCoachProfileWizardState extends State<EditCoachProfileWizard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
          leading: TextButton(
            onPressed: () {
              if (_currentPage > 0) {
                _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text("← Back", style: TextStyle(color: Colors.white70)),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w, top: 16.h),
              child: Text("${_currentPage < 2 ? 1 : 2}/10", style: const TextStyle(color: Color(0xFFC19E5F))),
            ),
          ],
        ),
        body: Column(
          children: [
            // Progress Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.w),
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / 4,
                backgroundColor: Colors.white10,
                color: const Color(0xFFC19E5F),
                minHeight: 2.h,
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _buildStep1(controller),
                  _buildStep2(controller),
                  _buildStep3(controller),
                  _buildStep4(controller),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 40.h),
          child: CustomButton(
            onPress: () async {
              if (_currentPage < 3) {
                _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
              } else {
                // Final Save
                Navigator.pop(context);
              }
            },
            title: _currentPage < 3 ? "Save and Continue →" : "Confirm and Save",
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
                        border: Border.all(color: const Color(0xFFC19E5F), width: 2),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFFC19E5F).withAlpha(80), blurRadius: 20, spreadRadius: 5),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network('https://i.pravatar.cc/150?u=coach_kamran', fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Color(0xFF42513B), shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                const Text("Profile Photo", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Text("Tap to change your photo", style: TextStyle(color: Colors.white54, fontSize: 12)),
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
      "Relationship Coaching", "Life Coaching", "Career Coaching", "Health & Wellness",
      "Divorce Support", "Anxiety & Stress Management", "Personal Growth", "Communication Skills"
    ];
    final styles = ["Direct and Honest", "Emphathetic and soft", "Data-Driven", "Spiritual", "Action-Oriented"];

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Year Of Experience"),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: const Color(0xFF2D3D2D),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.yearsOfExperience,
                hint: const Text("How You Want To Be Addressed?", style: TextStyle(color: Colors.white38, fontSize: 14)),
                isExpanded: true,
                dropdownColor: const Color(0xFF1B2B1B),
                items: ["1-2 Years", "3-5 Years", "5-8 Years", "8+ Years"].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(color: Colors.white)));
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
          ...specialties.map((s) => _buildCheckboxTile(s, controller.selectedSpecialties.contains(s), () => controller.toggleSpecialty(s))),
          SizedBox(height: 32.h),
          _buildLabel("My Coaching Style"),
          ...styles.map((s) => _buildCheckboxTile(s, controller.selectedCoachingStyles.contains(s), () => controller.toggleCoachingStyle(s))),
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
          _buildTextField(controller.pitchController, "In one sentence, how do you help people?", maxLines: 4),
          SizedBox(height: 32.h),
          _buildLabel("Bio"),
          _buildTextField(controller.bioController, "A deeper dive into your philosophy", maxLines: 8),
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
          const Text(
            "This is What Clients Will See Before Reaching Out",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24.h),
          _buildLabel("Per Minute Rate"),
          _buildTextField(controller.perMinuteRateController, "150\$"),
          SizedBox(height: 24.h),
          _buildLabel("Per Text Rate"),
          _buildTextField(controller.perTextRateController, "150\$"),
          SizedBox(height: 24.h),
          _buildLabel("Cancellation Policy"),
          _buildTextField(controller.cancellationPolicyController, "Write cancellation policy", maxLines: 4),
          SizedBox(height: 24.h),
          _buildLabel("Accept Cancellation Prior"),
          _buildTextField(controller.cancellationPriorController, "48h"),
          SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Service List", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton.icon(
                onPressed: controller.addServiceOption,
                icon: const Icon(Icons.add, color: Colors.white70, size: 18),
                label: const Text("Add Option", style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...List.generate(controller.services.length, (index) => _buildServiceCard(controller, index)),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Text(text, style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3D2D),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
          border: InputBorder.none,
        ),
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
                border: Border.all(color: Colors.white38, width: 1.5),
                borderRadius: BorderRadius.circular(4.r),
                color: isSelected ? const Color(0xFFC19E5F) : Colors.transparent,
              ),
              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 14) : null,
            ),
            SizedBox(width: 12.w),
            Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 14.sp)),
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
        color: const Color(0xFF2D3D2D).withAlpha(150),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Option ${index + 1}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Text("Active", style: TextStyle(color: Colors.white54, fontSize: 10)),
                  SizedBox(
                    height: 20,
                    child: Switch(
                      value: controller.services[index].isActive,
                      onChanged: (v) {
                        setState(() => controller.services[index].isActive = v);
                      },
                      activeColor: const Color(0xFFC19E5F),
                      activeTrackColor: const Color(0xFFC19E5F).withAlpha(80),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Color(0xFFE57373), size: 20),
                    onPressed: () => controller.removeServiceOption(index),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _buildLabel("Duration"),
          _buildTextField(TextEditingController(text: controller.services[index].duration), "Enter here"),
          SizedBox(height: 16.h),
          _buildLabel("Price"),
          _buildTextField(TextEditingController(text: controller.services[index].price), "Enter here"),
        ],
      ),
    );
  }
}
