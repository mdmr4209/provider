import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../../../../widgets/custom_button.dart';
import '../../../routes/app_router.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

// ─── Colors ──────────────────────────────────────────────────────────
class AC {
  static const bg = Color(0xFFFCEDEA);
  static const text = Color(0xFF222222);
  static const textLight = Color(0xFF888888);
  static const primary = Color(0xFFD05278);
  static const purple = Color(0xFF9B30F2);
  static const green = Color(0xFF4CAF50);
  static const sale = Color(0xFF81C784);
  static const cardBg = Color(0xFFF7F5FA);
  static const divider = Color(0xFFEEEEEE);
  static const border = Color(0xFFE0E0E0);
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _promoCtrl = TextEditingController();
  bool _promoError = false;

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        final isEmpty = cart.items.isEmpty;

        return Scaffold(
          backgroundColor: isEmpty
              ? AppColor.backgroundColor
              : AppColor.whiteColor,
          appBar: _appBar(context, cart),
          body: SafeArea(
            child: isEmpty
                ? _buildEmptyState(context)
                : _buildCartContent(cart),
          ),
        );
      },
    );
  }

  // --- UI FOR EMPTY STATE ---
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          children: [
            SizedBox(height: 20.h),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(ImageAssets.bgIcon),
                Positioned(
                  bottom: 0,
                  child: SvgPicture.asset(ImageAssets.bgCart),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              'Your Cart Is Empty',
              textAlign: TextAlign.center,
              style: GoogleFonts.tenorSans(
                color: AppColor.textColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Looks like you haven\'t made\nyour order yet.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                color: AppColor.textColor3,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 32.h),
            CustomButton(
              title: 'SHOP NOW',
              onPress: () async => context.go(AppRoutes.home),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI FOR ACTIVE CART ---
  Widget _buildCartContent(CartProvider cart) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                ...cart.items.map(
                  (item) => _CartItemCard(
                    item: item,
                    onIncrement: () => cart.increment(item.id),
                    onDecrement: () => cart.decrement(item.id),
                    onDelete: () => cart.removeItem(item.id),
                  ),
                ),
                SizedBox(height: 16.h),

                // Promo section
                if (!cart.promoApplied) ...[
                  _PromoInputRow(
                    controller: _promoCtrl,
                    hasError: _promoError,
                    onApply: () {
                      final ok = cart.applyPromo();
                      setState(() => _promoError = !ok);
                      if (ok) _promoCtrl.clear();
                    },
                  ),
                ] else ...[
                  _PromoAppliedBadge(
                    onRemove: () {
                      cart.removePromo();
                      setState(() => _promoError = false);
                    },
                  ),
                ],

                SizedBox(height: 24.h),
                _SummaryCard(cart: cart),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
        // Checkout button
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h),
          child: CustomButton(
            title: 'PROCEED TO CHECKOUT',
            onPress: () => context.push(AppRoutes.checkout),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _appBar(BuildContext context, CartProvider cart) {
    final count = 2;
    return AppBar(
      backgroundColor: AC.bg,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Order',
        style: GoogleFonts.tenorSans(
          color: AC.text,
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: Center(
            child: Badge(
              alignment: Alignment.bottomLeft,
              label: Text(count.toString(), style: TextStyle(fontSize: 10.sp)),
              isLabelVisible: count > 0,
              backgroundColor: AppColor.defaultColor,
              offset: Offset(-5.w, -10.h),
              child: _headerIcon(ImageAssets.cart, onTap: () {}),
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerIcon(String asset, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        asset,
        width: 24.w,
        height: 24.h,
        colorFilter: ColorFilter.mode(AppColor.blackColor, BlendMode.srcIn),
      ),
    );
  }
}

// ─── Cart Item Card ───────────────────────────────────────────────────
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const _CartItemCard({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _confirmDelete(context),
      child: Dismissible(
        key: Key(item.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          color: AC.primary,
          child: Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_outline, color: Colors.white, size: 24.r),
                SizedBox(height: 4.h),
                Text(
                  'DELETE',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        confirmDismiss: (_) async => await _confirmDeleteAsync(context),
        onDismissed: (_) => onDelete(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AC.border, width: 1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Sale badge
              if (item.isOnSale)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                    color: AC.sale,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  child: Text(
                    'SALE',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

              // Name + price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: GoogleFonts.tenorSans(
                        color: AC.text,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        if (item.originalPrice != null) ...[
                          Text(
                            '\$${item.originalPrice!.toStringAsFixed(2)}',
                            style: GoogleFonts.lato(
                              color: AC.textLight,
                              fontSize: 13.sp,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 6.w),
                        ],
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: GoogleFonts.lato(
                            color: item.isOnSale ? AC.primary : AC.text,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Quantity stepper
              _QuantityStepper(
                quantity: item.quantity,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Remove "${item.name}"?',
              style: GoogleFonts.tenorSans(fontSize: 16.sp, color: AC.text),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AC.border),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.lato(color: AC.text, fontSize: 14.sp),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onDelete();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AC.primary,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDeleteAsync(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            title: Text(
              'Remove item?',
              style: GoogleFonts.tenorSans(fontSize: 16.sp),
            ),
            content: Text(
              'Remove "${item.name}" from cart?',
              style: GoogleFonts.lato(fontSize: 13.sp, color: AC.textLight),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.lato(color: AC.textLight),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Delete',
                  style: GoogleFonts.lato(
                    color: AC.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}

// ─── Quantity Stepper ─────────────────────────────────────────────────
class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _QuantityStepper({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StepBtn(icon: Icons.add, onTap: onIncrement),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            '$quantity',
            style: GoogleFonts.lato(
              fontSize: 14.sp,
              color: AC.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _StepBtn(icon: Icons.remove, onTap: onDecrement),
      ],
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          border: Border.all(color: AC.border),
          borderRadius: BorderRadius.circular(4.r),
          color: Colors.white,
        ),
        child: Icon(icon, size: 16.r, color: AC.text),
      ),
    );
  }
}

// ─── Promo Input Row ──────────────────────────────────────────────────
class _PromoInputRow extends StatelessWidget {
  final TextEditingController controller;
  final bool hasError;
  final VoidCallback onApply;

  const _PromoInputRow({
    required this.controller,
    required this.hasError,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 52.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: hasError ? Colors.redAccent : AC.border,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.r),
                      bottomLeft: Radius.circular(4.r),
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.characters,
                    style: GoogleFonts.lato(fontSize: 14.sp, color: AC.text),
                    decoration: InputDecoration(
                      hintText: 'Enter promocode',
                      hintStyle: GoogleFonts.lato(
                        fontSize: 14.sp,
                        color: AC.textLight,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14.w),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onApply,
                child: Container(
                  height: 52.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: AC.border),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4.r),
                      bottomRight: Radius.circular(4.r),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Text(
                      'APPLY',
                      style: GoogleFonts.lato(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: AC.text,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (hasError)
            Padding(
              padding: EdgeInsets.only(top: 6.h, left: 4.w),
              child: Text(
                'Invalid promocode. Try DISCOUNT23',
                style: GoogleFonts.lato(
                  fontSize: 11.sp,
                  color: Colors.redAccent,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Promo Applied Badge ──────────────────────────────────────────────
class _PromoAppliedBadge extends StatelessWidget {
  final VoidCallback onRemove;
  const _PromoAppliedBadge({required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AC.green, size: 20.r),
          SizedBox(width: 8.w),
          Text(
            'Promocode applied',
            style: GoogleFonts.tenorSans(
              color: AC.text,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, color: AC.textLight, size: 18.r),
          ),
        ],
      ),
    );
  }
}

// ─── Summary Card ─────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final CartProvider cart;
  const _SummaryCard({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AC.cardBg,
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Column(
          children: [
            _SummaryRow(
              label: 'Subtotal',
              value: '\$${cart.subtotal.toStringAsFixed(2)}',
            ),
            if (cart.promoApplied) ...[
              SizedBox(height: 10.h),
              _SummaryRow(
                label: 'Discount',
                value: '-\$${cart.discountAmount.toStringAsFixed(2)}',
                valueColor: AC.textLight,
              ),
            ],
            SizedBox(height: 10.h),
            _SummaryRow(label: 'Delivery', value: 'Free', valueColor: AC.green),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: const Divider(color: AC.text, height: 1, thickness: 1),
            ),
            _SummaryRow(
              label: 'Total',
              value: '\$${cart.total.toStringAsFixed(2)}',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14.sp,
            color: isBold ? AC.text : AC.textLight,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 14.sp,
            color: valueColor ?? AC.text,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
