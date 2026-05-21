# Complete Implementation Package - Flutter E-Commerce App

> All files organized for manual integration. Copy each section to its respective file path.

---

## 📋 FILE STRUCTURE & PATHS

```
lib/
├── core/
│   ├── exceptions/
│   │   ├── app_exceptions.dart          ✅ CREATED
│   │   └── exception_handler.dart       ✅ CREATED
│   ├── services/
│   │   ├── navigation_service.dart      ✅ UPDATED
│   │   └── api_service.dart             (Already exists, add exception handling)
│   └── widgets/
│       ├── custom_button.dart           (Update existing)
│       ├── custom_text_field.dart       ✅ CREATED
│       ├── custom_loader.dart           ✅ CREATED
│       ├── error_widget.dart            ✅ CREATED
│       └── (other existing widgets)
├── features/
│   ├── auth/
│   │   └── controllers/
│   │       └── auth_controller.dart     (Update with exception handling)
│   ├── home/
│   │   ├── controllers/
│   │   │   └── home_controller.dart     (Update with exception handling)
│   │   ├── models/
│   │   │   └── product_model.dart
│   │   └── views/
│   │       ├── home_view.dart
│   │       └── search_view.dart
│   ├── cart/
│   │   ├── controllers/
│   │   │   └── cart_controller.dart     (Update with exception handling)
│   │   ├── models/
│   │   │   ├── cart_item.dart
│   │   │   ├── shipping_address.dart
│   │   │   └── credit_card.dart
│   │   └── views/
│   │       ├── order_view.dart
│   │       └── checkout.dart
│   ├── profile/
│   │   ├── controllers/
│   │   │   └── profile_controller.dart  (Update with exception handling)
│   │   ├── models/
│   │   │   └── point_transaction.dart
│   │   └── views/
│   │       ├── profile_view.dart
│   │       └── settings_view.dart
│   ├── onboarding/
│   │   └── controllers/
│   │       └── onboarding_controller.dart (Update with exception handling)
│   ├── theme/
│   │   └── controllers/
│   │       └── theme_controller.dart    (Update with exception handling)
│   └── localization/
│       └── controllers/
│           └── localization_controller.dart (Update with exception handling)
├── main.dart                             (Update initialization)
└── routes/
    └── app_router.dart                   (Update with navigation service)
```

---

## 🔄 IMPLEMENTATION ORDER

1. **✅ Already Done:** Exception system, Navigation service, widgets
2. **NEXT STEP:** Update controllers (copy code to existing files)
3. **THEN:** Create/update view files
4. **FINALLY:** Update main.dart and app_router.dart

---

## 📝 CONTROLLERS - UPDATE EXISTING FILES

### 1. OnboardingController
**File:** `lib/features/onboarding/controllers/onboarding_controller.dart`

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/exceptions/exception_handler.dart';

class OnboardingController extends ChangeNotifier {
  bool _hasCompletedOnboarding = false;
  bool _isLoading = true;
  AppException? _error;

  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get isLoading => _isLoading;
  AppException? get error => _error;

  OnboardingController() {
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      _hasCompletedOnboarding = prefs.getBool('completed_onboarding') ?? false;
    } on AppException catch (e) {
      _error = e;
      debugPrint('❌ Onboarding load error: ${e.message}');
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      debugPrint('❌ Unexpected error loading onboarding: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('completed_onboarding', true);
      _hasCompletedOnboarding = true;
      debugPrint('✅ Onboarding completed');
    } on AppException catch (e) {
      _error = e;
      debugPrint('❌ Complete onboarding error: ${e.message}');
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      debugPrint('❌ Unexpected error completing onboarding: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('completed_onboarding', false);
      _hasCompletedOnboarding = false;
      notifyListeners();
      debugPrint('✅ Onboarding reset');
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      debugPrint('❌ Error resetting onboarding: $e');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
```

---

### 2. ThemeController
**File:** `lib/features/theme/controllers/theme_controller.dart`

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/exceptions/exception_handler.dart';

class ThemeController extends ChangeNotifier {
  static const String _themeKey = "theme_mode";
  ThemeMode _themeMode = ThemeMode.light;
  AppException? _error;
  bool _isLoading = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  AppException? get error => _error;
  bool get isLoading => _isLoading;

  ThemeController() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey);
      if (themeIndex != null) {
        _themeMode = ThemeMode.values[themeIndex];
      }
      debugPrint('✅ Theme loaded: ${_themeMode.name}');
    } on AppException catch (e) {
      _error = e;
      debugPrint('❌ Theme load error: ${e.message}');
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      debugPrint('❌ Unexpected error loading theme: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _themeMode = mode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, mode.index);

      debugPrint('✅ Theme changed to: ${mode.name}');
    } on AppException catch (e) {
      _error = e;
      debugPrint('❌ Theme set error: ${e.message}');
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      debugPrint('❌ Unexpected error setting theme: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await setThemeMode(newMode);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
```

---

### 3. LocalizationController
**File:** `lib/features/localization/controllers/localization_controller.dart`

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/exceptions/exception_handler.dart';

class LocalizationController extends ChangeNotifier {
  static const String _localeKey = "app_locale";
  Locale _locale = const Locale('en', 'US');
  AppException? _error;
  bool _isLoading = false;

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('es', 'ES'),
    Locale('fr', 'FR'),
    Locale('de', 'DE'),
    Locale('ar', 'SA'),
  ];

  Locale get locale => _locale;
  AppException? get error => _error;
  bool get isLoading => _isLoading;

  LocalizationController() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey);

      if (languageCode != null) {
        if (languageCode.contains('_')) {
          final parts = languageCode.split('_');
          _locale = Locale(parts[0], parts[1]);
        } else {
          _locale = Locale(languageCode);
        }
      }
      debugPrint('✅ Locale loaded: ${_locale.toString()}');
    } on AppException catch (e) {
      _error = e;
      debugPrint('❌ Locale load error: ${e.message}');
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      debugPrint('❌ Unexpected error loading locale: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    if (!supportedLocales.contains(locale)) {
      debugPrint('❌ Unsupported locale: ${locale.toString()}');
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _locale = locale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.toString());

      debugPrint('✅ Locale changed to: ${locale.toString()}');
    } on AppException catch (e) {
      _error = e;
      debugPrint('❌ Locale set error: ${e.message}');
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      debugPrint('❌ Unexpected error setting locale: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String translate(String key) {
    // TODO: Implement with actual translation package
    return key;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
```

---

### 4. HomeController
**File:** `lib/features/home/controllers/home_controller.dart`

```dart
import 'package:flutter/material.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/exceptions/exception_handler.dart';
import '../models/product_model.dart';

class HomeController extends ChangeNotifier {
  bool _isLoading = false;
  AppException? _error;

  bool get isLoading => _isLoading;
  AppException? get error => _error;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // ── Category Management ───────────────────────────────────────────────
  final List<String> categories = ['All', 'Apparel', 'Dress', 'Tshirt', 'Bag'];
  String _selectedCategory = 'All';

  String get selectedCategory => _selectedCategory;

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // ── Filter States ─────────────────────────────────────────────────────
  String _sortOption = 'From expensive to cheap';
  Set<String> _selectedColors = {'#D4A5A0'};
  RangeValues _priceRange = const RangeValues(30, 130);
  Set<String> _selectedConditions = {'sale'};
  Set<String> _selectedGenders = {};
  Set<String> _selectedTags = {'skin'};

  String get sortOption => _sortOption;
  Set<String> get selectedColors => _selectedColors;
  RangeValues get priceRange => _priceRange;
  Set<String> get selectedConditions => _selectedConditions;
  Set<String> get selectedGenders => _selectedGenders;
  Set<String> get selectedTags => _selectedTags;

  void setSortOption(String value) {
    _sortOption = value;
    notifyListeners();
  }

  void setColors(Set<String> colors) {
    _selectedColors = colors;
    notifyListeners();
  }

  void setPriceRange(RangeValues range) {
    _priceRange = range;
    notifyListeners();
  }

  void setConditions(Set<String> conditions) {
    _selectedConditions = conditions;
    notifyListeners();
  }

  void setGenders(Set<String> genders) {
    _selectedGenders = genders;
    notifyListeners();
  }

  void setTags(Set<String> tags) {
    _selectedTags = tags;
    notifyListeners();
  }

  // ── Banner Management ─────────────────────────────────────────────────
  final PageController bannerController = PageController();
  int _currentBannerIndex = 0;
  int get currentBannerIndex => _currentBannerIndex;

  final List<String> bannerImages = [
    'assets/image/banner1.png',
    'assets/image/banner2.png',
    'assets/image/banner3.png',
  ];

  void updateBannerIndex(int index) {
    _currentBannerIndex = index;
    notifyListeners();
  }

  void nextBanner() {
    bannerController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  // ── Products ──────────────────────────────────────────────────────────
  final List<ProductModel> _allProducts = [
    ProductModel(
      id: '1',
      title: '21WN reversible angora card',
      image: 'assets/images/product1.png',
      price: '\$120',
      updatePrice: '\$80',
      rating: 4.5,
      sale: true,
      category: 'Apparel',
    ),
    ProductModel(
      id: '2',
      title: 'Classic Cotton Dress',
      image: 'assets/images/product2.png',
      price: '\$95',
      updatePrice: '0',
      rating: 4.8,
      sale: false,
      category: 'Dress',
    ),
    ProductModel(
      id: '3',
      title: 'Summer Casual T-Shirt',
      image: 'assets/images/product3.png',
      price: '\$45',
      updatePrice: '\$30',
      rating: 4.2,
      sale: true,
      category: 'Tshirt',
    ),
    ProductModel(
      id: '4',
      title: 'Elegant Leather Bag',
      image: 'assets/images/product4.png',
      price: '\$150',
      updatePrice: '0',
      rating: 4.6,
      sale: false,
      category: 'Bag',
    ),
  ];

  List<ProductModel> get allProducts => _allProducts;

  List<ProductModel> get filteredProducts {
    List<ProductModel> filtered = _allProducts;

    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    filtered = filtered.where((p) {
      String priceStr = p.updatePrice != '0' && p.updatePrice.isNotEmpty
          ? p.updatePrice
          : p.price;
      final price = double.tryParse(priceStr.replaceAll('\$', '')) ?? 0;
      return price >= _priceRange.start && price <= _priceRange.end;
    }).toList();

    if (_selectedConditions.isNotEmpty) {
      filtered = filtered.where((p) {
        if (_selectedConditions.contains('sale') && p.sale) return true;
        return false;
      }).toList();
    }

    switch (_sortOption) {
      case 'From expensive to cheap':
        filtered.sort((a, b) {
          final priceA = double.tryParse(a.price.replaceAll('\$', '')) ?? 0;
          final priceB = double.tryParse(b.price.replaceAll('\$', '')) ?? 0;
          return priceB.compareTo(priceA);
        });
        break;
      case 'From cheap to expensive':
        filtered.sort((a, b) {
          final priceA = double.tryParse(a.price.replaceAll('\$', '')) ?? 0;
          final priceB = double.tryParse(b.price.replaceAll('\$', '')) ?? 0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'Most Popular':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return filtered;
  }

  void resetFilters() {
    _sortOption = 'From expensive to cheap';
    _selectedColors = {'#D4A5A0'};
    _priceRange = const RangeValues(30, 130);
    _selectedConditions = {'sale'};
    _selectedGenders = {};
    _selectedTags = {'skin'};
    _selectedCategory = 'All';
    notifyListeners();
  }

  Future<void> fetchProductsFromApi() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // TODO: Uncomment for real API call
      // final response = await ApiService.get(
      //   api: ApiConstants.getProductsUrl,
      //   auth: true,
      // );

      debugPrint('✅ Products loaded');
    } on AppException catch (e) {
      _error = e;
      debugPrint('❌ Load products error: ${e.message}');
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      debugPrint('❌ Unexpected error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    bannerController.dispose();
    super.dispose();
  }
}
```

---

### 5. CartController
**File:** `lib/features/cart/controllers/cart_controller.dart`

```dart
import 'package:flutter/material.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/exceptions/exception_handler.dart';
import '../models/cart_item.dart';
import '../models/credit_card.dart';
import '../models/shipping_address.dart';

class CartController extends ChangeNotifier {
  bool _isLoading = false;
  AppException? _error;

  bool get isLoading => _isLoading;
  AppException? get error => _error;

  final List<CartItem> _items = [
    CartItem(
      id: '1',
      name: 'Foundation Beshop',
      price: 200.95,
      originalPrice: 265.95,
      isOnSale: true,
    ),
    CartItem(id: '2', name: 'Hair mask with oat extract', price: 125.95),
  ];

  List<CartItem> get items => List.unmodifiable(_items);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);
  double get discountAmount => _promoApplied ? subtotal * _discountPercent : 0;
  double get total => subtotal - discountAmount;
  double get badgeTotal => 45.98;

  String _promoInput = '';
  bool _promoApplied = false;
  final double _discountPercent = 0.10;

  static const List<String> _validCodes = ['DISCOUNT23', 'SAVE10', 'PROMO10'];

  String get promoInput => _promoInput;
  bool get promoApplied => _promoApplied;

  void setPromoInput(String value) {
    _promoInput = value;
    notifyListeners();
  }

  bool applyPromo() {
    if (_validCodes.contains(_promoInput.trim().toUpperCase())) {
      _promoApplied = true;
      notifyListeners();
      debugPrint('✅ Promo code applied: $_promoInput');
      return true;
    }
    _error = GenericException(message: 'Invalid promo code');
    notifyListeners();
    debugPrint('❌ Invalid promo code: $_promoInput');
    return false;
  }

  void removePromo() {
    _promoApplied = false;
    _promoInput = '';
    notifyListeners();
    debugPrint('✅ Promo code removed');
  }

  final List<ShippingAddress> addresses = const [
    ShippingAddress(
      label: 'Home',
      address: '8000 S Kirkland Ave, Chicago, IL 6065...',
    ),
    ShippingAddress(
      label: 'Work',
      address: '8000 S Kirkland Ave, Chicago, IL 6065...',
    ),
    ShippingAddress(
      label: 'Other',
      address: '8000 S Kirkland Ave, Chicago, IL 6065...',
    ),
    ShippingAddress(label: '', address: '3646 S 58th Ave, Cicero, IL 608...'),
  ];

  int _selectedAddressIndex = 3;
  int get selectedAddressIndex => _selectedAddressIndex;
  ShippingAddress get selectedAddress => addresses[_selectedAddressIndex];

  void selectAddress(int index) {
    _selectedAddressIndex = index;
    notifyListeners();
  }

  final List<CreditCard> creditCards = const [
    CreditCard(id: '1', masked: '7741 ******** 6644'),
    CreditCard(id: '2', masked: '7674 ******** 1884'),
  ];

  int _selectedCardIndex = 1;
  int get selectedCardIndex => _selectedCardIndex;
  CreditCard get selectedCard => creditCards[_selectedCardIndex];

  void selectCard(int index) {
    _selectedCardIndex = index;
    notifyListeners();
  }

  String _comment = '';
  String get comment => _comment;

  void setComment(String value) {
    _comment = value;
    notifyListeners();
  }

  void increment(String id) {
    try {
      final item = _items.firstWhere((i) => i.id == id);
      item.quantity++;
      notifyListeners();
      debugPrint('✅ Item quantity increased: $id');
    } catch (e) {
      _error = GenericException(message: 'Item not found');
      notifyListeners();
    }
  }

  void decrement(String id) {
    try {
      final item = _items.firstWhere((i) => i.id == id);
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        _items.removeWhere((i) => i.id == id);
      }
      notifyListeners();
      debugPrint('✅ Item quantity decreased: $id');
    } catch (e) {
      _error = GenericException(message: 'Item not found');
      notifyListeners();
    }
  }

  void removeItem(String id) {
    try {
      _items.removeWhere((i) => i.id == id);
      notifyListeners();
      debugPrint('✅ Item removed: $id');
    } catch (e) {
      _error = GenericException(message: 'Failed to remove item');
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _promoApplied = false;
    _promoInput = '';
    notifyListeners();
    debugPrint('✅ Cart cleared');
  }

  Future<void> placeOrder() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      if (_items.isEmpty) {
        throw GenericException(message: 'Cart is empty');
      }

      // TODO: Uncomment for real API
      // final response = await ApiService.post(
      //   api: ApiConstants.placeOrderUrl,
      //   data: {...},
      //   auth: true,
      // );

      await Future.delayed(const Duration(seconds: 2));

      debugPrint('✅ Order placed successfully');
      clearCart();
    } on AppException catch (e) {
      _error = e;
      debugPrint('❌ Place order error: ${e.message}');
    } catch (e) {
      _error = ExceptionHandler.handleException(e);
      debugPrint('❌ Unexpected error placing order: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
```

---

### 6. ProfileController
**File:** `lib/features/profile/controllers/profile_controller.dart`

REFERENCE: See previous message for complete ProfileController code - it's long but complete with all methods.

---

## 🎨 MODELS - CREATE NEW FILES

### ProductModel
**File:** `lib/features/home/models/product_model.dart`

```dart
class ProductModel {
  final String id;
  final String title;
  final String image;
  final String price;
  final String updatePrice;
  final double rating;
  final bool sale;
  final String? category;
  final String? description;
  final int? reviewCount;

  ProductModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.updatePrice,
    required this.rating,
    required this.sale,
    this.category,
    this.description,
    this.reviewCount,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      price: json['price'] as String,
      updatePrice: json['updatePrice'] as String? ?? '0',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      sale: json['sale'] as bool? ?? false,
      category: json['category'] as String?,
      description: json['description'] as String?,
      reviewCount: json['reviewCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'price': price,
      'updatePrice': updatePrice,
      'rating': rating,
      'sale': sale,
      'category': category,
      'description': description,
      'reviewCount': reviewCount,
    };
  }
}
```

---

### CartItem
**File:** `lib/features/cart/models/cart_item.dart`

```dart
class CartItem {
  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final bool isOnSale;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    this.isOnSale = false,
    this.quantity = 1,
  });

  double get totalPrice => price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] as double?,
      isOnSale: json['isOnSale'] as bool? ?? false,
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'originalPrice': originalPrice,
      'isOnSale': isOnSale,
      'quantity': quantity,
    };
  }
}
```

---

### PointTransaction
**File:** `lib/features/profile/models/point_transaction.dart`

```dart
class PointTransaction {
  final String title;
  final String date;
  final int points;
  final bool isCredit;

  PointTransaction({
    required this.title,
    required this.date,
    required this.points,
    this.isCredit = true,
  });

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    return PointTransaction(
      title: json['title'] as String,
      date: json['date'] as String,
      points: json['points'] as int,
      isCredit: json['isCredit'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'points': points,
      'isCredit': isCredit,
    };
  }
}
```

---

## 📱 VIEWS - CREATE NEW FILES

### HomeView
**File:** `lib/features/home/views/home_view.dart`

[See previous message for full HomeView code]

### AuthView  
**File:** `lib/features/auth/views/auth_view.dart`

[See previous message for full AuthView code]

### OrderView
**File:** `lib/features/cart/views/order_view.dart`

[See previous message for full OrderView code]

### ProfileView
**File:** `lib/features/profile/views/profile_view.dart`

[See previous message for full ProfileView code]

### SearchView
**File:** `lib/features/home/views/search_view.dart`

[See previous message for full SearchView code]

### SettingsView
**File:** `lib/features/profile/views/settings_view.dart`

[See previous message for full SettingsView code]

---

## 🔧 MAIN CONFIGURATION FILES

### main.dart
**File:** `lib/main.dart`

[See previous message for full updated main.dart]

### app_router.dart
**File:** `lib/routes/app_router.dart`

Add to the `create` method:
```dart
// Add this right before returning the GoRouter:
NavigationService.initRouter(router);
return router;
```

---

## 📦 pubspec.yaml
**File:** `pubspec.yaml`

[See previous message for complete pubspec.yaml with all dependencies]

---

## ✅ IMPLEMENTATION CHECKLIST

### Phase 1: Infrastructure (Already Done)
- [x] Exception system created
- [x] Navigation service updated
- [x] UI widgets created
- [x] Validators created

### Phase 2: Controllers (Copy & Paste from Above)
- [ ] Update OnboardingController
- [ ] Update ThemeController
- [ ] Update LocalizationController
- [ ] Update HomeController
- [ ] Update CartController
- [ ] Update ProfileController (copy full code from previous message)
- [ ] Update AuthController (copy snippet from previous message)

### Phase 3: Models (Create New)
- [ ] Create ProductModel
- [ ] Create CartItem & update models
- [ ] Create PointTransaction

### Phase 4: Views (Create/Update)
- [ ] Create HomeView
- [ ] Create AuthView
- [ ] Create OrderView
- [ ] Create ProfileView
- [ ] Create SearchView
- [ ] Create SettingsView
- [ ] Create other remaining views from previous message

### Phase 5: Configuration
- [ ] Update main.dart with NavigationService
- [ ] Update app_router.dart with navigation service init
- [ ] Update pubspec.yaml with dependencies

### Phase 6: Testing
- [ ] Test exceptions work correctly
- [ ] Test navigation flows
- [ ] Test state management
- [ ] Test error display
- [ ] Test dark mode
- [ ] Test multi-language

---

## 📚 ADDITIONAL RESOURCES

All full code for views and remaining controllers is available in the previous messages. This document serves as:
1. **File path reference** - Know where to put each file
2. **Priority order** - What to implement when
3. **Code snippets** - Quick copy-paste sections

---

## 🚀 QUICK START

1. **Copy exception files** - Already created ✅
2. **Update navigation service** - Already done ✅
3. **Copy widgets** - Custom button, text field, loader, error widget created ✅
4. **Paste controllers** above - One by one
5. **Create models** - ProductModel, CartItem, PointTransaction
6. **Create views** - Reference previous messages
7. **Update main.dart & app_router.dart**
8. **Update pubspec.yaml**
9. **Run `flutter pub get`**
10. **Test the app**

---

**Total Files to Create/Update: ~25 files**
**Time Estimate: 2-3 hours for complete implementation**
**Difficulty: Easy (mostly copy-paste with minor adjustments)**

Good luck! 🎉

