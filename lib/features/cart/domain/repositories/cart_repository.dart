import 'package:kicksvibe/features/cart/data/models/cart_item_model.dart';

abstract class CartRepository {
  List<CartItemModel> getItems();
  Future<void> save(CartItemModel item);
  Future<void> remove(String itemId);
  Future<void> clearCart();
}
