import 'package:kicksvibe/features/orders/data/models/order_model.dart';

abstract class OrdersRepository {
  Future<void> placeOrder(OrderModel order);

  // 💡 دالة لجلب طلبات مستخدم معين بترتيب الأحدث أولاً
  Stream<List<OrderModel>> watchUserOrders(String userId);
}
