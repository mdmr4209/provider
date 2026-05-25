import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/input_text_widget.dart';
import '../controllers/profile_controller.dart';

class AddPromoCodeView extends StatelessWidget {
  const AddPromoCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: 18.r,
              color: AppColors.textColor,
            ),
          ),
          title: Text(
            'My Promo Codes',
            style: GoogleFonts.tenorSans(
              color: AppColors.textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.0,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ListView(
              children: [
                SizedBox(height: 20.h),
                // Stack(
                //   alignment: Alignment.center,
                //   children: [
                // Image.asset(AppAssets.bgIcon),
                //     Positioned(
                //       bottom: 0,
                //       child: SvgPicture.asset(AppAssets.bgPromo),
                //     ),
                //   ],
                // ),
                Consumer<ProfileController>(
                  builder: (context, profile, _) => Column(
                    children: [
                      SizedBox(height: 30.h),
                      Text(
                        'Your Don\'t Have\nPromo Codes Yet!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.tenorSans(
                          color: AppColors.textColor,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.70,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Qui ex aute ipsum duis. Incididunt\nadipisicing voluptate laborum',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          color: AppColors.textColor2,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.70,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      InputTextWidget(
                        onChanged: (e) {},
                        hintText: 'Enter your promo code',
                        controller: profile.promoCodeCtrl,
                      ),
                      SizedBox(height: 30.h),
                      CustomButton(
                        height: 60,
                        title: 'ADD A PROMO CODE',
                        onPress: profile.isAddPromo
                            ? null
                            : () async {
                                profile.addPromo();
                                context.pop();
                              },
                        loading: profile.isAddPromo,
                      ),
                      SizedBox(height: 20.h),
                    ],
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
