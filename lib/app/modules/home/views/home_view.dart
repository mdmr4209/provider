import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../routes/app_router.dart';
import '../models/product_model.dart';
import '../controllers/home_controller.dart';
import '../../localization/localization_extension.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    int count = 2;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<HomeController>(
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
                          label: Text(
                            count.toString(),
                            style: TextStyle(fontSize: 10.sp),
                          ),
                          isLabelVisible: count > 0,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          offset: Offset(-5.w, -10.h),
                          child: _headerIcon(context, ImageAssets.cart, onTap: () {}),
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
                          context.watchTr('beauty_and_care'),
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            height: 1.20,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      SizedBox(
                        width: 213.w,
                        child: Text(
                          context.watchTr('onboarding_desc_1'), // Reusing a similar message
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.70,
                          ),
                        ),
                      ),
                      CustomButton(
                        onPress: () async {},
                        title: context.watchTr('shop_now'),
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
                  _titleHeader(context, context.watchTr('trending_products')),

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
                          child: _productCard(context, product),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 40.h),
                  Container(
                    width: double.infinity,
                    height: 238.h,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: context.watchTr('get_your'),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  height: 1.20,
                                ),
                              ),
                              TextSpan(
                                text: context.watchTr('discount_percent'),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.secondary,
                                  height: 1.20,
                                ),
                              ),
                              TextSpan(
                                text: context.watchTr('off'),
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                            context.watchTr('onboarding_desc_1'),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.70,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        CustomButton(
                          onPress: () async {},
                          title: context.watchTr('shop_now'),
                          width: 130.w,
                          height: 50.h,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  _titleHeader(context, context.watchTr('new_arrivals')),
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
                      return _productCard(context, product);
                    },
                  ),
                  _titleHeader(context, context.watchTr('man')),
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
                      return _productCard(context, product);
                    },
                  ),
                  _titleHeader(context, context.watchTr('woman')),
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
                      return _productCard(context, product);
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

  Widget _headerIcon(BuildContext context, String asset, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        asset,
        width: 24.w,
        height: 24.h,
        colorFilter: ColorFilter.mode(Theme.of(context).iconTheme.color ?? Theme.of(context).colorScheme.onSurface, BlendMode.srcIn),
      ),
    );
  }

  Widget _titleHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  height: 1.20,
                ),
              ),
              Text(
                context.watchTr('view_all'),
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  height: 1.50,
                ),
              ),
            ],
          ),
          Divider(thickness: 2.h, color: Theme.of(context).dividerColor, height: 10.h),
        ],
      ),
    );
  }

  Widget _productCard(BuildContext context, ProductModel product) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 15.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
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
                  color: Theme.of(context).colorScheme.surface,
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
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                           color: Colors.white,
                           fontWeight: FontWeight.w900,
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
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 4.h),
                Row(
                  spacing: 4.w,
                  children: [
                    if (product.updatePrice != '0')
                      Text(
                        product.updatePrice,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                           color: Theme.of(context).disabledColor,
                           decoration: TextDecoration.lineThrough,
                         ),
                      ),

                    Text(
                      product.price,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                         color: product.updatePrice != '0'
                             ? Theme.of(context).colorScheme.primary
                             : Theme.of(context).textTheme.titleMedium?.color,
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
