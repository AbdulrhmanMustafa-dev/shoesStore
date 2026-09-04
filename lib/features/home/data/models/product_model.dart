import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive_ce.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double price;
  @HiveField(3)
  final List<String> images;
  @HiveField(4)
  final List<String> rotationImages;
  @HiveField(5)
  final String category;
  @HiveField(6)
  final bool isBestSeller;
  @HiveField(7)
  final String description;
  @HiveField(8)
  final List<int> sizes;

  const ProductModel({
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

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    images,
    rotationImages,
    category,
    isBestSeller,
    description,
    sizes,
  ];
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'images': images,
      'rotationImages': rotationImages,
      'category': category,
      'isBestSeller': isBestSeller,
      'description': description,
      'sizes': sizes,
    };
  }
}
