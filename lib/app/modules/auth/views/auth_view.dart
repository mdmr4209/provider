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
import '../controllers/auth_controller.dart';
import '../../localization/localization_extension.dart';
import '../../../routes/app_router.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      context.watchTr('sign_in'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
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
                          child: Consumer<AuthController>(
                            builder: (context, auth, _) => ListView(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              children: [
                                SvgPicture.asset(ImageAssets.title),
                                SizedBox(height: 20.h),
                                Text(
                                  context.watchTr('welcome_back'),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.displaySmall,
                                ),
                                SizedBox(height: 20.h),
                                SizedBox(
                                  width: 266.w,
                                  child: Text(
                                    context.watchTr('auth_subtitle'),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                SizedBox(height: 110.h),
                                InputTextWidget(
                                  hintText: context.watchTr('enter_your_email'),
                                  textEditingController: auth.emailController,
                                  onChanged: (_) {},
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: 17.h),
                                InputTextWidget(
                                  hintText: context.watchTr('enter_your_password'),
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
                                                  ? Theme.of(context).colorScheme.primary
                                                  : Colors.transparent,
                                              border: Border.all(
                                                color: Theme.of(context).dividerColor,
                                              ),
                                              borderRadius: BorderRadius.circular(4.r),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.check,
                                                color: auth.isRemembered
                                                    ? Colors.white
                                                    : Colors.transparent,
                                                size: 14.r,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10.w),
                                          Text(
                                            context.watchTr('remember_me'),
                                            textAlign: TextAlign.right,
                                            style: Theme.of(context).textTheme.bodyMedium,
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
                                        context.watchTr('lost_your_password'),
                                        textAlign: TextAlign.right,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 50.h),
                                CustomButton(
                                  height: 60,
                                  title: context.watchTr('sign_in_caps'),
                                  onPress: auth.isLoading ? null : auth.login,
                                  loading: auth.isLoading,
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${context.watchTr('no_account')} ",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          context.push(AppRoutes.signup),
                                      child: Text(
                                        context.watchTr('register_now'),
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.primary,
                                          fontWeight: FontWeight.bold,
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
