import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/constants/app_colors.dart';
import '../../../routes/app_router.dart';
import '../../localization/localization_extension.dart';
import '../controllers/cart_controller.dart';

class ConfirmOrderView extends StatelessWidget {
  final bool? origin;
  const ConfirmOrderView({super.key, this.origin});

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
                SvgPicture.asset(AppAssets.title),
                SizedBox(height: 15.h),
                // Stack(
                //   alignment: Alignment.center,
                //   children: [
                //     Image.asset(AppAssets.bgIcon),
                //     Positioned(
                //       bottom: 0,
                //       child: SvgPicture.asset(
                //         origin == true ? AppAssets.bgThank : AppAssets.bgSorry,
                //       ),
                //     ),
                //   ],
                // ),
                Consumer<CartController>(
                  builder: (context, cart, _) => Expanded(
                    child: ListView(
                      children: [
                        SizedBox(height: 30.h),
                        Text(
                          origin == true
                              ? context.watchTr('thank_you_order')
                              : context.watchTr('order_failed'),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        SizedBox(height: 10.h),
                        origin == true
                            ? SizedBox(
                                width: 290.w,
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: context.watchTr(
                                          'congrats_points',
                                        ),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                      TextSpan(
                                        text:
                                            ' 5 ${context.watchTr('points')}\n',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      TextSpan(
                                        text: context.watchTr('thank_you'),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Text(
                                context.watchTr('something_went_wrong'),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                        SizedBox(height: 30.h),
                        CustomButton(
                          height: 60,
                          title: origin == true
                              ? context.watchTr('view_orders')
                              : context.watchTr('continue_shopping'),
                          onPress: () async {
                            origin == true
                                ? context.push(AppRoutes.orderHistory)
                                : context.go(AppRoutes.order);
                          },
                        ),
                        SizedBox(height: 10.h),
                        CustomButton(
                          height: 60,
                          textColor: AppColors.textColor,
                          buttonColor: AppColors.whiteColor,
                          title: origin == true
                              ? context.watchTr('try_again')
                              : context.watchTr('go_to_profile'),
                          onPress: () async {
                            origin == true
                                ? context.go(AppRoutes.home)
                                : context.go(AppRoutes.profile);
                          },
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
