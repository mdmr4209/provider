import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../res/colors/app_color.dart';
import '../../../routes/app_router.dart';
import '../providers/profile_provider.dart';

// ─── Main View ────────────────────────────────────────────────────────
class PromoCodeView extends StatelessWidget {
  const PromoCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              _TabBar(provider: provider),
              Expanded(
                child: provider.displayedCodes.isEmpty
                    ? _EmptyState(isUsed: provider.selectedTab1 == 1)
                    : _PromoGrid(provider: provider),
              ),
            ],
          ),
          bottomNavigationBar: _AddPromoButton(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.backgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 18.r,
          color: AppColor.textColor,
        ),
      ),
      title: Text(
        'My Promo Codes',
        style: GoogleFonts.tenorSans(
          color: AppColor.textColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

// ─── Tab Bar ──────────────────────────────────────────────────────────
class _TabBar extends StatelessWidget {
  final ProfileProvider provider;
  const _TabBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: _TabItem(
              label: 'Current',
              isSelected: provider.selectedTab1 == 0,
              onTap: () => provider.selectTab1(0),
            ),
          ),
          Expanded(
            child: _TabItem(
              label: 'Used',
              isSelected: provider.selectedTab1 == 1,
              onTap: () => provider.selectTab1(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 5.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColor.textColor : Colors.grey.shade300,
              width: 2.w,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.tenorSans(
            color: isSelected
                ? AppColor.textColor
                : AppColor.textColor.withAlpha(104),
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

// ─── Promo Grid ───────────────────────────────────────────────────────
class _PromoGrid extends StatelessWidget {
  final ProfileProvider provider;
  const _PromoGrid({required this.provider});

  @override
  Widget build(BuildContext context) {
    final codes = provider.displayedCodes;
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.78,
      ),
      itemCount: codes.length,
      itemBuilder: (context, index) => _PromoCard(
        promo: codes[index],
        onCopy: () => provider.copyCode(codes[index].code, context),
      ),
    );
  }
}

// ─── Promo Card ───────────────────────────────────────────────────────
class _PromoCard extends StatelessWidget {
  final PromoCode promo;
  final VoidCallback onCopy;
  const _PromoCard({required this.promo, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColor.cardBorderColor, width: 1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ticket icon with pink bg circle
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              color: AppColor.defaultColor.withAlpha(27),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: _TicketIcon(color: AppColor.defaultColor, size: 28.r),
            ),
          ),

          SizedBox(height: 12.h),

          // Company name
          Text(
            promo.company,
            style: GoogleFonts.tenorSans(
              color: AppColor.textColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 4.h),

          // Discount
          Text(
            promo.discount,
            style: GoogleFonts.tenorSans(
              color: promo.discountColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(height: 4.h),

          // Valid until
          Text(
            promo.validUntil,
            style: GoogleFonts.lato(
              color: AppColor.textColor.withAlpha(127),
              fontSize: 11.sp,
            ),
          ),

          SizedBox(height: 10.h),

          // Code row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColor.containerColor2,
              borderRadius: BorderRadius.circular(2.r),
              border: Border.all(color: AppColor.whiteTextColor, width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    promo.code,
                    style: GoogleFonts.lato(
                      color: AppColor.textColor.withAlpha(152),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: onCopy,
                  child: Icon(
                    Icons.copy_rounded,
                    size: 16.r,
                    color: AppColor.textColor.withAlpha(104),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Ticket SVG-style icon ────────────────────────────────────────────
class _TicketIcon extends StatelessWidget {
  final Color color;
  final double size;
  const _TicketIcon({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 0.65),
      painter: _TicketPainter(color: color),
    );
  }
}

class _TicketPainter extends CustomPainter {
  final Color color;
  const _TicketPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // Outer ticket shape (rotated rectangle with notches)
    final path = Path();
    const r = 3.0;
    // Draw rounded ticket outline
    path.moveTo(r, 0);
    path.lineTo(w * 0.65, 0);
    // top-right notch
    path.arcToPoint(Offset(w * 0.65 + r, r), radius: const Radius.circular(r));
    path.lineTo(w * 0.65 + r, h * 0.35);
    // right side notch indent
    path.arcToPoint(
      Offset(w * 0.65 + r, h * 0.65),
      radius: Radius.circular(h * 0.15),
      clockwise: false,
    );
    path.lineTo(w * 0.65 + r, h - r);
    path.arcToPoint(Offset(w * 0.65, h), radius: const Radius.circular(r));
    path.lineTo(r, h);
    path.arcToPoint(Offset(0, h - r), radius: const Radius.circular(r));
    path.lineTo(0, r);
    path.arcToPoint(Offset(r, 0), radius: const Radius.circular(r));
    canvas.drawPath(path, paint);

    // Dashed vertical line
    final dashPaint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    const dashH = 4.0;
    const gap = 3.0;
    double y = 2;
    while (y < h - 2) {
      canvas.drawLine(
        Offset(w * 0.65, y),
        Offset(w * 0.65, y + dashH),
        dashPaint,
      );
      y += dashH + gap;
    }

    // % symbol in center-left area
    final textPainter = TextPainter(
      text: TextSpan(
        text: '%',
        style: TextStyle(
          color: color,
          fontSize: w * 0.28,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((w * 0.65 - textPainter.width) / 2, (h - textPainter.height) / 2),
    );

    // Two small dots beside dashed line
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.65 - 6, h * 0.38), 2, dotPaint);
    canvas.drawCircle(Offset(w * 0.65 - 6, h * 0.62), 2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Empty State ──────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool isUsed;
  const _EmptyState({required this.isUsed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.confirmation_num_outlined,
            size: 56.r,
            color: AppColor.defaultColor.withAlpha(77),
          ),
          SizedBox(height: 16.h),
          Text(
            isUsed ? 'No used promocodes' : 'No promocodes yet',
            style: GoogleFonts.tenorSans(
              color: AppColor.textColor.withAlpha(104),
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Add Promo Button ─────────────────────────────────────────────────
class _AddPromoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 28.h, top: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => context.push(AppRoutes.addPromoCodeView),
            child: Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.add,
                size: 24.r,
                color: AppColor.textColor.withAlpha(175),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add a new promo code',
            style: GoogleFonts.lato(
              color: AppColor.textColor.withAlpha(127),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
