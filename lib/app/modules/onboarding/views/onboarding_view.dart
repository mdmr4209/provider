import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../controllers/onboarding_controller.dart';
import 'onboarding_content.dart';
import '../../localization/localization_extension.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  double _currentPage = 0;

  List<Map<String, dynamic>> onboardingData(BuildContext context) => [
    {
      "image": "assets/image/1.png",
      "title": context.watchTr('onboarding_title_1'),
      "description": context.watchTr('onboarding_desc_1'),
    },
    {
      "image": "assets/image/2.png",
      "title": context.watchTr('onboarding_title_2'),
      "description": context.watchTr('onboarding_desc_2'),
    },
    {
      "image": "assets/image/3.png",
      "title": context.watchTr('onboarding_title_3'),
      "description": context.watchTr('onboarding_desc_3'),
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
                final data = onboardingData(context);
                return Container(
                  height: 538.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(data[currentPage]['image']!),
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
                      itemCount: onboardingData(context).length,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page.toDouble();
                        });
                      },
                      itemBuilder: (context, index) {
                        final data = onboardingData(context);
                        return OnboardingContent(
                          title: data[index]['title']!,
                          description: data[index]['description']!,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(onboardingData(context).length, (index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Container(
                          width: index == _currentPage.toInt() ? 30.r : 10.r,
                          height: 10.r,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            color: index == _currentPage.toInt()
                                ? Theme.of(context).bottomNavigationBarTheme.selectedIconTheme?.color ?? Theme.of(context).colorScheme.primary
                                : (Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme?.color ?? Colors.grey).withAlpha(100),
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
                        final data = onboardingData(context);
                        if (_currentPage < data.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          await context
                              .read<OnboardingController>()
                              .completeOnboarding();
                        }
                      },
                      title: context.watchTr('next'),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () async {
                      await context
                          .read<OnboardingController>()
                          .completeOnboarding();
                    },
                    child: Text(
                      context.watchTr('skip'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        decoration: TextDecoration.underline,
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
