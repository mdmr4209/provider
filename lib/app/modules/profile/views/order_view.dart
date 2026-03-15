import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

// ══════════════════════════════════════════════════════════════════════
//  SCREEN 1 & 2 — ORDER (Cart)
// ══════════════════════════════════════════════════════════════════════
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
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _appBar(context, cart),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12.h),
                      // Cart items
                      ...cart.items.map((item) => _CartItemCard(
                            item: item,
                            onIncrement: () => cart.increment(item.id),
                            onDecrement: () => cart.decrement(item.id),
                            onDelete: () => cart.removeItem(item.id),
                          )),
                      SizedBox(height: 16.h),

                      // Promo section
                      if (!cart.promoApplied) ...[
                        _PromoInputRow(
                          controller: _promoCtrl,
                          hasError: _promoError,
                          onApply: () {
                            cart.setPromoInput(_promoCtrl.text);
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

                      // Summary card
                      _SummaryCard(cart: cart),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),

              // Checkout button
              _CheckoutButton(
                label: 'PROCEED TO CHECKOUT',
                onTap: () => Navigator.pushNamed(context, '/checkout'),
              ),
            ],
          ),
          bottomNavigationBar: _BottomNav(currentIndex: 2),
        );
      },
    );
  }

  PreferredSizeWidget _appBar(BuildContext context, CartProvider cart) {
    return AppBar(
      backgroundColor: AC.bg,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: Icon(Icons.arrow_back_ios_new, size: 18.r, color: AC.text),
      ),
      title: Text('Order',
          style: GoogleFonts.tenorSans(
              color: AC.text, fontSize: 20.sp, fontWeight: FontWeight.w400)),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 28.w, right: 8.w, top: 6.h, bottom: 6.h),
                decoration: BoxDecoration(
                  color: AC.primary,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '\$${cart.badgeTotal.toStringAsFixed(2)}',
                  style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Icon(Icons.shopping_basket_outlined,
                  color: AC.text, size: 22.r),
            ],
          ),
        ),
      ],
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
                Text('DELETE',
                    style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700)),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  margin: EdgeInsets.only(right: 10.w),
                  decoration: BoxDecoration(
                    color: AC.sale,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                  child: Text('SALE',
                      style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5)),
                ),

              // Name + price
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: GoogleFonts.tenorSans(
                            color: AC.text,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400)),
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      builder: (_) => Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Remove "${item.name}"?',
                style: GoogleFonts.tenorSans(
                    fontSize: 16.sp, color: AC.text)),
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
                          borderRadius: BorderRadius.circular(4.r)),
                    ),
                    child: Text('Cancel',
                        style: GoogleFonts.lato(color: AC.text, fontSize: 14.sp)),
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
                          borderRadius: BorderRadius.circular(4.r)),
                    ),
                    child: Text('Delete',
                        style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700)),
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
                borderRadius: BorderRadius.circular(8.r)),
            title: Text('Remove item?',
                style: GoogleFonts.tenorSans(fontSize: 16.sp)),
            content: Text('Remove "${item.name}" from cart?',
                style: GoogleFonts.lato(fontSize: 13.sp, color: AC.textLight)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Cancel',
                      style: GoogleFonts.lato(color: AC.textLight))),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Delete',
                      style: GoogleFonts.lato(
                          color: AC.primary, fontWeight: FontWeight.w700))),
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
          child: Text('$quantity',
              style: GoogleFonts.lato(
                  fontSize: 14.sp,
                  color: AC.text,
                  fontWeight: FontWeight.w600)),
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
                        color: hasError ? Colors.redAccent : AC.border),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.r),
                      bottomLeft: Radius.circular(4.r),
                    ),
                  ),
                  child: TextField(
                    controller: controller,
                    textCapitalization: TextCapitalization.characters,
                    style: GoogleFonts.lato(
                        fontSize: 14.sp, color: AC.text),
                    decoration: InputDecoration(
                      hintText: 'Enter promocode',
                      hintStyle: GoogleFonts.lato(
                          fontSize: 14.sp, color: AC.textLight),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 14.w),
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
                    child: Text('APPLY',
                        style: GoogleFonts.lato(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                            color: AC.text,
                            letterSpacing: 0.5)),
                  ),
                ),
              ),
            ],
          ),
          if (hasError)
            Padding(
              padding: EdgeInsets.only(top: 6.h, left: 4.w),
              child: Text('Invalid promocode. Try DISCOUNT23',
                  style: GoogleFonts.lato(
                      fontSize: 11.sp, color: Colors.redAccent)),
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
          Text('Promocode applied',
              style: GoogleFonts.tenorSans(
                  color: AC.text,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w400)),
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
                value: '\$${cart.subtotal.toStringAsFixed(2)}'),
            if (cart.promoApplied) ...[
              SizedBox(height: 10.h),
              _SummaryRow(
                  label: 'Discount',
                  value: '-\$${cart.discountAmount.toStringAsFixed(2)}',
                  valueColor: AC.textLight),
            ],
            SizedBox(height: 10.h),
            _SummaryRow(
                label: 'Delivery',
                value: 'Free',
                valueColor: AC.green),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: const Divider(color: AC.text, height: 1, thickness: 1),
            ),
            _SummaryRow(
                label: 'Total',
                value: '\$${cart.total.toStringAsFixed(2)}',
                isBold: true),
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
        Text(label,
            style: GoogleFonts.lato(
                fontSize: 14.sp,
                color: isBold ? AC.text : AC.textLight,
                fontWeight:
                    isBold ? FontWeight.w700 : FontWeight.w400)),
        Text(value,
            style: GoogleFonts.lato(
                fontSize: 14.sp,
                color: valueColor ?? AC.text,
                fontWeight:
                    isBold ? FontWeight.w700 : FontWeight.w400)),
      ],
    );
  }
}

// ─── Checkout Button ──────────────────────────────────────────────────
class _CheckoutButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _CheckoutButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: AC.purple,
        padding: EdgeInsets.symmetric(vertical: 18.h),
        child: Text(label,
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0)),
      ),
    );
  }
}

// ─── Bottom Nav ───────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  const _BottomNav({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('HOME', Icons.home_outlined),
      ('SEARCH', Icons.search),
      ('CART', Icons.shopping_basket_outlined),
      ('WISHLIST', Icons.favorite_outline),
      ('PROFILE', Icons.person_outline),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AC.divider)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final isActive = i == currentIndex;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Icon(item.$2,
                          size: 24.r,
                          color: isActive ? AC.primary : AC.textLight),
                      if (isActive && i == 2)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                                color: AC.primary, shape: BoxShape.circle),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(item.$1,
                      style: GoogleFonts.lato(
                          fontSize: 9.sp,
                          color: isActive ? AC.primary : AC.textLight,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
//  SCREEN 3 — CHECKOUT
// ══════════════════════════════════════════════════════════════════════
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
              icon: Icon(Icons.arrow_back_ios_new,
                  size: 18.r, color: AC.text),
            ),
            title: Text('Checkout',
                style: GoogleFonts.tenorSans(
                    color: AC.text,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400)),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    children: [
                      // Order summary card
                      _CheckoutCard(
                        child: Column(
                          children: [
                            _CheckoutCardHeader(
                                label: 'My order',
                                value:
                                    '\$${cart.total.toStringAsFixed(2)}'),
                            SizedBox(height: 12.h),
                            ...cart.items.map((item) => _CheckoutItemRow(
                                  name: item.name,
                                  qty: item.quantity,
                                  price: item.price,
                                )),
                            if (cart.promoApplied)
                              _CheckoutDetailRow(
                                  label: 'Discount',
                                  value:
                                      '-\$${cart.discountAmount.toStringAsFixed(2)}'),
                            _CheckoutDetailRow(
                                label: 'Delivery',
                                value: 'Free',
                                valueColor: AC.green),
                          ],
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Shipping details
                      _CheckoutCard(
                        onTap: () =>
                            Navigator.pushNamed(context, '/shipping'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _CheckoutCardHeader(
                                label: 'Shipping details',
                                hasArrow: true,
                                onTap: () => Navigator.pushNamed(
                                    context, '/shipping')),
                            SizedBox(height: 10.h),
                            Text(
                              cart.selectedAddress.address,
                              style: GoogleFonts.lato(
                                  fontSize: 13.sp, color: AC.textLight),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Payment method
                      _CheckoutCard(
                        onTap: () =>
                            Navigator.pushNamed(context, '/payment'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _CheckoutCardHeader(
                                label: 'Payment method',
                                hasArrow: true,
                                onTap: () => Navigator.pushNamed(
                                    context, '/payment')),
                            SizedBox(height: 10.h),
                            Text(
                              cart.selectedCard.masked,
                              style: GoogleFonts.lato(
                                  fontSize: 13.sp, color: AC.textLight),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Comment field
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AC.border),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: TextField(
                          controller: commentCtrl,
                          onChanged: cart.setComment,
                          maxLines: 4,
                          style: GoogleFonts.lato(
                              fontSize: 14.sp, color: AC.text),
                          decoration: InputDecoration(
                            hintText: 'Enter your comment',
                            hintStyle: GoogleFonts.lato(
                                fontSize: 14.sp, color: AC.textLight),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(14.w),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),

              // Confirm button
              _CheckoutButton(
                label:
                    'CONFIRM ORDER (\$${(cart.total + 1).toStringAsFixed(2)})',
                onTap: () => _showOrderConfirmed(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOrderConfirmed(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AC.green, size: 24.r),
            SizedBox(width: 8.w),
            Text('Order Confirmed!',
                style: GoogleFonts.tenorSans(fontSize: 18.sp)),
          ],
        ),
        content: Text('Your order has been placed successfully.',
            style: GoogleFonts.lato(fontSize: 13.sp, color: AC.textLight)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                ..pop()
                ..popUntil(ModalRoute.withName('/order'));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AC.purple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r)),
                elevation: 0),
            child: Text('Done',
                style: GoogleFonts.lato(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
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
            Text(label,
                style: GoogleFonts.tenorSans(
                    fontSize: 16.sp,
                    color: AC.text,
                    fontWeight: FontWeight.w400)),
            Row(
              children: [
                if (value != null)
                  Text(value!,
                      style: GoogleFonts.lato(
                          fontSize: 14.sp,
                          color: AC.text,
                          fontWeight: FontWeight.w600)),
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
  const _CheckoutItemRow(
      {required this.name, required this.qty, required this.price});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(name,
                style:
                    GoogleFonts.lato(fontSize: 13.sp, color: AC.textLight)),
          ),
          Text('$qty x \$${price.toStringAsFixed(2)}',
              style: GoogleFonts.lato(
                  fontSize: 13.sp, color: AC.textLight)),
        ],
      ),
    );
  }
}

class _CheckoutDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _CheckoutDetailRow(
      {required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.lato(
                  fontSize: 13.sp, color: AC.textLight)),
          Text(value,
              style: GoogleFonts.lato(
                  fontSize: 13.sp,
                  color: valueColor ?? AC.textLight)),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════
//  SCREEN 4 — SHIPPING DETAILS
// ══════════════════════════════════════════════════════════════════════
class ShippingDetailsScreen extends StatelessWidget {
  const ShippingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new,
                  size: 18.r, color: AC.text),
            ),
            title: Text('Shipping Details',
                style: GoogleFonts.tenorSans(
                    color: AC.text,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400)),
          ),
          body: Column(
            children: [
              // Map placeholder
              Container(
                height: 260.h,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: Stack(
                  children: [
                    // Map visual representation
                    Positioned.fill(
                      child: CustomPaint(painter: _MapPainter()),
                    ),
                    // Map pin
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on,
                              color: AC.green, size: 36.r),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Address list
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/bg_pattern.png'),
                      opacity: 0.05,
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                  child: Column(
                    children: [
                      ...cart.addresses.asMap().entries.map(
                            (e) => _AddressOption(
                              index: e.key,
                              address: e.value,
                              isSelected:
                                  cart.selectedAddressIndex == e.key,
                              onSelect: () {
                                cart.selectAddress(e.key);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                      // Use current location
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 14.h),
                        child: Row(
                          children: [
                            Icon(Icons.check,
                                size: 16.r,
                                color: AC.textLight.withOpacity(0.5)),
                            SizedBox(width: 8.w),
                            Text('Use current location',
                                style: GoogleFonts.lato(
                                    fontSize: 14.sp,
                                    color: AC.textLight)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AddressOption extends StatelessWidget {
  final int index;
  final ShippingAddress address;
  final bool isSelected;
  final VoidCallback onSelect;

  const _AddressOption({
    required this.index,
    required this.address,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: isSelected ? AC.primary : AC.border, width: 1),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (address.label.isNotEmpty)
                  Text(address.label,
                      style: GoogleFonts.tenorSans(
                          fontSize: 15.sp, color: AC.text)),
                Text(address.address,
                    style: GoogleFonts.lato(
                        fontSize: 13.sp, color: AC.textLight)),
              ],
            ),
            // Radio button
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: isSelected ? AC.primary : Colors.grey.shade400,
                    width: 1.5),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: const BoxDecoration(
                            color: AC.primary, shape: BoxShape.circle),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// Simple map background painter
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFE8EAE6);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bg);

    final road = Paint()
      ..color = const Color(0xFFFDD835)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    final roadWhite = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Draw some roads
    final paths = [
      [Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.4)],
      [Offset(0, size.height * 0.6), Offset(size.width, size.height * 0.55)],
      [Offset(size.width * 0.3, 0), Offset(size.width * 0.35, size.height)],
      [Offset(size.width * 0.7, 0), Offset(size.width * 0.65, size.height)],
    ];

    for (final p in paths) {
      canvas.drawLine(p[0], p[1], road);
      canvas.drawLine(p[0], p[1], roadWhite);
    }

    // Green patches
    final green = Paint()..color = const Color(0xFFA5D6A7).withOpacity(0.4);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.15, size.height * 0.7),
            width: 80,
            height: 60),
        green);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(size.width * 0.8, size.height * 0.2),
            width: 60,
            height: 50),
        green);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ══════════════════════════════════════════════════════════════════════
//  SCREEN 5 — PAYMENT METHOD
// ══════════════════════════════════════════════════════════════════════
class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AC.bg,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new,
                  size: 18.r, color: AC.text),
            ),
            title: Text('Payment Method',
                style: GoogleFonts.tenorSans(
                    color: AC.text,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400)),
          ),
          body: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AC.cardBg,
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(color: AC.border, width: 0.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Credit Cards',
                      style: GoogleFonts.tenorSans(
                          fontSize: 18.sp,
                          color: AC.text,
                          fontWeight: FontWeight.w400)),
                  SizedBox(height: 6.h),
                  const Divider(color: AC.text, height: 1, thickness: 1),
                  SizedBox(height: 4.h),
                  ...cart.creditCards.asMap().entries.map(
                        (e) => _CardOption(
                          card: e.value,
                          isSelected: cart.selectedCardIndex == e.key,
                          onSelect: () {
                            cart.selectCard(e.key);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CardOption extends StatelessWidget {
  final CreditCard card;
  final bool isSelected;
  final VoidCallback onSelect;

  const _CardOption({
    required this.card,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(card.masked,
                style: GoogleFonts.lato(
                    fontSize: 14.sp, color: AC.textLight)),
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: isSelected ? AC.primary : Colors.grey.shade400,
                    width: 1.5),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: const BoxDecoration(
                            color: AC.primary, shape: BoxShape.circle),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}