part of 'cart_cubit.dart';

class CartState {
  const CartState({
    this.cartItems = const [],
    this.subtotal = 0.0,
    this.shippingCost = 0.0,
    this.totalCost = 0.0,
  });

  final List<CartItemModel> cartItems;
  final double subtotal;
  final double shippingCost;
  final double totalCost;
}
