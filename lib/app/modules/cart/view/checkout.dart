import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/custom_button.dart';
import '../../../../widgets/input_text_widget.dart';
import '../../../routes/app_router.dart';
import '../providers/cart_provider.dart';
import 'order_view.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final commentCtrl = TextEditingController(text: cart.comment);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AC.bg,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new, size: 18.r, color: AC.text),
            ),
            title: Text(
              'Checkout',
              style: GoogleFonts.tenorSans(
                color: AC.text,
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
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
                                label: 'My order',
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
                                label: 'Delivery',
                                value: 'Free',
                                valueColor: AC.green,
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
                                label: 'Shipping details',
                                hasArrow: true,
                                onTap: () => context.push(AppRoutes.shipping),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                cart.selectedAddress.address,
                                style: GoogleFonts.lato(
                                  fontSize: 13.sp,
                                  color: AC.textLight,
                                ),
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
                                label: 'Payment method',
                                hasArrow: true,
                                onTap: () => context.push(AppRoutes.payment),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                cart.selectedCard.masked,
                                style: GoogleFonts.lato(
                                  fontSize: 13.sp,
                                  color: AC.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Comment field
                        InputTextWidget(
                          height: 130,
                          hintText: 'Enter your comment',
                          maxLines: 10,
                          borderColor: AC.border,
                          borderRadius: 4,
                          textEditingController: commentCtrl,
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
                        'CONFIRM ORDER (\$${(cart.total + 1).toStringAsFixed(2)})',
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
          color: AC.cardBg,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: AC.border, width: 0.5),
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
              style: GoogleFonts.tenorSans(
                fontSize: 16.sp,
                color: AC.text,
                fontWeight: FontWeight.w400,
              ),
            ),
            Row(
              children: [
                if (value != null)
                  Text(
                    value!,
                    style: GoogleFonts.lato(
                      fontSize: 14.sp,
                      color: AC.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (hasArrow) ...[
                  SizedBox(width: 4.w),
                  Icon(Icons.chevron_right, size: 20.r, color: AC.textLight),
                ],
              ],
            ),
          ],
        ),
        SizedBox(height: 10.h),
        const Divider(color: AC.text, height: 1, thickness: 1),
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
              style: GoogleFonts.lato(fontSize: 13.sp, color: AC.textLight),
            ),
          ),
          Text(
            '$qty x \$${price.toStringAsFixed(2)}',
            style: GoogleFonts.lato(fontSize: 13.sp, color: AC.textLight),
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
            style: GoogleFonts.lato(fontSize: 13.sp, color: AC.textLight),
          ),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 13.sp,
              color: valueColor ?? AC.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
