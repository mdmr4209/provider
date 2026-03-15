import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';


// ─── Colors ──────────────────────────────────────────────────────────
class AppColor {
  static const Color background = Color(0xFFFCEDEA);
  static const Color text = Color(0xFF222222);
  static const Color primary = Color(0xFFD05278);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color cardBorder = Color(0xFFE8E8E8);
  static const Color codeBg = Color(0xFFF5F5F5);
}


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
      backgroundColor: AppColor.background,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.maybePop(context),
        icon: Icon(
          Icons.arrow_back_ios_new,
          size: 18.r,
          color: AppColor.text,
        ),
      ),
      title: Text(
        'My Promocodes',
        style: GoogleFonts.tenorSans(
          color: AppColor.text,
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
          _TabItem(
            label: 'Current',
            isSelected: provider.selectedTab1 == 0,
            onTap: () => provider.selectTab1(0),
          ),
          _TabItem(
            label: 'Used',
            isSelected: provider.selectedTab1 == 1,
            onTap: () => provider.selectTab1(1),
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
  const _TabItem(
      {required this.label,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(bottom: 12.h),
        margin: EdgeInsets.only(right: 24.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColor.text : Colors.grey.shade300,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.tenorSans(
            color: isSelected
                ? AppColor.text
                : AppColor.text.withOpacity(0.4),
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
        border: Border.all(color: AppColor.cardBorder, width: 1),
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
              color: AppColor.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: _TicketIcon(color: AppColor.primary, size: 28.r),
            ),
          ),

          SizedBox(height: 12.h),

          // Company name
          Text(
            promo.company,
            style: GoogleFonts.tenorSans(
              color: AppColor.text,
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
              color: AppColor.text.withOpacity(0.5),
              fontSize: 11.sp,
            ),
          ),

          SizedBox(height: 10.h),

          // Code row
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColor.codeBg,
              borderRadius: BorderRadius.circular(2.r),
              border: Border.all(color: AppColor.divider, width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    promo.code,
                    style: GoogleFonts.lato(
                      color: AppColor.text.withOpacity(0.6),
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
                    color: AppColor.text.withOpacity(0.4),
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
    path.arcToPoint(Offset(w * 0.65 + r, r),
        radius: const Radius.circular(r));
    path.lineTo(w * 0.65 + r, h * 0.35);
    // right side notch indent
    path.arcToPoint(Offset(w * 0.65 + r, h * 0.65),
        radius: Radius.circular(h * 0.15), clockwise: false);
    path.lineTo(w * 0.65 + r, h - r);
    path.arcToPoint(Offset(w * 0.65, h),
        radius: const Radius.circular(r));
    path.lineTo(r, h);
    path.arcToPoint(Offset(0, h - r),
        radius: const Radius.circular(r));
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
          Offset(w * 0.65, y), Offset(w * 0.65, y + dashH), dashPaint);
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
        Offset((w * 0.65 - textPainter.width) / 2,
            (h - textPainter.height) / 2));

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
          Icon(Icons.confirmation_num_outlined,
              size: 56.r, color: AppColor.primary.withOpacity(0.3)),
          SizedBox(height: 16.h),
          Text(
            isUsed ? 'No used promocodes' : 'No promocodes yet',
            style: GoogleFonts.tenorSans(
              color: AppColor.text.withOpacity(0.4),
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
            onTap: () => _showAddPromoDialog(context),
            child: Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.add,
                  size: 24.r, color: AppColor.text.withOpacity(0.7)),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add a new promocode',
            style: GoogleFonts.lato(
              color: AppColor.text.withOpacity(0.5),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPromoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => const _AddPromoDialog(),
    );
  }
}

// ─── Add Promo Dialog ─────────────────────────────────────────────────
class _AddPromoDialog extends StatefulWidget {
  const _AddPromoDialog();

  @override
  State<_AddPromoDialog> createState() => _AddPromoDialogState();
}

class _AddPromoDialogState extends State<_AddPromoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _companyCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _discountCtrl = TextEditingController();
  final _validCtrl = TextEditingController();

  // Selected discount color
  Color _selectedColor = const Color(0xFFD05278);

  final List<Color> _colorOptions = const [
    Color(0xFFD05278), // pink
    Color(0xFF2E7D32), // green
    Color(0xFFE65100), // orange
    Color(0xFF1565C0), // blue
    Color(0xFF6A1B9A), // purple
  ];

  @override
  void dispose() {
    _companyCtrl.dispose();
    _codeCtrl.dispose();
    _discountCtrl.dispose();
    _validCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileProvider>().addPromoCode(
            company: _companyCtrl.text.trim(),
            code: _codeCtrl.text.trim().toUpperCase(),
            discount: _discountCtrl.text.trim(),
            discountColor: _selectedColor,
            validUntil: _validCtrl.text.trim().isNotEmpty
                ? _validCtrl.text.trim()
                : 'No expiry',
          );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Promocode added!'),
          backgroundColor: const Color(0xFFD05278),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Promocode',
                    style: GoogleFonts.tenorSans(
                      color: AppColor.text,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close,
                        size: 20.r,
                        color: AppColor.text.withOpacity(0.5)),
                  ),
                ],
              ),

              SizedBox(height: 20.h),

              // Company name
              _InputField(
                controller: _companyCtrl,
                label: 'Company Name',
                hint: 'e.g. Acme Co.',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),

              SizedBox(height: 14.h),

              // Promo code
              _InputField(
                controller: _codeCtrl,
                label: 'Promo Code',
                hint: 'e.g. DISCOUNT23',
                textCapitalization: TextCapitalization.characters,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),

              SizedBox(height: 14.h),

              // Discount
              _InputField(
                controller: _discountCtrl,
                label: 'Discount',
                hint: 'e.g. 50% off',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Required' : null,
              ),

              SizedBox(height: 14.h),

              // Valid until
              _InputField(
                controller: _validCtrl,
                label: 'Valid Until (optional)',
                hint: 'e.g. Jan 30, 2025',
              ),

              SizedBox(height: 16.h),

              // Color picker
              Text(
                'Discount Color',
                style: GoogleFonts.lato(
                  color: AppColor.text.withOpacity(0.6),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: _colorOptions.map((c) {
                  final isSelected = c.value == _selectedColor.value;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 28.w,
                      height: 28.w,
                      margin: EdgeInsets.only(right: 10.w),
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColor.text : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color: c.withOpacity(0.4),
                                    blurRadius: 6)
                              ]
                            : [],
                      ),
                      child: isSelected
                          ? Icon(Icons.check,
                              color: Colors.white, size: 14.r)
                          : null,
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: 24.h),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Add Promocode',
                    style: GoogleFonts.lato(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Reusable Input Field ─────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.textCapitalization = TextCapitalization.words,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            color: AppColor.text.withOpacity(0.6),
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          validator: validator,
          textCapitalization: textCapitalization,
          style: GoogleFonts.lato(
              color: AppColor.text, fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.lato(
              color: AppColor.text.withOpacity(0.3),
              fontSize: 13.sp,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            filled: true,
            fillColor: AppColor.codeBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide:
                  const BorderSide(color: AppColor.cardBorder, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide:
                  const BorderSide(color: AppColor.cardBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide:
                  const BorderSide(color: AppColor.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide:
                  const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.r),
              borderSide:
                  const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}