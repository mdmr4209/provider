import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        backgroundColor: AppColor.whiteColor,
        body: Container(
          width: 1.sw,
          height: 1.sh,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageAssets.background3),
              fit: BoxFit.cover,
            ),
          ),
          child: Consumer<AuthProvider>(
            builder: (context, auth, _) => ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              children: [
                SizedBox(height: .57.sh),
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
      ),
    );
  }
}
