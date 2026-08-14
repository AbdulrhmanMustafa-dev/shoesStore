import 'package:injectable/injectable.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/cart/data/models/cart_item_model.dart';
import 'package:kicksvibe/features/cart/domain/repositories/cart_repository.dart';

@injectable
class AddProductToCart {
  AddProductToCart(this._cartRepository);

  final CartRepository _cartRepository;

  Future<void> call(ProductModel product, int selectedSizeIndex) async {
    if (product.sizes.isEmpty ||
        selectedSizeIndex < 0 ||
        selectedSizeIndex >= product.sizes.length) {
      throw const ProductSizeUnavailableException();
    }

    final selectedSize = product.sizes[selectedSizeIndex].toString();
    final itemId = '${product.id}_$selectedSize';
    CartItemModel? existingItem;
    for (final item in _cartRepository.getItems()) {
      if (item.id == itemId) {
        existingItem = item;
        break;
      }
    }

    if (existingItem != null) {
      existingItem.quantity++;
      await _cartRepository.save(existingItem);
      return;
    }

    await _cartRepository.save(
      CartItemModel(id: itemId, product: product, selectedSize: selectedSize),
    );
  }
}

class ProductSizeUnavailableException implements Exception {
  const ProductSizeUnavailableException();
}
