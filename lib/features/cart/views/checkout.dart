import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/input_text_widget.dart';
import '../../../routes/app_router.dart';
import '../../localization/localization_extension.dart';
import '../controllers/cart_controller.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartController>(
      builder: (context, cart, _) {
        final commentCtrl = TextEditingController(text: cart.comment);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new, size: 18.r, color: Theme.of(context).iconTheme.color),
            ),
            title: Text(
              context.watchTr('checkout'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      children: [
                        // Order summary card
                        _CheckoutCard(
                          child: Column(
                            children: [
                                _CheckoutCardHeader(
                                  label: context.watchTr('my_order'),
                                  value: '\$${cart.total.toStringAsFixed(2)}',
                                ),
                              SizedBox(height: 12.h),
                              ...cart.items.map(
                                (item) => _CheckoutItemRow(
                                  name: item.name,
                                  qty: item.quantity,
                                  price: item.price,
                                ),
                              ),
                              if (cart.promoApplied)
                                _CheckoutDetailRow(
                                  label: 'Discount',
                                  value:
                                      '-\$${cart.discountAmount.toStringAsFixed(2)}',
                                ),
                                _CheckoutDetailRow(
                                  label: context.watchTr('delivery'),
                                  value: context.watchTr('free'),
                                  valueColor: Colors.green,
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Shipping details
                        _CheckoutCard(
                          onTap: () => context.push(AppRoutes.shipping),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                _CheckoutCardHeader(
                                  label: context.watchTr('shipping_details'),
                                  hasArrow: true,
                                  onTap: () => context.push(AppRoutes.shipping),
                                ),
                              SizedBox(height: 10.h),
                                Text(
                                  cart.selectedAddress.address,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Payment method
                        _CheckoutCard(
                          onTap: () => context.push(AppRoutes.payment),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                _CheckoutCardHeader(
                                  label: context.watchTr('payment_method'),
                                  hasArrow: true,
                                  onTap: () => context.push(AppRoutes.payment),
                                ),
                              SizedBox(height: 10.h),
                                Text(
                                  cart.selectedCard.masked,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Comment field
                        InputTextWidget(
                          height: 130,
                          hintText: context.watchTr('enter_your_comment'),
                          maxLines: 10,
                          borderColor: Theme.of(context).dividerColor,
                          borderRadius: 12,
                          controller: commentCtrl,
                          onChanged: cart.setComment,
                          borderWidth: 1,
                        ),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),

                // Confirm button
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.w,
                    right: 20.w,
                    bottom: 10.h,
                  ),
                  child: CustomButton(
                    title:
                        '${context.watchTr('confirm_order')} (\$${(cart.total + 1).toStringAsFixed(2)})',
                    onPress: () async =>
                        context.push(AppRoutes.confirm, extra: false),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CheckoutCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _CheckoutCard({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Theme.of(context).dividerColor, width: 0.5),
        ),
        child: child,
      ),
    );
  }
}

class _CheckoutCardHeader extends StatelessWidget {
  final String label;
  final String? value;
  final bool hasArrow;
  final VoidCallback? onTap;

  const _CheckoutCardHeader({
    required this.label,
    this.value,
    this.hasArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Row(
              children: [
                if (value != null)
                  Text(
                    value!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                SizedBox(width: 4.w),
                Icon(Icons.chevron_right, size: 20.r, color: Theme.of(context).iconTheme.color),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Divider(color: Theme.of(context).dividerColor, height: 1, thickness: 1),
      ],
    );
  }
}

class _CheckoutItemRow extends StatelessWidget {
  final String name;
  final int qty;
  final double price;
  const _CheckoutItemRow({
    required this.name,
    required this.qty,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Text(
            '$qty x \$${price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _CheckoutDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _CheckoutDetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: valueColor ?? Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
