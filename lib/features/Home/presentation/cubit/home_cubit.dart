import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/Home/data/models/brand_model.dart';
import 'package:injectable/injectable.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final FirebaseFirestore _firestore;

  HomeCubit(this._firestore) : super(HomeInitial());

  List<ProductModel> _allProducts = const [];
  List<BrandModel> _brands = const [];
  String selectedBrand = 'All'; // الديفولت هو All

 Future<void> fetchHomeData() async {
    emit(HomeLoading());
    try {
      final productsBox = Hive.box<ProductModel>('homeProductsBox');
      final brandsBox = Hive.box<BrandModel>('brandsBox');

      // 1. عرض البيانات المخزنة محلياً أولاً (للسرعة والأوفلاين)
      if (productsBox.isNotEmpty && brandsBox.isNotEmpty) {
        _allProducts = productsBox.values.toList();
        _brands = brandsBox.values.toList();
        _emitFilteredProducts();
      }

      // 2. جلب البيانات الحديثة من Firebase
      final brandSnapshot = await _firestore.collection('brands').get();
      final newBrands = [
        BrandModel(id: '0', title: 'All', iconUrl: ''),
        ...brandSnapshot.docs.map(
          (doc) => BrandModel.fromJson(doc.data(), doc.id),
        ),
      ];

      final productSnapshot = await _firestore.collection('products').get();
      final newProducts = productSnapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .toList();

      // 3. تحديث البيانات المحلية (الكاش)
      await brandsBox.clear();
      await brandsBox.addAll(newBrands);
      await productsBox.clear();
      await productsBox.addAll(newProducts);

      _allProducts = newProducts;
      _brands = newBrands;
      _emitFilteredProducts();
    } catch (e) {
      // إذا فشل النت ولا يوجد كاش، نعرض خطأ
      if (_allProducts.isEmpty) emit(HomeError("حدث خطأ: ${e.toString()}"));
    }
  }

  void changeBrand(String brandTitle) {
    selectedBrand = brandTitle;
    _emitFilteredProducts();
  }

  void _emitFilteredProducts() {
    final filteredList = selectedBrand == 'All'
        ? _allProducts
        : _allProducts
              .where((product) => product.category == selectedBrand)
              .toList();

    // التقسيم لـ Popular و New Arrivals
    final popular = filteredList.where((p) => p.isBestSeller).toList();
    final newArrivals = filteredList.where((p) => !p.isBestSeller).toList();

    emit(
      HomeLoaded(
        brands: _brands,
        selectedBrand: selectedBrand,
        popularProducts: popular,
        newArrivalProducts: newArrivals,
      ),
    );
  }
}
