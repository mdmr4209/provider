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
import '../controllers/auth_controller.dart';
import '../../localization/localization_extension.dart';
import '../../../routes/app_router.dart';

class ForgetPasswordView extends StatelessWidget {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).iconTheme.color),
                    ),
                    Spacer(),
                    Text(
                      context.watchTr('forgot_password'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
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
                      Consumer<AuthController>(
                        builder: (context, auth, _) => ListView(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          children: [
                            SizedBox(height: 30.h),
                            SizedBox(
                              width: 295.w,
                                child: Text(
                                  context.watchTr('forget_pass_msg'),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                            ),
                            SizedBox(height: 30.h),
                            InputTextWidget(
                               hintText: context.watchTr('enter_your_email'),
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
                               title: context.watchTr('continue_button'),
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
