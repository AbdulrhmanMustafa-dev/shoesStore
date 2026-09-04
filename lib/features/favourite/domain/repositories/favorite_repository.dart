import 'package:kicksvibe/features/home/data/models/product_model.dart';

abstract class FavoriteRepository {
  Stream<List<ProductModel>> watchFavorites();
  Future<void> toggle(ProductModel product);
}
