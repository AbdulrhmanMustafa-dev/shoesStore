part of 'cart_cubit.dart';

class CartState {
  final List<CartItemModel> cartItems;
  final double subtotal;
  final double shippingCost;
  final double totalCost;

  CartState({
    this.cartItems = const [],
    this.subtotal = 0.0,
    this.shippingCost = 40.90, // تكلفة الشحن الافتراضية كما في التصميم
    this.totalCost = 0.0,
  });
}
