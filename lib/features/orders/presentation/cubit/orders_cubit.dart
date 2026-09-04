import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/features/orders/data/models/order_model.dart';
import 'package:kicksvibe/features/orders/domain/repositories/orders_repository.dart';

part 'orders_state.dart';

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._repository) : super(OrdersInitial()) {
    _loadOrders();
  }

  final OrdersRepository _repository;
  StreamSubscription<List<OrderModel>>? _ordersSubscription;

  void _loadOrders() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(OrdersError('Please sign in to view your orders.'));
      return;
    }

    emit(OrdersLoading());
    _ordersSubscription?.cancel();
    _ordersSubscription = _repository
        .watchUserOrders(user.uid)
        .listen(
          (orders) {
            if (!isClosed) emit(OrdersLoaded(orders));
          },
          onError: (_, _) {
            if (!isClosed) {
              emit(OrdersError('Failed to load orders. Please try again.'));
            }
          },
        );
  }

  @override
  Future<void> close() async {
    await _ordersSubscription?.cancel();
    return super.close();
  }
}
