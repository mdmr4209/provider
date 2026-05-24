import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/services/api_service.dart';
import '../../auth/controllers/auth_controller.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../localization/localization_extension.dart';

class Navbar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const Navbar({super.key, required this.navigationShell});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  bool _showGuide = false;
  int _guideIndex = 0;
  final List<String> _guideMessages = [];

  @override
  void initState() {
    super.initState();
    _prepareGuides();
    _checkAndShowGuide();
  }

  void _prepareGuides() {
    _guideMessages.addAll([
      'Home: Browse products and collections',
      'The Circle: Community and social features',
      'Find Coaches: Search and book experts',
      'Inbox: View messages and notifications',
      'Profile: Manage your account and settings',
    ]);
  }

  Future<void> _checkAndShowGuide() async {
    final v = await ApiService.getStored(key: 'show_nav_guide');
    if (v == 'true') {
      setState(() => _showGuide = true);
      // show dialog after first frame
      WidgetsBinding.instance.addPostFrameCallback((_) => _showGuideDialog());
    }
  }

  Future<void> _hideGuidePermanently() async {
    await ApiService.store(key: 'show_nav_guide', value: 'false');
  }

  void _showGuideDialog() {
    if (!_showGuide) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final message = _guideMessages[_guideIndex];
            final isLastStep = _guideIndex == _guideMessages.length - 1;

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 100.h,
                    left: 16.w,
                    right: 16.w,
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFF1F3A2F),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Step indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _guideMessages.length,
                              (i) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Container(
                                  width: 8.r,
                                  height: 8.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: i == _guideIndex
                                        ? const Color(0xFFD4AF37)
                                        : Colors.white30,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),

                          // Guide message
                          Text(
                            message,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  height: 1.6,
                                  fontSize: 14.sp,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24.h),

                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_guideIndex > 0)
                                Expanded(
                                  child: Container(
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white30,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          setStateDialog(() => _guideIndex--);
                                        },
                                        borderRadius: BorderRadius.circular(24),
                                        child: Center(
                                          child: Text(
                                            'Previous',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Expanded(child: SizedBox.shrink()),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Container(
                                  height: 48.h,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFD4AF37),
                                        Color(0xFFC99C21),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () async {
                                        if (!isLastStep) {
                                          setStateDialog(() => _guideIndex++);
                                        } else {
                                          // finish
                                          await _hideGuidePermanently();
                                          setState(() => _showGuide = false);
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(24),
                                      child: Center(
                                        child: Text(
                                          isLastStep ? 'Done' : 'Next',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Container(
        height: 88.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1F3A2F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                context,
                0,
                context.watchTr('home'),
                'assets/icons/home.svg',
              ),
              _navItem(
                context,
                1,
                context.watchTr('the_circle'),
                'assets/image/home2.svg',
              ),
              _navItem(
                context,
                2,
                context.watchTr('find_coaches'),
                'assets/image/search.svg',
              ),
              _navItem(
                context,
                3,
                context.watchTr('inbox'),
                'assets/image/wishlist.svg',
              ),
              _navItem(
                context,
                4,
                context.watchTr('profile'),
                'assets/icons/logo.svg',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, int index, String label, String icon) {
    final isSelected = widget.navigationShell.currentIndex == index;

    return GestureDetector(
      onTap: () {
        widget.navigationShell.goBranch(
          index,
          initialLocation: index == widget.navigationShell.currentIndex,
        );
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 68.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Column(
                children: [
                  SvgPicture.asset(
                    icon,
                    colorFilter: ColorFilter.mode(
                      isSelected ? const Color(0xFFD4AF37) : Colors.white70,
                      BlendMode.srcIn,
                    ),
                    width: 26.r,
                    height: 26.r,
                  ),
                  SizedBox(height: 6.h),
                  if (isSelected)
                    Container(
                      width: 28.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    )
                  else
                    SizedBox(height: 4.h),
                ],
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? const Color(0xFFD4AF37) : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
