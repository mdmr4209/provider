import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/input_text_widget.dart';
import '../../../routes/app_router.dart';
import '../providers/auth_provider.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Spacer(),
                    Text(
                      'Sign in',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tenorSans(
                        color: AppColor.textColor,
                        fontSize: 18.w,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: Container(
                    width: 335.w,
                    height: 677.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageAssets.background),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeIn,
                          top: isKeyboardOpen ? -150.h : 50.h,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Consumer<AuthProvider>(
                            builder: (context, auth, _) => ListView(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              children: [
                                SvgPicture.asset(ImageAssets.title),
                                SizedBox(height: 20.h),
                                Text(
                                  'Welcome Back!',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.tenorSans(
                                    color: AppColor.textColor,
                                    fontSize: 32.sp,
                                    fontWeight: FontWeight.w400,
                                    height: 1.20,
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                SizedBox(
                                  width: 266.w,
                                  child: Text(
                                    'Use social networks or your email',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.lato(
                                      color: AppColor.textColor2,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      height: 1.70,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 110.h),
                                InputTextWidget(
                                  hintText: 'Enter your email',
                                  textEditingController: auth.emailController,
                                  onChanged: (_) {},
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: 17.h),
                                InputTextWidget(
                                  hintText: 'Enter your password',
                                  obscureText: true,
                                  textEditingController:
                                      auth.passwordController,
                                  onChanged: (_) {},
                                  leadingHeight: 18,
                                  leadingWidth: 14,
                                ),
                                SizedBox(height: 16.h),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: auth.toggleRemembered,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 18.r,
                                            height: 18.r,
                                            decoration: BoxDecoration(
                                              color: auth.isRemembered
                                                  ? AppColor.defaultColor
                                                  : AppColor.whiteColor,
                                              border: Border.all(
                                                color: auth.isRemembered
                                                    ? Colors.transparent
                                                    : AppColor.whiteColor,
                                              ),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.check,
                                                color: auth.isRemembered
                                                    ? AppColor.textWhiteColor
                                                    : Colors.transparent,
                                                size: 14,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Text(
                                            'Remember me',
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.lato(
                                              color: AppColor.textColor2,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              height: 1.70,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        // Add this to debug
                                        context.push(AppRoutes.forgetPass);
                                      },
                                      child: Text(
                                        'Lost your password?',
                                        textAlign: TextAlign.right,
                                        style: GoogleFonts.lato(
                                          color: AppColor.defaultColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          height: 1.70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 50.h),
                                CustomButton(
                                  height: 60,
                                  title: 'SIGN IN',
                                  onPress: auth.isLoading ? null : auth.login,
                                  loading: auth.isLoading,
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "No account? ",
                                      style: GoogleFonts.lato(
                                        color: AppColor.textColor2,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        height: 1.70,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          context.push(AppRoutes.signup),
                                      child: Text(
                                        'Register now',
                                        style: GoogleFonts.lato(
                                          color: AppColor.defaultColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          height: 1.70,
                                        ),
                                      ),
                                    ),
                                  ],
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
