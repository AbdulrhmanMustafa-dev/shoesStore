import 'package:hive_ce/hive_ce.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/features/cart/data/models/cart_item_model.dart';
import 'package:kicksvibe/features/cart/domain/repositories/cart_repository.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  static const _boxName = 'cartBox';

  Box<CartItemModel> get _box => Hive.box<CartItemModel>(_boxName);

  @override
  List<CartItemModel> getItems() => _box.values.toList(growable: false);

  @override
  Future<void> remove(String itemId) => _box.delete(itemId);

  @override
  Future<void> save(CartItemModel item) => _box.put(item.id, item);
}
