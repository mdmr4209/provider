import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../localization/localization_extension.dart';
import '../controllers/onboarding_controller.dart';
import 'onboarding_content.dart';

class OnboardingView extends StatelessWidget {
  final PageController _pageController = PageController();
  final ValueNotifier<double> _currentPage = ValueNotifier<double>(0.0);

  OnboardingView({super.key});

  List<Map<String, dynamic>> onboardingData(BuildContext context) => [
    {
      "icon": Icons.volunteer_activism_rounded,
      "title": context.watchTr('onboarding_title_1'),
      "description": context.watchTr('onboarding_desc_1'),
      "color": Theme.of(context).colorScheme.primaryContainer,
    },
    {
      "icon": Icons.psychology_rounded,
      "title": context.watchTr('onboarding_title_2'),
      "description": context.watchTr('onboarding_desc_2'),
      "color": Theme.of(context).colorScheme.secondaryContainer,
    },
    {
      "icon": Icons.groups_rounded,
      "title": context.watchTr('onboarding_title_3'),
      "description": context.watchTr('onboarding_desc_3'),
      "color": Theme.of(context).colorScheme.tertiaryContainer,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final data = onboardingData(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ValueListenableBuilder<double>(
        valueListenable: _currentPage,
        builder: (context, currentPage, child) {
          final int pageInt = currentPage.toInt();
          return Stack(
            children: [
              // Dynamic Background Color based on current page
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: 1.sh,
                width: 1.sw,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      data[pageInt]['color'] as Color,
                      theme.scaffoldBackgroundColor,
                    ],
                  ),
                ),
              ),
              
              SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 60.h),
                    // Hero Icon/Placeholder instead of fixed img.png
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 200.r,
                          width: 200.r,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Icon(
                          data[pageInt]['icon'] as IconData,
                          size: 100.r,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                    
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: data.length,
                        onPageChanged: (int page) {
                          _currentPage.value = page.toDouble();
                        },
                        itemBuilder: (context, index) {
                          return OnboardingContent(
                            title: data[index]['title']!,
                            description: data[index]['description']!,
                          );
                        },
                      ),
                    ),

                    // Indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(data.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          width: index == pageInt ? 24.w : 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.r),
                            color: index == pageInt
                                ? theme.colorScheme.primary
                                : theme.colorScheme.primary.withValues(alpha: 0.2),
                          ),
                        );
                      }),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          CustomButton(
                            height: 56,
                            onPress: () async {
                              if (currentPage < data.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                await context
                                    .read<OnboardingController>()
                                    .completeOnboarding();
                              }
                            },
                            title: currentPage == data.length - 1 
                                ? context.watchTr('get_started') 
                                : context.watchTr('next'),
                          ),
                          SizedBox(height: 16.h),
                          TextButton(
                            onPressed: () async {
                              await context
                                  .read<OnboardingController>()
                                  .completeOnboarding();
                            },
                            child: Text(
                              context.watchTr('skip'),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
