import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
        body: SafeArea(
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
                top: isKeyboardOpen ? 50.h : 290.h,
                left: 0,
                right: 0,
                bottom: 0,
                child: Consumer<AuthProvider>(
                  builder: (context, auth, _) => ListView(
                    padding: EdgeInsets.symmetric(horizontal: 35.w),
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontSize: 27,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'Login to your account',
                        style: TextStyle(
                          color: AppColor.textGreyColor,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20.h),
                      InputTextWidget(
                        hintText: 'user@mail.com',
                        textEditingController: auth.emailController,
                        onChanged: (_) {},
                        leading: true,
                        leadingIcon: ImageAssets.mail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 17.h),
                      InputTextWidget(
                        hintText: 'Password',
                        obscureText: true,
                        textEditingController: auth.passwordController,
                        onChanged: (_) {},
                        leading: true,
                        leadingIcon: ImageAssets.password,
                        leadingHeight: 18,
                        leadingWidth: 14,
                      ),
                      SizedBox(height: 16.h),
                      Padding(
                        padding: EdgeInsets.only(right: 15.w),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: auth.toggleRemembered,
                              child: Container(
                                width: 17,
                                height: 17,
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
                                      size: 14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontSize: 12,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.50,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () =>
                                  context.push(AppRoutes.forgetPass),
                              child: const Text(
                                'Forget Password?',
                                style: TextStyle(
                                  color: AppColor.defaultColor,
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  letterSpacing: 0.50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.h),
                      CustomButton(
                        title: 'Login',
                        onPress: auth.isLoading ? null : auth.login,
                        loading: auth.isLoading,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        radius: 30.r,
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have account?",
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 14,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.60,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          GestureDetector(
                            onTap: () => context.push(AppRoutes.signup),
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: AppColor.defaultColor,
                                fontSize: 16,
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
