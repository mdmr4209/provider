
import 'package:flutter/material.dart';

import '../models/point_model.dart';
import '../models/point_transaction.dart';
/// Pure ChangeNotifier — zero BuildContext, zero Navigator.
/// Navigation is done via GoRouter using the routerKey set in main.dart.
/// 
/// 

enum PromoStatus { current, used }
 
class PromoCode {
  final String id;
  final String company;
  final String discount;
  final Color discountColor;
  final String validUntil;
  final String code;
  final PromoStatus status;
 
  const PromoCode({
    required this.id,
    required this.company,
    required this.discount,
    required this.discountColor,
    required this.validUntil,
    required this.code,
    required this.status,
  });
 
  PromoCode copyWith({PromoStatus? status}) {
    return PromoCode(
      id: id,
      company: company,
      discount: discount,
      discountColor: discountColor,
      validUntil: validUntil,
      code: code,
      status: status ?? this.status,
    );
  }
}


class RewardTier {
  final String name;
  final double spend;
  final double pointsPerDollar;
  final bool bonusPoints;
  final bool redeemDiscounts;
  final bool pointsNeverExpire;
  final bool birthdayDouble;
  final bool birthdayGift;
  final bool tenDollarCoupon;
  final bool exclusiveDeals;
  final bool fullSizeDiamondGift;
 
  const RewardTier({
    required this.name,
    required this.spend,
    required this.pointsPerDollar,
    required this.bonusPoints,
    required this.redeemDiscounts,
    required this.pointsNeverExpire,
    required this.birthdayDouble,
    required this.birthdayGift,
    required this.tenDollarCoupon,
    required this.exclusiveDeals,
    required this.fullSizeDiamondGift,
  });
}
 
class RedemptionOption {
  final int points;
  final String label;
  final bool canClaim;
 
  const RedemptionOption({
    required this.points,
    required this.label,
    required this.canClaim,
  });
}
class ProfileProvider extends ChangeNotifier {
  /// Set this from main.dart: HomeProvider.routerKey = _routerKey;
  static GlobalKey<NavigatorState>? routerKey;


  bool _isCurrent = false;
  bool get isCurrent => _isCurrent;
  void toggleCurrent() {
    _isCurrent = !_isCurrent;
    notifyListeners();
  }


  String? _expandedOrderId;
  String? get expandedOrderId => _expandedOrderId;

  void toggleOrderExpansion(String orderId) {
    if (_expandedOrderId == orderId) {
      _expandedOrderId = null; // Collapse if tapped again
    } else {
      _expandedOrderId = orderId; // Expand new one
    }
    notifyListeners();
  }


  List<PointTransaction> _history = [];
  List<PointTransaction> get history => _history;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Simulate fetching data
  Future<void> fetchPointHistory1() async {
    _isLoading = true;
    notifyListeners();

    // Dummy Details
    await Future.delayed(const Duration(seconds: 1));
    _history = [
    PointTransaction(title: 'Daily Check-in', date: '25 Jan 2026', points: 10),
    PointTransaction(title: 'Refund - Car Rental', date: '24 Jan 2026', points: 150),
    PointTransaction(title: 'Ride Completed', date: '22 Jan 2026', points: 45),
    PointTransaction(title: 'Discount Applied', date: '20 Jan 2026', points: 20, isCredit: false),
  ];

    _isLoading = false;
    notifyListeners();
  }// Dummy Details

  int get totalPoints => _history.fold(0, (sum, item) => item.isCredit ? sum + item.points : sum - item.points);

 
  // Member info
  final String memberName = 'Billie Groves';
  final String joinedDate = 'Joined 09/02/2017';
  final String memberTier = 'Member';
 
  // Points info
  int currentPoints = 112;
  double pointsValue = 3.00;
 
  // Tier progress
  double get tierProgressPercent => (currentPoints / 500).clamp(0.0, 1.0);
  double amountToReachPlatinum = 500;
  double amountToGo = 500;
  String earningRate = '1 pt per \$1';
 
  // Tab state
  int selectedTab = 0;
 
  void selectTab(int index) {
    selectedTab = index;
    notifyListeners();
  }
 
  // Progress milestones
  final List<Map<String, dynamic>> milestones = [
    {'label': '\$3', 'pts': '100 pts', 'value': 100},
    {'label': '\$6', 'pts': '200 pts', 'value': 200},
    {'label': '\$8', 'pts': '250 pts', 'value': 250},
  ];
 
  // Reward tiers
  final List<RewardTier> tiers = const [
    RewardTier(
      name: 'MEMBER\nFREE',
      spend: 0,
      pointsPerDollar: 1,
      bonusPoints: true,
      redeemDiscounts: true,
      pointsNeverExpire: false,
      birthdayDouble: true,
      birthdayGift: true,
      tenDollarCoupon: false,
      exclusiveDeals: false,
      fullSizeDiamondGift: false,
    ),
    RewardTier(
      name: 'PLATINUM\n\$500',
      spend: 500,
      pointsPerDollar: 1.25,
      bonusPoints: true,
      redeemDiscounts: true,
      pointsNeverExpire: true,
      birthdayDouble: true,
      birthdayGift: true,
      tenDollarCoupon: true,
      exclusiveDeals: true,
      fullSizeDiamondGift: false,
    ),
    RewardTier(
      name: 'DIAMOND\n\$1200',
      spend: 1200,
      pointsPerDollar: 1.5,
      bonusPoints: true,
      redeemDiscounts: true,
      pointsNeverExpire: true,
      birthdayDouble: true,
      birthdayGift: true,
      tenDollarCoupon: true,
      exclusiveDeals: true,
      fullSizeDiamondGift: true,
    ),
  ];
 
  // Redemption options
  final List<RedemptionOption> redemptionOptions = const [
    RedemptionOption(points: 2000, label: '\$75 off', canClaim: false),
    RedemptionOption(points: 3000, label: '\$100 off', canClaim: false),
  ];
 
  Future<void> fetchPointHistory() async {
    _isLoading = true;
    notifyListeners();
 
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
 
    _isLoading = false;
    notifyListeners();
  }
 
  void claimReward(RedemptionOption option) {
    if (currentPoints >= option.points) {
      currentPoints -= option.points;
      notifyListeners();
    }
  }

  int _selectedTab1 = 0;
  int get selectedTab1 => _selectedTab1;
 
 
  final List<PromoCode> _promoCodes = [
    const PromoCode(
      id: '1',
      company: 'Acme Co.',
      discount: '50% off',
      discountColor: Color(0xFFD05278),
      validUntil: 'Valid until Jan 30, 2023',
      code: 'DISCOUNT23',
      status: PromoStatus.current,
    ),
    const PromoCode(
      id: '2',
      company: 'Barone LLC.',
      discount: '15% off',
      discountColor: Color(0xFF2E7D32),
      validUntil: 'Valid until Jan 30, 2023',
      code: 'DISCOUNT23',
      status: PromoStatus.current,
    ),
    const PromoCode(
      id: '3',
      company: 'Abstergo Ltd.',
      discount: '30% off',
      discountColor: Color(0xFFE65100),
      validUntil: 'Valid until Jan 30, 2023',
      code: 'DISCOUNT23',
      status: PromoStatus.current,
    ),
    const PromoCode(
      id: '4',
      company: 'Wayne Ent.',
      discount: '20% off',
      discountColor: Color(0xFFD05278),
      validUntil: 'Valid until Dec 31, 2022',
      code: 'WAYNE20',
      status: PromoStatus.used,
    ),
    const PromoCode(
      id: '5',
      company: 'Stark Ind.',
      discount: '10% off',
      discountColor: Color(0xFF2E7D32),
      validUntil: 'Valid until Nov 15, 2022',
      code: 'STARK10',
      status: PromoStatus.used,
    ),
  ];
 
  List<PromoCode> get currentCodes =>
      _promoCodes.where((p) => p.status == PromoStatus.current).toList();
 
  List<PromoCode> get usedCodes =>
      _promoCodes.where((p) => p.status == PromoStatus.used).toList();
 
  List<PromoCode> get displayedCodes =>
      _selectedTab1 == 0 ? currentCodes : usedCodes;
 
  Future<void> selectTab1(int index) async {
    _selectedTab1 = index;
    notifyListeners();
  }
 
  void addPromoCode({
    required String company,
    required String code,
    required String discount,
    required Color discountColor,
    required String validUntil,
  }) {
    final newCode = PromoCode(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      company: company,
      discount: discount,
      discountColor: discountColor,
      validUntil: validUntil,
      code: code,
      status: PromoStatus.current,
    );
    _promoCodes.add(newCode);
    notifyListeners();
  }
 
  void copyCode(String code, BuildContext context) {
    // In real app: Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Code "$code" copied!'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFFD05278),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }




}