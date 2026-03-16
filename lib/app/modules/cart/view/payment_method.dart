import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/credit_card.dart';
import '../providers/cart_provider.dart';
import 'order_view.dart';

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
              icon: Icon(Icons.arrow_back_ios_new, size: 18.r, color: AC.text),
            ),
            title: Text(
              'Payment Method',
              style: GoogleFonts.tenorSans(
                color: AC.text,
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                  Text(
                    'Credit Cards',
                    style: GoogleFonts.tenorSans(
                      fontSize: 18.sp,
                      color: AC.text,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
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
            Text(
              card.masked,
              style: GoogleFonts.lato(fontSize: 14.sp, color: AC.textLight),
            ),
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AC.primary : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: const BoxDecoration(
                          color: AC.primary,
                          shape: BoxShape.circle,
                        ),
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
