import 'package:flutter/material.dart';

// ─── Models ──────────────────────────────────────────────────────────
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
}

class ShippingAddress {
  final String label;
  final String address;

  const ShippingAddress({required this.label, required this.address});
}

class CreditCard {
  final String id;
  final String masked;

  const CreditCard({required this.id, required this.masked});
}

// ─── Provider ────────────────────────────────────────────────────────
class CartProvider extends ChangeNotifier {
  // Cart items
  final List<CartItem> _items = [
    CartItem(
      id: '1',
      name: 'Foundation Beshop',
      price: 200.95,
      originalPrice: 265.95,
      isOnSale: true,
    ),
    CartItem(
      id: '2',
      name: 'Hair mask with oat extract',
      price: 125.95,
    ),
  ];

  List<CartItem> get items => List.unmodifiable(_items);

  // Promo
  String _promoInput = '';
  bool _promoApplied = false;
  double _discountPercent = 0.10; // 10% discount

  String get promoInput => _promoInput;
  bool get promoApplied => _promoApplied;

  static const List<String> _validCodes = [
    'DISCOUNT23',
    'SAVE10',
    'PROMO10'
  ];

  // Totals
  double get subtotal =>
      _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get discountAmount =>
      _promoApplied ? subtotal * _discountPercent : 0;

  double get total => subtotal - discountAmount;

  // Cart badge total (original prices for display)
  double get badgeTotal => 45.98;

  // Shipping addresses
  final List<ShippingAddress> addresses = const [
    ShippingAddress(
        label: 'Home', address: '8000 S Kirkland Ave, Chicago, IL 6065...'),
    ShippingAddress(
        label: 'Work', address: '8000 S Kirkland Ave, Chicago, IL 6065...'),
    ShippingAddress(
        label: 'Other', address: '8000 S Kirkland Ave, Chicago, IL 6065...'),
    ShippingAddress(
        label: '', address: '3646 S 58th Ave, Cicero, IL 608...'),
  ];

  int _selectedAddressIndex = 3;
  int get selectedAddressIndex => _selectedAddressIndex;
  ShippingAddress get selectedAddress => addresses[_selectedAddressIndex];

  void selectAddress(int index) {
    _selectedAddressIndex = index;
    notifyListeners();
  }

  // Credit cards
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

  // Comment
  String _comment = '';
  String get comment => _comment;
  void setComment(String v) {
    _comment = v;
    notifyListeners();
  }

  // ── Cart actions ──────────────────────────────────────────────────
  void increment(String id) {
    final item = _items.firstWhere((i) => i.id == id);
    item.quantity++;
    notifyListeners();
  }

  void decrement(String id) {
    final item = _items.firstWhere((i) => i.id == id);
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.removeWhere((i) => i.id == id);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  // ── Promo ─────────────────────────────────────────────────────────
  void setPromoInput(String v) {
    _promoInput = v;
    notifyListeners();
  }

  /// Returns true if valid, false if invalid
  bool applyPromo() {
    if (_validCodes.contains(_promoInput.trim().toUpperCase())) {
      _promoApplied = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromo() {
    _promoApplied = false;
    _promoInput = '';
    notifyListeners();
  }
}