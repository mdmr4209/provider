import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../profile/controllers/profile_controller.dart';
import '../../localization/localization_extension.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20.r,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        title: Text(
          context.watchTr('order_history'),
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Consumer<ProfileController>(
        builder: (context, profile, _) => SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  children: [
                    SizedBox(height: 20.h),

                    // On its way
                    _orderCard(
                      context: context,
                      orderId: '#205479',
                      status: 'On its way',
                      statusColor: const Color(0xFFFFBE00),
                      date: 'Jul 12, 2022 at 7:48 PM',
                      price: '\$568.92',
                      isExpanded: profile.expandedOrderId == '#205479',
                      onTap: () => profile.toggleOrderExpansion('#205479'),
                    ),

                    // Delivered (Expanded Example)
                    _orderCard(
                      context: context,
                      orderId: '#198452',
                      status: 'Delivered',
                      statusColor: Colors.green,
                      date: 'Jun 26, 2022 at 3:16 PM',
                      price: '\$588.80',
                      isExpanded: profile.expandedOrderId == '#198452',
                      onTap: () => profile.toggleOrderExpansion('#198452'),
                    ),
                    _orderCard(
                      context: context,
                      orderId: '#198454',
                      status: 'Delivered',
                      statusColor: Colors.green,
                      date: 'Jun 26, 2022 at 3:16 PM',
                      price: '\$428.80',
                      isExpanded: profile.expandedOrderId == '#198454',
                      onTap: () => profile.toggleOrderExpansion('#198454'),
                    ),

                    // Canceled
                    _orderCard(
                      context: context,
                      orderId: '#116878',
                      status: 'Canceled',
                      statusColor: const Color(0xFFD05278),
                      date: 'May 22, 2022 at 2:27 PM',
                      price: '\$367.24',
                      isExpanded: profile.expandedOrderId == '#116878',
                      onTap: () => profile.toggleOrderExpansion('#116878'),
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _orderCard({
    required BuildContext context,
    required String orderId,
    required String status,
    required Color statusColor,
    required String date,
    required String price,
    required VoidCallback onTap, // Added callback
    bool isExpanded = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          // Background turns surface color only when expanded
          color: isExpanded
              ? Theme.of(context).colorScheme.surface
              : Theme.of(context).cardTheme.color,
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(orderId, style: Theme.of(context).textTheme.bodyLarge),
                Row(
                  children: [
                    Text(
                      status,
                      style: GoogleFonts.lato(
                        color: statusColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    // Icon changes based on expansion state
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 18.r,
                      color: statusColor,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // Price and Date Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(date, style: Theme.of(context).textTheme.bodySmall),
                Text(
                  price,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            // CONDITIONAL DETAILS SECTION
            if (isExpanded) ...[
              Divider(height: 30.h, color: Theme.of(context).dividerColor),
              _productLine(context, 'Foundation Beshop', '1 x \$401.90'),
              _productLine(
                context,
                'Hair mask with oat extract',
                '1 x \$125.95',
              ),
              _productLine(
                context,
                'Spray balm with oat extract',
                '1 x \$60.95',
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _actionButton(
                    context,
                    Icons.refresh,
                    context.watchTr('repeat_order'),
                    Theme.of(context).textTheme.bodyLarge?.color ??
                        Colors.black,
                  ),
                  _actionButton(
                    context,
                    Icons.star_outline,
                    context.watchTr('leave_review'),
                    const Color(0xFFD05278),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _productLine(BuildContext context, String name, String qtyPrice) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(name, style: Theme.of(context).textTheme.bodySmall),
          ),
          Text(qtyPrice, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: color),
        SizedBox(width: 6.w),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
