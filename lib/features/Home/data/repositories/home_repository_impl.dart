import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:injectable/injectable.dart';
import 'package:kicksvibe/features/Home/data/models/brand_model.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/Home/domain/repositories/home_repository.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<HomeCatalog> watchCatalog() async* {
    final productsBox = Hive.box<ProductModel>('homeProductsBox');
    final brandsBox = Hive.box<BrandModel>('brandsBox');
    final hasCachedCatalog = productsBox.isNotEmpty && brandsBox.isNotEmpty;

    if (hasCachedCatalog) {
      yield HomeCatalog(
        brands: brandsBox.values.toList(growable: false),
        products: productsBox.values.toList(growable: false),
      );
    }

    try {
      final brandsRequest = _firestore.collection('brands').get();
      final productsRequest = _firestore.collection('products').get();
      final brandsSnapshot = await brandsRequest;
      final productsSnapshot = await productsRequest;
      final brands = <BrandModel>[
        BrandModel(id: '0', title: 'All', iconUrl: ''),
        ...brandsSnapshot.docs.map(
          (document) => BrandModel.fromJson(document.data(), document.id),
        ),
      ];
      final products = productsSnapshot.docs
          .map(
            (document) => ProductModel.fromJson(document.data(), document.id),
          )
          .toList(growable: false);

      await productsBox.clear();
      await brandsBox.clear();
      await productsBox.addAll(products);
      await brandsBox.addAll(brands);

      yield HomeCatalog(brands: brands, products: products);
    } on Object {
      if (!hasCachedCatalog) rethrow;
    }
  }
}
