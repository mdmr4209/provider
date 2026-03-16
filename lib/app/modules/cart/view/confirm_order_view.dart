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
import '../providers/cart_provider.dart';

class ConfirmOrderView extends StatelessWidget {
  final bool? origin;
  const ConfirmOrderView({super.key, this.origin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                SvgPicture.asset(ImageAssets.title),
                SizedBox(height: 15.h),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(ImageAssets.bgIcon),
                    Positioned(
                      bottom: 0,
                      child: SvgPicture.asset(
                        origin == true
                            ? ImageAssets.bgThank
                            : ImageAssets.bgSorry,
                      ),
                    ),
                  ],
                ),
                Consumer<CartProvider>(
                  builder: (context, cart, _) => Expanded(
                    child: ListView(
                      children: [
                        SizedBox(height: 30.h),
                        Text(
                          origin == true
                              ? 'Thank You For Your Order!'
                              : 'Sorry! Your Order Has Failed!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: AppColor.textColor,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.70,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        origin == true
                            ? SizedBox(
                                width: 290.w,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Congratulations! You get ',
                                        style: GoogleFonts.lato(
                                          color: AppColor.textColor3,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          height: 1.70,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '5 Points\n',
                                        style: GoogleFonts.lato(
                                          color: AppColor.textColor3,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          height: 1.70,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Thank you!',
                                        style: GoogleFonts.lato(
                                          color: AppColor.textColor3,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          height: 1.70,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Text(
                                'Something went wrong. Please try again\nto continue your order.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                  color: AppColor.textColor2,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.70,
                                ),
                              ),
                        SizedBox(height: 30.h),
                        CustomButton(
                          height: 60,
                          title: origin == true
                              ? 'VIEW ORDERS'
                              : 'CONTINUE SHOPPING',
                          onPress: () async {
                            origin == true
                                ? context.push(AppRoutes.orderHistory)
                                : context.go(AppRoutes.order);
                          },
                        ),
                        SizedBox(height: 10.h),
                        CustomButton(
                          height: 60,
                          textColor: AppColor.textColor,
                          buttonColor: AppColor.whiteColor,
                          title: origin == true
                              ? 'TRY AGAIN'
                              : 'GO TO MY PROFILE',
                          onPress: () async {
                            origin == true
                                ? context.go(AppRoutes.home)
                                : context.go(AppRoutes.profile);
                          },
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
