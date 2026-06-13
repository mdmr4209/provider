import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/group_controller.dart';
import '../models/group_model.dart';

class GroupReportsView extends StatelessWidget {
  const GroupReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<GroupController>();
      if (controller.reports.isEmpty && !controller.isLoading) {
        controller.fetchGroupReports();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.people_alt, color: AppColors.secondaryColorLight, size: 24.r),
            SizedBox(width: 8.w),
            Text(
              "List of Reports",
              style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Consumer<GroupController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: CustomInput(
                  height: 48,
                  hintText: "Search Follower",
                  backgroundColor: Colors.white.withAlpha(13),
                  borderRadius: 24,
                  shadow: false,
                ),
              ),
              Expanded(
                child: controller.isLoading
                    ? ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: 3,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: ShimmerLoader(
                            width: double.infinity,
                            height: 56.h,
                            borderRadius: 12.r,
                          ),
                        ),
                      )
                    : Stack(
                        children: [
                          RefreshIndicator(
                            onRefresh: () => controller.fetchGroupReports(isRefresh: true),
                            color: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            strokeWidth: 0,
                            elevation: 0,
                            child: controller.reports.isEmpty
                                ? ListView(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    children: [
                                      SizedBox(height: 100.h),
                                      Center(
                                        child: Text(
                                          "No reports available.",
                                          style: TextStyle(color: Colors.white.withAlpha(128)),
                                        ),
                                      ),
                                    ],
                                  )
                                : ListView.builder(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                                    itemCount: controller.reports.length,
                                    itemBuilder: (context, index) {
                                      final report = controller.reports[index];
                                      return _ReportTile(report: report);
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

class _ReportTile extends StatelessWidget {
  final GroupReportModel report;

  const _ReportTile({required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.postCardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${report.id}'),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              report.reporterName,
              style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
          CustomButton(
            onPress: () async => _showReportDetails(context),
            title: "View Report",
            width: 100,
            height: 32,
            fontSize: 12,
            buttonColor: Colors.white.withAlpha(13),
            borderColor: Colors.transparent,
            radius: 8,
          ),
        ],
      ),
    );
  }

  void _showReportDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: const Color(0xFF20341F),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withAlpha(13)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${report.category} Report", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, color: Colors.white.withAlpha(128), size: 20.r),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=reported'),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(report.reportedUserName, style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w500)),
                  ),
                  Icon(Icons.visibility_outlined, color: AppColors.secondaryColorLight, size: 16.r),
                  SizedBox(width: 4.w),
                  Text("View", style: TextStyle(color: AppColors.secondaryColorLight, fontSize: 13.sp)),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(26),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  report.content,
                  style: TextStyle(color: Colors.white.withAlpha(179), fontSize: 13.sp, height: 1.5),
                ),
              ),
              SizedBox(height: 24.h),
              CustomButton(
                onPress: () async => Navigator.pop(context),
                title: "Mark resolved",
                linearGradient: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

