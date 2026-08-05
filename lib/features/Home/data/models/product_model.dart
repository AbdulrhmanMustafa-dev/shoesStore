class ProductModel {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category; // الماركة (Nike, Puma, etc.)
  final bool isBestSeller;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isBestSeller,
  });

  // دالة لتحويل بيانات فايربيس (JSON) إلى Object
  factory ProductModel.fromJson(Map<String, dynamic> json, String documentId) {
    return ProductModel(
      id: documentId,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      isBestSeller: json['isBestSeller'] ?? false,
    );
  }
}
