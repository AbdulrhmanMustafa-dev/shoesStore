import 'package:kicksvibe/features/Home/data/models/brand_model.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';

class HomeCatalog {
  const HomeCatalog({required this.brands, required this.products});

  final List<BrandModel> brands;
  final List<ProductModel> products;
}

abstract class HomeRepository {
  /// Emits cached data first, then emits the fresh Firestore catalogue.
  Stream<HomeCatalog> watchCatalog();
}
