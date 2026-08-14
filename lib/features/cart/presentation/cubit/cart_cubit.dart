import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/features/cart/data/models/cart_item_model.dart';
import 'package:kicksvibe/features/cart/domain/repositories/cart_repository.dart';

part 'cart_state.dart';

@lazySingleton
class CartCubit extends Cubit<CartState> {
  CartCubit(this._repository) : super(CartState()) {
    _loadCart();
  }

  final CartRepository _repository;

  void _loadCart() {
    _emitUpdatedState(_repository.getItems());
  }

  Future<void> addToCart(CartItemModel item) async {
    final existingItem = _itemById(item.id);
    if (existingItem != null) {
      existingItem.quantity += item.quantity;
      await _repository.save(existingItem);
    } else {
      await _repository.save(item);
    }
    _loadCart();
  }

  Future<void> incrementQuantity(String itemId) async {
    final item = _itemById(itemId);
    if (item != null) {
      item.quantity++;
      await _repository.save(item);
      _loadCart();
    }
  }

  Future<void> decrementQuantity(String itemId) async {
    final item = _itemById(itemId);
    if (item != null && item.quantity > 1) {
      item.quantity--;
      await _repository.save(item);
      _loadCart();
    }
  }

  Future<void> removeFromCart(String itemId) async {
    await _repository.remove(itemId);
    _loadCart();
  }

  CartItemModel? _itemById(String itemId) {
    for (final item in _repository.getItems()) {
      if (item.id == itemId) return item;
    }
    return null;
  }

  void _emitUpdatedState(List<CartItemModel> items) {
    double subtotal = 0.0;
    for (var item in items) {
      subtotal += (item.product.price * item.quantity);
    }

    final shipping = items.isEmpty ? 0.0 : 40.90;
    final total = items.isEmpty ? 0.0 : subtotal + shipping;

    emit(
      CartState(
        cartItems: items,
        subtotal: subtotal,
        shippingCost: shipping,
        totalCost: total,
      ),
    );
  }
}
