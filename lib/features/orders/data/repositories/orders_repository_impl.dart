import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/features/orders/data/models/order_model.dart';
import 'package:kicksvibe/features/orders/domain/repositories/orders_repository.dart';

@LazySingleton(as: OrdersRepository)
class OrdersRepositoryImpl implements OrdersRepository {
  final FirebaseFirestore _firestore;

  OrdersRepositoryImpl(this._firestore);

  @override
  Future<void> placeOrder(OrderModel order) async {
    // رفع الطلب لـ Collection اسمها orders
    await _firestore.collection('orders').doc(order.id).set(order.toJson());
  }

  @override
  Stream<List<OrderModel>> watchUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true) // الأحدث يظهر أولاً
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
              .toList(),
        );
  }
}
