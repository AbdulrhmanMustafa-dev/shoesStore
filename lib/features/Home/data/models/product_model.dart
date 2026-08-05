class ProductModel {
  final String id;
  final String name;
  final double price;
  final List<String> images;
  final String category;
  final bool isBestSeller;
  final String description; // جديد
  final List<int> sizes; // جديد

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.images,
    required this.category,
    required this.isBestSeller,
    required this.description,
    required this.sizes,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, String documentId) {
    return ProductModel(
      id: documentId,
      name: json['name'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      isBestSeller: json['isBestSeller'] ?? false,
      description:
          json['description'] ?? 'No description available.', // قيمة افتراضية
      sizes: List<int>.from(
        json['sizes'] ?? [38, 39, 40, 41, 42],
      ), // قيمة افتراضية
    );
  }
}
