import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kicksvibe/features/Home/data/models/product_model.dart';
part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ProductModel> allProducts = []; // تخزين كل المنتجات محلياً

  final List<String> brands = ['Nike', 'Puma', 'Under Armour', 'Adidas', 'Converse'];
  String selectedBrand = 'Nike';

  // 1. جلب المنتجات من فايربيس
  Future<void> fetchProducts() async {
    emit(HomeLoading());
    try {
      final snapshot = await _firestore.collection('products').get();
      
      allProducts = snapshot.docs.map((doc) {
        return ProductModel.fromJson(doc.data(), doc.id);
      }).toList();

      // تصفية المنتجات للماركة الافتراضية
      filterProductsByBrand(selectedBrand);
    } catch (e) {
      emit(HomeError( "حدث خطأ أثناء جلب البيانات: ${e.toString()}"));
    }
  }

  // 2. تغيير الماركة والتصفية
  void changeBrand(String brand) {
    selectedBrand = brand;
    filterProductsByBrand(brand);
  }

  // 3. تصفية المنتجات من القائمة المحفوظة (بدون عمل Request جديد لفايربيس)
  void filterProductsByBrand(String brand) {
    final filteredList = allProducts.where((product) => product.category == brand).toList();
    emit(HomeLoaded(filteredList));
  }
}