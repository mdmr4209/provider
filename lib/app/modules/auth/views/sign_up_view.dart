import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../routes/app_router.dart';
import '../providers/auth_provider.dart';
import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/input_text_widget.dart';
class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 30.h,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 250.h,
                  width: 375.h,
                  child: SvgPicture.asset(ImageAssets.auth, fit: BoxFit.fill),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
                top: isKeyboardOpen ? 50.h : 250.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: Consumer<AuthProvider>(
                  builder: (context, auth, _) => ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 35.w),
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        'Sign up',
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontSize: 24.sp,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'Create your new account',
                        style: TextStyle(
                          color: AppColor.textGreyColor,
                          fontSize: 14.sp,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      InputTextWidget(
                        textEditingController: auth.signupEmailController,
                        hintText: 'user@mail.com',
                        onChanged: (v) => auth.signupEmailController.text = v,
                        leading: true,
                        leadingIcon: ImageAssets.mail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 17.h),
                      Padding(
                        padding: EdgeInsets.only(right: 15.w),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: auth.toggleRemembered,
                              child: Container(
                                width: 14.w,
                                height: 14.h,
                                decoration: BoxDecoration(
                                  color: auth.isRemembered
                                      ? AppColor.defaultColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: auth.isRemembered
                                        ? Colors.transparent
                                        : AppColor.textGreyColor,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(Icons.check,
                                      color: auth.isRemembered
                                          ? AppColor.textWhiteColor
                                          : Colors.transparent,
                                      size: 13.sp),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Remember me',
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontSize: 10.sp,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.50,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () => context.push(AppRoutes.forgetPass),
                              child: Text(
                                'Re-send OTP?',
                                style: TextStyle(
                                  color: AppColor.defaultColor,
                                  fontSize: 10.sp,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColor.defaultColor,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 46.h),
                      auth.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              onPress: () async {
                                if (auth.signupEmailController.text.isNotEmpty) {
                                  await auth.signup();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please enter an email'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              title: 'Register',
                              fontWeight: FontWeight.w700,
                            ),
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 12.sp,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.60,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          GestureDetector(
                            onTap: () => context.go(AppRoutes.login),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: AppColor.defaultColor,
                                fontSize: 14.sp,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColor.defaultColor,
                                letterSpacing: 0.70,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 17.h),
                      Center(
                        child: Text(
                          '..............Or sign up with.............',
                          style: TextStyle(
                            color: AppColor.textColor,
                            fontSize: 14.sp,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.70,
                          ),
                        ),
                      ),
                      SizedBox(height: 17.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: auth.signInWithFacebook,
                            child: SvgPicture.asset(ImageAssets.fb),
                          ),
                          SizedBox(width: 12.w),
                          GestureDetector(
                            onTap: auth.signInWithGoogle,
                            child: SvgPicture.asset(ImageAssets.ggl),
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
    );
  }
}
