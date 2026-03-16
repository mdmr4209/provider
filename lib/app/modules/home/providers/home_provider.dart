import 'package:flutter/material.dart';

import '../../../../res/assets/image_assets.dart';
import '../models/product_model.dart';

/// Pure ChangeNotifier — zero BuildContext, zero Navigator.
/// Navigation is done via GoRouter using the routerKey set in main.dart.
class HomeProvider extends ChangeNotifier {
  /// Set this from main.dart: HomeProvider.routerKey = _routerKey;
  static GlobalKey<NavigatorState>? routerKey;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  // ── Category Management ──────────────────────────────────────────────
  final List<String> categories = ['All', 'Apparel', 'Dress', 'Tshirt', 'Bag'];

  String _selectedCategory = 'All';

  String get selectedCategory => _selectedCategory;

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // ── Filter States ────────────────────────────────────────────────────
  String _sortOption = 'From expensive to cheap';
  Set<String> _selectedColors = {'#D4A5A0'};
  RangeValues _priceRange = const RangeValues(30, 130);
  Set<String> _selectedConditions = {'sale'};
  Set<String> _selectedGenders = {};
  Set<String> _selectedTags = {'skin'};

  // Getters
  String get sortOption => _sortOption;
  Set<String> get selectedColors => _selectedColors;
  RangeValues get priceRange => _priceRange;
  Set<String> get selectedConditions => _selectedConditions;
  Set<String> get selectedGenders => _selectedGenders;
  Set<String> get selectedTags => _selectedTags;

  // Setters with notifyListeners
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



  final PageController bannerController = PageController();
  int _currentBannerIndex = 0;
  int get currentBannerIndex => _currentBannerIndex;

  // List of banner images
  final List<String> bannerImages = [
    ImageAssets.homeBg, // Your first image
    ImageAssets.background3, // Example second image
    ImageAssets.homeBg, // Example third image
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

  // ── All Products (Sample Data) ───────────────────────────────────────
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
    ProductModel(
      id: '5',
      title: 'Designer Apparel Set',
      image: 'assets/images/product5.png',
      price: '\$200',
      updatePrice: '\$140',
      rating: 4.9,
      sale: true,
      category: 'Apparel',
    ),
    ProductModel(
      id: '6',
      title: 'Premium Shirt',
      image: 'assets/images/product6.png',
      price: '\$75',
      updatePrice: '\$60',
      rating: 4.7,
      sale: true,
      category: 'Tshirt',
    ),
    ProductModel(
      id: '7',
      title: 'Evening Dress',
      image: 'assets/images/product7.png',
      price: '\$180',
      updatePrice: '0',
      rating: 4.9,
      sale: false,
      category: 'Dress',
    ),
    ProductModel(
      id: '8',
      title: 'Canvas Backpack',
      image: 'assets/images/product8.png',
      price: '\$65',
      updatePrice: '\$50',
      rating: 4.4,
      sale: true,
      category: 'Bag',
    ),
  ];

  // ── Filtered Products (with sorting and filtering logic) ──────────────
  List<ProductModel> get filteredProducts {
    List<ProductModel> filtered = _allProducts;

    // ✅ Filter by Category
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((p) => p.category == _selectedCategory)
          .toList();
    }

    // ✅ Filter by Price Range
    filtered = filtered
        .where((p) {
      // Parse price - use updatePrice if available and not '0', else use price
      String priceStr = p.updatePrice != '0' && p.updatePrice.isNotEmpty
          ? p.updatePrice
          : p.price;
      final price = double.tryParse(priceStr.replaceAll('\$', '')) ?? 0;
      return price >= _priceRange.start && price <= _priceRange.end;
    })
        .toList();

    // ✅ Filter by Sale Status
    if (_selectedConditions.isNotEmpty) {
      filtered = filtered
          .where((p) {
        if (_selectedConditions.contains('sale') && p.sale) return true;
        return false;
      })
          .toList();
    }

    // ✅ Apply Sorting
    switch (_sortOption) {
      case 'From expensive to cheap':
        filtered.sort((a, b) {
          final priceA =
              double.tryParse(a.price.replaceAll('\$', '')) ?? 0;
          final priceB =
              double.tryParse(b.price.replaceAll('\$', '')) ?? 0;
          return priceB.compareTo(priceA);
        });
        break;
      case 'From cheap to expensive':
        filtered.sort((a, b) {
          final priceA =
              double.tryParse(a.price.replaceAll('\$', '')) ?? 0;
          final priceB =
              double.tryParse(b.price.replaceAll('\$', '')) ?? 0;
          return priceA.compareTo(priceB);
        });
        break;
      case 'Most Popular':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Newest':
      // Implement based on date if available
        break;
    }

    return filtered;
  }

  // ── All Products (without filters - for reference) ────────────────────
  List<ProductModel> get allProducts => _allProducts;

  // Dummy List for home (not filtered)
  final List<ProductModel> dummyProducts = [
    ProductModel(
      id: '1',
      title: 'Modern Chair',
      price: '\$120',
      image: 'assets/image/img_1.png',
      rating: 4.5,
      sale: false,
    ),
    ProductModel(
      id: '2',
      title: 'Wood Table',
      price: '\$250',
      image: 'assets/image/img_1.png',
      rating: 4.8,
      sale: true,
      updatePrice: '\$38.00',
    ),
    ProductModel(
      id: '3',
      title: 'Lounge Sofa',
      price: '\$500',
      image: 'assets/image/img_1.png',
      rating: 4.2,
    ),
    ProductModel(
      id: '4',
      title: 'Fancy Chair',
      price: '\$550',
      image: 'assets/image/img_1.png',
      rating: 4.2,
    ),
  ];
}