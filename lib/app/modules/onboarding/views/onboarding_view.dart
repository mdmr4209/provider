import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../providers/onboarding_provider.dart';
import 'onboarding_content.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  double _currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      "image": "assets/image/1.png",
      "title": "Welcome to\nElixir-369 !",
      "description":
          "Labore sunt culpa excepteur culpa ipsum. Labore occaecat ex nisi mollit.",
    },
    {
      "image": "assets/image/2.png",
      "title": "Easy Track\nOrder!",
      "description":
          "Labore sunt culpa excepteur culpa ipsum. Labore occaecat ex nisi mollit.",
    },
    {
      "image": "assets/image/3.png",
      "title": "Door to Door\nDelivery!",
      "description":
          "Labore sunt culpa excepteur culpa ipsum. Labore occaecat ex nisi mollit.",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: ValueListenableBuilder<int>(
              valueListenable: ValueNotifier<int>(_currentPage.toInt()),
              builder: (context, currentPage, child) {
                return Container(
                  height: 538.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(onboardingData[currentPage]['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 30.h,
            left: 0,
            right: 0,
            height: 0.32.sh,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 210.sh,
                  width: 210.w,
                  child: Image.asset("assets/image/img.png"),
                ),
                Positioned(
                  top: 20.h,
                  left: 0,
                  right: 0,
                  height: 0.255.sh,
                  child: SizedBox(
                    height: 0.255.sh,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: onboardingData.length,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page.toDouble();
                        });
                      },
                      itemBuilder: (context, index) => OnboardingContent(
                        title: onboardingData[index]['title']!,
                        description: onboardingData[index]['description']!,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(onboardingData.length, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Container(
                          width: index == _currentPage.toInt() ? 30.r : 10.r,
                          height: 10.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: index == _currentPage.toInt()
                                ? AppColor.defaultColor
                                : AppColor.indicatorColor,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 20.w,
            right: 20.w,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: 343.w,
                    child: CustomButton(
                      onPress: () async {
                        if (_currentPage < onboardingData.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          await context
                              .read<OnboardingProvider>()
                              .completeOnboarding();
                        }
                      },
                      title: "NEXT",
                    ),
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () async {
                      await context
                          .read<OnboardingProvider>()
                          .completeOnboarding();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColor.textColor),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontSize: 18.sp,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w400,
                          height: 1.22,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
