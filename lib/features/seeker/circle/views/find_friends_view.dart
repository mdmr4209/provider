import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/circle_controller.dart';
import '../models/circle_post_model.dart';

class FindFriendsView extends StatelessWidget {
  const FindFriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Fetch recommendations
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<CircleController>();
      if (controller.discoverSuggestions.isEmpty && !controller.isLoading) {
        controller.fetchDiscoverSuggestions();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Find Friends",
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.whiteColor,
            fontFamily: 'Georgia',
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<CircleController>(
        builder: (context, controller, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: CustomInput(
                  height: 48,
                  hintText: "Search Friends",
                  backgroundColor: AppColors.whiteColor.withAlpha(13),
                  borderRadius: 24,
                  shadow: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Text(
                  "Suggestions",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor.withAlpha(128),
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Expanded(
                child: controller.isLoading
                    ? GridView.builder(
                        padding: EdgeInsets.all(16.w),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: 4,
                        itemBuilder: (context, index) => ShimmerLoader(
                          width: double.infinity,
                          height: 180.h,
                          borderRadius: 16.r,
                        ),
                      )
                    : Stack(
                        children: [
                          RefreshIndicator(
                            onRefresh: () => controller.fetchDiscoverSuggestions(isRefresh: true),
                            color: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            strokeWidth: 0,
                            elevation: 0,
                            child: controller.discoverSuggestions.isEmpty
                                ? ListView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    children: [
                                      SizedBox(height: 100.h),
                                      Center(
                                        child: Text(
                                          "No suggestions available.",
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.whiteColor.withAlpha(128)),
                                        ),
                                      ),
                                    ],
                                  )
                                : GridView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.all(16.w),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16.w,
                                      mainAxisSpacing: 16.h,
                                      childAspectRatio: 0.75,
                                    ),
                                    itemCount: controller.discoverSuggestions.length,
                                    itemBuilder: (context, index) {
                                      final suggestion = controller.discoverSuggestions[index];
                                      return _UserDiscoveryCard(suggestion: suggestion);
                                    },
                                  ),
                          ),
                          if (controller.isRefreshing)
                            Positioned(
                              top: 16.h,
                              left: 0,
                              right: 0,
                              child: const Center(child: CustomLoader(size: 150)),
                            ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _UserDiscoveryCard extends StatelessWidget {
  final SuggestionModel suggestion;

  const _UserDiscoveryCard({required this.suggestion});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.postCardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.whiteColor.withAlpha(13)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundImage: NetworkImage(suggestion.avatar),
            backgroundColor: AppColors.whiteColor.withAlpha(26),
          ),
          SizedBox(height: 12.h),
          Text(
            suggestion.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "${suggestion.mutualFriends} mutual Friend",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor.withAlpha(128),
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 12.h),
          CustomButton(
            onPress: () async {},
            title: "Add Friedns", // Keep the original "Add Friedns" label
            linearGradient: true,
            height: 32.h,
            fontSize: 12,
            radius: 8,
          ),
        ],
      ),
    );
  }
}

