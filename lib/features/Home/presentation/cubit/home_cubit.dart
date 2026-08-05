import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
import 'package:kicksvibe/features/Home/data/models/brand_model.dart';
import 'package:injectable/injectable.dart';

part 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final FirebaseFirestore _firestore;

  HomeCubit(this._firestore) : super(HomeInitial());

  List<ProductModel> allProducts = [];
  List<BrandModel> brands = [];
  String selectedBrand = 'All'; // الديفولت هو All

  Future<void> fetchHomeData() async {
    emit(HomeLoading());
    try {
      // 1. جلب الماركات وإضافة "All" كأول عنصر
      final brandSnapshot = await _firestore.collection('brands').get();
      brands = [BrandModel(id: '0', title: 'All', iconUrl: '')];
      brands.addAll(
        brandSnapshot.docs.map(
          (doc) => BrandModel.fromJson(doc.data(), doc.id),
        ),
      );

      // 2. جلب جميع المنتجات
      final productSnapshot = await _firestore.collection('products').get();
      allProducts = productSnapshot.docs
          .map((doc) => ProductModel.fromJson(doc.data(), doc.id))
          .toList();

      // 3. التصفية المبدئية
      filterProductsByBrand(selectedBrand);
    } catch (e) {
      emit(HomeError("حدث خطأ أثناء جلب البيانات: ${e.toString()}"));
    }
  }

  void changeBrand(String brandTitle) {
    selectedBrand = brandTitle;
    filterProductsByBrand(brandTitle);
  }

  void filterProductsByBrand(String brandTitle) {
    List<ProductModel> filteredList = brandTitle == 'All'
        ? allProducts
        : allProducts
              .where((product) => product.category == brandTitle)
              .toList();

    // التقسيم لـ Popular و New Arrivals
    final popular = filteredList.where((p) => p.isBestSeller).toList();
    final newArrivals = filteredList.where((p) => !p.isBestSeller).toList();

    emit(HomeLoaded(popularProducts: popular, newArrivalProducts: newArrivals));
  }
}
