import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/input_text_widget.dart';
import '../../../routes/app_router.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: AppColor.backgroundColor),
            child: SafeArea(
              child: SizedBox(
                height: 47.h,
                child: Stack(
                  children: [
                    Positioned(
                      left: 331.w,
                      top: 10.h,
                      child: InkWell(
                        onTap: () => context.push(AppRoutes.filter),
                        child: Container(
                          width: 24.r,
                          height: 24.r,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(),
                          child: SvgPicture.asset(ImageAssets.filter),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 17.w,
                      top: 11.h,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 16.r,
                            height: 16.r,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: SvgPicture.asset(ImageAssets.search),
                          ),
                          InputTextWidget(
                            width: 260.w,
                            height: 20.h,
                            contentPadding: false,
                            horizontal: 0,
                            onChanged: (onChanged) {},
                            hintText: 'Search',
                            backgroundColor: AppColor.backgroundColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
