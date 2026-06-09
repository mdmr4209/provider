import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/input_text_widget.dart';
import '../../../core/widgets/background_widget.dart';
import '../../../routes/app_router.dart';
import '../../localization/localization_extension.dart';
import '../controllers/auth_controller.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      imagePath: 'assets/images/bg1.png',
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
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
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Theme.of(context).iconTheme.color,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Reset Password',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      SizedBox(width: 20.w),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: 335.w,
                    height: 331.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withAlpha(200),
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
                                  context.watchTr('reset_pass_msg'),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              SizedBox(height: 30.h),
                              InputTextWidget(
                                hintText: context.watchTr('enter_your_password'),
                                obscureText: true,
                                onChanged: (_) {},
                                controller: auth.setPasswordController,
                                leadingIconHeight: 18,
                                leadingIconWidth: 14,
                              ),
                              SizedBox(height: 20.h),
                              InputTextWidget(
                                hintText: context.watchTr(
                                  'confirm_your_password',
                                ),
                                obscureText: true,
                                onChanged: (_) {},
                                leadingIconHeight: 18,
                                leadingIconWidth: 14,
                                controller: auth.confirmPasswordController,
                              ),
                              SizedBox(height: 20.h),
                              CustomButton(
                                height: 60,
                                title: context.watchTr('change_password_caps'),
                                fontWeight: FontWeight.w900,
                                onPress: auth.isLoading
                                    ? null
                                    : () async {
                                        context.push(AppRoutes.goToHome);
                                      },
                                loading: auth.isLoading,
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
      ),
    );
  }
}
