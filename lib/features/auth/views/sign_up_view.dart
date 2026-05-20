import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/input_text_widget.dart';
import '../../../routes/app_router.dart';
import '../../localization/localization_extension.dart';
import '../controllers/auth_controller.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

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
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new, color: Theme.of(context).iconTheme.color),
                    ),
                    Spacer(),
                    Text(
                      context.watchTr('sign_up'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Spacer(),
                    SizedBox(width: 20.w),
                  ],
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: Container(
                    width: 335.w,
                    height: 677.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      // Removed: image: DecorationImage(
                      // Removed:   image: AssetImage(ImageAssets.background),
                      // Removed:   fit: BoxFit.cover,
                      // Removed: ),
                      color: Theme.of(context).colorScheme.surface, // Placeholder color
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
                                SizedBox(height: 20.h),
                                Text(
                                  context.watchTr('sign_up_caps'),
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
                                  hintText: context.watchTr('enter_your_name'),
                                  controller: auth.nameController,
                                  onChanged: (_) {},
                                  keyboardType: TextInputType.name,
                                ),
                                SizedBox(height: 10.h),
                                InputTextWidget(
                                  hintText: context.watchTr('enter_your_email'),
                                  controller: auth.emailController,
                                  onChanged: (_) {},
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                SizedBox(height: 10.h),
                                InputTextWidget(
                                  hintText: context.watchTr('enter_your_password'),
                                  obscureText: true,
                                  controller:
                                      auth.passwordController,
                                  onChanged: (_) {},
                                  leadingIconHeight: 18,
                                  leadingIconWidth: 14,
                                ),
                                SizedBox(height: 10.h),
                                InputTextWidget(
                                  hintText: context.watchTr('confirm_your_password'),
                                  obscureText: true,
                                  controller:
                                      auth.setPasswordController,
                                  onChanged: (_) {},
                                  leadingIconHeight: 18,
                                  leadingIconWidth: 14,
                                ),
                                SizedBox(height: 20.h),
                                CustomButton(
                                  height: 60,
                                  title: context.watchTr('sign_up_button'),
                                  onPress: auth.isLoading ? null :()async {
                                    // auth.login
                                    context.push(AppRoutes.goToHome,extra:"Sign up");
                                  },
                                  loading: auth.isLoading,
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${context.watchTr('already_have_account')} ",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          context.push(AppRoutes.login),
                                      child: Text(
                                        context.watchTr('sign_in_dot'),
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
