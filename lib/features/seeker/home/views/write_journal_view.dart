import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newproject/core/constants/app_colors.dart';
import 'package:newproject/core/widgets/background_widget.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/home_controller.dart';

class WriteJournalView extends StatelessWidget {
  const WriteJournalView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = context.read<HomeController>();
    final textTheme = Theme.of(context).textTheme;
    return BackgroundWidget(
      imagePath: AppAssets.bgJournal,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),

        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: const Color(0xFF4A6741),
                size: 26.r,
              ),
              onPressed: () => Navigator.pop(context),
            ), // ── Header ────────────────────────────────────────────────────────
            title: Text(
              "Write Journals",
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.whiteColor,
                fontFamily: 'Georgia',
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ── Journal Input Area ─────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 245.h,
                    padding: EdgeInsets.all(20.r),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(77),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.white.withAlpha(13)),
                    ),
                    child: TextField(
                      controller: homeController.journalController,
                      maxLines: null,
                      autofocus: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontFamily: 'Georgia',
                      ),
                      decoration: InputDecoration(
                        hintText: " 🪶  Share Your Thoughts",
                        hintStyle: TextStyle(
                          color: Colors.white.withAlpha(77),
                          fontSize: 13.sp,
                        ),
                        border: InputBorder.none,
                        // isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),

                // ── Post Button ────────────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.only(
                    left: 24.w,
                    right: 24.w,
                    bottom: 30.h,
                  ),
                  child: CustomButton(
                    onPress: () async {
                      homeController.postJournal();
                    },
                    title: "Save Now",
                    linearGradient: true,
                    height: 56,
                    fontSize: 18,
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
