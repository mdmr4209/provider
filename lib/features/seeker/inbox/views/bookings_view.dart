import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_loader.dart';
import '../controllers/inbox_controller.dart';
import '../models/booking_model.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<InboxController>();
      if (controller.currentBookings.isEmpty && controller.historyBookings.isEmpty && !controller.isLoading) {
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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("Bookings", style: TextStyle(color: Colors.white, fontSize: 18.sp)),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white.withAlpha(128),
            dividerColor: Colors.white.withAlpha(26),
            tabs: const [Tab(text: "Current"), Tab(text: "History")],
          ),
        ),
        body: Consumer<InboxController>(
          builder: (context, controller, child) {
            if (controller.isLoading && controller.currentBookings.isEmpty && controller.historyBookings.isEmpty) {
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
                      _buildCurrentList(controller, controller.currentBookings),
                      _buildHistoryList(controller, controller.historyBookings),
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

  Widget _buildCurrentList(InboxController controller, List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 100.h),
          Center(
            child: Text("No current bookings.", style: TextStyle(color: Colors.white.withAlpha(128))),
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

  Widget _buildHistoryList(InboxController controller, List<BookingModel> bookings) {
    if (bookings.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 100.h),
          Center(
            child: Text("No booking history.", style: TextStyle(color: Colors.white.withAlpha(128))),
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
  const _BookingCard({required this.controller, required this.booking, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(13),
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
                        const Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 8.w),
                        Text(booking.date, style: TextStyle(color: Colors.green, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                      ],
                      if (isCurrent) ...[
                        Icon(Icons.calendar_today_outlined, color: Colors.white.withAlpha(128), size: 14.r),
                        SizedBox(width: 8.w),
                        Text(booking.date, style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp)),
                      ],
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.white.withAlpha(128), size: 14.r),
                      SizedBox(width: 8.w),
                      Text(booking.time, style: TextStyle(color: Colors.white.withAlpha(128), fontSize: 12.sp)),
                    ],
                  ),
                ],
              ),
              if (isCurrent)
                GestureDetector(
                  onTap: () => _showCancelDialog(context),
                  child: Row(
                    children: [
                      Icon(Icons.cancel_outlined, color: Colors.red.withAlpha(179), size: 18.r),
                      SizedBox(width: 4.w),
                      Text("Cancel", style: TextStyle(color: Colors.red.withAlpha(179), fontSize: 12.sp)),
                    ],
                  ),
                )
              else
                IconButton(
                  icon: Icon(Icons.more_horiz, color: Colors.white.withAlpha(128)),
                  onPressed: () => _showHistoryMenu(context),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(color: Colors.black.withAlpha(26), borderRadius: BorderRadius.circular(12.r)),
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
                    style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  booking.amount,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
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
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(color: const Color(0xFF20341F), borderRadius: BorderRadius.circular(20.r)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(alignment: Alignment.topRight, child: GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.close, color: Colors.white.withAlpha(128), size: 20.r))),
              SizedBox(height: 10.h),
              Text("Are you sure about Cancelling Session?", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(child: CustomButton(onPress: () async => Navigator.pop(context), title: "No", buttonColor: const Color(0xFF334B2F), borderColor: Colors.transparent)),
                  SizedBox(width: 12.w),
                  Expanded(child: CustomButton(onPress: () async {
                    Navigator.pop(context);
                    // Dynamically cancel the booking using InboxController
                    await controller.cancelBooking(booking.id);
                  }, title: "Yes", linearGradient: true)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHistoryMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B2B1B),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(leading: const Icon(Icons.visibility_outlined, color: Colors.white70), title: const Text("View Profile", style: TextStyle(color: Colors.white)), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.star_outline, color: Colors.white70), title: const Text("Give a review", style: TextStyle(color: Colors.white)), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.report_gmailerrorred_outlined, color: Colors.white70), title: const Text("Report", style: TextStyle(color: Colors.white)), onTap: () => Navigator.pop(context)),
          ListTile(leading: const Icon(Icons.block_outlined, color: Colors.white70), title: const Text("Block", style: TextStyle(color: Colors.white)), onTap: () => Navigator.pop(context)),
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
        child: ShimmerLoader(width: double.infinity, height: 120.h, borderRadius: 16.r),
      ),
    );
  }
}
