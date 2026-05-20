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