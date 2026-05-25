import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_router.dart';
import '../../localization/localization_extension.dart';
import '../controllers/home_controller.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  late Set<String> _selectedColors;

  // ── Color Options ──────────────────────────────────────────────────────
  final List<String> colorOptions = [
    '#F5E6E1',
    '#E8D4CC',
    '#D4A5A0', // Selected in design
    '#D9A89F',
    '#E59E8F',
    '#E08A7C',
  ];

  @override
  void initState() {
    super.initState();
    _selectedColors = {'#D4A5A0'};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // ── Main Content ────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Consumer<HomeController>(
                    builder: (context, home, _) => Stack(
                      children: [
                        // 1. FULL SCREEN IMAGE SLIDER
                        // SizedBox(
                        //   height:
                        //       375.h, // Adjusted to match your uploaded design
                        //   child: PageView.builder(
                        //     controller: home.bannerController,
                        //     onPageChanged: home.updateBannerIndex,
                        //     itemCount: home.bannerImages.length,
                        //     itemBuilder: (context, index) {
                        //       return Image.asset(
                        //         home.bannerImages[index],
                        //         fit: BoxFit.cover,
                        //         width: double.infinity,
                        //       );
                        //     },
                        //   ),
                        // ),

                        // 2. TOP NAVIGATION (Logo & Cart)
                        SafeArea(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 10.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.title,
                                ), // Your menu/logo
                                _headerIcon(AppAssets.cart, onTap: () {}),
                              ],
                            ),
                          ),
                        ),

                        // 3. PAGE INDICATOR (Bottom Center)
                        // Positioned(
                        //   bottom: 30.h,
                        //   left: 0,
                        //   right: 0,
                        //   child: Center(
                        //     child: SmoothPageIndicator(
                        //       controller: home.bannerController,
                        //       count: home.bannerImages.length,
                        //       effect: WormEffect(
                        //         dotWidth: 8.r,
                        //         dotHeight: 8.r,
                        //         activeDotColor: Colors.white,
                        //         dotColor: Colors.white.withAlpha(127),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        // 4. NEXT IMAGE PREVIEW & ARROW (Bottom Right)
                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: GestureDetector(
                        //     onTap: () => home.nextBanner(),
                        //     child: Stack(
                        //       alignment: Alignment.center,
                        //       children: [
                        //         // The "Next" Image Background
                        //         ClipRRect(
                        //           child: Image.asset(
                        //             // Show the next image in the list, or loop back to first
                        //             home.bannerImages[(home.currentBannerIndex +
                        //                     1) %
                        //                 home.bannerImages.length],
                        //             width: 100.w,
                        //             height: 120.h,
                        //             fit: BoxFit.cover,
                        //           ),
                        //         ),
                        //         // The Arrow Overlay
                        //         Container(
                        //           width: 100.w,
                        //           height: 120.h,
                        //           color: Colors.black.withAlpha(54),
                        //           child: Icon(
                        //             Icons.arrow_forward_ios,
                        //             color: Colors.white,
                        //             size: 20.r,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),

                        // 5. TEXT CONTENT
                        Positioned(
                          bottom: 120.h,
                          left: 30.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'LUXURY\nFASHION',
                                style: GoogleFonts.bodoniModa(
                                  // Using a serif font like your image
                                  color: Colors.black87,
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2,
                                ),
                              ),
                              SizedBox(height: 10.h),
                              CustomButton(
                                onPress: () async {},
                                title: context.watchTr('explore'),
                                width: 150.w,
                                height: 45.h,
                                buttonColor: Colors.black.withAlpha(104),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 32.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 13.w,
                              children: [
                                SizedBox(
                                  width: 280.w,
                                  child: Text(
                                    'Body Hair Depilatory Cream',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge,
                                  ),
                                ),
                                Container(
                                  width: 40.r,
                                  height: 40.r,
                                  padding: EdgeInsets.all(8.r),
                                  decoration: ShapeDecoration(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                    shadows: [
                                      BoxShadow(
                                        color: Color(0x26222222),
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    width: 20.r,
                                    height: 20.r,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(),
                                    child: SvgPicture.asset(AppAssets.wishlist),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              spacing: 10.w,
                              children: [
                                Text(
                                  context.watchTr('in_stock'),
                                  style: Theme.of(context).textTheme.labelLarge
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                      ),
                                ),
                                Row(
                                  spacing: 4.w,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: AppColors.ratingColor2,
                                      size: 12.r,
                                    ),
                                    Text(
                                      '5.0',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$37.88',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Container(
                                  width: 114.w,
                                  height: 40.h,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainerHighest,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1.w,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.add),
                                      ),
                                      SizedBox(
                                        width: 26.w,
                                        child: Text(
                                          '1',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.remove),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            _buildColorSection(),
                            SizedBox(height: 20.h),
                            Divider(
                              thickness: 2.h,
                              color: AppColors.whiteTextColor,
                              height: 0,
                            ),
                            SizedBox(height: 30.h),
                            Text(
                              context.watchTr('description'),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(height: 14.h),
                            Text(
                              'Amet amet Lorem eu consectetur in deserunt nostrud dolor culpa ad sint amet. Nostrud deserunt consectetur culpa minim mollit veniam aliquip pariatur exercitation ullamco ea voluptate et. Pariatur ipsum mollit magna proident nisi ipsum.',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            SizedBox(height: 30.h),
                            SizedBox(height: 30.h),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        _titleHeader('Reviews (23)'),
                        SizedBox(height: 16.h),
                        _reviewCard(),
                        SizedBox(height: 16.h),
                        _reviewCard(),
                        SizedBox(height: 16.h),
                        _reviewCard(),
                        SizedBox(height: 16.h),
                        _reviewCard(),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Apply Filters Button ───────────────────────────────────
          Padding(
            padding: EdgeInsets.all(16.w),
            child: CustomButton(
              onPress: () async {},
              title: context.watchTr('add_to_cart'),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // WIDGETS
  // ─────────────────────────────────────────────────────────────────────

  Widget _reviewCard() {
    return Container(
      padding: EdgeInsets.all(20.r), // Standardizing padding
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                width: 30.r,
                height: 30.r,
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 14.w),
              // Name and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Annette Black',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Jul 23, 2022',
                      style: GoogleFonts.lato(
                        color: AppColors.textColor3,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating
              Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 14.r,
                    color: AppColors.primaryColor, // Theme primary color
                  ),
                  SizedBox(width: 4.w),
                  Text('5.0', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
          SizedBox(height: 15.h),
          // Review Content
          Row(
            children: [
              SizedBox(
                width: 30.r,
                height: 30.r,
                // Add child: Image.asset(...) or Text(...) for the avatar content
              ),
              SizedBox(width: 14.w),
              SizedBox(
                width: 248.w,
                child: Text(
                  'Consequat ut ea dolor aliqua laborum tempor Lorem culpa. Commodo veniam sint est mollit proident commodo.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _titleHeader(String title) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            InkWell(
              onTap: () {
                context.push(AppRoutes.review);
              },
              child: Text(
                'View  all',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        Divider(thickness: 2.h, color: AppColors.blackColor, height: 10.h),
      ],
    );
  }

  AppBar _buildAppBar() {
    final count = 2;
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(right: 20.w, left: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back_ios_new),
              ),
              Badge(
                alignment: Alignment.bottomLeft,
                label: Text(
                  count.toString(),
                  style: TextStyle(fontSize: 10.sp),
                ),
                isLabelVisible: count > 0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                offset: Offset(-5.w, -10.h),
                child: _headerIcon(AppAssets.cart, onTap: () {}),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerIcon(String asset, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        asset,
        width: 24.w,
        height: 24.h,
        colorFilter: ColorFilter.mode(
          Theme.of(context).iconTheme.color!,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildColorSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 14.w,
      children: [
        Text(
          'Color',
          style: GoogleFonts.tenorSans(
            color: AppColors.textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 16.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: colorOptions.map((color) {
            final isSelected = _selectedColors.contains(color);
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColors.clear();
                  _selectedColors.add(color);
                });
              },
              child: Container(
                width: 30.r,
                height: 30.r,
                decoration: BoxDecoration(
                  color: Color(int.parse(color.replaceFirst('#', '0xFF'))),
                  borderRadius: BorderRadius.circular(4.r),
                  border: isSelected
                      ? Border.all(color: AppColors.primaryColor, width: 2.5.w)
                      : Border.all(color: Colors.transparent, width: 2.5.w),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
