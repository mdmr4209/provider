import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/input_text_widget.dart';
import '../../../routes/app_router.dart';
import '../../localization/localization_extension.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
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
                          child: SvgPicture.asset(AppAssets.filter),
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
                            child: SvgPicture.asset(AppAssets.search),
                          ),
                          InputTextWidget(
                            width: 260.w,
                            height: 20.h,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 0.w,
                            ),
                            onChanged: (onChanged) {},
                            hintText: context.watchTr('search'),
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
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
