import 'package:hive_ce/hive_ce.dart';
import 'package:kicksvibe/features/home/data/models/product_model.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 2)
class CartItemModel {
  @HiveField(0)
  final String id; // يُفضل أن يكون مركب من (معرف المنتج + المقاس) لضمان عدم التكرار
  @HiveField(1)
  final ProductModel product;
  @HiveField(2)
  int quantity;
  @HiveField(3)
  final String selectedSize;

  CartItemModel({
    required this.id,
    required this.product,
    this.quantity = 1,
    required this.selectedSize,
  });
}
