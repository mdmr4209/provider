import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/point_transaction.dart';
import '../models/profile_details_model.dart';
import 'package:newproject/core/constants/app_colors.dart';

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

class ProfileController extends ChangeNotifier {
  /// Set this from main.dart: HomeProvider.routerKey = _routerKey;
  static GlobalKey<NavigatorState>? routerKey;

  // ── Profile Fields ────────────────────────────────────────────────────────
  String _memberName = 'Billie Groves';
  String get memberName => _memberName;

  String _email = 'billie.groves@example.com';
  String get email => _email;

  String _phoneNumber = '+1 234 567 890';
  String get phoneNumber => _phoneNumber;

  String _address = '123 Fashion St, New York, NY';
  String get address => _address;

  final String joinedDate = 'Joined 09/02/2017';
  final String memberTier = 'Member';

  // ── Text Controllers for Editing ──────────────────────────────────────────
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  void initEditFields() {
    nameCtrl.text = _memberName;
    emailCtrl.text = _email;
    phoneCtrl.text = _phoneNumber;
    addressCtrl.text = _address;
  }

  Future<void> updateProfile() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _memberName = nameCtrl.text;
    _email = emailCtrl.text;
    _phoneNumber = phoneCtrl.text;
    _address = addressCtrl.text;

    _isLoading = false;
    notifyListeners();
  }

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

  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  ProfileDetailsModel? _profileDetails;
  ProfileDetailsModel? get profileDetails => _profileDetails;

  Future<void> fetchProfileDetails({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      final String jsonString = await rootBundle.loadString(
        'assets/json/profile.json',
      );
      final Map<String, dynamic> rawProfile = jsonDecode(jsonString);

      _profileDetails = ProfileDetailsModel.fromJson(rawProfile);

      final String extraJsonString = await rootBundle.loadString(
        'assets/json/profile_extra.json',
      );
      final Map<String, dynamic> extraData = jsonDecode(extraJsonString);
      milestones = List<Map<String, dynamic>>.from(extraData['milestones']);
    } catch (e) {
      debugPrint("Error loading profile: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  // Simulate fetching data
  Future<void> fetchPointHistory1() async {
    _isLoading = true;
    notifyListeners();

    // Dummy Details
    await Future.delayed(const Duration(seconds: 1));
    _history = [
      PointTransaction(
        title: 'Daily Check-in',
        date: '25 Jan 2026',
        points: 10,
      ),
      PointTransaction(
        title: 'Refund - Car Rental',
        date: '24 Jan 2026',
        points: 150,
      ),
      PointTransaction(
        title: 'Ride Completed',
        date: '22 Jan 2026',
        points: 45,
      ),
      PointTransaction(
        title: 'Discount Applied',
        date: '20 Jan 2026',
        points: 20,
        isCredit: false,
      ),
    ];

    _isLoading = false;
    notifyListeners();
  } // Dummy Details

  int get totalPoints => _history.fold(
    0,
    (sum, item) => item.isCredit ? sum + item.points : sum - item.points,
  );

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
  List<Map<String, dynamic>> milestones = [];

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

  Future<void> fetchPointHistory({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    _isLoading = false;
    _isRefreshing = false;
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
      discountColor: AppColors.coachColorFFD05278,
      validUntil: 'Valid until Jan 30, 2023',
      code: 'DISCOUNT23',
      status: PromoStatus.current,
    ),
    const PromoCode(
      id: '2',
      company: 'Barone LLC.',
      discount: '15% off',
      discountColor: AppColors.coachColorFF2E7D32,
      validUntil: 'Valid until Jan 30, 2023',
      code: 'DISCOUNT23',
      status: PromoStatus.current,
    ),
    const PromoCode(
      id: '3',
      company: 'Abstergo Ltd.',
      discount: '30% off',
      discountColor: AppColors.coachColorFFE65100,
      validUntil: 'Valid until Jan 30, 2023',
      code: 'DISCOUNT23',
      status: PromoStatus.current,
    ),
    const PromoCode(
      id: '4',
      company: 'Wayne Ent.',
      discount: '20% off',
      discountColor: AppColors.coachColorFFD05278,
      validUntil: 'Valid until Dec 31, 2022',
      code: 'WAYNE20',
      status: PromoStatus.used,
    ),
    const PromoCode(
      id: '5',
      company: 'Stark Ind.',
      discount: '10% off',
      discountColor: AppColors.coachColorFF2E7D32,
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
        backgroundColor: AppColors.coachColorFFD05278,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  final promoCodeCtrl = TextEditingController();

  @override
  void dispose() {
    promoCodeCtrl.dispose();
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  bool _isAddPromo = false;
  bool get isAddPromo => _isAddPromo;
  void toggleAddPromo() {
    _isAddPromo = !_isAddPromo;
    notifyListeners();
  }

  void addPromo() {
    if (promoCodeCtrl.text.isNotEmpty) {
      toggleAddPromo();
      addPromoCode(
        company: 'MD MR',
        code: promoCodeCtrl.text.trim(),
        discount: '20% off',
        discountColor: AppColors.greenAccentColor,
        validUntil: 'No expiry',
      );
      promoCodeCtrl.clear();
      toggleAddPromo();
    }
  }

  List<Map<String, dynamic>> _blockedUsers = [];
  List<Map<String, dynamic>> get blockedUsers => _blockedUsers;

  Future<void> fetchBlockedUsers({bool isRefresh = false}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      _isLoading = true;
    }
    notifyListeners();
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      final String extraJsonString = await rootBundle.loadString(
        'assets/json/profile_extra.json',
      );
      final Map<String, dynamic> extraData = jsonDecode(extraJsonString);
      _blockedUsers = List<Map<String, dynamic>>.from(extraData['blockedUsers']);
    } catch (e) {
      debugPrint("Error loading blocked users: $e");
    } finally {
      _isLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  void unblockUser(String id) {
    _blockedUsers.removeWhere((user) => user['id'] == id);
    notifyListeners();
  }
}
