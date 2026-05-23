import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:newproject/core/constants/app_assets.dart';
import 'package:newproject/core/constants/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_loader.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/input_text_widget.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../routes/app_router.dart';
import '../../localization/localization_extension.dart';
import '../controllers/auth_controller.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return BackgroundWidget(
      imagePath: 'assets/images/bg1.png',
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Consumer<AuthController>(
                builder: (context, auth, _) {
                  if (auth.error != null && auth.error!.isCritical) {
                    return ErrorDisplayWidget(
                      exception: auth.error!,
                      isFullScreen: true,
                      onRetry: () => auth.login(),
                    );
                  }

                  if (auth.isLoading && auth.error == null) {
                    return const FullScreenLoader();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [const Spacer(), const Spacer()]),
                      SizedBox(height: 10.h),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                              top: isKeyboardOpen ? -150.h : 170.h,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: ListView(
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                children: [
                                  SizedBox(height: 20.h),
                                  Text(
                                    context.watchTr('welcome_back'),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(fontFamily: 'LobsterTwo'),
                                  ),
                                  SizedBox(
                                    width: 291.w,
                                    child: Text(
                                      context.watchTr('auth_subtitle'),
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontFamily: 'Segoe UI',
                                            color: AppColors.textColor2,
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),

                                  if (auth.error != null) ...[
                                    ErrorDisplayWidget(
                                      exception: auth.error!,
                                      onRetry: () => auth.clearError(),
                                    ),
                                    SizedBox(height: 16.h),
                                  ],
                                  Text(
                                    context.watchTr('email'),
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontFamily: 'Segoe UI'),
                                  ),
                                  SizedBox(height: 8.h),
                                  InputTextWidget(
                                    hintText: context.watchTr(
                                      'enter_your_email',
                                    ),
                                    controller: auth.emailController,
                                    onChanged: (_) => auth.clearError(),
                                    keyboardType: TextInputType.emailAddress,
                                    leadingIcon: AppAssets.email,
                                    leadingColor: AppColors.iconColor,
                                    leadingPadding: EdgeInsets.only(
                                      left: 10.w,
                                      right: 5.w,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    context.watchTr('password'),
                                    textAlign: TextAlign.left,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(fontFamily: 'Segoe UI'),
                                  ),
                                  SizedBox(height: 8.h),
                                  InputTextWidget(
                                    hintText: context.watchTr(
                                      'enter_your_password',
                                    ),
                                    obscureText: true,
                                    controller: auth.passwordController,
                                    onChanged: (_) => auth.clearError(),
                                    showObscureToggle: true,
                                    leadingIcon: AppAssets.pass,
                                    leadingColor: AppColors.iconColor,
                                    leadingPadding: EdgeInsets.only(
                                      left: 10.w,
                                      right: 5.w,
                                    ),
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
                                                    ? Theme.of(
                                                        context,
                                                      ).colorScheme.primary
                                                    : Colors.transparent,
                                                border: Border.all(
                                                  color: Theme.of(
                                                    context,
                                                  ).dividerColor,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(4.r),
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
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodyMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () =>
                                            context.push(AppRoutes.forgetPass),
                                        child: Text(
                                          context.watchTr('forget_password'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: AppColors.textColor3,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 28.h),
                                  CustomButton(
                                    linearGradient: true,
                                    height: 48,
                                    title: context.watchTr('login'),
                                    onPress: auth.isLoading ? null : auth.login,
                                    loading: auth.isLoading,
                                  ),
                                  SizedBox(height: 20.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: AppColors.defaultColorLight,
                                          thickness: 1.h,
                                        ),
                                      ),
                                      Container(
                                        width: 50.w,
                                        height: 22.h,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 16.w,
                                        ),
                                        decoration: ShapeDecoration(
                                          color: AppColors.defaultColorLight,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              44.r,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'or',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyLarge,
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: AppColors.defaultColorLight,
                                          thickness: 1.h,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.h),
                                  Container(
                                    width: 319.w,
                                    height: 48.h,
                                    decoration: ShapeDecoration(
                                      color: AppColors.defaultColorAlpha,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      spacing: 14.w,
                                      children: [
                                        Container(
                                          width: 19.99.w,
                                          height: 19.99.h,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(),
                                          child: SvgPicture.asset(
                                            AppAssets.google,
                                          ),
                                        ),
                                        Text(
                                          'Log in with Google',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                color: AppColors.whiteColor,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    spacing: 5.w,
                                    children: [
                                      Text(
                                        "${context.watchTr('no_account')} ",
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            context.push(AppRoutes.signup),
                                        child: Text(
                                          context.watchTr('sign_up_caps'),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: AppColors.borderColor,
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
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
