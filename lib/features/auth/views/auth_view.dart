import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_loader.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/input_text_widget.dart';
import '../../../routes/app_router.dart';
import '../../localization/localization_extension.dart';
import '../controllers/auth_controller.dart';

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
            child: Consumer<AuthController>(
              builder: (context, auth, _) {
                // 1. Critical Error Handling (Full Screen)
                // Used for issues like No Internet or Server Down.
                if (auth.error != null && auth.error!.isCritical) {
                  return ErrorDisplayWidget(
                    exception: auth.error!,
                    isFullScreen: true,
                    onRetry: () => auth.login(),
                  );
                }

                // 2. Loading State
                if (auth.isLoading && auth.error == null) {
                  return const FullScreenLoader();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          context.watchTr('sign_in'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Expanded(
                      child: Container(
                        width: 335.w,
                        height: 677.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                              top: isKeyboardOpen ? -150.h : 50.h,
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

                                  // 3. Non-Critical Error Display (Inline)
                                  if (auth.error != null) ...[
                                    ErrorDisplayWidget(
                                      exception: auth.error!,
                                      onRetry: () => auth.clearError(),
                                    ),
                                    SizedBox(height: 16.h),
                                  ] else if (auth.errorMessage.isNotEmpty) ...[
                                    // Fallback for string-based errors
                                    ErrorDisplayWidget(
                                      exception: GenericException(message: auth.errorMessage),
                                      onRetry: () => auth.clear(),
                                    ),
                                    SizedBox(height: 16.h),
                                  ],

                                  InputTextWidget(
                                    hintText: context.watchTr('enter_your_email'),
                                    controller: auth.emailController,
                                    onChanged: (_) => auth.clearError(), // Auto-clear error when user types
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  SizedBox(height: 17.h),
                                  InputTextWidget(
                                    hintText: context.watchTr('enter_your_password'),
                                    obscureText: true,
                                    controller: auth.passwordController,
                                    onChanged: (_) => auth.clearError(), // Auto-clear error when user types
                                    showObscureToggle: true,
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
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
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
                                        onTap: () => context.push(AppRoutes.signup),
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
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
