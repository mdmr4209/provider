import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/input_text_widget.dart';
import '../../../../widgets/snack_bar_helper.dart';
import '../../../routes/app_router.dart';
import '../providers/auth_provider.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new),
                    ),
                    Spacer(),
                    Text(
                      'Forgot password',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.tenorSans(
                        color: AppColor.textColor,
                        fontSize: 18.w,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Spacer(),
                    SizedBox(width: 20.w),
                  ],
                ),
                SizedBox(height: 10.h),
                Container(
                  width: 335.w,
                  height: 331.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageAssets.background2),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Consumer<AuthProvider>(
                        builder: (context, auth, _) => ListView(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          children: [
                            SizedBox(height: 30.h),
                            SizedBox(
                              width: 295.w,
                              child: Text(
                                'Please enter your email address. You will receive a link to create a new password via email.',
                                style: GoogleFonts.lato(
                                  color: AppColor.textColor2,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  height: 1.70,
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                            InputTextWidget(
                              hintText: 'Enter your email',
                              textEditingController: auth.forgetEmailController,
                              onChanged: (v) =>
                                  auth.forgetEmailController.text = v,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 20.h),
                            CustomButton(
                              onPress: auth.isLoading
                                  ? null
                                  : () async {
                                      if (auth
                                          .forgetEmailController
                                          .text
                                          .isNotEmpty) {
                                        context.push(
                                          AppRoutes.otpVerify,
                                          extra: "forget",
                                        );
                                      } else {
                                        showWarningSnackBar(
                                          message: 'Please enter an email',
                                        );
                                      }
                                    },
                              loading: auth.isLoading,
                              title: 'Continue',
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
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
