class ProductModel {
  final String id;
  final String title;
  final String image;
  final String price;
  final String updatePrice;
  final double rating;
  final bool sale;
  final String category;

  ProductModel({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    this.updatePrice = '0',
    this.rating = 0,
    this.sale = false,
    this.category = '',
  });
}
