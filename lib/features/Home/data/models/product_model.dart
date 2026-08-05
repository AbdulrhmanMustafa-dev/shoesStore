class ProductModel {
  final String id;
  final String name;
  final double price;
  final List<String> images; // صور المعرض والألوان (Gallery)
  final List<String> rotationImages; // صور الـ 3D المتسلسلة (جديد)
  final String category;
  final bool isBestSeller;
  final String description;
  final List<int> sizes;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.images,
    required this.rotationImages,
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
      rotationImages: List<String>.from(
        json['rotationImages'] ?? [],
      ), // قراءة الداتا الجديدة
      category: json['category'] ?? '',
      isBestSeller: json['isBestSeller'] ?? false,
      description: json['description'] ?? 'No description available.',
      sizes: List<int>.from(json['sizes'] ?? [38, 39, 40, 41, 42]),
    );
  }
}
