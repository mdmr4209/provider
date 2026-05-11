import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../controllers/auth_controller.dart';
import '../../localization/localization_extension.dart';
import '../../../routes/app_router.dart';

class GoToHome extends StatelessWidget {
  final String? origin;
  const GoToHome({super.key, this.origin});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h),
                SvgPicture.asset(ImageAssets.title),
                SizedBox(height: 15.h),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(ImageAssets.bgIcon),
                    Positioned(
                        bottom: 0,
                        child: SvgPicture.asset( origin == "Sign up"?ImageAssets.account:ImageAssets.password)),
                  ],
                ),
                Consumer<AuthController>(
                  builder: (context, auth, _) => Expanded(
                    child: ListView(
                      children: [
                        SizedBox(height: 30.h),
                        Text(
                          origin == "Sign up"
                              ? context.watchTr('account_created')
                              : context.watchTr('password_reset_success'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          origin == "Sign up"
                              ? context.watchTr('account_created_msg')
                              : context.watchTr('password_reset_msg'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 30.h),
                        CustomButton(
                          height: 60,
                          title: origin == "Sign up" ? context.watchTr('shop_now') : context.watchTr('done'),
                          onPress: auth.isHomeLoading
                              ? null
                              : () async {
                                  auth.clear();
                                  context.push(AppRoutes.home);
                                },
                          loading: auth.isHomeLoading,
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
      ),
    );
  }
}
