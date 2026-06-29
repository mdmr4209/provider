import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/inbox_controller.dart';
import '../models/booking_model.dart';
import 'package:newproject/core/constants/app_colors.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<InboxController>();
      if (controller.currentBookings.isEmpty &&
          controller.historyBookings.isEmpty &&
          !controller.isLoading) {
        controller.fetchBookings();
      }
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Bookings",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor,
              fontSize: 18.sp,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: AppColors.amberColor,
            labelColor: AppColors.amberColor,
            unselectedLabelColor: AppColors.whiteColor.withAlpha(128),
            dividerColor: AppColors.whiteColor.withAlpha(26),
            tabs: const [
              Tab(text: "Current"),
              Tab(text: "History"),
            ],
          ),
        ),
        body: Consumer<InboxController>(
          builder: (context, controller, child) {
            if (controller.isLoading &&
                controller.currentBookings.isEmpty &&
                controller.historyBookings.isEmpty) {
              return const _BookingsShimmer();
            }

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () => controller.fetchBookings(isRefresh: true),
                  color: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  strokeWidth: 0,
                  elevation: 0,
                  child: TabBarView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      _buildCurrentList(
                        context,
                        controller,
                        controller.currentBookings,
                      ),
                      _buildHistoryList(
                        context,
                        controller,
                        controller.historyBookings,
                      ),
                    ],
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentList(
    BuildContext context,
    InboxController controller,
    List<BookingModel> bookings,
  ) {
    if (bookings.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 100.h),
          Center(
            child: Text(
              "No current bookings.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor.withAlpha(128),
              ),
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(20.r),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _BookingCard(
          controller: controller,
          booking: booking,
          isCurrent: true,
        );
      },
    );
  }

  Widget _buildHistoryList(
    BuildContext context,
    InboxController controller,
    List<BookingModel> bookings,
  ) {
    if (bookings.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 100.h),
          Center(
            child: Text(
              "No booking history.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.whiteColor.withAlpha(128),
              ),
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(20.r),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _BookingCard(
          controller: controller,
          booking: booking,
          isCurrent: false,
        );
      },
    );
  }
}

class _BookingCard extends StatelessWidget {
  final InboxController controller;
  final BookingModel booking;
  final bool isCurrent;
  const _BookingCard({
    required this.controller,
    required this.booking,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.coachColorFF1C2B19,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!isCurrent) ...[
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.greenColor,
                          size: 16,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          booking.date,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.greenColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                      if (isCurrent) ...[
                        Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.whiteColor.withAlpha(128),
                          size: 14.r,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          booking.date,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.whiteColor.withAlpha(128),
                                fontSize: 12.sp,
                              ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColors.whiteColor.withAlpha(128),
                        size: 14.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        booking.originalTime != null
                            ? "${booking.originalTime} -> ${booking.time}"
                            : booking.time,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.whiteColor.withAlpha(128),
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isCurrent)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz,
                    color: AppColors.whiteColor.withAlpha(128),
                  ),
                  color: AppColors.coachColorFF1B2B1B,
                  onSelected: (value) {
                    if (value == 'cancel') {
                      _showCancelDialog(context);
                    } else if (value == 'reschedule') {
                      _showRescheduleDialog(context);
                    }
                  },
                  itemBuilder: (context) => [
                    _buildPopupMenuItem(
                      context,
                      'cancel',
                      'Cancel',
                      Icons.cancel_outlined,
                    ),
                    _buildPopupMenuItem(
                      context,
                      'reschedule',
                      'Request reschedule',
                      Icons.calendar_month_outlined,
                    ),
                  ],
                )
              else
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz,
                    color: AppColors.whiteColor.withAlpha(128),
                  ),
                  color: AppColors.coachColorFF1B2B1B,
                  onSelected: (value) {
                    // Handle history actions
                  },
                  itemBuilder: (context) => [
                    _buildPopupMenuItem(
                      context,
                      'view_profile',
                      'View Profile',
                      Icons.visibility_outlined,
                    ),
                    _buildPopupMenuItem(
                      context,
                      'review',
                      'Give a review',
                      Icons.star_outline,
                    ),
                    _buildPopupMenuItem(
                      context,
                      'report',
                      'Report',
                      Icons.report_gmailerrorred_outlined,
                    ),
                    _buildPopupMenuItem(
                      context,
                      'block',
                      'Block',
                      Icons.block_outlined,
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.coachColorFF263523,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                if (!isCurrent) ...[
                  CircleAvatar(
                    radius: 18.r,
                    backgroundImage: NetworkImage(
                      booking.coachName == "Miles Esther"
                          ? "https://i.pravatar.cc/150?u=miles"
                          : "https://i.pravatar.cc/150?u=thomas",
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: Text(
                    isCurrent ? booking.sessionName : booking.coachName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.whiteColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  booking.amount,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.whiteColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.popupBackgroundColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: AppColors.whiteColor.withAlpha(128),
                    size: 20.r,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Are you sure about Cancelling Session?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPress: () async => Navigator.pop(context),
                      title: "No",
                      buttonColor: AppColors.coachColorFF334B2F,
                      borderColor: Colors.transparent,
                      radius: 4,
                      height: 32,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomButton(
                      onPress: () async {
                        Navigator.pop(context);
                        // Dynamically cancel the booking using InboxController
                        await controller.cancelBooking(booking.id);
                      },
                      title: "Yes",
                      height: 32,
                      radius: 4,
                      linearGradient: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showRescheduleDialog(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.buttonColor,
              onPrimary: AppColors.whiteColor,
              surface: AppColors.popupBackgroundColor,
              onSurface: AppColors.whiteColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      if (!context.mounted) return;
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: AppColors.buttonColor,
                onPrimary: AppColors.whiteColor,
                surface: AppColors.popupBackgroundColor,
                onSurface: AppColors.whiteColor,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        if (!context.mounted) return;
        final formattedDate = DateFormat('dd MMM, yyyy').format(pickedDate);
        final formattedTime = pickedTime.format(context);
        await controller.rescheduleBooking(
          booking.id,
          formattedDate,
          formattedTime,
        );
      }
    }
  }

  PopupMenuItem<String> _buildPopupMenuItem(
    BuildContext context,
    String value,
    String text,
    IconData icon,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: AppColors.whiteColor.withAlpha(153), size: 20.r),
          SizedBox(width: 12.w),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.whiteColor,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingsShimmer extends StatelessWidget {
  const _BookingsShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(20.r),
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.only(bottom: 16.h),
        child: ShimmerLoader(
          width: double.infinity,
          height: 120.h,
          borderRadius: 16.r,
        ),
      ),
    );
  }
}
