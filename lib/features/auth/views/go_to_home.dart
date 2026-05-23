import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../routes/app_router.dart';
import '../../localization/localization_extension.dart';
import '../controllers/auth_controller.dart';

class GoToHome extends StatelessWidget {
  final String? origin;
  const GoToHome({super.key, this.origin});

  @override
  Widget build(BuildContext context) {
    // Standardizing the origin check based on AuthController refactor
    final isSignup = origin?.toLowerCase() == "signup" || origin == "Sign up";

    return BackgroundWidget(
      imagePath: 'assets/images/bg1.png',
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 160.r,
                        height: 160.r,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Icon(
                        isSignup ? Icons.person_add_alt_1_rounded : Icons.lock_reset_rounded,
                        size: 80.r,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    isSignup
                        ? context.watchTr('account_created')
                        : context.watchTr('password_reset_success'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    isSignup
                        ? context.watchTr('account_created_msg')
                        : context.watchTr('password_reset_msg'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Consumer<AuthController>(
                    builder: (context, auth, _) => CustomButton(
                      height: 56,
                      title: isSignup ? context.watchTr('shop_now') : context.watchTr('done'),
                      onPress: auth.isLoading
                          ? null
                          : () async {
                              // Reset input controllers but don't log out (don't call auth.clear())
                              auth.clearInputFields();
                              // Navigate to home and clear navigation stack
                              context.go(AppRoutes.home);
                            },
                      loading: auth.isLoading,
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
