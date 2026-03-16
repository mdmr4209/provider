import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../res/assets/image_assets.dart';
import '../../../../res/colors/app_color.dart';
import '../providers/profile_provider.dart';

// ─── Main View ──────────────────────────────────────────────────────
class PointView extends StatefulWidget {
  const PointView({super.key});

  @override
  State<PointView> createState() => _PointViewState();
}

class _PointViewState extends State<PointView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchPointHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context),
          body: provider.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.defaultColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TabBar(provider: provider),
                      _MemberInfoSection(provider: provider),
                      _CircularProgressSection(provider: provider),
                      _TierInfoSection(provider: provider),
                      _MemberIdButton(),
                      SizedBox(height: 24.h),
                      _PointsActivitySection(provider: provider),
                      _ProgressBarSection(provider: provider),
                      SizedBox(height: 32.h),
                      _RewardsLoveSection(provider: provider),
                      SizedBox(height: 32.h),
                      _PointsRedeemedSection(provider: provider),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
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
        'My Points',
        style: GoogleFonts.tenorSans(
          color: AppColor.textColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

// ─── Tab Bar ────────────────────────────────────────────────────────
class _TabBar extends StatelessWidget {
  final ProfileProvider provider;
  const _TabBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          _TabItem(
            label: 'Current',
            isSelected: provider.selectedTab == 0,
            onTap: () => provider.selectTab(0),
          ),
          _TabItem(
            label: 'Used',
            isSelected: provider.selectedTab == 1,
            onTap: () => provider.selectTab(1),
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
        padding: EdgeInsets.only(bottom: 10.h),
        margin: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? AppColor.textColor
                  : AppColor.textColor.withAlpha(67),
              width: 2,
            ),
          ),
        ),
        child: Opacity(
          opacity: isSelected ? 1.0 : 0.5,
          child: Text(
            label,
            style: GoogleFonts.tenorSans(
              color: AppColor.textColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Member Info ────────────────────────────────────────────────────
class _MemberInfoSection extends StatelessWidget {
  final ProfileProvider provider;
  const _MemberInfoSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            provider.memberTier,
            style: GoogleFonts.tenorSans(
              color: AppColor.textColor,
              fontSize: 22.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                provider.memberName,
                style: GoogleFonts.lato(
                  color: AppColor.textColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                provider.joinedDate,
                style: GoogleFonts.lato(
                  color: AppColor.textColor.withAlpha(152),
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Circular Progress ──────────────────────────────────────────────
class _CircularProgressSection extends StatelessWidget {
  final ProfileProvider provider;
  const _CircularProgressSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    final percent = (provider.tierProgressPercent * 100).toStringAsFixed(0);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 160.w,
              height: 160.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160.w,
                    height: 160.w,
                    child: CircularProgressIndicator(
                      value: provider.tierProgressPercent,
                      strokeWidth: 8.w,
                      backgroundColor: AppColor.lightGrey,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColor.defaultColor,
                      ),
                    ),
                  ),
                  Text(
                    '$percent%',
                    style: GoogleFonts.tenorSans(
                      color: AppColor.textColor,
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Towards Platinum',
              style: GoogleFonts.lato(
                color: AppColor.textColor.withAlpha(152),
                fontSize: 13.sp,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tier Info Section ──────────────────────────────────────────────
class _TierInfoSection extends StatelessWidget {
  final ProfileProvider provider;
  const _TierInfoSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          _TierInfoRow(
            label: 'To reach Platinum',
            value: '\$${provider.amountToReachPlatinum.toStringAsFixed(0)}',
          ),
          Divider(color: AppColor.whiteTextColor, height: 1),
          _TierInfoRow(
            label: 'Amount to go',
            value: '\$${provider.amountToGo.toStringAsFixed(0)}',
          ),
          Divider(color: AppColor.whiteTextColor, height: 1),
          _TierInfoRow(label: "You're earning", value: provider.earningRate),
          Divider(color: AppColor.whiteTextColor, height: 1),
        ],
      ),
    );
  }
}

class _TierInfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _TierInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.lato(fontSize: 13.sp, color: AppColor.textColor),
          ),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 13.sp,
              color: AppColor.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Member ID Button ────────────────────────────────────────────────
class _MemberIdButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.textColor.withAlpha(77)),
          borderRadius: BorderRadius.circular(2.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(ImageAssets.memberId, width: 20.r, height: 20.r),
            SizedBox(width: 8.w),
            Text(
              'MEMBER ID',
              style: GoogleFonts.lato(
                color: AppColor.textColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Points Activity ────────────────────────────────────────────────
class _PointsActivitySection extends StatelessWidget {
  final ProfileProvider provider;
  const _PointsActivitySection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'POINTS ACTIVITY',
            style: GoogleFonts.tenorSans(
              color: AppColor.textColor.withAlpha(127),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${provider.currentPoints}',
                    style: GoogleFonts.tenorSans(
                      color: AppColor.textColor,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Points',
                    style: GoogleFonts.tenorSans(
                      fontSize: 11.sp,
                      color: AppColor.textColor.withAlpha(127),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 28.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${provider.pointsValue.toStringAsFixed(2)}',
                    style: GoogleFonts.tenorSans(
                      color: AppColor.textColor,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Value',
                    style: GoogleFonts.tenorSans(
                      fontSize: 11.sp,
                      color: AppColor.textColor.withAlpha(127),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Progress Bar ────────────────────────────────────────────────────
class _ProgressBarSection extends StatelessWidget {
  final ProfileProvider provider;
  const _ProgressBarSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 6.h,
                decoration: BoxDecoration(
                  color: AppColor.lightGrey,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              FractionallySizedBox(
                widthFactor: (provider.currentPoints / 250).clamp(0.0, 1.0),
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: AppColor.defaultColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: provider.milestones.map((m) {
              return Column(
                children: [
                  Text(
                    m['label'],
                    style: GoogleFonts.tenorSans(
                      fontSize: 10.sp,
                      color: AppColor.textColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    m['pts'],
                    style: GoogleFonts.tenorSans(
                      fontSize: 10.sp,
                      color: AppColor.textColor.withAlpha(127),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─── Rewards Love Table ──────────────────────────────────────────────
class _RewardsLoveSection extends StatelessWidget {
  final ProfileProvider provider;
  const _RewardsLoveSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Rewards Love',
            style: GoogleFonts.tenorSans(
              color: AppColor.textColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'THE PERKS GET ELIXIER-369 AT EVERY MEMBER LEVEL',
            textAlign: TextAlign.center,
            style: GoogleFonts.tenorSans(
              color: AppColor.textColor.withAlpha(127),
              fontSize: 10.sp,
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 20.h),

          // Header row
          _TableHeaderRow(tiers: provider.tiers),

          // ── POINTS section ──
          _SectionLabel(label: 'POINTS'),
          _TableDataRow(
            label: 'Points per \$1',
            values: provider.tiers
                .map((t) => t.pointsPerDollar.toString().replaceAll('.0', ''))
                .toList(),
            useText: true,
          ),
          _TableDataRow(
            label: 'Bonus points &\nsavings',
            values: provider.tiers.map((t) => t.bonusPoints).toList(),
          ),
          _TableDataRow(
            label: 'Redeem for\ndiscounts',
            values: provider.tiers.map((t) => t.redeemDiscounts).toList(),
          ),
          _TableDataRow(
            label: 'Points never\nexpire',
            values: provider.tiers.map((t) => t.pointsNeverExpire).toList(),
          ),

          // ── BIRTHDAY section ──
          _SectionLabel(label: 'BIRTHDAY'),
          _TableDataRow(
            label: '2X points\nmonth**',
            values: provider.tiers.map((t) => t.birthdayDouble).toList(),
          ),
          _TableDataRow(
            label: 'Choice of\nBirthday Gift**',
            values: provider.tiers.map((t) => t.birthdayGift).toList(),
          ),
          _TableDataRow(
            label: '\$10 coupon**',
            values: provider.tiers.map((t) => t.tenDollarCoupon).toList(),
          ),

          // ── EXTRAS section ──
          _SectionLabel(label: 'EXTRAS'),
          _TableDataRow(
            label: 'Exclusive deals,\ngifts & early\naccess',
            values: provider.tiers.map((t) => t.exclusiveDeals).toList(),
          ),
          _TableDataRow(
            label: 'Choice of full size\nDiamond Gift',
            values: provider.tiers.map((t) => t.fullSizeDiamondGift).toList(),
          ),
        ],
      ),
    );
  }
}

class _TableHeaderRow extends StatelessWidget {
  final List<RewardTier> tiers;
  const _TableHeaderRow({required this.tiers});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            'SPEND PER YEAR',
            style: GoogleFonts.tenorSans(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textColor.withAlpha(127),
              letterSpacing: 0.5,
            ),
          ),
        ),
        ...tiers.map(
          (t) => Expanded(
            child: Center(
              child: Text(
                t.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.tenorSans(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textColor,
                  letterSpacing: 0.5,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 8.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: GoogleFonts.tenorSans(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textColor.withAlpha(115),
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

class _TableDataRow extends StatelessWidget {
  final String label;
  final List<dynamic> values; // bool or String
  final bool useText;

  const _TableDataRow({
    required this.label,
    required this.values,
    this.useText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.whiteTextColor, width: 0.8),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.tenorSans(
                fontSize: 12.sp,
                color: AppColor.textColor,
                height: 1.4,
              ),
            ),
          ),
          ...values.map(
            (v) => Expanded(
              child: Center(
                child: useText
                    ? Text(
                        v.toString(),
                        style: GoogleFonts.tenorSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textColor,
                        ),
                      )
                    : (v == true
                          ? SvgPicture.asset(
                              ImageAssets.love,
                              height: 16.r,
                              width: 16.w,
                            )
                          : const SizedBox.shrink()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Points Redeemed ─────────────────────────────────────────────────
class _PointsRedeemedSection extends StatelessWidget {
  final ProfileProvider provider;
  const _PointsRedeemedSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColor.backgroundColor,
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            children: [
              Text(
                'Points Redeemed',
                style: GoogleFonts.tenorSans(
                  color: AppColor.textColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 16.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: provider.redemptionOptions.map((opt) {
                    return _RedemptionCard(
                      option: opt,
                      userPoints: provider.currentPoints,
                      onClaim: () => provider.claimReward(opt),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RedemptionCard extends StatelessWidget {
  final RedemptionOption option;
  final int userPoints;
  final VoidCallback onClaim;

  const _RedemptionCard({
    required this.option,
    required this.userPoints,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final canClaim = userPoints >= option.points;

    return Container(
      width: 250.w,
      height: 132.h,
      margin: EdgeInsets.only(right: 12.w),
      decoration: BoxDecoration(
        color: AppColor.defaultColor,
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // backgroundColor overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.08,
              child: Container(color: Colors.white),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${option.points} PTS',
                style: GoogleFonts.tenorSans(
                  color: AppColor.defaultLightColor,
                  fontSize: 12.sp,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                option.label,
                style: GoogleFonts.tenorSans(
                  color: AppColor.backgroundColor,
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              GestureDetector(
                onTap: canClaim ? onClaim : null,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: canClaim ? Colors.white : const Color(0xFFFF84A9),
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(1.r),
                  ),
                  child: Text(
                    'Claim',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ],
      ),
    );
  }
}
