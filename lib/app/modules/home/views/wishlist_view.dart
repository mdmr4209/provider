import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../routes/app_router.dart';
import '../models/product_model.dart';
import '../providers/home_provider.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final count = 2;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Wishlist',
          style: GoogleFonts.tenorSans(
            color: AppColor.textColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Center(
              child: Badge(
                alignment: Alignment.bottomLeft,
                label: Text(
                  count.toString(),
                  style: TextStyle(fontSize: 10.sp),
                ),
                isLabelVisible: count > 0,
                backgroundColor: AppColor.defaultColor,
                offset: Offset(-5.w, -10.h),
                child: _headerIcon(ImageAssets.cart, onTap: () {}),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, home, _) => SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 15.h),

                    itemCount: home.dummyProducts.length,
                    itemBuilder: (context, index) {
                      final product = home.dummyProducts[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              context.push(AppRoutes.product);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: _productCard(product),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              context.push(AppRoutes.product);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: _productCard(product),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
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
        colorFilter: ColorFilter.mode(AppColor.blackColor, BlendMode.srcIn),
      ),
    );
  }

  Widget _productCard(ProductModel product) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      height: 100.h,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.w, color: AppColor.whiteTextColor),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            height: 80.h,
            child: Stack(
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
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.70,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 14.w, right: 10.w, top: 2.h),
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
                  SizedBox(height: 5.h),
                  Row(
                    spacing: 4.w,
                    children: [
                      if (product.updatePrice != '0')
                        Text(
                          product.updatePrice,
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
                  SizedBox(height: 11.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 4.w,
                    children: [
                      Icon(Icons.star, color: AppColor.ratingColor),
                      Text(
                        '5.0',
                        style: GoogleFonts.lato(
                          color: AppColor.textColor2,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 17.w,
                height: 16.h,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(),
                child: SvgPicture.asset(ImageAssets.love),
              ),
              Container(
                width: 40.w,
                height: 40.h,
                padding: EdgeInsets.all(10.r),
                decoration: ShapeDecoration(
                  color: AppColor.defaultColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x26222222),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Container(
                  width: 17.w,
                  height: 17.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: SvgPicture.asset(
                    ImageAssets.cart,
                    colorFilter: ColorFilter.mode(
                      AppColor.whiteColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
