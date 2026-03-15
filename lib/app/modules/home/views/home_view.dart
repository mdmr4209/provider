import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newproject/res/assets/image_assets.dart';
import 'package:newproject/res/colors/app_color.dart';
import 'package:newproject/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_router.dart';
import '../models/product_model.dart';
import '../providers/home_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    int count = 2;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Consumer<HomeProvider>(
        builder: (context, home, _) => ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Image.asset(ImageAssets.homeBg),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(ImageAssets.title),
                        Badge(
                          alignment: Alignment.bottomLeft,
                          label: Text(count.toString()),
                          isLabelVisible: count > 0,
                          backgroundColor: AppColor.defaultColor,
                          child: _headerIcon(ImageAssets.cart, onTap: () {}),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 75.h,
                  left: 20.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10.h,
                    children: [
                      SizedBox(
                        width: 234.w,
                        child: Text(
                          'Beauty & Care',
                          style: GoogleFonts.tenorSans(
                            color: AppColor.textColor,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.20,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: 213.w,
                        child: Text(
                          'Labore sunt culpa excepteur culpa ipsum.',
                          style: GoogleFonts.tenorSans(
                            color: AppColor.textColor2,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.70,
                          ),
                        ),
                      ),
                      CustomButton(
                        onPress: () async {},
                        title: 'SHOP NOW',
                        width: 130.w,
                        height: 50.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SafeArea(
              child: Column(
                children: [
                  _titleHeader('Trending Products'),

                  // Horizontal ListView section
                  SizedBox(
                    height: 240.h,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      scrollDirection: Axis.horizontal,
                      itemCount: home.dummyProducts.length,
                      itemBuilder: (context, index) {
                        final product = home.dummyProducts[index];
                        return InkWell(
                            onTap: () {
                              context.push(AppRoutes.product);
                            },
                            child: _productCard(product));
                      },
                    ),
                  ),

                  SizedBox(height: 40.h),
                  Container(
                    width: double.infinity,
                    height: 238.h,
                    color: AppColor.backgroundColor,
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Get Your',
                                style: GoogleFonts.tenorSans(
                                  color: AppColor.textColor,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.20,
                                ),
                              ),
                              TextSpan(
                                text: ' 50% ',
                                style: GoogleFonts.tenorSans(
                                  color: AppColor.defaultColor,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.20,
                                ),
                              ),
                              TextSpan(
                                text: 'Off!',
                                style: GoogleFonts.tenorSans(
                                  color: AppColor.textColor,
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        SizedBox(
                          width: 213.w,
                          child: Text(
                            'Labore sunt culpa excepteur culpa ipsum.',
                            style: GoogleFonts.lato(
                              color: AppColor.textColor2,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              height: 1.70,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        CustomButton(
                          onPress: () async {},
                          title: 'SHOP NOW',
                          width: 130.w,
                          height: 50.h,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  _titleHeader('New Arrivals'),
                  GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    // shrinkWrap + NeverScrollableScrollPhysics allows this to sit inside a parent ListView
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // 0.65 to 0.7 is usually ideal for cards with a 150h image and 2 lines of text
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                    ),
                    itemCount: home.dummyProducts.length,
                    itemBuilder: (context, index) {
                      final product = home.dummyProducts[index];
                      // Remove the horizontal margin from the card since GridView handles spacing
                      return _productCard(product);
                    },
                  ),
                  _titleHeader('MAN'),
                  GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    // shrinkWrap + NeverScrollableScrollPhysics allows this to sit inside a parent ListView
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // 0.65 to 0.7 is usually ideal for cards with a 150h image and 2 lines of text
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                    ),
                    itemCount: home.dummyProducts.length,
                    itemBuilder: (context, index) {
                      final product = home.dummyProducts[index];
                      // Remove the horizontal margin from the card since GridView handles spacing
                      return _productCard(product);
                    },
                  ),
                  _titleHeader('WOMEN'),
                  GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    // shrinkWrap + NeverScrollableScrollPhysics allows this to sit inside a parent ListView
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // 0.65 to 0.7 is usually ideal for cards with a 150h image and 2 lines of text
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                    ),
                    itemCount: home.dummyProducts.length,
                    itemBuilder: (context, index) {
                      final product = home.dummyProducts[index];
                      // Remove the horizontal margin from the card since GridView handles spacing
                      return _productCard(product);
                    },
                  ),
                  SizedBox(height: 120.h),
                ],
              ),
            ),
          ],
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
        colorFilter: ColorFilter.mode(AppColor.blackColor, BlendMode.srcIn),
      ),
    );
  }

  Widget _titleHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.tenorSans(
                  color: AppColor.textColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.20,
                ),
              ),
              Text(
                'View  all',
                textAlign: TextAlign.right,
                style: GoogleFonts.lato(
                  color: AppColor.defaultColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ],
          ),
          Divider(thickness: 2.h, color: AppColor.blackColor, height: 10.h),
        ],
      ),
    );
  }

  Widget _productCard(ProductModel product) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.r),
                  child: Image.asset(product.image, fit: BoxFit.cover),
                ),
              ),
              Positioned(
                top: 5.h,
                left: 7.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w),
                  decoration: ShapeDecoration(
                    color: Colors.black.withValues(alpha: 0.50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22.r),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4.w,
                    children: [
                      Icon(Icons.star, color: AppColor.ratingColor),
                      Text(
                        '5.0',
                        style: GoogleFonts.lato(
                          color: AppColor.whiteColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w900,
                          height: 1.70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 40.h,
                right: 9.w,
                child: Container(
                  width: 28.r,
                  height: 28.r,
                  padding: EdgeInsets.all(6.r),
                  decoration: ShapeDecoration(
                    color: Colors.black.withValues(alpha: 0.50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  child: SvgPicture.asset(
                    ImageAssets.wishlist,
                    colorFilter: ColorFilter.mode(
                      AppColor.whiteColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10.h,
                right: 9.w,
                child: Container(
                  width: 28.r,
                  height: 28.r,
                  padding: EdgeInsets.all(6.r),
                  decoration: ShapeDecoration(
                    color: Colors.black.withValues(alpha: 0.50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  child: SvgPicture.asset(
                    ImageAssets.cart,
                    colorFilter: ColorFilter.mode(
                      AppColor.whiteColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              if (product.sale == true)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(color: const Color(0xFFA3D2A2)),
                    child: Text(
                      'SALE',
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.70,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.tenorSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: AppColor.textColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  spacing: 4.w,
                  children: [
                    if (product.updatePrice != '0')
                      Text(
                        product.updatePrice!,
                        style: GoogleFonts.lato(
                          color: AppColor.textColor3,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.lineThrough,
                          height: 1.50,
                        ),
                      ),

                    Text(
                      product.price,
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        color: product.updatePrice != '0'
                            ? AppColor.defaultColor
                            : AppColor.textColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
