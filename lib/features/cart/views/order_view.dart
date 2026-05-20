import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../routes/app_router.dart';
import '../../localization/localization_extension.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_item.dart';

// ─── Colors ──────────────────────────────────────────────────────────
// AC class removed in favor of Theme.of(context)

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
    return Consumer<CartController>(
      builder: (context, cart, _) {
        final isEmpty = cart.items.isEmpty;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                Image.asset(AppAssets.bgIcon),
                Positioned(
                  bottom: 0,
                  child: SvgPicture.asset(AppAssets.bgCart),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              context.watchTr('your_cart_is_empty'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12.h),
            Text(
              context.watchTr('cart_empty_msg'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 32.h),
            CustomButton(
              title: context.watchTr('shop_now'),
              onPress: () async => context.go(AppRoutes.home),
            ),
          ],
        ),
      ),
    );
  }

  // --- UI FOR ACTIVE CART ---
  Widget _buildCartContent(CartController cart) {
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
            title: context.watchTr('proceed_to_checkout'),
            onPress: () => context.push(AppRoutes.checkout),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _appBar(BuildContext context, CartController cart) {
    final count = 2;
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        context.watchTr('order'),
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: Center(
            child: Badge(
              alignment: Alignment.bottomLeft,
              label: Text(count.toString(), style: TextStyle(fontSize: 10.sp)),
              isLabelVisible: count > 0,
              backgroundColor: Theme.of(context).colorScheme.primary,
              offset: Offset(-5.w, -10.h),
              child: _headerIcon(AppAssets.cart, onTap: () {}),
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
        colorFilter: ColorFilter.mode(Theme.of(context).iconTheme.color ?? Colors.black, BlendMode.srcIn),
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
          color: Theme.of(context).colorScheme.primary,
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
            color: Theme.of(context).cardTheme.color,
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
            borderRadius: BorderRadius.circular(12.r),
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
                    color: Theme.of(context).colorScheme.secondary,
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
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        if (item.originalPrice != null) ...[
                          Text(
                            '\$${item.originalPrice!.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 6.w),
                        ],
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: item.isOnSale ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodyLarge?.color,
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
              style: GoogleFonts.tenorSans(fontSize: 16.sp, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Theme.of(context).dividerColor),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    child: Text(
                      context.watchTr('cancel'),
                      style: Theme.of(context).textTheme.bodyMedium,
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
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
              style: GoogleFonts.lato(fontSize: 13.sp, color: Theme.of(context).disabledColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.lato(color: Theme.of(context).disabledColor),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  context.watchTr('delete'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
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
              color: Theme.of(context).textTheme.bodyLarge?.color,
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
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(4.r),
          color: Theme.of(context).cardTheme.color,
        ),
        child: Icon(icon, size: 16.r, color: Theme.of(context).iconTheme.color),
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
                      color: hasError ? Colors.redAccent : Theme.of(context).dividerColor,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.r),
                      bottomLeft: Radius.circular(4.r),
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.characters,
                    style: GoogleFonts.lato(fontSize: 14.sp, color: Theme.of(context).textTheme.bodyLarge?.color),
                    decoration: InputDecoration(
                      hintText: 'Enter promocode',
                      hintStyle: GoogleFonts.lato(
                        fontSize: 14.sp,
                        color: Theme.of(context).disabledColor,
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
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4.r),
                      bottomRight: Radius.circular(4.r),
                    ),
                    color: Theme.of(context).cardTheme.color,
                  ),
                  child: Center(
                    child: Text(
                      'APPLY',
                      style: GoogleFonts.lato(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
          Icon(Icons.check_circle, color: Colors.green, size: 20.r),
          SizedBox(width: 8.w),
          Text(
            'Promocode applied',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Spacer(),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, color: Theme.of(context).disabledColor, size: 18.r),
          ),
        ],
      ),
    );
  }
}

// ─── Summary Card ─────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final CartController cart;
  const _SummaryCard({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12.r),
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
                valueColor: Theme.of(context).disabledColor,
              ),
            ],
            SizedBox(height: 10.h),
            _SummaryRow(label: 'Delivery', value: 'Free', valueColor: Colors.green),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Divider(color: Theme.of(context).dividerColor, height: 1, thickness: 1),
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isBold ? Theme.of(context).textTheme.bodyLarge?.color : Theme.of(context).textTheme.bodySmall?.color,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 14.sp,
            color: valueColor ?? Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
