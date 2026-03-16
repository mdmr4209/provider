import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/shipping_address.dart';
import '../providers/cart_provider.dart';
import 'order_view.dart';

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
              icon: Icon(Icons.arrow_back_ios_new, size: 18.r, color: AC.text),
            ),
            title: Text(
              'Shipping Details',
              style: GoogleFonts.tenorSans(
                color: AC.text,
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
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
                    Positioned.fill(child: CustomPaint(painter: _MapPainter())),
                    // Map pin
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, color: AC.green, size: 36.r),
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
                          isSelected: cart.selectedAddressIndex == e.key,
                          onSelect: () {
                            cart.selectAddress(e.key);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      // Use current location
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 14.h,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check,
                              size: 16.r,
                              color: AC.textLight.withAlpha(127),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Use current location',
                              style: GoogleFonts.lato(
                                fontSize: 14.sp,
                                color: AC.textLight,
                              ),
                            ),
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
            color: isSelected ? AC.primary : AC.border,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (address.label.isNotEmpty)
                  Text(
                    address.label,
                    style: GoogleFonts.tenorSans(
                      fontSize: 15.sp,
                      color: AC.text,
                    ),
                  ),
                Text(
                  address.address,
                  style: GoogleFonts.lato(fontSize: 13.sp, color: AC.textLight),
                ),
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
    final green = Paint()..color = const Color(0xFFA5D6A7).withAlpha(104);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.15, size.height * 0.7),
        width: 80,
        height: 60,
      ),
      green,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.8, size.height * 0.2),
        width: 60,
        height: 50,
      ),
      green,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
