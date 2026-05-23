import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/background_widget.dart';
import '../../../../routes/app_router.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/input_text_widget.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../controllers/auth_controller.dart';
import 'setup_base_view.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

Widget _buildOptionButton({
  required String option,
  required String? selectedOption,
  required Function(String) onSelect,
}) {
  final isSelected = selectedOption == option;
  return Padding(
    padding: EdgeInsets.only(bottom: 16.h),
    child: CustomButton(
      title: option,
      center: false,
      buttonColor: isSelected ? AppColors.buttonColor3 : AppColors.buttonColor4,
      borderColor: isSelected
          ? Colors.transparent
          : AppColors.buttonBorderColor4,
      textColor: isSelected ? AppColors.textColor3 : AppColors.whiteColor,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      onPress: () async => onSelect(option),
    ),
  );
}

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
    borderShadowColor: isEnabled ? Colors.transparent : AppColors.buttonShadowColor4,
    onPress: isEnabled ? () async => onPress() : null,
  );
}

Widget _buildLegalContent(String title, String content) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20.h),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 22.sp,
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30.h),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              content,
              style: TextStyle(
                color: AppColors.whiteColor.withOpacity(0.8),
                fontSize: 16.sp,
                fontFamily: 'Segoe UI',
                height: 1.6,
              ),
            ),
          ),
        ),
        SizedBox(height: 100.h),
      ],
    ),
  );
}

const String _dummyLegalText = """
1. Welcome to Ai. By using our services, you agree to abide by the terms and conditions outlined below. These terms govern your access to and 

2. use of Ai tools and services, so please review them carefully before proceeding. 

3. Ai provides innovative tools designed to enhance how you capture and manage voice recordings. Our services include voice-to-text transcription and AI-driven summarization, which are intended 

4. for lawful, ethical purposes only. You must ensure compliance with applicable laws, including obtaining consent from all participants when recording conversations. CleverTalk disclaims liability for any misuse of its tools.
""";

// ── Views ────────────────────────────────────────────────────────────────────

// Step 3: post-name question
class Setup1View extends StatefulWidget {
  const Setup1View({super.key});
  @override
  State<Setup1View> createState() => _Setup1ViewState();
}

class _Setup1ViewState extends State<Setup1View> {
  String? _selectedOption;
  final List<String> _options = [
    "I need help staying in No Contact 📵",
    "I want to get my soulmate back ❤️",
    "I want to move on ✨",
    "*My situation is... complicated. 🌀",
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final name = auth.nameController.text.trim();
    return SetupBaseView(
      currentStep: 3,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "We’re here to support you ${name.isNotEmpty ? name : "friend"}. What are you struggling with most?",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Georgia',
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "We're here for you, no matter what.",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 32.h),
            ..._options.map((o) => _buildOptionButton(option: o, selectedOption: _selectedOption, onSelect: (v) => setState(() => _selectedOption = v))),
            const Spacer(),
            _buildContinueButton(isEnabled: _selectedOption != null, onPress: () => context.push(AppRoutes.setup2)),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// Step 4: Duration together
class Setup2View extends StatefulWidget {
  const Setup2View({super.key});
  @override
  State<Setup2View> createState() => _Setup2ViewState();
}

class _Setup2ViewState extends State<Setup2View> {
  String? _selectedOption;
  final List<String> _options = ["Under 3 Months 🌱", "3 to 12 Months ☀️", "1 to 3 Years ✨", "3 to 10 Years 🌳", "10+ Years ♾️"];

  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
      currentStep: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text("How long were you together?", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'Georgia', color: AppColors.whiteColor)),
            SizedBox(height: 8.h),
            Text("Every bond is significant, no matter how long or short you were together.", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textColor)),
            SizedBox(height: 32.h),
            ..._options.map((o) => _buildOptionButton(option: o, selectedOption: _selectedOption, onSelect: (v) => setState(() => _selectedOption = v))),
            const Spacer(),
            _buildContinueButton(isEnabled: _selectedOption != null, onPress: () => context.push(AppRoutes.setup3)),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// Step 5: Time since split
class Setup3View extends StatefulWidget {
  const Setup3View({super.key});
  @override
  State<Setup3View> createState() => _Setup3ViewState();
}

class _Setup3ViewState extends State<Setup3View> {
  String? _selectedOption;
  final List<String> _options = ["0–30 Days 🌊", "1–3 Months ⛅️", "4–6 Months 🍃", "7–12 Months 🍂", "1–2 Years ️🕯️", "2+ Years 🕰️️"];

  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
      currentStep: 5,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text("How long since the split?", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'Georgia', color: AppColors.whiteColor)),
            SizedBox(height: 8.h),
            Text("Whether it’s been a day or over a year, your feelings are valid 🩹", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textColor)),
            SizedBox(height: 32.h),
            ..._options.map((o) => _buildOptionButton(option: o, selectedOption: _selectedOption, onSelect: (v) => setState(() => _selectedOption = v))),
            const Spacer(),
            _buildContinueButton(isEnabled: _selectedOption != null, onPress: () => context.push(AppRoutes.setup4)),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// Step 6: Image 1 - Rollercoaster
class Setup4View extends StatefulWidget {
  const Setup4View({super.key});
  @override
  State<Setup4View> createState() => _Setup4ViewState();
}

class _Setup4ViewState extends State<Setup4View> {
  String? _selectedOption;
  final List<String> _options = [
    "Total Silence 🔇",
    "Occasional 'Breadcrumbs' 🍞",
    "Active Contact 💥",
    "Necessary Contact (for kids, bills etc) 🩰",
    "I'm Blocked 🚫"
  ];

  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
      currentStep: 6,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "What’s weighing on you the most at this moment?",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Georgia',
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Breakups are a rollercoaster 🎢, we know....",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 32.h),
            ..._options.map((o) => _buildOptionButton(option: o, selectedOption: _selectedOption, onSelect: (v) => setState(() => _selectedOption = v))),
            const Spacer(),
            _buildContinueButton(
              isEnabled: _selectedOption != null,
              onPress: () => context.push(AppRoutes.setup5),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// Step 7: Image 2 - Understand
class Setup5View extends StatefulWidget {
  const Setup5View({super.key});
  @override
  State<Setup5View> createState() => _Setup5ViewState();
}

class _Setup5ViewState extends State<Setup5View> {
  String? _selectedOption;
  final List<String> _options = [
    "The urge to reach out 📱",
    "Intense overthinking 🌀",
    "Checking their socials 🕵️",
    "Feeling lost/Not knowing how to move on 🧭",
  ];

  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
      currentStep: 7,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "What’s weighing on you most?",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Georgia',
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Let's understand what you're going through.",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 32.h),
            ..._options.map((o) => _buildOptionButton(option: o, selectedOption: _selectedOption, onSelect: (v) => setState(() => _selectedOption = v))),
            const Spacer(),
            _buildContinueButton(
              isEnabled: _selectedOption != null,
              onPress: () => context.push(AppRoutes.setup6),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// Step 8: Image 3 - How feeling
class Setup6View extends StatefulWidget {
  const Setup6View({super.key});
  @override
  State<Setup6View> createState() => _Setup6ViewState();
}

class _Setup6ViewState extends State<Setup6View> {
  String? _selectedOption;
  final List<String> _options = [
    "I'm in crisis mode 🚨",
    "I'm fragile but holding 🩹",
    "I'm ready to level up 🚀",
    "I'm just... stuck ⛓️",
  ];

  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
      currentStep: 8,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "How are you feeling right now?",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Georgia',
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Take a breath and check in.",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 32.h),
            ..._options.map((o) => _buildOptionButton(option: o, selectedOption: _selectedOption, onSelect: (v) => setState(() => _selectedOption = v))),
            const Spacer(),
            _buildContinueButton(
              isEnabled: _selectedOption != null,
              onPress: () => context.push(AppRoutes.setup7),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// Step 9: Image 4 - Started NC
class Setup7View extends StatefulWidget {
  const Setup7View({super.key});
  @override
  State<Setup7View> createState() => _Setup7ViewState();
}

class _Setup7ViewState extends State<Setup7View> {
  String? _selectedOption;
  final List<String> _options = [
    "I'm starting fresh today. 🆕",
    "I've already started! 💪",
  ];

  void _showPopup(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        // Auto dismiss after 5 seconds
        Timer(const Duration(seconds: 5), () {
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        });

        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 323,
              height: 169,
              decoration: ShapeDecoration(
                color: const Color(0xFF20341F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0A1E1E01),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "“Congrats”",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "On taking this big FIRST\nSTEP and starting No Contact Today 😀",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: anim1,
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
      currentStep: 9,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "Have you started no contact?",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Georgia',
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "OK, so it’s time to lock in your progress 🔒",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 32.h),
            ..._options.map(
              (o) => _buildOptionButton(
                option: o,
                selectedOption: _selectedOption,
                onSelect: (v) {
                  setState(() => _selectedOption = v);
                  _showPopup(context);
                },
              ),
            ),
            const Spacer(),
            _buildContinueButton(
              isEnabled: _selectedOption != null,
              onPress: () => context.push(AppRoutes.setup8),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// Step 10: Image 5 - How many days
class Setup8View extends StatefulWidget {
  const Setup8View({super.key});
  @override
  State<Setup8View> createState() => _Setup8ViewState();
}

class _Setup8ViewState extends State<Setup8View> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
      currentStep: 10,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "How many days has it been?",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Georgia',
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "That’s amazing! You should be proud of yourself 🙂",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 40.h),
            InputTextWidget(
              hintText: "Enter Here",
              controller: _controller,
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
            ),
            const Spacer(),
            _buildContinueButton(
              isEnabled: _controller.text.isNotEmpty,
              onPress: () => context.push(AppRoutes.setup9),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// Step 11: Image 6 - Identify
class Setup9View extends StatefulWidget {
  const Setup9View({super.key});
  @override
  State<Setup9View> createState() => _Setup9ViewState();
}

class _Setup9ViewState extends State<Setup9View> {
  String? _selectedOption;
  final List<String> _options = ["I'm a Woman", "I'm a Man", "Other"];

  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
      currentStep: 11,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "How do you identify?",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Georgia',
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "This helps us match you with support",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 32.h),
            ..._options.map(
              (o) => _buildOptionButton(
                option: o,
                selectedOption: _selectedOption,
                onSelect: (v) => setState(() => _selectedOption = v),
              ),
            ),
            const Spacer(),
            _buildContinueButton(
              isEnabled: _selectedOption != null,
              onPress: () => context.push(AppRoutes.setup10),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// Step 12: Image 7 - How old
class Setup10View extends StatefulWidget {
  const Setup10View({super.key});
  @override
  State<Setup10View> createState() => _Setup10ViewState();
}

class _Setup10ViewState extends State<Setup10View> {
  String? _selectedOption;
  final List<String> _options = ["Under 18", "18-24", "25-34", "34-44", "45+"];

  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
      currentStep: 12,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              "How old are you?",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontFamily: 'Georgia',
                color: AppColors.whiteColor,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Almost there!",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textColor),
            ),
            SizedBox(height: 32.h),
            ..._options.map(
              (o) => _buildOptionButton(
                option: o,
                selectedOption: _selectedOption,
                onSelect: (v) => setState(() => _selectedOption = v),
              ),
            ),
            const Spacer(),
            _buildContinueButton(
              isEnabled: _selectedOption != null,
              onPress: () => context.push(AppRoutes.setup11),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

// Step 13: Privacy Policy
class Setup11View extends StatelessWidget {
  const Setup11View({super.key});
  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
      currentStep: 13,
      child: Stack(
        children: [
          _buildLegalContent("Privacy Policy", _dummyLegalText),
          Positioned(
            bottom: 40.h,
            left: 24.w,
            right: 24.w,
            child: _buildContinueButton(
              isEnabled: true,
              onPress: () => context.push(AppRoutes.setup12),
            ),
          ),
        ],
      ),
    );
  }
}

// Step 14: Terms and Conditions
class Setup12View extends StatelessWidget {
  const Setup12View({super.key});
  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
      currentStep: 14,
      child: Stack(
        children: [
          _buildLegalContent("Terms and Conditions", _dummyLegalText),
          Positioned(
            bottom: 40.h,
            left: 24.w,
            right: 24.w,
            child: _buildContinueButton(
              isEnabled: true,
              onPress: () => context.push(AppRoutes.setup13),
            ),
          ),
        ],
      ),
    );
  }
}

// Step 15: Medical/Legal Disclaimer
class Setup13View extends StatelessWidget {
  const Setup13View({super.key});
  @override
  Widget build(BuildContext context) {
    return SetupBaseView(
      currentStep: 15,
      child: Stack(
        children: [
          _buildLegalContent("Medical/Legal Disclaimer", _dummyLegalText),
          Positioned(
            bottom: 40.h,
            left: 24.w,
            right: 24.w,
            child: _buildContinueButton(
              isEnabled: true,
              onPress: () => context.push(AppRoutes.setupComplete),
            ),
          ),
        ],
      ),
    );
  }
}

// Final Completion Screen
class SetupCompleteView extends StatelessWidget {
  const SetupCompleteView({super.key});

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
              // Confetti / Logo Section
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
                      child: Text("✨ 🎉 🥳", style: TextStyle(fontSize: 100.sp)),
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
                  "Take a deep breath, ${name.isNotEmpty ? name : "friend"}. You’re not in this alone anymore. Let’s start your journey.✨",
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
                  onPress: () async => context.go(AppRoutes.home),
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
