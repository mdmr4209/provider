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
import '../providers/auth_provider.dart';

class GoToHome extends StatelessWidget {
  final String? origin;
  const GoToHome({super.key, this.origin});

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
                        child: SvgPicture.asset( origin == "Sign up"?ImageAssets.account:ImageAssets.password)),
                  ],
                ),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) => Expanded(
                    child: ListView(
                      children: [
                        SizedBox(height: 30.h),
                        Text(
                          origin == "Sign up"
                              ? 'Account Created!'
                              : 'Your password has\nbeen reset!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            color: AppColor.textColor,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.70,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          origin == "Sign up"
                              ? 'Your account had beed created\nsuccessfully.'
                              : 'Qui ex aute ipsum duis. Incididunt\nadipisicing voluptate laborum',
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
                          title: origin == "Sign up" ? 'SHOP NOW' : 'DONE',
                          onPress: auth.isHomeLoading
                              ? null
                              : () async {
                                  auth.clear();
                                  context.push(AppRoutes.home);
                                },
                          loading: auth.isHomeLoading,
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
