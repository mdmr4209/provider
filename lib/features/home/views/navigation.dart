import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../core/services/api_service.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/home_controller.dart';
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
  Timer? _autoVanishTimer;
  double _overlayOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _checkAndShowGuide();
  }

  @override
  void dispose() {
    _autoVanishTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkAndShowGuide() async {
    final v = await ApiService.getStored(key: 'show_nav_guide');
    if (v == 'true') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _showGuide = true;
            _guideIndex = 0;
            _overlayOpacity = 1.0;
          });
          _startAutoVanishTimer();
        }
      });
    }
  }

  void _startAutoVanishTimer() {
    _autoVanishTimer?.cancel();
    _autoVanishTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _showGuide) {
        final home = context.read<HomeController>();
        if (_guideIndex < home.guideData.length - 1) {
          setState(() => _guideIndex++);
          _startAutoVanishTimer();
        } else {
          _closeGuideWithAnimation();
        }
      }
    });
  }

  Future<void> _closeGuideWithAnimation() async {
    setState(() => _overlayOpacity = 0.0);
    await Future.delayed(const Duration(milliseconds: 400));
    _hideGuidePermanently();
  }

  Future<void> _hideGuidePermanently() async {
    _autoVanishTimer?.cancel();
    await ApiService.store(key: 'show_nav_guide', value: 'false');
    if (mounted) {
      setState(() {
        _showGuide = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final home = context.watch<HomeController>();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double marginW = 20.w;
    final double bubbleWidth = screenWidth - (marginW * 2);

    // Precise center calculation for 5 items: centers are at 10%, 30%, 50%, 70%, 90%
    final double itemWidth = screenWidth / 5;
    final double itemCenter = (_guideIndex + 0.5) * itemWidth;
    final double pointerX = (itemCenter - marginW) / bubbleWidth;

    final isLastStep =
        home.guideData.isNotEmpty && _guideIndex == home.guideData.length - 1;

    return Stack(
      children: [
        Scaffold(
          body: widget.navigationShell,
          bottomNavigationBar: Container(
            height: 88.h,
            decoration: BoxDecoration(
              color: AppColors.defaultColorAlpha2,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(0, context.watchTr('home'), AppAssets.home),
                  _navItem(1, context.watchTr('the_circle'), AppAssets.circle),
                  _navItem(2, context.watchTr('find_coaches'), AppAssets.coach),
                  _navItem(
                    3,
                    context.watchTr('inbox'),
                    AppAssets.inbox,
                    badge: "2",
                  ),
                  _navItem(4, context.watchTr('profile'), AppAssets.profile),
                ],
              ),
            ),
          ),
        ),

        // ── Guide Overlay ───────────────────────────────────────────────────
        if (_showGuide && home.guideData.isNotEmpty)
          AnimatedOpacity(
            opacity: _overlayOpacity,
            duration: const Duration(milliseconds: 400),
            child: Material(
              color: Colors.transparent,
              child: Container(
                color: Colors.black.withOpacity(0.6),
                child: Stack(
                  children: [
                    // Dismiss by tapping background
                    GestureDetector(
                      onTap: _closeGuideWithAnimation,
                      child: Container(color: Colors.transparent),
                    ),

                    // Pointer Bubble
                    Positioned(
                      bottom: 105.h,
                      left: marginW,
                      right: marginW,
                      child: CustomPaint(
                        painter: BubblePainter(pointerX: pointerX),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Text(
                                  home.guideData[_guideIndex]['message'] ?? "",
                                  key: ValueKey(_guideIndex),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    height: 1.5,
                                    fontFamily: 'Segoe UI',
                                    decoration: TextDecoration.none,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              SizedBox(height: 28.h),
                              Row(
                                children: [
                                  // Previous Button - Outlined
                                  Expanded(
                                    child: Opacity(
                                      opacity: _guideIndex > 0 ? 1.0 : 0.0,
                                      child: GestureDetector(
                                        onTap: _guideIndex > 0
                                            ? () {
                                                setState(() => _guideIndex--);
                                                _startAutoVanishTimer();
                                              }
                                            : null,
                                        child: Container(
                                          height: 48.h,
                                          margin: EdgeInsets.only(right: 12.w),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white38,
                                              width: 1.5,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              24.r,
                                            ),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Previous",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                decoration: TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Next / Done Button - Gold Gradient
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (!isLastStep) {
                                          setState(() => _guideIndex++);
                                          _startAutoVanishTimer();
                                        } else {
                                          _closeGuideWithAnimation();
                                        }
                                      },
                                      child: Container(
                                        height: 48.h,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFAC823A),
                                              Color(0xFFF3D194),
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            24.r,
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            isLastStep ? "Done" : "Next",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              decoration: TextDecoration.none,
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
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _navItem(int index, String label, String icon, {String? badge}) {
    // Highlight items based on guide index if visible
    final bool isActive = _showGuide
        ? (_guideIndex == index)
        : (widget.navigationShell.currentIndex == index);

    final Color activeColor = const Color(0xFFD4AF37);
    final Color inactiveColor = Colors.white70;

    return GestureDetector(
      onTap: () {
        if (_showGuide) return;
        widget.navigationShell.goBranch(
          index,
          initialLocation: index == widget.navigationShell.currentIndex,
        );
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Stack(
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  icon,
                  colorFilter: isActive
                      ? null
                      : ColorFilter.mode(inactiveColor, BlendMode.srcIn),
                  width: 24.r,
                  height: 24.r,
                ),
                if (badge != null)
                  Positioned(
                    top: -4.r,
                    right: -4.r,
                    child: Container(
                      padding: EdgeInsets.all(2.r),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD44637),
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14.r,
                        minHeight: 14.r,
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4.h),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isActive ? activeColor : inactiveColor,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                ),

                SizedBox(height: 4.h),

                if (isActive)
                  Container(
                    width: 62.w,
                    height: 2.h,
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xFFB18406),
                          Color(0xFFFFD258),
                          Color(0xFFB28406),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: 14.w,
                    height: 2.h,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ── Bubble Painter ───────────────────────────────────────────────────────────

class BubblePainter extends CustomPainter {
  final double pointerX;

  BubblePainter({required this.pointerX});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color =
          const Color(0xFF20341F) // Exact color from image
      ..style = PaintingStyle.fill;

    final double radius = 16.r;
    final double tipHeight = 15.h;
    final double tipWidth = 12.w;
    final double tipX = size.width * pointerX;

    final path = Path()
      ..addRRect(
        RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(radius)),
      )
      ..moveTo(tipX - tipWidth, size.height)
      ..lineTo(tipX, size.height + tipHeight)
      ..lineTo(tipX + tipWidth, size.height)
      ..close();

    // Shadow as requested
    canvas.drawShadow(path, const Color(0x0A1E1E01), 10, false);

    // Draw the bubble and pointer
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
